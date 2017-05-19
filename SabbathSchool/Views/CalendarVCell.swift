//
//  CalendarVCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 04/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class CalendarVCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    var calendar: Calendar_! {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI() {
        
        dateLabel.text = calendar.date_
        
        saturdayLabel.text = calendar.saturday_
    
        if let status =  calendar?.status_ {
            
            if status == "nao_preenchido" {
                dateLabel.textColor = UIColor(red: 226/255.0, green: 101/255.0, blue: 99/255.0, alpha: 1)
            }
            
            if status == "preenchido" {
                dateLabel.textColor = UIColor(red: 30/255.0, green: 215/255.0, blue: 97/255.0, alpha: 1)
            }
            
            if status == "nao_disponivel" {
                dateLabel.textColor = UIColor(red: 15/255.0, green: 157/255.0, blue: 204/255.0, alpha: 1)
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
