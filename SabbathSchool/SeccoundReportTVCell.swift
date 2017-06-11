//
//  SeccoundReportTVCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 02/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class SeccoundReportTVCell: UITableViewCell {

    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var entity: Seccound_ListEntity_!{
        didSet {
            updateProgressView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateProgressView() {
        
        let saturdayFull = entity.quantityFilledOut_
        let numberOfSaturday = entity.numberOfSaturday_
        
        let value1 = (saturdayFull * 100)
        
        let value = (value1 / numberOfSaturday)
        
        let valueToString = "\(value)"
        
        let valueToStringWithPercent = valueToString.replace(target: ".0", withString: "")
        
        //let valueInt = Int(valueToStringWithPercent)! / 20
        
        let remaindValue: Int = Int(valueToStringWithPercent)! % 20
        
        let valueDouble = Double(remaindValue)
        
        let relative = Float(valueDouble / 100)
        
        progressView.progress = Float(relative)
        
        let valueToStringForLabel = "\(value)%"
        
        //        let valueToStringWithPercentForLabel = valueToStringForLabel.replace(target: ".0", withString: "%")
        
        percentLabel.text = valueToStringForLabel
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
