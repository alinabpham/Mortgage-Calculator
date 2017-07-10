//
//  MortgageDetailViewController.swift
//  MortgageCalculator
//
//  Created by Alina Pham on 6/21/17.
//  Copyright © 2017 Alina Pham. All rights reserved.
//

import UIKit

class MortgageDetailViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var nameHome: UILabel!
    @IBOutlet weak var loanAmount: UILabel!
    @IBOutlet weak var interestRate: UILabel!
    @IBOutlet weak var loanTerm: UILabel!
    
    @IBOutlet weak var originalMonthly: UILabel!
    @IBOutlet weak var originalTotal: UILabel!
    
    @IBOutlet weak var custTerm1: UILabel!
    @IBOutlet weak var custMonthly1: UILabel!
    @IBOutlet weak var custTotal1: UILabel!
    @IBOutlet weak var amountSaved1: UILabel!

    @IBOutlet weak var custTerm2: UILabel!
    @IBOutlet weak var custMonthly2: UILabel!
    @IBOutlet weak var custTotal2: UILabel!
    @IBOutlet weak var amountSaved2: UILabel!
    
    @IBOutlet weak var custTerm3: UILabel!
    @IBOutlet weak var custMonthly3: UILabel!
    @IBOutlet weak var custTotal3: UILabel!
    @IBOutlet weak var amountSaved3: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    var mortgage: MortgageCalculation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.backBarButtonItem?.title = ""
        
        //If mortgage previously selected, fill with existing info
        if let mortgage = mortgage {
            
            navigationItem.title = mortgage.name
            nameHome.text = mortgage.name
            loanAmount.text = mortgage.loan
            interestRate.text = mortgage.original.rate
            loanTerm.text = mortgage.original.term
            
            originalMonthly.text = mortgage.original.monthly
            originalTotal.text = mortgage.original.totalInterest
            
            custTerm1.text = mortgage.custom1.term
            custMonthly1.text = mortgage.custom1.monthly
            custTotal1.text = mortgage.custom1.totalInterest
            amountSaved1.text = mortgage.custom1.amountSaved
            
            custTerm2.text = mortgage.custom2?.term
            custMonthly2.text = mortgage.custom2?.monthly
            custTotal2.text = mortgage.custom2?.totalInterest
            amountSaved2.text = mortgage.custom2?.amountSaved
            
            custTerm3.text = mortgage.custom3?.term
            custMonthly3.text = mortgage.custom3?.monthly
            custTotal3.text = mortgage.custom3?.totalInterest
            amountSaved3.text = mortgage.custom3?.amountSaved
        }
        
        //Create border
        for view in contentView.subviews {
            if view.tag == 1 {
                view.layer.borderColor = UIColor(red:0.77, green:0.76, blue:0.76, alpha:1.0).cgColor
                view.layer.borderWidth = 0.75
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "EditItem") {
            
            guard let mortgageCalculatorViewController = segue.destination as? MortgageCalculatorViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
        
            mortgageCalculatorViewController.mortgage = mortgage
        
        }
        else if (segue.identifier == "SeeChart") {
            
            guard let mortgageBarViewController = segue.destination as? MortgageBarViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            mortgageBarViewController.mortgage = mortgage
        
        }
        else {
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "N/A")")
        }
    }
    
 

}








