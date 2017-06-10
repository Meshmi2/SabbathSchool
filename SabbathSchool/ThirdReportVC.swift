//
//  ThirdReportVC.swift
//  SabbathSchool
//
//  Created by André Pimentel on 02/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import ReachabilitySwift
import Charts

var entityIdForFourthReport = 0
var nameEntityForFourthReport = ""

class ThirdReportVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ChartViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var saturdays: UILabel!
    @IBOutlet weak var saturdaysFull: UILabel!
    @IBOutlet weak var numberClass: UILabel!
    
    let quarters = ["1º Tri." , "2º Tri.", "3º Tri.", "4º Tri."]
    
    var saturdaysItem = Array<Any>()
    
    var classItem = Array<Any>()
    
    var fullSaturdays = Array<Any>()
    
    var reachability: Reachability?
    
    var user = [User]()
    
    var listEntity: [Third_ListEntity_]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var arrayHistory: [Third_ArrayHistory_]?
    
    let operation: String = "getCalendarioRelatorio"
    var entityId = entityIdForThirdReport
    var periodId: Int32 = 0
    var contextObject: NSManagedObjectContext!
    var newListEntity: NSManagedObject!
    var newHistory: NSManagedObject!
    var newOneMore: NSManagedObject!
    var oneMoreLevel = true
    
    struct Storyboard {
        
        static let reportCell = "CellThirdReport"
        static let segueToFourthReport = "SegueToFourthReport"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadUser()
        
        configureHeader()
        
        configureCellSpace()
        
    }
    
    func configureHeader() {
        
        let title = nameEntityForThirdReport
        
        self.navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
    }
    
    func setChartData(quarters : [String]) {
        
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<quarters.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: saturdaysItem[i] as! Double))
        }
        
        // 1 - creating an array of data entries
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<quarters.count {
            yVals2.append(ChartDataEntry(x: Double(i), y: classItem[i] as! Double))
        }
        
        // 1 - creating an array of data entries
        var yVals3 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<quarters.count {
            yVals3.append(ChartDataEntry(x: Double(i), y: fullSaturdays[i] as! Double))
        }
        
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Nº Sáb.")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.white.withAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.yellow) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.yellow
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = true
        
        // 2 - create a data set with our array
        let set2: LineChartDataSet = LineChartDataSet(values: yVals2, label: "Nº Sáb.")
        set2.axisDependency = .left // Line will correlate with left axis values
        set2.setColor(UIColor.white.withAlphaComponent(0.5)) // our line's opacity is 50%
        set2.setCircleColor(UIColor.yellow) // our circle will be dark red
        set2.lineWidth = 2.0
        set2.circleRadius = 6.0 // the radius of the node circle
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.yellow
        set2.highlightColor = UIColor.white
        set2.drawCircleHoleEnabled = true
        
        // 2 - create a data set with our array
        let set3: LineChartDataSet = LineChartDataSet(values: yVals3, label: "Nº Sáb.")
        set3.axisDependency = .left // Line will correlate with left axis values
        set3.setColor(UIColor.white.withAlphaComponent(0.5)) // our line's opacity is 50%
        set3.setCircleColor(UIColor.yellow) // our circle will be dark red
        set3.lineWidth = 2.0
        set3.circleRadius = 6.0 // the radius of the node circle
        set3.fillAlpha = 65 / 255.0
        set3.fillColor = UIColor.yellow
        set3.highlightColor = UIColor.white
        set3.drawCircleHoleEnabled = true
        
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        dataSets.append(set3)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        
        //5 - finally set our data
        self.lineChartView.data = data
        
        //6 - add x-axis label
        let xaxis = self.lineChartView.xAxis
        xaxis.valueFormatter = MyXAxisFormatter(quarters)
        
    }
    
    
    func reandChart() {
        
        // 1
        self.lineChartView.delegate = self
        // 2
        self.lineChartView.chartDescription?.text = "Central Paranaense"
        // 3
        self.lineChartView.chartDescription?.textColor = UIColor.white
        self.lineChartView.gridBackgroundColor = UIColor(red: 52/255, green: 149/255, blue: 184/255, alpha: 0)
        // 4
        self.lineChartView.noDataText = "No data provided"
        // 5
        
        setChartData(quarters: quarters)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadUser()
        
        setupReachability(nil, useClosures: true)
        startNotifier()
        
        //tableView.reloadData()
        
    }
    
    //    func configureHeader() {
    //
    //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
    //        imageView.contentMode = .scaleAspectFit
    //
    //        let image = UIImage(named: "logo_cabecalho.png")
    //        imageView.image = image
    //        navigationItem.titleView = imageView
    //
    //    }
    
    func loadUser() {
        
        print("Entrou no loadUser")
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            
            let userCurrent = user[0]
            
            // Recovery information then Class User for use in request class Info
            print(userCurrent)
            //print(userCurrent.classId_)
            
            periodId = userCurrent.periodId_
            
            // Atributing information then class User for tableView Header
            
        } catch {
            
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
            
        }
    }
    
    func getInfo() {
        
        print("Buscou informações na API")
        
        let getInfoParameters: [String : Any] = ["operacao": self.operation, "periodoId": self.periodId, "entidadeId": self.entityId]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/preenchimentoCartao/index_controller.php"
        
        print(getInfoParameters)
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseObject { (response: DataResponse<superReport>) in
            
            //let data = response
            
            switch response.result {
                
            case .failure( _):
                
                //self.getInfoCoreData()
                
                //print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                self.contextObject = appDel.managedObjectContext
                self.newOneMore = NSEntityDescription.insertNewObject(forEntityName: "Third_OneMoreLevel_", into: self.contextObject)
                
                if let oneMore = data.moreOneLevel {
                    self.newOneMore.setValue(oneMore, forKey: "moreOneLevel_")
                    self.oneMoreLevel = oneMore
                    
                }
                do {
                    try self.newOneMore.managedObjectContext?.save()
                    
                    //self.getInfoCoreData()
                    
                } catch {
                    appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                }
                
                if let someList = data.list {
                    for _list in someList {
                        
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        self.newListEntity = NSEntityDescription.insertNewObject(forEntityName: "Third_ListEntity_", into: self.contextObject)
                        
                        if let name = _list.name {
                            self.newListEntity.setValue(name, forKey: "name_")
                        }
                        
                        if let numberOfClass = _list.numberOfClass {
                            self.newListEntity.setValue(numberOfClass, forKey: "numberOfClass")
                            let numberOfClassDouble = Double(numberOfClass)
                            
                            self.classItem.append(numberOfClassDouble)
                        }
                        
                        if let quantityFilledOut  = _list.quantityFilledOut {
                            self.newListEntity.setValue(quantityFilledOut, forKey: "quantityFilledOut_")
                            
                            let quantityFilledOutDouble = Double(quantityFilledOut)
                            
                            self.fullSaturdays.append(quantityFilledOutDouble)
                            
                        }
                        
                        if let entityId  = _list.entityId {
                            self.newListEntity.setValue(entityId, forKey: "entityId_")
                        }
                        
                        if let numberOfSaturday  = _list.numberOfSaturday {
                            self.newListEntity.setValue(numberOfSaturday, forKey: "numberOfSaturday_")
                            self.saturdaysItem.append(Double(numberOfSaturday))
                        }
                        
                        do {
                            try self.newListEntity.managedObjectContext?.save()
                          
                            
                        } catch {
                            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                        }
                    }
                }
                
                self.getListCoreData()
                
                if let someHistory = data.history {
                    for _history in someHistory {
                        
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        self.newHistory = NSEntityDescription.insertNewObject(forEntityName: "Third_ArrayHistory_", into: self.contextObject)
                        
                        if let name = _history.namePeriod {
                            self.newHistory.setValue(name, forKey: "namePeriod_")
                        }
                        
                        if let quantityFilledOut = _history.quantityFilledOut {
                            self.newHistory.setValue(quantityFilledOut, forKey: "quantityFilledOut_")
                        }
                        
                        if let numberOfSaturday  = _history.numberOfSaturday {
                            self.newHistory.setValue(numberOfSaturday, forKey: "numberOfSaturaday_")
                        }
                        
                        if let numberOfClass  = _history.numberOfClass {
                            self.newHistory.setValue(numberOfClass, forKey: "numberOfClass_")
                        }
                        
                        do {
                            try self.newListEntity.managedObjectContext?.save()
                            
                            //self.getInfoCoreData()
                            
                        } catch {
                            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                        }
                    }
                }
                
                self.getArrayHistoryCoreData()
            }
            self.reandChart()
        }
    }
    
    func getListCoreData() {
        
        let presentRequest:NSFetchRequest<Third_ListEntity_> = Third_ListEntity_.fetchRequest()
        
        //        var predicate = NSPredicate(format: "name contains[c] %@", "001")
        //
        //        predicate = NSPredicate(format: "date == %@", dateChosenSegue)
        //
        //        presentRequest.predicate = predicate
        
        do {
            listEntity = try managedObjectContext.fetch(presentRequest)
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func getArrayHistoryCoreData() {
        
        let presentRequest:NSFetchRequest<Third_ArrayHistory_> = Third_ArrayHistory_.fetchRequest()
        
        //        var predicate = NSPredicate(format: "name contains[c] %@", "001")
        //
        //        predicate = NSPredicate(format: "date == %@", dateChosenSegue)
        //
        //        presentRequest.predicate = predicate
        
        do {
            
            arrayHistory = try managedObjectContext.fetch(presentRequest)
            
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func deleteRecords() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Third_ListEntity_")
        
        // Configure Fetch Request
        fetchRequest.includesPropertyValues = false
        
        //        var predicate = NSPredicate(format: "name contains[c] %@", "001")
        //
        //        predicate = NSPredicate(format: "date == %@", dateChosenSegue)
        //
        //        fetchRequest.predicate = predicate
        
        do {
            let items = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                
                print("Deletei este item \(item)")
                managedObjectContext.delete(item)
            }
            
            // Save Changes
            try managedObjectContext.save()
            
        } catch {
            appDelegate.errorView("Isso é constrangedor!")
        }
        
    }
    
    
    @IBAction func closeButtonTyped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.listEntity == nil {
            return 0
        }
        return (self.listEntity?.count)!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.reportCell, for: indexPath) as! ThirdReportTVCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let listEntityInformation = listEntity?[indexPath.row]
        
        cell.descriptionLabel.text = listEntityInformation?.name_
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getMoreCoreData()
        let dateSegue = listEntity?[indexPath.row]
        
        if oneMoreLevel  == true {
            
            if dateSegue?.entityId_ != nil {
                
                entityIdForFourthReport = Int((dateSegue?.entityId_)!)
                nameEntityForFourthReport = (dateSegue?.name_)!
            }
            
            self.performSegue(withIdentifier: Storyboard.segueToFourthReport, sender: nil)
            
        }
    }
    
    
    func configureCellSpace() {
        
        tableView.estimatedRowHeight = tableView.rowHeight
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
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
            
            //deleteHeader()
            
            getInfo()
            
        } else {
            
            //Sem conexão
            print("Quando não tem internet")
            
            getListCoreData()
            //loadHeader()
            
        }
        
    }
    
    func getCoreDataWhenNotReachable(_ reachability: Reachability) {
        
        
        print("Outra função que vai no CoreData")
        
        getListCoreData()
        //loadHeader()
        
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
    
    
}

//class MyXAxisFormatter: NSObject, IAxisValueFormatter {
//
//    let months: [String]
//
//    init(_ months: [String]) {
//        self.months = months
//    }
//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return months[Int(value)]
//    }
//    
//}
