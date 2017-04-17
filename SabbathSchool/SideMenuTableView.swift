//
//  SideMenuTableView.swift
//  SideMenu
//
//  Created by Jon Kent on 4/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SideMenu

class SideMenuTableView: UITableViewController, ExitTVCellDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //tableView.tableFooterView = UIView(frame: CGRectZero)
        
        }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    struct Storyboard {
        static let exitCell = "ExitCell"
        
    }
    
    func buttonExitDidClicked() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginVC
        // vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginVC
        // vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    
}
