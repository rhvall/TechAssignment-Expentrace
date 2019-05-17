//
//  FileManager.swift
//  Expentrace
//
//  Created by RHVT on 16/5/19.
//  Copyright © 2019 R. All rights reserved.
//

import Eureka

class AddEditViewController: FormViewController {
    
    enum ItemsTags: String {
        case name
        case price
        case currency
        case date
        case category
        case saveButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let strGenOver = NSLocalizedString("General Overview", comment: "The general details of a transaction")
        let strName = NSLocalizedString("Name", comment: "Name of a transaction")
        let strPrice = NSLocalizedString("Price", comment: "Price a transaction")
        let strCurr = NSLocalizedString("Currency", comment: "Currency of the transaction")
        let strDate = NSLocalizedString("Date", comment: "Date of the transaction")
        let strCategory = NSLocalizedString("Category", comment: "Category of a transaction")
        let strSave = NSLocalizedString("Save", comment: "Save a transaction")
        let supportedCurr = Constants.supportedCurrencies() as! [String]
        
        // Very good explanation of how this code works is here:
        // https://github.com/xmartlabs/Eureka
        // In basic terms, it has a general forms, to which it starts adding
        // rows as needed. There are rows for each element that we need to
        // acquire information, listed in ItemsTag.
        form +++ Section(strGenOver)
            <<< TextRow(){
                $0.title = strName
                $0.tag = ItemsTags.name.rawValue
                }.onChange({ (tr:_TextRow) in
                    // If the value of the name has changed, then we can safe
                    if tr.value?.isEmpty == false {
                        let button = self.form.rowBy(tag: ItemsTags.saveButton.rawValue)
                        button?.disabled = false
                        button?.evaluateDisabled()
                    }
                })
            <<< DecimalRow() {
                $0.title = strPrice
                $0.value = 0
                $0.tag = ItemsTags.price.rawValue
            }
            <<< SegmentedRow<String>() {
                $0.title = strCurr
                $0.options = supportedCurr
                $0.value = Constants.nzdKey()
                $0.tag = ItemsTags.currency.rawValue
            }
            <<< DateRow() {
                $0.title = strDate
                $0.tag = ItemsTags.date.rawValue
                $0.value = Date(timeIntervalSinceNow: 0)
            }
            <<< TextRow() {
                $0.title = strCategory;
                $0.tag = ItemsTags.category.rawValue
            }
        +++ Section()
            <<< ButtonRow() {
                    $0.title = strSave
                    $0.disabled = true
                    $0.tag = ItemsTags.saveButton.rawValue
                }
                .onCellSelection({ [unowned self] (cell, row) in
                    let nameRowOpt = self.form.rowBy(tag: ItemsTags.name.rawValue) as? RowOf<String>
                    if let nameRow = nameRowOpt,
                        nameRow.value?.isEmpty == false
                    {
                        self.storeValues()
                    }
                })
    }
    
    // Once we have acquired the transaction information, it is time to store in a file
    func storeValues() {
        let nameOpt = (self.form.rowBy(tag: ItemsTags.name.rawValue) as? RowOf<String>)?.value
        let priceOpt = (self.form.rowBy(tag: ItemsTags.price.rawValue) as? RowOf<Double>)?.value
        let currOpt = (self.form.rowBy(tag: ItemsTags.currency.rawValue) as? RowOf<String>)?.value
        let dateOpt = (self.form.rowBy(tag: ItemsTags.date.rawValue) as? RowOf<Date>)?.value
        let categoryOpt = (self.form.rowBy(tag: ItemsTags.category.rawValue) as? RowOf<String>)?.value
        
        guard let name = nameOpt,
            let price = priceOpt,
            let curr = currOpt,
            let date = dateOpt
        else {
                return
        }
        
        let cat = categoryOpt ?? ""
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .short
        let strDate = dateformatter.string(from:date)
        
        let tran = Transaction(id: date.hashValue,
                               name: name,
                               price: price,
                               currency: curr,
                               date: strDate,
                               categories: [cat])
        
        ListOfTransactions.sharedTransactions.addTransaction(tr: tran)
    }
}
