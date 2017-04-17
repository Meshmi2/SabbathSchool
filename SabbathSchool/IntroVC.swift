//
//  IntroVC.swift
//  SabbathSchool
//
//  Created by André Pimentel on 15/03/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func showLogin(_ sender: UIButton?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginVC
        // vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

}
