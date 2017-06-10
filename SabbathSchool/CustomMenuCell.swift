//
//  CustomMenuCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 31/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class CustomMenuCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
