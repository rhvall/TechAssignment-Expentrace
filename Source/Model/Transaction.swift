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
    @objc let tID: Int
    @objc let tName: String
    @objc let tPrice: Double
    @objc let tCurrency: String
    @objc let tDate: String
    @objc let tCats: [String]?
    
    @objc init(id: Int, name: String, price: Double,
               currency: String, date: String, categories: [String]?) {
        self.tID = id
        self.tName = name
        self.tPrice = price
        self.tCurrency = currency
        self.tDate = date
        self.tCats = categories
        super.init()
    }
}
