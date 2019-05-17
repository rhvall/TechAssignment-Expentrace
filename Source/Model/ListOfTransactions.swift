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
    @objc static let sharedTransactions = ListOfTransactions()
    
    private var transactions: [Transaction]
    
    override private init() {
        self.transactions = ListOfTransactions.loadTransactions()
        super.init()
    }
    
    func addTransaction(tr: Transaction) {
        transactions.append(tr)
    }
    
    func removeTransaction(tr: Transaction) {
        if let index = transactions.firstIndex(of: tr) {
            transactions.remove(at: index)
        }
    }
    
    @objc func getTransactions() -> [Transaction] {
        return transactions
    }
    
    @objc func persistTransactions() {
        FileMgmt.persist(object: transactions, file: Constants.transactionsFile())
    }
    
    static func loadTransactions() -> [Transaction] {
        if let tran = FileMgmt.retrieveFrom(file: Constants.transactionsFile()) {
            return tran
        }
        else {
            return []
        }
    }
}
