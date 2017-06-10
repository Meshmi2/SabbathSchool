//
//  MenuHeaderCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 31/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class MenuHeaderCell: UITableViewCell {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var descriptionFunctionLabel: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
