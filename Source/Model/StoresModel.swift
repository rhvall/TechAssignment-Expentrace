//
//  StoresModel.swift
//  Expentrace
//
//  Created by RHVT on 9/5/19.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation

// This class is really messy for the simple tasks of transforming a
// dictionary into a class StoreElement, it would had been way easier
// using "Codable" and "struct" for parsing in Swift JSON, but the
// interoperability (NSObject) makes it more complicated
class StoreElement: NSObject, Codable {
    let storeID: UInt
    let storeName: String
    let storeAddr: String
    let storeLatitude: Double
    let storeLongigude: Double
    let storeDistance: Double
    let storeFeatures: [String]
    
    init(_ id: UInt, _ name: String, _ addr: String,
        _ lat: Double, _ lon: Double, _ dist: Double, _ feat: [String]) {
        self.storeID = id
        self.storeName = name
        self.storeAddr = addr
        self.storeLatitude = lat
        self.storeLongigude = lon
        self.storeDistance = dist
        self.storeFeatures = feat
        super.init()
    }
    
    // Custom keys to match the ones on the JSON file
    enum CodingKeys: String, CodingKey {
        case storeID = "id"
        case storeName = "name"
        case storeAddr = "address"
        case storeLatitude = "latitude"
        case storeLongigude = "longitude"
        case storeDistance = "distance"
        case storeFeatures = "featureList"
    }
    
    @objc static func parseStoreElement(dic: NSDictionary) -> StoreElement? {
        guard  let sID = dic[StoreElement.CodingKeys.storeID.stringValue] as? UInt,
              let sNam = dic[StoreElement.CodingKeys.storeName.stringValue] as? String,
              let sAdr = dic[StoreElement.CodingKeys.storeAddr.stringValue] as? String,
              let sLat = dic[StoreElement.CodingKeys.storeLatitude.stringValue] as? Double,
              let sLon = dic[StoreElement.CodingKeys.storeLongigude.stringValue] as? Double,
              let sDis = dic[StoreElement.CodingKeys.storeDistance.stringValue] as? Double,
              let sFet = dic[StoreElement.CodingKeys.storeFeatures.stringValue] as? [String]
        else {
            return nil
        }
        
        return StoreElement(sID, sNam, sAdr, sLat, sLon, sDis, sFet)
    }
}
