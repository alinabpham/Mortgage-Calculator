//
//  MortgageTableViewController.swift
//  MortgageCalculator
//
//  Created by Alina Pham on 6/21/17.
//  Copyright © 2017 Alina Pham. All rights reserved.
//

import UIKit
import os.log

class MortgageTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var mortgages = [MortgageCalculation]()
    var mortgage : MortgageCalculation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Give Back Button no title
        self.navigationItem.backBarButtonItem?.title = ""
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        //load any existing mortgages
        if let savedMortgages = loadMortgages() {
            mortgages += savedMortgages
        }
        else {
            print("There are no saved mortgages")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mortgages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MortgageTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MortgageTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MortgageTableViewCell.")
        }
        
        // Fetches the appropriate mortgage for the data source layout.
        let mortgage = mortgages[indexPath.row]
        
        cell.nameHome.text = mortgage.name
        cell.originalMonthly.text = "Pay: \(mortgage.original.monthly) /mo"
        cell.custMonthly1.text = "\(mortgage.custom1.monthly) /mo"
        cell.custMonthly2.text = "\(mortgage.custom2?.monthly ?? "") /mo"
        cell.custMonthly3.text = "\(mortgage.custom3?.monthly ?? "") /mo"
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            mortgages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
            
        case "AddItem":
            os_log("Adding a new mortgage object.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mortgageDetailViewController = segue.destination as? MortgageDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMortgageCell = sender as? MortgageTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "N/A")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMortgageCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMortgage = mortgages[indexPath.row]
            mortgageDetailViewController.mortgage = selectedMortgage
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "N/A")")
        }

    }
    
    //MARK: Actions
    
    //When click Save, go back to main menu and update information or save new mortgage information
    @IBAction func unwindToMortgageList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? MortgageCalculatorViewController, let mortgage = sourceViewController.mortgage {
            
            print("went back")
            print(mortgage)
            
            // Check whether a row in the table view is selected (aka edit)
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing meal
                mortgages[selectedIndexPath.row] = mortgage
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
                // Add a new meal otherwise
            else {
                
                let newIndexPath = IndexPath(row: mortgages.count, section: 0)
                
                mortgages.append(mortgage)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            
            saveMeals()
        }
        
    }
    
    //MARK: Private functions
    
    //Save the meal when newly created or updated
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(mortgages, toFile: MortgageCalculation.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Mortgage successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save mortgage...", log: OSLog.default, type: .error)
        }
    }
    
    //Load any saved mortgages
    private func loadMortgages() -> [MortgageCalculation]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: MortgageCalculation.ArchiveURL.path) as? [MortgageCalculation]
    }
    

}
