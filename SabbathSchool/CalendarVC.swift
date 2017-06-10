//
//  CalendarVC.swift
//  SabbathSchool
//
//  Created by André Pimentel on 09/03/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit
import CoreData
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import ReachabilitySwift
import NVActivityIndicatorView

var dateChosenSegue = ""


class CalendarVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var entityTypeLabel: UILabel!
    @IBOutlet weak var entityLabel: UILabel!
    @IBOutlet weak var periodNameLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var ageRangeLabel: UILabel!
   
    var reachability: Reachability?

    var user = [User]()
    
    var calendar: [Calendar_]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var cCalendar: [cCalendar]?
    
    let operation: String = "getCalendario"
    var periodId: Int32 = 0
    var classId: Int32 = 0
    var contextObject: NSManagedObjectContext!
    var newCalendar: NSManagedObject!
    
    struct Storyboard {
        
        static let calendarCell = "CellCalendar"
        static let segueToCard = "SegueToCard"
        
    }
    
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
        
        setupReachability(nil, useClosures: true)
        startNotifier()
        
        configureHeader()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        //getCalendar()
        //getCalendarCoreData()

    }

    func configureHeader() {
        
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
            
            periodId = userCurrent.periodId_
            classId = userCurrent.classId_
            
            
            self.entityTypeLabel.text = userCurrent.entityTypeName_
            self.entityLabel.text = userCurrent.entityName_
            self.periodNameLabel.text = userCurrent.periodName_
            self.classNameLabel.text = userCurrent.className_
            self.ageRangeLabel.text = userCurrent.ageGroupName_
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }

    func getCalendar() {
        
        let size = CGSize(width: 30, height:30)
        
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            NVActivityIndicatorPresenter.self
        }

        
        print("Buscou informações na API")
        
        let getInfoParameters: [String : Any] = ["operacao": "getCalendario", "periodoId": self.periodId, "classeId": self.classId]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/preenchimentoCartao/index_controller.php"
       
        print(getInfoParameters)
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseArray { (response: DataResponse<[cCalendar]>) in
            
            switch response.result {
                
            case .failure( _):
                
                self.getCalendarCoreData()
                
                //print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                //self.deleteRecords()
                
                for _calendar in data {
                    
                    let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    
                    self.contextObject = appDel.managedObjectContext
                    
                    self.newCalendar = NSEntityDescription.insertNewObject(forEntityName: "Calendar_", into: self.contextObject)
                    
                    if let date = _calendar.date {
                        
                        self.newCalendar.setValue(date, forKey: "date_")
                    
                    }
                    
                    if let released = _calendar.released {
                        
                        self.newCalendar.setValue(released, forKey: "released_")
                    
                    }
                    
                    if let saturday = _calendar.saturday {
                        
                        self.newCalendar.setValue(saturday, forKey: "saturday_")
                    
                    }
                    
                    if let status = _calendar.status {
                        
                        self.newCalendar.setValue(status, forKey: "status_")
                    
                    }
                    
                    do {
                        
                        try self.newCalendar.managedObjectContext?.save()
                    
                    } catch {
                        appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                    }

                }
                
                self.getCalendarCoreData()
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.3) {
                self.stopAnimating()
            }
        }
        
    }
    
    
    func getCalendarCoreData() {
        
        print("Acessou o core data")
        
        let presentRequest:NSFetchRequest<Calendar_> = Calendar_.fetchRequest()
        
        do {
            calendar = try managedObjectContext.fetch(presentRequest)
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }

    
    func deleteRecords() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Calendar_")
        
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
        if self.calendar == nil {
            return 0
        } else {
            return (self.calendar?.count)!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.calendarCell, for: indexPath) as! CalendarVCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let calendarInformation = calendar?[indexPath.row]
        
        cell.calendar = calendarInformation
        
        return cell
        
    }
    
    // Configura uma animação para a célula
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 1. Setar o estado inicial
        cell.alpha = 0
        
        // 2. Mudar o metodo de animação
        UIView.animate(withDuration: 2.0, animations: {
            cell.alpha = 1.0
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        getCalendarCoreData()
        
        let dateSegue = calendar?[indexPath.row]
    
        if dateSegue?.date_ != nil {
            
            dateChosenSegue = (dateSegue?.date_)!
            
        }
        
        self.performSegue(withIdentifier: Storyboard.segueToCard, sender: nil)
        
    }
    
    @IBAction func closeButtonTyped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            
            getCalendar()
            
            //getInfoCoreData()
            
            //tableView.reloadData()
            
        } else {
            
            //Sem conexão
            print("Quando não tem internet")
            
            getCalendarCoreData()
            
        }
        
    }
    
    func getCoreDataWhenNotReachable(_ reachability: Reachability) {
        
        
        print("Outra função que vai no CoreData")
        
        getCalendarCoreData()
        
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

extension String {
    
    func strstr(needle: String, beforeNeedle: Bool = false) -> String? {
        guard let range = self.range(of: needle) else { return nil }
        
        if beforeNeedle {
            return self.substring(to: range.lowerBound)
        }
        
        return self.substring(from: range.upperBound)
    }
    
}
