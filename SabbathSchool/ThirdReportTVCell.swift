//
//  ThirdReportTVCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 02/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class ThirdReportTVCell: UITableViewCell {

    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
