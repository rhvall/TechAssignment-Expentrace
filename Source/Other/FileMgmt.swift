//
//  FileManager.swift
//  Expentrace
//
//  Created by RHVT on 16/5/19.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation

@objc class FileMgmt: NSObject
{
    static let fileExtension = "plist"
    
    @objc static func retrieveFrom(file: String) -> Array<Transaction>? {
        let fileWithExt = file + "." + fileExtension;
        let pathURL = FileManager.default.urls(for:.documentDirectory,
                                          in:.userDomainMask)[0].appendingPathComponent(fileWithExt)
        
        guard let xml = FileManager.default.contents(atPath: pathURL.path),
            let preferences = try? PropertyListDecoder().decode(Array<Transaction>.self, from: xml)
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
            let data = try encoder.encode(object)
            print(path);
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
}


