//
//  firstPieChartVC.swift
//  SabbathSchool
//
//  Created by André Pimentel on 07/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import UIKit
import Charts

class FirstPieChartVC: UIViewController {

    @IBOutlet var pieChartView: PieChartView!
    @IBOutlet weak var registredLabel: UILabel!
    @IBOutlet weak var presentLabel: UILabel!
    @IBOutlet weak var QNLabel: UILabel!
    @IBOutlet weak var titleQNLabel: UILabel!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        createChart()
    
    }
    
     func viewWillAppear()
    {
        self.pieChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func createChart() {
        
        pieChartDictionary = UserDefaults.standard.value(forKey: "chartPie") as? [String: Any]
        
        var entityName = String()
        
        if (pieChartDictionary?["entityName"]) != nil {
            
            entityName = pieChartDictionary?["entityName"] as! String
            print(entityName) 
        }
        
        if let matriculdos = pieChartDictionary?["matriculados"] {
    
            registredLabel.text = String(describing: matriculdos)
        }
        
        if let qn2 = pieChartDictionary?["qn2"]{
            
            QNLabel.text = String(describing: qn2)
            titleQNLabel.text = titleForPieChart
        }
        
        if let presentes = pieChartDictionary?["present"] {
            
            presentLabel.text = String(describing: presentes)
        }
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        
        var qp2 = Double()
        
        if let qp2Temp = pieChartDictionary?["qp2"] {
            
            qp2 = qp2Temp as! Double
            
        }
        
        let qp2Rounded = qp2.rounded()
        
        let anotherValue = 100 - qp2Rounded
        
        let itensChart = [anotherValue, qp2Rounded]
        // Do any additional setup after loading the view.
        let ys1 = Array(itensChart) //{ x in return sin(Double(x) / 2.0 / 3.141 * 1.5) * 100.0 }
        
        let yse1 = ys1.enumerated().map { x, y in return PieChartDataEntry(value: Double(y), label: String(x)) }
        
        let data = PieChartData()
        let ds1 = PieChartDataSet(values: yse1, label: "\(titleForPieChart)")
        print(ds1)
        ds1.colors = ChartColorTemplates.vordiplom()
        
        data.addDataSet(ds1)
        
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText: NSMutableAttributedString = NSMutableAttributedString(string: "\(titleForPieChart) \n \(entityName)")
        centerText.setAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 10.0)!, NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, centerText.length))
        centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 13.0)!, NSForegroundColorAttributeName: UIColor.gray], range: NSMakeRange(10, centerText.length - 10))
        centerText.addAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-LightItalic", size: 13.0)!, NSForegroundColorAttributeName: UIColor(red: 51 / 255.0, green: 181 / 255.0, blue: 229 / 255.0, alpha: 1.0)], range: NSMakeRange(centerText.length - 19, 19))
        
        
        self.pieChartView.centerAttributedText = centerText
        
        self.pieChartView.data = data
        
        self.pieChartView.chartDescription?.text = "O valor em porcentagem apresentado aqui, \n corresponde ao total da entidade anterior"

        
    }
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        
        self.removeAnimate()
        //self.view.removeFromSuperview()
        
        UserDefaults.standard.removeObject(forKey: "chartPie")
        UserDefaults.standard.synchronize()
        
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }

    
}
