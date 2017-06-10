//
//  FourthTVCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 30/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class FourthTVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var imgImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var currentIndex: Int = 0
    
    var more: More_Fourth_!{
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
        
        let value = more.qn2_
        
        let valueToString = "\(value)"
        
        let valueToStringWithPercent = valueToString.replace(target: ".0", withString: "")
        
        _ = Int(valueToStringWithPercent)! / 20
        
        let remaindValue: Int = Int(valueToStringWithPercent)! % 20
        
        let valueDouble = Double(remaindValue)
        
        let relative = Float(valueDouble / 20)
        
        progressView.progress = Float(relative)
        
        
    }
    
    
}
