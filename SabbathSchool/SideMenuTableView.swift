//
//  SideMenuTableView.swift
//  SideMenu
//
//  Created by Jon Kent on 4/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SideMenu
import CoreData

class SideMenuTableView: UITableViewController, ExitTVCellDelegate {
    
   
   
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
   
    @IBOutlet weak var functionLabel: UILabel!
    
    var user = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        //tableView.tableFooterView = UIView(frame: CGRectZero)
            loadUser()
        
        }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    struct Storyboard {
        static let exitCell = "ExitCell"
        
    }
    
    
    
    func loadUser() {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            
            let userCurrent = user[0]
        
            // Recovery information then Class User for use in request class Info
            
            // Atributing information then class User for tableView Header
            
            functionLabel.text = userCurrent.functionName_
            
            if let fullname = userCurrent.name_ {
                
                let first = fullname.strstr(needle: " ", beforeNeedle: true)
                
                firstNameLabel.text = first
                
                
                let last = fullname.strstr(needle: " ")
                
                lastNameLabel.text = last
                
                
                
            }
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
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
