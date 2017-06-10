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
import ReachabilitySwift
import NVActivityIndicatorView

var nameInstructorSegue = ""
var nameFriendSegue = ""
var statusSegue = ""
var idSegue = 0

class FriendsVC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var tableView: UITableView!
    
    var reachability: Reachability?
    
    var user = [User]()
    
    var students = [[Friend_]]()
    
    //var sectionId:String!
    
    var initialInformationCard: [cFriends]?
    
    let operation: String = "getAmigos"
    var functionId: Int32 = 0
    var classId: Int32 = 0
    var contextObject: NSManagedObjectContext!
    var newFriend: NSManagedObject!
    var newInstructor: NSManagedObject!
    
    
    struct Storyboard {
        
        static let friendsCell = "CellFriend"
        static let segueToEditFriend = "SegueToEditFriend"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUser()
        
        // Start reachability without a hostname intially
        setupReachability(nil, useClosures: true)
        startNotifier()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        setupNavigationBar()
   
    }
    
    // MARK: Setup
    
    fileprivate func setupNavigationBar(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38.0, height: 30.0))
        imageView.image = UIImage(named: "logo_cabecalho")
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    // MARK: DataSource

    
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
        
        let size = CGSize(width: 30, height:30)
        
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            NVActivityIndicatorPresenter.self
        }
        
        let getInfoParameters: [String : Any] = ["operacao": "getAmigos", "classeId": 7793/*self.classId*/, "data": 7/*self.functionId*/]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/amigosEstudo/index_controller.php"
        
        //let info = Info(context: managedObjectContext)
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseObject { (response: DataResponse<friendsMaster>) in
            
            switch response.result {
                
            case .failure( _):
                
                self.getFriendCoreData()
                
                return
                
            case .success(let data):
                
                if let someFriends = data.friends {
                    for _friends in someFriends {
                        
                        //print(_friends.name)
                        
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        
                        self.newFriend = NSEntityDescription.insertNewObject(forEntityName: "Friend_", into: self.contextObject)
                        
                        
                        self.newInstructor = NSEntityDescription.insertNewObject(forEntityName: "Instructor_", into: self.contextObject)
  
                        if let instructor = _friends.instructor {
                            self.newFriend.setValue(instructor, forKey: "instructor_")
                            if _friends.instructor == true {
                                self.newInstructor.setValue(_friends.nameInstructor, forKey: "name_")
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
                self.getFriendCoreData()
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                    self.stopAnimating()
                }

            }
        }
    }
    
    
    func getFriendCoreData() {
        
        let presentRequest:NSFetchRequest<Friend_> = Friend_.fetchRequest()
        
        do {
            
            let friend = try managedObjectContext.fetch(presentRequest).filter({$0.instructor_ == true})
            for i in friend {
                var studentsTemp = [Friend_]()
                var friend:[Friend_]
                studentsTemp.append(i)
                friend = try managedObjectContext.fetch(presentRequest).filter({$0.nameInstructor_ == i.name_})
                for e in friend {
                    studentsTemp.append(e)
                }
                self.students.append(studentsTemp)
            }
            //self.students.append(students1)
            self.tableView.reloadData()
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func deleteFriends() -> Void {
        
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
    
    
    func deleteInstructor() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Instructor_")
        
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
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        
        print("Executou o setupReachability")
        
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        
        self.reachability = reachability
        
        if useClosures {
            
            reachability?.whenReachable = { reachability in
                DispatchQueue.main.async {
                    
                    self.sendRequestWhenReachable(reachability)
                    
                    print("Está conectado")
                    
                }
            }
            reachability?.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    
                    print("Sem conexão")
                    
                    self.getCoreDataWhenNotReachable(reachability)
                    
                    // Sem conexão
                    
                }
            }
            
        } else {
            
            NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
            
            print("Entrou no else")
            
        }
    }
    
    func startNotifier() {
        
        print("iniciou a notificação")
        
        do {
            
            try reachability?.startNotifier()
            
        } catch {
            
            //appDelegate.infoView(message: "Unable to start\nnotifier", color: .red)
            //print("\((message: "Unable to start\nnotifier", color: .red))" as Any)
            
            return
        }
    }
    
    func stopNotifier() {
        
        print("Parou a notificação")
        
        reachability?.stopNotifier()
        
        NotificationCenter.default.removeObserver(self, name:ReachabilityChangedNotification, object: nil)
        
        reachability = nil
        
    }
    
    func sendRequestWhenReachable(_ reachability: Reachability) {
        
        if reachability.isReachableViaWiFi {
            
            // Conectado via Wifi
            print("Quando entra Está conectado")
            
            deleteFriends()
            
            deleteInstructor()
            
            getFriend()
            
        } else {
            
            //Sem conexão
            print("Quando não tem internet")
            
            getFriendCoreData()
            
        }
        
    }
    
    func getCoreDataWhenNotReachable(_ reachability: Reachability) {
        
        
        print("Outra função que vai no CoreData")
        
        getFriendCoreData()
        
        tableView.reloadData()
        
        appDelegate.infoView(message: reachability.currentReachabilityString, color: .red)
        
    }
    
    
    func reachabilityChanged(_ note: Notification) {
        
        let reachability = note.object as! Reachability
        
        print("Executou o reachabilityChanged")
        
        if reachability.isReachable {
            
            sendRequestWhenReachable(reachability)
            
        } else {
            
            getCoreDataWhenNotReachable(reachability)
            
        }
    }
    
    deinit {
        stopNotifier()
    }

  
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension FriendsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "CellFriend") as! FriendTVCell
        header.instructorLabel.text = self.students[section][0].name_
        //nameInstructorSegue = self.students[section][0].name_!
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.students.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students[section].count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellStudent", for: indexPath) as! StudentTVCell
        cell.selectionStyle = .none
        cell.nameLabel.text = self.students[indexPath.section][indexPath.row + 1].name_
        return cell
    }
    
    
    // Configura uma animação para a célula
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 1. Setar o estado inicial
        cell.alpha = 0
        
        // 2. Mudar o metodo de animação
        UIView.animate(withDuration: 1.0, animations: {
            cell.alpha = 1.0
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getFriendCoreData()
        
        let instructor = self.students[indexPath.section][indexPath.row - indexPath.row].name_
       
        nameInstructorSegue = instructor!
        
        if let nameFriend = self.students[indexPath.section][indexPath.row + 1].name_ {
        
            nameFriendSegue = nameFriend
            
        }
        
        if let status = self.students[indexPath.section][indexPath.row + 1].statusId_ {
            
            let id = self.students[indexPath.section][indexPath.row + 1].id_
            
            idSegue = Int(id)
            
            statusSegue = status
            
        }
        
        self.performSegue(withIdentifier: Storyboard.segueToEditFriend, sender: nil)
        
    }
    
}
