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


class SideMenuTableView: UITableViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
   
    @IBOutlet weak var functionLabel: UILabel!
    
    var user = [User]()
    var releasesReports: Int16 = 0
    var firstName = ""
    var lastName = ""
    var functionDescription = ""
    
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
        
        static let segueToCalendar = "SegueToCalendar"
        static let segueToFriend = "SegueToFriend"
        static let segueToReport = "SegueToReport"
    
    }
    
    
    
    func loadUser() {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            
            let userCurrent = user[0]
        
            // Recovery information then Class User for use in request class Info
            
            // Atributing information then class User for tableView Header
            
            self.functionDescription = userCurrent.functionName_!
            releasesReports = userCurrent.releasesReports_
            
            if let fullname = userCurrent.name_ {
                
                let first = fullname.strstr(needle: " ", beforeNeedle: true)
                
                self.firstName = first!
            
                let last = fullname.strstr(needle: " ")
                
                self.lastName = last!
    
            }
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }

    
       func buttonExitDidClicked() {
        
        print("Clicou aqui")
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginVC
        // vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
        
        deleteRecords()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginVC
        // vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    
    
    func deleteRecords() -> Void {
       
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [User]
        
        for object in resultData {
            moc.delete(object)
        }
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        switch releasesReports {
    
        // Se usuário preenche cartão, retorna 4 células
        case 0:
           
            print("Não é departamental")
            
            return 4
        
        // Se o usuário apenas visualiza relatórios retorna 3 cálulas
        case 1:
            
            print("Não é departamental")
            
            return 5
            
        default:

            return 0
        
        }
    
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Entrou no cellForRowAtIndexPath")
        
        switch releasesReports {
        
        case 0:
           
            print("Não é departamental")
            
            if indexPath.row == 0 {

                let cell = Bundle.main.loadNibNamed("MenuHeaderCell", owner: self, options: nil)?.first as! MenuHeaderCell
                
                cell.selectionStyle = .none
                
                cell.firstNameLabel.text = firstName
                cell.lastNameLabel.text = lastName
                cell.descriptionFunctionLabel.text = functionDescription
                
                return cell
            }
            
            if indexPath.row == 1 {
                
                let cell = Bundle.main.loadNibNamed("MenuCalendarCell", owner: self, options: nil)?.first as! MenuCalendarCell
                
                cell.selectionStyle = .none
                
                return cell
            }
            
            if indexPath.row == 2 {
                
                let cell = Bundle.main.loadNibNamed("MenuFriendCell", owner: self, options: nil)?.first as! MenuFriendCell
                
                return cell
           
            }
            
            if indexPath.row == 3 {
                
                let cell = Bundle.main.loadNibNamed("MenuExitCell", owner: self, options: nil)?.first as! MenuExitCell
                
                cell.selectionStyle = .none
                
                return cell
            
            }
            
            else {
                
                let desfaultCell = UITableViewCell()
                
                return desfaultCell
           
            }
        
        case 1:
            
            print("É departamental")
            
            if indexPath.row == 0 {
                
                let cell = Bundle.main.loadNibNamed("MenuHeaderCell", owner: self, options: nil)?.first as! MenuHeaderCell
                
                cell.selectionStyle = .none
                
                cell.firstNameLabel.text = firstName
                cell.lastNameLabel.text = lastName
                cell.descriptionFunctionLabel.text = functionDescription
                
                return cell
            }
            
            if indexPath.row == 1 {
                
                let cell = Bundle.main.loadNibNamed("MenuCalendarCell", owner: self, options: nil)?.first as! MenuCalendarCell
                
                cell.selectionStyle = .none
                
                return cell
            }
            
            if indexPath.row == 2 {
                
                let cell = Bundle.main.loadNibNamed("MenuFriendCell", owner: self, options: nil)?.first as! MenuFriendCell
                
                return cell
                
            }
            
            if indexPath.row == 3 {
                
                let cell = Bundle.main.loadNibNamed("MenuReportCell", owner: self, options: nil)?.first as! MenuReportCell
                
                cell.selectionStyle = .none
                
                return cell
            
            }
            
            if indexPath.row == 4 {
                
                let cell = Bundle.main.loadNibNamed("MenuExitCell", owner: self, options: nil)?.first as! MenuExitCell
                
                cell.selectionStyle = .none
                
                return cell
                
            } else {
                
                let desfaultCell = UITableViewCell()
                
                return desfaultCell
            
            }
       
        default:
            
            print("Default")
        
        }
        
        let desfaultCell = UITableViewCell()
        
        return desfaultCell
    
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch releasesReports {
        
        case 0:
            
            if indexPath.row == 1 {
                self.performSegue(withIdentifier: Storyboard.segueToCalendar, sender: nil)
            }
            
            if indexPath.row == 2 {
                self.performSegue(withIdentifier: Storyboard.segueToFriend, sender: nil)
            }
            
            if indexPath.row == 3 {
                
                UserDefaults.standard.removeObject(forKey: "user")
                UserDefaults.standard.synchronize()
                
                deleteRecords()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginVC
                // vc.delegate = self
                self.present(vc, animated: true, completion: nil)
                
            }

        case 1:
            
            if indexPath.row == 1 {
                self.performSegue(withIdentifier: Storyboard.segueToCalendar, sender: nil)
            }

            if indexPath.row == 2 {
                self.performSegue(withIdentifier: Storyboard.segueToFriend, sender: nil)
            }

            if indexPath.row == 3 {
                self.performSegue(withIdentifier: Storyboard.segueToReport, sender: nil)
            }

            if indexPath.row == 4 {
                
                UserDefaults.standard.removeObject(forKey: "user")
                UserDefaults.standard.synchronize()
                
                deleteRecords()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginVC
                // vc.delegate = self
                self.present(vc, animated: true, completion: nil)
                
            }
       
        default:
            print("Sou o Default")
        }
        
    }

    
    // MARK: Get Context
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}

extension MenuExitCell {
    
    func buttonExitDidClicked() {
        print("Clicou aqui")
    }
}
