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
import NVActivityIndicatorView

var titleForPieChart = ""
var questionIdForSegue = 0

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
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
        static let segueToMore = "SegueToMore"
        
    }
    
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Start reachability without a hostname intially
        //setupReachability(nil, useClosures: true)
        //startNotifier()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //loadUser()
        
        
        loadUser()
        
        setupReachability(nil, useClosures: true)
        startNotifier()
        
        configureHeader()
        
        //configureCellSpace()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewdidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
//        loadUser()
//        
//        setupReachability(nil, useClosures: true)
//        startNotifier()
        
        //tableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
    }
    
    func configureHeader() {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo_cabecalho.png")
        imageView.image = image
        navigationItem.titleView = imageView

    }
    
    func loadUser() {
        print("Executou o LoadUser")
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            
            let userCurrent = user[0]
            
            // Recovery information then Class User for use in request class Info
            print(userCurrent)
            print(userCurrent.entityName_)
           
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
        
        let size = CGSize(width: 30, height:30)
        
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            NVActivityIndicatorPresenter.self
        }

        
        print("Buscou informações na API")
        
        let getInfoParameters: [String : Any] = ["operacao": "getInfo", "periodoId": self.periodId, "faixaEtaria": self.ageRange ,"classeId": self.classId, "EntidadeId": self.entityId, "funcaoId": self.funcaoId]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/paginaInicial/index_controller.php"
        
        print(getInfoParameters)

        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseArray { (response: DataResponse<[InitialInformation]>) in
            
            //let data = response
        
            switch response.result {
                
            case .failure( _):
                
                self.getInfoCoreData()
                
                //print(error.localizedDescription)
    
                return
                
            case .success(let data):
        
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
                    
                    if let questionId = _info.questionId {
                        
                        self.newInfo.setValue(questionId, forKey: "questionId_")
                        
                        //print("7  + \(percentual)")
                    }

                    
                    do {
                        try self.newInfo.managedObjectContext?.save()
                        
                        self.getInfoCoreData()
                        
                    } catch {
                        appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                    }
                }
                
            }
         
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                self.stopAnimating()
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
        
        print("Chamou a função que deleta informações do CoreData")
        
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
            
            //cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            if let initialInformation = info?[indexPath.row] {
            
                cell.info = initialInformation
                
                cell.titleLabel.text = initialInformation.title_
                
                 
                let value = initialInformation.value_
                    
                let valueToString = "\(value)"
                    
                let valueToStringWithPercent = valueToString.replace(target: ".0", withString: "%")
                    
                cell.percentLabel.text = valueToStringWithPercent
                
                cell.imgImageView.image = UIImage(named: (initialInformation.image_)!)
                
                cell.smileImabeView.image = UIImage(named: (initialInformation.smile_)!)
            
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.questionCellWithOutPercentual, for: indexPath) as! InitialInformationWithOutPercentualTVCell
                        
            cell.titleLabel.text = information?.title_
            
            cell.valueDescriptionLabel.text = information?.descriptionValue_
            
            cell.imgImageView.image = UIImage(named: (information?.image_)!)
           
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getInfoCoreData()
        
        if let dateSegue = info?[indexPath.row] {
            
            questionIdForSegue = Int(dateSegue.questionId_)
            titleForPieChart = dateSegue.title_!
    
            self.performSegue(withIdentifier: Storyboard.segueToMore, sender: nil)
            
        }
        
    }
    
    // Configura uma animação para a célula
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 1. Setar o estado inicial
        cell.alpha = 0
        
        // 2. Mudar o metodo de animação
        UIView.animate(withDuration: 3.0, animations: {
            cell.alpha = 1.0
        })
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
           
            deleteRecords()
            
            getInfo()
        
        } else {
            
            //Sem conexão
            print("Quando não tem internet")
            
            getInfoCoreData()
            
        }
    
    }
    
    func getCoreDataWhenNotReachable(_ reachability: Reachability) {
    
        
        print("Outra função que vai no CoreData")
        
        getInfoCoreData()
        
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

