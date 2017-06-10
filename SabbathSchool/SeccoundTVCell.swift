//
//  SeccoundTVCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 23/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class SeccoundTVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var imgImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var showPieChart: UIButton!
    
    var currentIndex: Int = 0
    
    var more: More_Seccound_!{
        didSet {
            updateProgressView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        progressView.progress = 0
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateProgressView() {
        
        let qn2 = Int(more.qn2_)
        
        print(totalForChart)
        print(qn2)
        
        let value1 = (qn2 * 100)
        
        let value = (value1 / totalForChart)
        
        let remaindValue: Int = value
        
        let valueDouble = Double(remaindValue)
        
        let relative = Float(valueDouble / 100)
        
        progressView.progress = Float(relative)
        
        let valueForLabel = Double(value)
        
        let valueRound = valueForLabel.rounded()
        
        let valueConvertToString = "\(valueRound)"
        
        let valueToStringWithPercent = valueConvertToString.replace(target: ".0", withString: "%")
        
        percentLabel.text = String(valueToStringWithPercent)
        
    }
    
    
}
