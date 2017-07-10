//
//  BarChartView+Data.swift
//  MortgageCalculator
//
//  Created by Alina Pham on 6/27/17.
//  Copyright © 2017 Alina Pham. All rights reserved.
//

import Foundation
import Charts

extension BarChartView {
    
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            //print(labels)
            self.labels = labels
        }
    }
    
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        //formatting yAxis
        let yFormatter = NumberFormatter()
        yFormatter.numberStyle = .currencyAccounting
        yFormatter.currencySymbol = "$"
        yFormatter.maximumFractionDigits = 2
        yFormatter.minimumFractionDigits = 2
        
        self.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: yFormatter)
        
        self.leftAxis.labelFont = UIFont.systemFont(ofSize: 11.0)
        self.rightAxis.drawLabelsEnabled = false
        
        
        //var index = 0
        var smallestVal : Double = yValues[0]
        
        var dataEntries: [BarChartDataEntry] = []
        
        //Formatting xAxis
        let xFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        
        self.legend.font = UIFont.systemFont(ofSize: 13.0)
        self.xAxis.labelFont = UIFont.systemFont(ofSize: 12.0)
        
        for i in 0..<yValues.count {
            if yValues[i] < smallestVal {
                smallestVal = yValues[i]
                //index = i
            }
            
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
            
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartData.barWidth = 0.4
        chartDataSet.colors = [UIColor(red:0.31, green:0.69, blue:1.00, alpha:1.0)]
        chartDataSet.valueFont = UIFont.systemFont(ofSize: 11.0)
        chartDataSet.valueFormatter = DefaultValueFormatter(formatter: yFormatter)
        
        xAxis.valueFormatter = xFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        //Position xAxis labels
        self.xAxis.labelPosition = .bottom
        self.xAxis.labelRotationAngle = CGFloat(45.0)
        
        self.data = chartData
    }
} 
