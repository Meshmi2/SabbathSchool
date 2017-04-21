//
//  MainViewController.swift
//
//  Created by Jon Kent on 11/12/15.
//  Copyright © 2015 Jon Kent. All rights reserved.
//

import Foundation
import SideMenu
import CoreData
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import ReachabilitySwift
import UIKit


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var entityTypeLabel: UILabel!
    @IBOutlet weak var entityLabel: UILabel!
    @IBOutlet weak var periodNameLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var ageRangeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var actualizedAtLabel: UILabel!
    
    var reachability: Reachability?
    
    var user = [User]()
    
    var info: [Info]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var initialInformation: [InitialInformation]?
    
        
    let operation: String = "getInfo"
    var entityId: Int32 = 0
    var periodId: Int32 = 0
    var ageRange: Int32 = 0
    var classId: Int32 = 0
    var funcaoId: Int32 = 0
    var contextObject: NSManagedObjectContext!
    var newInfo: NSManagedObject!
    
    struct Storyboard {
       
        static let questionCell = "CellQuestion"
        static let questionCellWithOutPercentual = "CellQuestionWihOutPercentual"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Start reachability without a hostname intially
        setupReachability(nil, useClosures: true)
        startNotifier()
        
        // After 5 seconds, stop and re-start reachability, this time using a hostname
        let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(5)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.stopNotifier()
            self.setupReachability(nil, useClosures: true)
            self.startNotifier()
            
            let dispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(5)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                self.stopNotifier()
                self.setupReachability(nil, useClosures: true)
                self.startNotifier()
            }
            
        }
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadUser()
        
        self.deleteRecords()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo_cabecalho.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
    }
    
    func loadUser() {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            
            let userCurrent = user[0]
            
            print("Este é o userCurrent")
            print(user)
            
            // Recovery information then Class User for use in request class Info
            
            periodId = userCurrent.periodId_
            entityId = userCurrent.entity_
            ageRange = userCurrent.ageGroupId_
            classId = userCurrent.classId_
            funcaoId = userCurrent.functionId_
            
            
            // Atributing information then class User for tableView Header
            
            self.entityTypeLabel.text = userCurrent.entityTypeName_
            self.entityLabel.text = userCurrent.entityName_
            self.periodNameLabel.text = userCurrent.periodName_
            self.classNameLabel.text = userCurrent.className_
            self.ageRangeLabel.text = userCurrent.ageGroupName_
            self.levelLabel.text = "\(userCurrent.entityLevel_)"
            
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func getInfo() {
        
        let getInfoParameters: [String : Any] = ["operacao": "getInfo", "periodoId": 3/*periodId*/, "faixaEtaria": 0/*ageRange*/ ,"classeId": 13072/*classId*/, "EntidadeId": 0/*entityId*/, "funcaoId": 7/*funcaoId*/]
       
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/paginaInicial/index_controller.php"
        
        
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseArray { (response: DataResponse<[InitialInformation]>) in
            
            //let data = response
        
            switch response.result {
                
            case .failure(let error):
                
                self.getInfoCoreData()
                
                print(error.localizedDescription)
                
                
                
                return
                
            case .success(let data):
            
                
                self.deleteRecords()
                
                for _info in data {
                    
                    let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    self.contextObject = appDel.managedObjectContext
                    self.newInfo = NSEntityDescription.insertNewObject(forEntityName: "Info", into: self.contextObject)
                    
                    if let description = _info.Descricao {
                        
                        self.newInfo.setValue(description, forKey: "description_")
                        
                        //print("1 " + description)
                    }
                    
                    if let title = _info.TituloGrid {
                        
                        self.newInfo.setValue(title, forKey: "title_")
                        
                        //print("2 " + title)
                    }
                  
                    if let img = _info.Img {
                        
                        self.newInfo.setValue(img, forKey: "image_")
                        
                        //print("3 " + img)
                    }
                    
                    if let reportPercentual = _info.Relatoriopercentual {
                       
                        self.newInfo.setValue(reportPercentual, forKey: "reportPercentual_")
                    
                        //print("4 \(reportPercentual)")
                    }
                    
                    
                    if let value = _info.valor {
                        
                        let valueArround = Double(value).roundTo(places: 0)
                    
                        self.newInfo.setValue(valueArround, forKey: "value_")

                        //print("5 \(value)")
                        //print("5.1 \(valueArround)")
                    }
                    
                    if let descriptionValue = _info.DescricaoValor {
                            
                            self.newInfo.setValue(descriptionValue, forKey: "descriptionValue_")
                        
                        //print("6 " + descriptionValue)
                    }
                    
                    if _info.DescricaoValor == "" {
                        self.newInfo.setValue("none", forKey: "descriptionValue_")
                    }
                    
                    if let percentual = _info.percentual {
                        
                        self.newInfo.setValue(percentual, forKey: "percentual_")
                     
                        //print("7  + \(percentual)")
                    }
                    
                    if let imgSmile = _info.imgSmile {
                        
                         self.newInfo.setValue(imgSmile, forKey: "smile_")
                        
                         //print("8 " + imgSmile)
                        
                    } else {
                   
                        self.newInfo.setValue("none", forKey: "smile_")
                    
                    }
                    
                    do {
                        try self.newInfo.managedObjectContext?.save()
                        
                        self.getInfoCoreData()
                        
                    } catch {
                        appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                    }
                }
                
            }
            
        }
        
    }
    
    func getInfoCoreData() {
        
        let presentRequest:NSFetchRequest<Info> = Info.fetchRequest()
        
        do {
            info = try managedObjectContext.fetch(presentRequest)
            //tableView.reloadData()
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func deleteRecords() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Info")
        
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
        if self.info == nil {
            return 0
        }
        return (self.info?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let information = info?[indexPath.row]
        
        if information?.reportPercentual_ == 1 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.questionCell, for: indexPath) as! InitialInformationTVCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            if let initialInformation = info?[indexPath.row] {
            
                cell.info = initialInformation
                    
                //print("-----------------------------")
                //print(initialInformation)
                //print("=============================")
                
                cell.titleLabel.text = initialInformation.title_
                
                 
                let value = initialInformation.value_
                    
                let valueToString = "\(value)"
                    
                let valueToStringWithPercent = valueToString.replace(target: ".0", withString: "%")
                    
                cell.percentLabel.text = valueToStringWithPercent
                
                cell.imgImageView.image = UIImage(named: (initialInformation.image_)!)
                
                cell.smileImabeView.image = UIImage(named: (initialInformation.smile_)!)
            
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.questionCellWithOutPercentual, for: indexPath) as! InitialInformationWithOutPercentualTVCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
                        
            cell.titleLabel.text = information?.title_
            
            cell.valueDescriptionLabel.text = information?.descriptionValue_
            
            cell.imgImageView.image = UIImage(named: (information?.image_)!)
           
            return cell
        }
       
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        //appDelegate.errorView(hostName != nil ? hostName! : "www.iap.org.br")
    
        print("\((hostName != nil ? hostName! : "www.iap.org.br"))")
        
        let reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        self.reachability = reachability
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                DispatchQueue.main.async {
                    self.updateLabelColourWhenReachable(reachability)
                    self.getInfoCoreData()
                    self.tableView.reloadData()
                }
            }
            reachability?.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    self.updateLabelColourWhenNotReachable(reachability)
                    print("Com nexão")
                }
            }
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        }
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            
            //appDelegate.infoView(message: "Unable to start\nnotifier", color: .red)
            //print("\((message: "Unable to start\nnotifier", color: .red))" as Any)
            
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
    
    func updateLabelColourWhenReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.currentReachabilityString)")
        if reachability.isReachableViaWiFi {
            print("Conectado com Wifi")
           
            getInfo()
            getInfoCoreData()
            tableView.reloadData()
        } else {
            print("Oi de novo")
            
        }
        
        //appDelegate.errorView(reachability.currentReachabilityString)
        print("\((reachability.currentReachabilityString))")
    }
    
    func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.currentReachabilityString)")
        
        appDelegate.infoView(message: reachability.currentReachabilityString, color: .red)
        getInfoCoreData()
        tableView.reloadData()
    }
    
    
    func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            updateLabelColourWhenReachable(reachability)
        } else {
            updateLabelColourWhenNotReachable(reachability)
        }
    }
    
    deinit {
        stopNotifier()
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
