//
//  InitialInformationWithOutPercentualTVCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 06/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class InitialInformationWithOutPercentualTVCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueDescriptionLabel: UILabel!
    @IBOutlet weak var imgImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
