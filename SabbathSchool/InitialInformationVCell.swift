//
//  InitialInformationTVCell.swift
//  SabbathSchool
//
//  Created by André Pimentel on 15/02/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class InitialInformationTVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var smileImabeView: UIImageView!
    @IBOutlet weak var imgImageView: UIImageView!
        
    @IBOutlet weak var firstProgressView: UIProgressView!
    @IBOutlet weak var seccoundProgressView: UIProgressView!
    @IBOutlet weak var thirdProgressView: UIProgressView!
    @IBOutlet weak var fourthProgressView: UIProgressView!
    @IBOutlet weak var fifthProgressView: UIProgressView!
    
    
    var currentIndex: Int = 0

    var info: Info!{
        didSet {
            updateProgressView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        firstProgressView.progress = 0
        seccoundProgressView.progress = 0
        thirdProgressView.progress = 0
        fourthProgressView.progress = 0
        fifthProgressView.progress = 0
    }
    
    
    func updateProgressView() {
        
        let value = info.value_
        
        let valueToString = "\(value)"
        
        let valueToStringWithPercent = valueToString.replace(target: ".0", withString: "")
        
        let valueInt = Int(valueToStringWithPercent)! / 20
        
        let remaindValue: Int = Int(valueToStringWithPercent)! % 20
        
        let valueDouble = Double(remaindValue)
        
        let relative = Float(valueDouble / 20)
    
        
        /*let lessOfTwenty = Int(valueToStringWithPercent)
        
        if lessOfTwenty! <= 20 {
            fifthProgressView.progress = 1
        }*/
        
        switch valueInt {
        case 1:
         
            firstProgressView.progress = 1
            seccoundProgressView.progress = Float(relative)
        case 2:
        
            firstProgressView.progress = 1
            seccoundProgressView.progress = 1
            thirdProgressView.progress = Float(relative)
        
        case 3:
        
            firstProgressView.progress = 1
            seccoundProgressView.progress = 1
            thirdProgressView.progress = 1
            fourthProgressView.progress = Float(relative)
        
        case 4:
        
            firstProgressView.progress = 1
            seccoundProgressView.progress = 1
            thirdProgressView.progress = 1
            fourthProgressView.progress = 1
            fifthProgressView.progress = Float(relative)
        
        case 5:
        
            firstProgressView.progress = 1
            seccoundProgressView.progress = 1
            thirdProgressView.progress = 1
            fourthProgressView.progress = 1
            fifthProgressView.progress = 1
        
        default:
            print("Este é o Default")
        }
        
                
    }
    
}
