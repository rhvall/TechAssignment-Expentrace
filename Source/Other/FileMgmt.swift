//
//  FileManager.swift
//  Expentrace
//
//  Created by RHVT on 16/5/19.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation

/// This class helps to abstract the reading/writing of files
/// to flash memory.
// Biiiig NOTE!! At the moment, the salt and IV vector innitialization
// is stored within the same file, which is NOT a solution, those
// values should be stored in a different and more secure place.
@objc class FileMgmt: NSObject
{
    static let fileExtension = "plist"
    
    @objc static func retrieveFrom(file: String) -> Array<Transaction>? {
        let fileWithExt = file + "." + fileExtension;
        let pass = Constants.encryptionPass()!
        let pathURL = FileManager.default.urls(for:.documentDirectory,
                                             in:.userDomainMask)[0].appendingPathComponent(fileWithExt)
        
        // First Decript the contents
        
        guard let xmlEnc = FileManager.default.contents(atPath: pathURL.path),
            let dataEnc = try? PropertyListDecoder().decode(Dictionary<String, Data>.self, from: xmlEnc)
        else {
            // If this happened, it was not able to read and decode the PLIST
            return nil
        }
        
        // NOTE!! Check class description for the big note.
        let decripted = decryptData(fromDictionary: dataEnc, withPassword:pass)
        
        guard let preferences = try? PropertyListDecoder().decode(Array<Transaction>.self, from: decripted)
        else {
            return nil
        }
        
        return preferences
    }
    
    @objc static func persist(object: Array<Transaction>, file: String) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let fileWithExt = file + "." + fileExtension;
        let path = FileManager.default.urls(for:.documentDirectory,
                                          in:.userDomainMask)[0].appendingPathComponent(fileWithExt)
        
        do {
            let plainDta = try encoder.encode(object)
            let pass = Constants.encryptionPass()!
            // NOTE!! Check class description for the big note.
            let dataEnc = encryptData(plainDta, withPassword:pass)
            let encDta = try encoder.encode(dataEnc)
            try encDta.write(to: path, options:.completeFileProtection)
        } catch {
            print(error)
        }
    }
    
    // Code based on this post: https://code.tutsplus.com/tutorials/securing-ios-data-at-rest-encryption--cms-28786
    // And warnings drove me crazy, it needs to be more carefully updated to Swift5
    static func decryptData(fromDictionary dictionary : Dictionary<String, Data>, withPassword password : String) -> Data
    {
        var setupSuccess = true
        let encrypted = dictionary["EncryptionData"]
        let iv = dictionary["EncryptionIV"]
        let salt = dictionary["EncryptionSalt"]
        var key = Data(repeating:0, count:kCCKeySizeAES256)
        salt?.withUnsafeBytes { (saltBytes: UnsafePointer<UInt8>) -> Void in
            let passwordData = password.data(using:String.Encoding.utf8)!
            var altKey = key
            altKey.withUnsafeMutableBytes { (keyBytes : UnsafeMutablePointer<UInt8>) in
                let derivationStatus = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2), password, passwordData.count, saltBytes, salt!.count, CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA512), 14271, keyBytes, key.count)
                if derivationStatus != Int32(kCCSuccess)
                {
                    setupSuccess = false
                }
            }
            key = altKey
        }
        
        var decryptSuccess = false
        let size = (encrypted?.count)! + kCCBlockSizeAES128
        var clearTextData = Data.init(count: size)
        if (setupSuccess)
        {
            var numberOfBytesDecrypted : size_t = 0
            let cryptStatus = iv?.withUnsafeBytes {ivBytes in
                clearTextData.withUnsafeMutableBytes {clearTextBytes in
                    encrypted?.withUnsafeBytes {encryptedBytes in
                        key.withUnsafeBytes {keyBytes in
                            CCCrypt(CCOperation(kCCDecrypt),
                                    CCAlgorithm(kCCAlgorithmAES128),
                                    CCOptions(kCCOptionPKCS7Padding),
                                    keyBytes,
                                    key.count,
                                    ivBytes,
                                    encryptedBytes,
                                    (encrypted?.count)!,
                                    clearTextBytes,
                                    size,
                                    &numberOfBytesDecrypted)
                        }
                    }
                }
            }
            
            if cryptStatus! == Int32(kCCSuccess)
            {
                clearTextData.count = numberOfBytesDecrypted
                decryptSuccess = true
            }
        }
        
        return decryptSuccess ? clearTextData : Data.init(count: 0)
    }
    
    static func encryptData(_ clearTextData : Data, withPassword password : String) -> Dictionary<String, Data>
    {
        var setupSuccess = true
        var outDictionary = Dictionary<String, Data>.init()
        var key = Data(repeating:0, count:kCCKeySizeAES256)
        let count = 8
        var salt = Data(count: count)
        salt.withUnsafeMutableBytes { (saltBytes: UnsafeMutablePointer<UInt8>) -> Void in
            let saltStatus = SecRandomCopyBytes(kSecRandomDefault, count, saltBytes)
            if saltStatus == errSecSuccess
            {
                let passwordData = password.data(using:String.Encoding.utf8)!
                var altKey = key
                altKey.withUnsafeMutableBytes { (keyBytes : UnsafeMutablePointer<UInt8>) in
                    let derivationStatus = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2), password, passwordData.count, saltBytes, count, CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA512), 14271, keyBytes, key.count)
                    if derivationStatus != Int32(kCCSuccess)
                    {
                        setupSuccess = false
                    }
                }
                key = altKey
            }
            else
            {
                setupSuccess = false
            }
        }
        
        var iv = Data.init(count: kCCBlockSizeAES128)
        iv.withUnsafeMutableBytes { (ivBytes : UnsafeMutablePointer<UInt8>) in
            let ivStatus = SecRandomCopyBytes(kSecRandomDefault, kCCBlockSizeAES128, ivBytes)
            if ivStatus != errSecSuccess
            {
                setupSuccess = false
            }
        }
        
        if (setupSuccess)
        {
            var numberOfBytesEncrypted : size_t = 0
            let size = clearTextData.count + kCCBlockSizeAES128
            var encrypted = Data.init(count: size)
            let cryptStatus = iv.withUnsafeBytes {ivBytes in
                encrypted.withUnsafeMutableBytes {encryptedBytes in
                    clearTextData.withUnsafeBytes {clearTextBytes in
                        key.withUnsafeBytes {keyBytes in
                            CCCrypt(CCOperation(kCCEncrypt),
                                    CCAlgorithm(kCCAlgorithmAES),
                                    CCOptions(kCCOptionPKCS7Padding),
                                    keyBytes,
                                    key.count,
                                    ivBytes,
                                    clearTextBytes,
                                    clearTextData.count,
                                    encryptedBytes,
                                    size,
                                    &numberOfBytesEncrypted)
                        }
                    }
                }
            }
            if cryptStatus == Int32(kCCSuccess)
            {
                encrypted.count = numberOfBytesEncrypted
                outDictionary["EncryptionData"] = encrypted
                outDictionary["EncryptionIV"] = iv
                outDictionary["EncryptionSalt"] = salt
            }
        }
        
        return outDictionary;
    }
}


