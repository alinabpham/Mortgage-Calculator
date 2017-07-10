//
//  MortgageBarViewController.swift
//  MortgageCalculator
//
//  Created by Alina Pham on 6/26/17.
//  Copyright © 2017 Alina Pham. All rights reserved.
//

import UIKit
import Charts

class MortgageBarViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var barChart: BarChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var options : [String]!
    var mortgage : MortgageCalculation?
    
    var interestPaid : [Double]!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        barChart.noDataText = "You need to provide data for the chart."
        
        if ((mortgage?.custom2) != nil) {
            if((mortgage?.custom3) != nil){
                options = ["Original", "Custom 1" , "Custom 2", "Custom 3"]
                interestPaid = [mortgage!.original.totalInterest.currencyToDouble(), mortgage!.custom1.totalInterest.currencyToDouble(), (mortgage!.custom2?.totalInterest.currencyToDouble())!, (mortgage!.custom3?.totalInterest.currencyToDouble())!]
            }
            else{
                options = ["Original", "Custom 1" , "Custom 2"]
                interestPaid = [mortgage!.original.totalInterest.currencyToDouble(), mortgage!.custom1.totalInterest.currencyToDouble(), (mortgage!.custom2?.totalInterest.currencyToDouble())!]
            }
        }
        else {
            options = ["Original", "Custom 1"]
            interestPaid = [mortgage!.original.totalInterest.currencyToDouble(), mortgage!.custom1.totalInterest.currencyToDouble()]
        }

        
        setChart(dataPoints: options, values: interestPaid)
        
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
    }
    
    //MARK: Functions
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        
        barChart.noDataText = "You need to provide data for the chart."
        
        barChart.chartDescription?.text = ""
        
        barChart.xAxis.granularityEnabled = true
        barChart.xAxis.granularity = 1.0
        
        
        
        barChart.setBarChartData(xValues: dataPoints, yValues: values, label: "Interest Paid")
        
        barChart.drawGridBackgroundEnabled = true
        barChart.gridBackgroundColor = NSUIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        barChart.xAxis.drawGridLinesEnabled = false

        barChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)

    }
    

}









