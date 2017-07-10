//
//  MortgageCalculatorViewController.swift
//  MortgageCalculator
//
//  Created by Alina Pham on 6/15/17.
//  Copyright © 2017 Alina Pham. All rights reserved.
//

import UIKit
import os.log

class MortgageCalculatorViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var nameHome: UITextField!
    @IBOutlet weak var loanAmount: UITextField!
    @IBOutlet weak var interestRate: UITextField!
    @IBOutlet weak var loanTerm: UITextField!
    
    @IBOutlet weak var customTerm1: UITextField!
    @IBOutlet weak var customRate1: UITextField!
    
    @IBOutlet weak var customTerm2: UITextField!
    @IBOutlet weak var customRate2: UITextField!
    
    @IBOutlet weak var customTerm3: UITextField!
    @IBOutlet weak var customRate3: UITextField!
    
    @IBOutlet var inputFields: [UITextField]!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    weak var activeField: UITextField?
    
    var mortgage : MortgageCalculation?
    var originalTR : TermRateInfo?
    var customTR1 : TermRateInfo?
    var customTR2 : TermRateInfo?
    var customTR3 : TermRateInfo?
    
    var originalMonthly : String?
    var originalTotal : String?
    
    var customMonthly1 : String?
    var customTotal1 : String?
    
    var customMonthly2 : String?
    var customTotal2 : String?
    
    var customMonthly3 : String?
    var customTotal3 : String?
    
    var saved1 : String?
    var saved2 : String?
    var saved3 : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameHome.delegate = self
        nameHome.setLeftPaddingPoints(10)
        
        // Set up views if editing an existing Mortgage.
        if let mortgage = mortgage {
            nameHome.text = mortgage.name
            loanAmount.text = mortgage.loan
            interestRate.text = mortgage.original.rate
            loanTerm.text = mortgage.original.term
            
            customTerm1.text = mortgage.custom1.term
            customRate1.text = mortgage.custom1.rate
            
            
            customTerm2.text = mortgage.custom2?.term
            customRate2.text = mortgage.custom2?.rate
            
            customTerm3.text = mortgage.custom3?.term
            customRate3.text = mortgage.custom3?.rate
            
        }
        
        
        for field in inputFields {
            //Add Padding to each field
            field.setLeftPaddingPoints(10)
            //Specify what text field needs a done button
            addDoneButtonToKeyboard(textField: field)
        }
    
        //Format currency/rate when entering numbers
        loanAmount.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        interestRate.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        customRate1.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        customRate2.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        customRate3.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        //Notice if keyboard is showing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        // Enable the Save button only if the text field has a valid entry
        updateSaveButtonState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard on Done
        textField.resignFirstResponder()
        return true
    }
    
    func myTextFieldDidChange(_ textField: UITextField) {
        //format currency input
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
        //Enable Save button upon finish editing
        updateSaveButtonState()
    }
    
    //MARK: keyboard notification
    
    func keyboardDidShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        
        let navBarAllowance = (self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.size.height)!
        
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(navBarAllowance, 0.0, keyboardSize!.height + 10.0, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height+navBarAllowance
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        let navBarAllowance = (self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.size.height)!
        
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(navBarAllowance, 0.0, -(keyboardSize!.height + 10.0), 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        self.view.endEditing(true)
    }

    
    //MARK: Calculate Mortgage
    
    @IBAction func calculateMonthlyPayment(_ sender: UIButton) {
        
        
        //format field inputs to fit calculation
        let loan = loanAmount.text?.currencyToDouble()
        
        let origTerm = Int(loanTerm.text!)! * 12
        let origRate = interestRate.text?.currencyToDouble()
        
        let custTerm1 = Int(customTerm1.text!)!
        let custRate1 = customRate1.text?.currencyToDouble()
        
        
        //Show original monthly payment
        let originalMonthlyPayment = MortgageCalculation.getMonthlyPayment(loanAmount: loan!, loanTerm: origTerm, interestRate: origRate!)
        originalMonthly = "$ " + (NSString(format: "%.2f", originalMonthlyPayment) as String)
        
        //Show original total payment
        let originalTotalPayment = MortgageCalculation.getTotalPayment(monthly: originalMonthlyPayment, loanAmount: loan!, loanTerm: origTerm)
        originalTotal = "$ " + (NSString(format: "%.2f", originalTotalPayment) as String).currencyInputFormatting()
        
        //Set TermRateInfo object
        originalTR = TermRateInfo(rate: interestRate.text!, term: loanTerm.text!, monthly: originalMonthly!, totalInterest: originalTotal!, amountSaved: "0")
        
        
        //Custom Term/Rate 1
        let customMonthlyPayment1 = MortgageCalculation.getMonthlyPayment(loanAmount: loan!, loanTerm: custTerm1, interestRate: custRate1!)
        customMonthly1 = "$ " + (NSString(format: "%.2f", customMonthlyPayment1) as String)

        let customTotalPayment1 = MortgageCalculation.getTotalPayment(monthly: customMonthlyPayment1, loanAmount: loan!, loanTerm: custTerm1)
        customTotal1 = "$ " + (NSString(format: "%.2f", customTotalPayment1) as String).currencyInputFormatting()
        
        let interestSaves1 = originalTotalPayment - customTotalPayment1
        saved1 = "$ " + (NSString(format: "%.2f", interestSaves1) as String).currencyInputFormatting()
        
        customTR1 = TermRateInfo(rate: customRate1.text!, term: customTerm1.text!, monthly: customMonthly1!, totalInterest: customTotal1!, amountSaved: saved1!)
        
        
        //Custom Term/Rate 2
        if (customTerm2.hasText && customRate2.hasText) {
            
            let custTerm2 = Int(customTerm2.text!)!
            let custRate2 = customRate2.text?.currencyToDouble()
            
            let customMonthlyPayment2 = MortgageCalculation.getMonthlyPayment(loanAmount: loan!, loanTerm: custTerm2, interestRate: custRate2!)
            customMonthly2 = "$ " + (NSString(format: "%.2f", customMonthlyPayment2) as String)
            
            let customTotalPayment2 = MortgageCalculation.getTotalPayment(monthly: customMonthlyPayment2, loanAmount: loan!, loanTerm: custTerm2)
            customTotal2 = "$ " + (NSString(format: "%.2f", customTotalPayment2) as String).currencyInputFormatting()
            
            let interestSaves2 = originalTotalPayment - customTotalPayment2
            saved2 = "$ " + (NSString(format: "%.2f", interestSaves2) as String).currencyInputFormatting()
            
            customTR2 = TermRateInfo(rate: customRate2.text!, term: customTerm2.text!, monthly: customMonthly2!, totalInterest: customTotal2!, amountSaved: saved2!)
            
            //Custom Term/Rate 3
            if (customTerm3.hasText && customRate3.hasText) {
                
                let custTerm3 = Int(customTerm3.text!)!
                let custRate3 = customRate3.text?.currencyToDouble()
                
                let customMonthlyPayment3 = MortgageCalculation.getMonthlyPayment(loanAmount: loan!, loanTerm: custTerm3, interestRate: custRate3!)
                customMonthly3 = "$ " + (NSString(format: "%.2f", customMonthlyPayment3) as String)
                
                let customTotalPayment3 = MortgageCalculation.getTotalPayment(monthly: customMonthlyPayment3, loanAmount: loan!, loanTerm: custTerm3)
                customTotal3 = "$ " + (NSString(format: "%.2f", customTotalPayment3) as String).currencyInputFormatting()
                
                let interestSaves3 = originalTotalPayment - customTotalPayment3
                saved3 = "$ " + (NSString(format: "%.2f", interestSaves3) as String).currencyInputFormatting()
                
                customTR3 = TermRateInfo(rate: customRate3.text!, term: customTerm3.text!, monthly: customMonthly3!, totalInterest: customTotal3!, amountSaved: saved3!)
                
                //Set mortgage details
                mortgage = MortgageCalculation(name: nameHome.text!, loan: loanAmount.text!, original: originalTR!, custom1: customTR1!, custom2: customTR2!, custom3: customTR3!)
            }
            else {
                //Set mortgage details
                mortgage = MortgageCalculation(name: nameHome.text!, loan: loanAmount.text!, original: originalTR!, custom1: customTR1!, custom2: customTR2!)
            }
        }
        else {
            //Set mortgage details
            mortgage = MortgageCalculation(name: nameHome.text!, loan: loanAmount.text!, original: originalTR!, custom1: customTR1!)
        }
        

        
        
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMortgageMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMortgageMode {
            //Dismiss if in modal mode (adding item)
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            //Pop view off navigation stack (editing item)
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MortgageCalculatorViewController is not inside a navigation controller.")
        }
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        
    }
    
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        
        // Disable the Save button if the text field is empty.
        for field in inputFields {
            saveButton.isEnabled = field.hasText
        }
        
    }

    
}






