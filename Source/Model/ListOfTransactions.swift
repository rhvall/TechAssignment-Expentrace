//
//  ListsOfTransactions.swift
//  Expentrace
//
//  Created by RHVT on 17/5/19.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation

// Singleton entity that will help to keep track of the
// number of transactions as well as read/store them from
// a file
@objc class ListOfTransactions : NSObject
{
    @objc static let allTransactions = ListOfTransactions()
    
    private var transactions: [Transaction]
    
    override private init() {
        if let tran = FileMgmt.retrieveFrom(file: Constants.transactionsFile()) {
            self.transactions = tran
        }
        else {
            self.transactions = []
        }
    }
    
    func addTransaction(tr: Transaction) {
    
    }
    
    func removeTransaction(tr: Transaction) {
        
    }
    
    func persistTransactions(tr: Transaction) {
        
    }
}
