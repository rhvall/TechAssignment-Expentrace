//
//  Transaction.swift
//  Expentrace
//
//  Created by RHVT on 9/5/19.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation

/// A simple class container for the transactions that are going to
/// be stored.
@objc class Transaction: NSObject, Codable {
    @objc let tID: UInt
    @objc let tName: String
    @objc let tAddr: String
    @objc let tDate: String
    @objc let tCats: [String]
    
    init(_ id: UInt, _ name: String, _ addr: String,
        _ date: String, _ categories: [String]) {
        self.tID = id
        self.tName = name
        self.tAddr = addr
        self.tDate = date
        self.tCats = categories
        super.init()
    }
}
