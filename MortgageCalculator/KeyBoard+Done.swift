//
//  keyboardExtensions.swift
//  MortgageCalculator
//
//  Created by Alina Pham on 6/19/17.
//  Copyright © 2017 Alina Pham. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController: UITextFieldDelegate {
    
    func addDoneButtonToKeyboard(textField: UITextField){
        
        let doneToolbar = UIToolbar()
        
        doneToolbar.barStyle = UIBarStyle.default
        
        doneToolbar.tintColor = UIColor.white
        
        doneToolbar.backgroundColor = UIColor.darkText
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction(){
        self.view.endEditing(true)
    }
    
}
