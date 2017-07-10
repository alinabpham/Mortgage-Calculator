//
//  MortgageCalculation.swift
//  MortgageCalculator
//
//  Created by Alina Pham on 6/19/17.
//  Copyright © 2017 Alina Pham. All rights reserved.
//

import UIKit
import os.log

class MortgageCalculation : NSObject, NSCoding {
    
    //MARK: Properties
    var name: String
    var loan: String
    
    var original : TermRateInfo
    var custom1 : TermRateInfo
    var custom2 : TermRateInfo?
    var custom3 : TermRateInfo?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("mortgages")
    
    //MARK: Initialization
    
    //With only custom1
    init?(name: String, loan: String, original: TermRateInfo, custom1 : TermRateInfo) {
        // Initialization should fail if there is no name, or if the rating is negative or greater than max.
        guard !name.isEmpty else {
            return nil
        }
        guard !loan.isEmpty else {
            return nil
        }
        guard !original.isEmpty() else {
            print("init issue here original")
            return nil
        }
        guard !custom1.isEmpty() else {
            print("init issue here custom")
            return nil
        }
        
        
        // Initialize stored properties from params
        self.name = name
        self.loan = loan
        
        self.original = original
        self.custom1 = custom1
        
    }
    
    //With custom2
    init?(name: String, loan: String, original: TermRateInfo, custom1 : TermRateInfo, custom2 : TermRateInfo?) {
        // Initialization should fail if there is no name, or if the rating is negative or greater than max.
        guard !name.isEmpty else {
            return nil
        }
        guard !loan.isEmpty else {
            return nil
        }
        guard !original.isEmpty() else {
            return nil
        }
        guard !custom1.isEmpty() else {
            return nil
        }

        
        // Initialize stored properties from params
        self.name = name
        self.loan = loan
        
        self.original = original
        self.custom1 = custom1
        self.custom2 = custom2
        
    }
    
    //With custom3
    init?(name: String, loan: String, original: TermRateInfo, custom1 : TermRateInfo, custom2 : TermRateInfo?, custom3 : TermRateInfo?) {
        // Initialization should fail if there is no name, or if the rating is negative or greater than max.
        guard !name.isEmpty else {
            return nil
        }
        guard !loan.isEmpty else {
            return nil
        }
        guard !original.isEmpty() else {
            print("this didnt work")
            return nil
        }
        guard !custom1.isEmpty() else {
            return nil
        }
        
        
        // Initialize stored properties from params
        self.name = name
        self.loan = loan
        
        self.original = original
        self.custom1 = custom1
        self.custom2 = custom2
        self.custom3 = custom3
        
    }
 
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let loan = "loan"
        
        static let original = "original"
        static let custom1 = "custom1"
        static let custom2 = "custom2"
        static let custom3 = "custom3"
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(loan, forKey: PropertyKey.loan)
        
        aCoder.encode(original, forKey: PropertyKey.original)
        aCoder.encode(custom1, forKey: PropertyKey.custom1)
        aCoder.encode(custom2, forKey: PropertyKey.custom2)
        aCoder.encode(custom3, forKey: PropertyKey.custom3)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // Each field is required. If we cannot decode a field string, the initializer should fail.
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a MortgageCalculation object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let loan = aDecoder.decodeObject(forKey: PropertyKey.loan) as? String else {
            os_log("Unable to decode the loan amount for a MortgageCalculation object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        guard let original = aDecoder.decodeObject(forKey: PropertyKey.original) as? TermRateInfo else {
            os_log("Unable to decode the original term/rate info for a MortgageCalculation object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let custom1 = aDecoder.decodeObject(forKey: PropertyKey.custom1) as? TermRateInfo else {
            os_log("Unable to decode the custom1 term/rate info for a MortgageCalculation object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let custom2 = aDecoder.decodeObject(forKey: PropertyKey.custom2) as? TermRateInfo
        let custom3 = aDecoder.decodeObject(forKey: PropertyKey.custom3) as? TermRateInfo
        
        
        // Must call designated initializer.
        self.init(name: name, loan: loan, original: original, custom1: custom1, custom2: custom2, custom3: custom3)
        
    }
    
    
    //MARK: Calculation Functions
    
    //Calculate the monthly payment
    static func getMonthlyPayment(loanAmount: Double, loanTerm: Int, interestRate: Double) ->Double {
        let r : Double = interestRate / (100 * 12)
        let n : Double = Double(loanTerm)
        let l : Double = loanAmount
        
        let payment : Double = l * (r * pow((1 + r), n)) / (pow((1 + r), n) - 1)
        return payment
    }
    
    //Calculate the total amount of interest paid on top of original loan
    static func getTotalPayment(monthly: Double, loanAmount: Double, loanTerm: Int) ->Double {
        let m : Double = monthly
        let n : Double = Double(loanTerm)
        let l : Double = loanAmount
        
        let payment : Double = (m * n) - l
        return payment
    }
    
    
}
