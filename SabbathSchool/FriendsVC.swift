//
//  FriendsVC.swift
//  SabbathSchool
//
//  Created by André Pimentel on 05/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit
import CoreData
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user = [User]()
    
    var friend: [Friend_]?
    
    var initialInformationCard: [cFriends]?
    
    let operation: String = "getAmigos"
    var functionId: Int32 = 0
    var classId: Int32 = 0
    var contextObject: NSManagedObjectContext!
    var newFriend: NSManagedObject!
    var newInstructor: NSManagedObject!
    
    
    struct Storyboard {
        
        static let friendsCell = "CellFriend"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUser()
       
        getFriend()
        
        getFriendCoreData()
   
    }

    
    func loadUser() {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            
            let userCurrent = user[0]
            
            // Recovery information then Class User for use in request class Info
            
            classId = userCurrent.classId_
            functionId = userCurrent.functionId_
            
            // Atributing information then class User for tableView Header
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    
    func getFriend() {
        
        let getInfoParameters: [String : Any] = ["operacao": "getAmigos", "classeId": self.classId, "data": self.functionId]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/amigosEstudo/index_controller.php"
        
        //let info = Info(context: managedObjectContext)
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseObject { (response: DataResponse<friendsMaster>) in
            
            switch response.result {
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                self.deleteRecords()
                
                if let someFriends = data.friends {
                    for _friends in someFriends {
                        
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        self.newFriend = NSEntityDescription.insertNewObject(forEntityName: "Friend_", into: self.contextObject)
                        
                        
                        self.newInstructor = NSEntityDescription.insertNewObject(forEntityName: "Instructor_", into: self.contextObject)
  
                        if let instructor = _friends.instructor {
                            self.newFriend.setValue(instructor, forKey: "instructor_")
                            if _friends.instructor == true {
                                self.newInstructor.setValue(instructor, forKey: "name_")
                            }
                        }
                        if let name = _friends.name {
                            self.newFriend.setValue(name, forKey: "name_")
                        }
                        if let nameInstructor = _friends.nameInstructor {
                            self.newFriend.setValue(nameInstructor, forKey: "nameInstructor_")
                        }
                        if let statudId = _friends.statusStudyId {
                            self.newFriend.setValue(statudId, forKey: "statusId_")
                        }
                        if let id = _friends.id {
                            self.newFriend.setValue(id, forKey: "id_")
                        }
                        
                        do {
                            try self.newFriend.managedObjectContext?.save()
                        } catch {
                            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    
    func getFriendCoreData() {
        
        let presentRequest:NSFetchRequest<Friend_> = Friend_.fetchRequest()
        
        do {
            friend = try managedObjectContext.fetch(presentRequest)
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func deleteRecords() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend_")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        do {
            let items = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedObjectContext.delete(item)
            }
            
            // Save Changes
            try managedObjectContext.save()
            
        } catch {
            appDelegate.errorView("Isso é constrangedor!")
        }
        
    }

 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.friend == nil {
            return 0
        }
        return (self.friend?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.friendsCell, for: indexPath) as! FriendTVCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let initialInformationFriend = friend?[indexPath.row]
        
        cell.instructorLabel.text = initialInformationFriend?.nameInstructor_
        
        return cell
        
    }
  
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
