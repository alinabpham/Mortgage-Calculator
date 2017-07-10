//
//  MortgageTableViewCell.swift
//  MortgageCalculator
//
//  Created by Alina Pham on 6/21/17.
//  Copyright © 2017 Alina Pham. All rights reserved.
//

import UIKit

class MortgageTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var nameHome: UILabel!
    @IBOutlet weak var originalMonthly: UILabel!
    @IBOutlet weak var custMonthly1: UILabel!
    @IBOutlet weak var custMonthly2: UILabel!
    @IBOutlet weak var custMonthly3: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
