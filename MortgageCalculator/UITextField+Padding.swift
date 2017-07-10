//
//  UITextField+Padding.swift
//  MortgageCalculator
//
//  Created by Alina Pham on 6/21/17.
//  Copyright © 2017 Alina Pham. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
}
