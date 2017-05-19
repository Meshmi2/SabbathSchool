//
//  ExitTVCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 23/03/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

protocol ExitTVCellDelegate
{
    func buttonExitDidClicked()
}

class ExitTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var delegate: ExitTVCellDelegate!
    
    @IBAction func exitButton(sender: UIButton) {
        
        self.delegate?.buttonExitDidClicked()
        
    }

}
