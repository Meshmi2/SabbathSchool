//
//  FourthLevelVC.swift
//  SabbathSchool
//
//  Created by André Pimentel on 30/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit
import Foundation
import SideMenu
import CoreData
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import ReachabilitySwift


var nomeClasseFourth: Int16 = 0

class FourthLevelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var reachability: Reachability?
    
    var user = [User]()
    
    var header = [Header_More_Fourth_]()
    
    var more: [More_Fourth_]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var initialInformation: [entityList]?
    
    var navigationBarAppearace = UINavigationBar.appearance()
    
    let operation: String = "getSpecificInfo"
    var entityId: Int32 = Int32(entityIdForFourth)
    var periodId: Int32 = 3
    var ageRange: Int32 = 0
    var classId: Int32 = 0
    var functionId: Int32 = 0
    var questionId: Int32 = Int32(questionIdForSegue)
    var contextObject: NSManagedObjectContext!
    var newMore: NSManagedObject!
    var newHeader: NSManagedObject!
    
    struct Storyboard {
        
        static let moreCell = "CellMore"
        static let segueToMore = "SegueToMore"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
        
        // Start reachability without a hostname intially
        setupReachability(nil, useClosures: true)
        startNotifier()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        configureCellSpace()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadUser() {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            
            let userCurrent = user[0]
            
            // Recovery information then Class User for use in request class Info
            
            periodId = userCurrent.periodId_
            ageRange = userCurrent.ageGroupId_
            classId = userCurrent.classId_
            functionId = userCurrent.functionId_
            
            // Atributing information then class User for tableView Header
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    
    func loadHeader() {
        
        let presentRequest:NSFetchRequest<Header_More_Fourth_> = Header_More_Fourth_.fetchRequest()
        
        do {
            header = try managedObjectContext.fetch(presentRequest)
            
            let headerCurrent = header[0]
            
            if let title = headerCurrent.nameEntityType_ {
                
                self.navigationItem.title = title
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
                
            }
            // Recovery information then Class User for use in request class Info
            
            //registered =  headerCurrent.registered_
            //form = headerCurrent.form_
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func getMore() {
        
        print("Entrou aqui")
        
        let getInfoParameters: [String : Any] = ["operacao": self.operation, "classeId": self.classId, "periodoId": self.periodId, "EntidadeId": self.entityId, "faixaEtaria": self.ageRange, "funcaoId": self.functionId, "questaoId": self.questionId,]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/paginaInicial/index_controller.php"
        
        //let info = Info(context: managedObjectContext)
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseObject { (response: DataResponse<superMore>) in
            
            switch response.result {
                
            case .failure(let error):
                
                self.getMoreCoreData()
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                self.contextObject = appDel.managedObjectContext
                self.newHeader = NSEntityDescription.insertNewObject(forEntityName: "Header_More_Fourth_", into: self.contextObject)
                
                if let total = data.total {
                    self.newHeader.setValue(total, forKey: "total_")
                }
                
                if let nameEntityType = data.entityTypeName {
                    self.newHeader.setValue(nameEntityType, forKey: "nameEntityType_")
                }
                
                if let percentual = data.percentual {
                    self.newHeader.setValue(percentual, forKey: "percentual")
                }
                
                if let oneMore = data.oneMore {
                    self.newHeader.setValue(oneMore, forKey: "oneMoreLevel_")
                }
                
                self.loadHeader()
                
                if let someMore = data.collectionEntity {
                    for _more in someMore {
                        
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        self.newMore = NSEntityDescription.insertNewObject(forEntityName: "More_Fourth_", into: self.contextObject)
                        
                        if let entityId = _more.entityId {
                            self.newMore.setValue(entityId, forKey: "entityId_")
                        }
                        
                        if let entityName = _more.entityName {
                            self.newMore.setValue(entityName, forKey: "entityName_")
                        }
                        
                        if let parentId = _more.parentId {
                            self.newMore.setValue(parentId, forKey: "parentId_")
                        }
                        
                        if let className = _more.className {
                            self.newMore.setValue(className, forKey: "className_")
                        }
                        
                        if let classId = _more.classId {
                            self.newMore.setValue(classId, forKey: "classId")
                        }
                        
                        if let registred = _more.registred {
                            self.newMore.setValue(registred, forKey: "registred_")
                        }
                        
                        if let present = _more.present {
                            self.newMore.setValue(present, forKey: "present")
                        }
                        
                        if let qn2 = _more.QN2 {
                            self.newMore.setValue(qn2, forKey: "qn2_")
                        }
                        
                        if let qp2 = _more.QP2 {
                            self.newMore.setValue(qp2, forKey: "qp2_")
                        }
                        
                        
                        do {
                            
                            try self.newMore.managedObjectContext?.save()
                            
                        } catch {
                            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                        }
                    }
                }
                
                self.getMoreCoreData()
                
            }
        }
    }
    
    
    
    func getMoreCoreData() {
        
        let presentRequest:NSFetchRequest<More_Fourth_> = More_Fourth_.fetchRequest()
        
        do {
            more = try managedObjectContext.fetch(presentRequest)
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func deleteRecords() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "More_Fourth_")
        
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
    
    func deleteHeader() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Header_More_Fourth_")
        
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
        if self.more == nil {
            return 0
        }
        return (self.more?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.moreCell, for: indexPath) as! FourthTVCell
        
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let moreInformation = more?[indexPath.row]
        
        cell.more = moreInformation
        
        if let percentual = moreInformation?.qp2_ {
            
            let value = percentual
            
            let valueRound = value.rounded()
            
            let valueToString = "\(valueRound)"
            
            let valueToStringWithPercent = valueToString.replace(target: ".0", withString: "%")
            
            print(valueToStringWithPercent)
            
            cell.percentLabel.text = String(valueToStringWithPercent)
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.titleLabel.text = moreInformation?.entityName_
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getMoreCoreData()
        
        let dateSegue = more?[indexPath.row]
        
        var qp2 = ""
        
        if let nameClass = dateSegue?.entityName_{
            
            if let percentual = dateSegue?.qp2_ {
                
                let value = percentual
                
                let valueRound = value.rounded()
                
                let valueToString = "\(valueRound)"
                
                let valueToStringWithPercent = valueToString.replace(target: ".0", withString: "%")
                qp2 = valueToStringWithPercent
            }
            
            SweetAlert().showAlert("\(nameClass)", subTitle: "Comunão: \(qp2)", style: AlertStyle.warning)
            
        }
        
        //self.performSegue(withIdentifier: Storyboard.segueToMore, sender: nil)
        
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
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        
        print("Executou o setupReachability")
        
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        
        self.reachability = reachability
        
        if useClosures {
            
            reachability?.whenReachable = { reachability in
                DispatchQueue.main.async {
                    
                    self.sendRequestWhenReachable(reachability)
                    
                    //                    self.getInfoCoreData()
                    //
                    //                    self.tableView.reloadData()
                    
                    print("Está conectado")
                    
                }
            }
            reachability?.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    
                    self.getCoreDataWhenNotReachable(reachability)
                    
                    // Sem conexão
                    
                    print("Sem conexão")
                    
                    //self.getInfoCoreData()
                    
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
            
            deleteRecords()
            
            deleteHeader()
            
            getMore()
            
            //getInfoCoreData()
            
            //tableView.reloadData()
            
        } else {
            
            //Sem conexão
            print("Quando não tem internet")
            
            getMoreCoreData()
            
            loadHeader()
            
        }
        
    }
    
    func getCoreDataWhenNotReachable(_ reachability: Reachability) {
        
        
        print("Outra função que vai no CoreData")
        
        getMoreCoreData()
        
        loadHeader()
        
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

    func configureCellSpace() {
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
}
