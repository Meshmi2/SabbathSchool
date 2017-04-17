//
//  CardTVCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 04/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class CardTVCell: UITableViewCell {

    @IBOutlet weak var valueQuestionTextField: UITextField!
    @IBOutlet weak var descriptionQuestionLabel: UILabel!
    @IBOutlet weak var titleQuestionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
