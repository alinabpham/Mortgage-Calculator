//
//  TermRateInfo.swift
//  MortgageCalculator
//
//  Created by Alina Pham on 7/5/17.
//  Copyright © 2017 Alina Pham. All rights reserved.
//

import Foundation

import UIKit
import os.log

class TermRateInfo : NSObject, NSCoding {
    
    //MARK: Properties
    var rate: String
    var term: String
    
    var monthly : String
    var totalInterest : String
    
    var amountSaved : String

    
    //MARK: Initialization
    
    init?(rate: String, term: String, monthly : String, totalInterest : String, amountSaved: String) {
        // Initialization should fail if there is no name, or if the rating is negative or greater than max.

        guard !rate.isEmpty else {
            return nil
        }
        guard !term.isEmpty else {
            return nil
        }
        guard !monthly.isEmpty else {
            return nil
        }
        guard !totalInterest.isEmpty else {
            return nil
        }
        
        // Initialize stored properties from params
        self.rate = rate
        self.term = term
        
        self.monthly = monthly
        self.totalInterest = totalInterest
        
        self.amountSaved = amountSaved

    }
    
    //MARK: Types
    
    struct PropertyKey {
        static let rate = "rate"
        static let term = "term"
        
        static let monthly = "monthly"
        static let totalInterest = "totalInterest"
        
        static let amountSaved = "amountSaved"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rate, forKey: PropertyKey.rate)
        aCoder.encode(term, forKey: PropertyKey.term)
        
        aCoder.encode(monthly, forKey: PropertyKey.monthly)
        aCoder.encode(totalInterest, forKey: PropertyKey.totalInterest)
        
        aCoder.encode(amountSaved, forKey: PropertyKey.amountSaved)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // Each field is required. If we cannot decode a field string, the initializer should fail.
        
        guard let rate = aDecoder.decodeObject(forKey: PropertyKey.rate) as? String else {
            os_log("Unable to decode the rate for a TermRateInfo object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let term = aDecoder.decodeObject(forKey: PropertyKey.term) as? String else {
            os_log("Unable to decode the term for a TermRateInfo object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        guard let monthly = aDecoder.decodeObject(forKey: PropertyKey.monthly) as? String else {
            os_log("Unable to decode the monthly payment for a TermRateInfo object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let totalInterest = aDecoder.decodeObject(forKey: PropertyKey.totalInterest) as? String else {
            os_log("Unable to decode the total interest paid for a TermRateInfo object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let amountSaved = aDecoder.decodeObject(forKey: PropertyKey.amountSaved) as? String else {
            os_log("Unable to decode the amount saved for a TermRateInfo object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //let amountSaved = aDecoder.decodeObject(forKey: PropertyKey.amountSaved) as? TermRateInfo
        
        
        // Must call designated initializer.
        self.init(rate: rate, term: term, monthly: monthly, totalInterest: totalInterest, amountSaved: amountSaved)
        
    }
    
    //MARK: Functions
    
    func isEmpty() -> Bool {
        if rate.isEmpty || term.isEmpty || monthly.isEmpty || totalInterest.isEmpty {
            return true
        }
        
        return false
    }
    
    
}
