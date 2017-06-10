//
//  ParticipationReportVC.swift
//  SabbathSchool
//
//  Created by André Pimentel on 01/06/17.
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
import NVActivityIndicatorView

var entityIdForFirstReport = 0
var nameEntityForFirstReport = ""

class ParticipationReportVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ChartViewDelegate, NVActivityIndicatorViewable {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lineChartView: LineChartView!

    @IBOutlet weak var saturdays: UILabel!
    @IBOutlet weak var saturdaysFull: UILabel!
    @IBOutlet weak var numberClass: UILabel!
    
    
    var quarters: [Any] = []
    
    var saturdaysItem: [Any] = []
    
    var classItem: [Any] = []
    
    var fullSaturdays: [Any] = []
    
    var reachability: Reachability?
    
    var user = [User]()
    
    var listEntity: [ListEntity_]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var arrayHistory: [ArrayHistory_]?

    let operation: String = "getCalendarioRelatorio"
    var entityId: Int32 = 0
    var periodId: Int32 = 0
    var contextObject: NSManagedObjectContext!
    var newListEntity: NSManagedObject!
    var newHistory: NSManagedObject!
    var newOneMore: NSManagedObject!
    var oneMoreLevel = true
    
    
    struct Storyboard {
        static let reportCell = "CellReport"
        static let segueToFirstReport = "SegueToFirstReport"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        
        loadUser()

        setupReachability(nil, useClosures: true)
        startNotifier()
//
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //loadUser()
        
        configureHeader()
        
        configureCellSpace()

    }
    
    
    func setChartData(quarters : [String]) {
        
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals3 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<quarters.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: saturdaysItem[i] as! Double))
            
            yVals2.append(ChartDataEntry(x: Double(i), y: fullSaturdays[i] as! Double))
            
            yVals3.append(ChartDataEntry(x: Double(i), y: classItem[i] as! Double))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Nº Sábados.")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor(red: 41/255, green: 150/255, blue: 210/255, alpha: 1)) // our line's opacity is 50%
        set1.setCircleColor(UIColor(red: 41/255, green: 150/255, blue: 210/255, alpha: 1)) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor(red: 41/255, green: 150/255, blue: 210/255, alpha: 1)
        set1.highlightColor = UIColor(red: 41/255, green: 150/255, blue: 210/255, alpha: 1)
        set1.drawCircleHoleEnabled = true
        
        // 2 - create a data set with our array
        let set2: LineChartDataSet = LineChartDataSet(values: yVals2, label: "Sáb. Preenchidos")
        set2.axisDependency = .left // Line will correlate with left axis values
        set2.setColor(UIColor(red: 231/255, green: 139/255, blue: 0/255, alpha: 1)) // our line's opacity is 50%
        set2.setCircleColor(UIColor(red: 231/255, green: 139/255, blue: 0/255, alpha: 1)) // our circle will be dark red
        set2.lineWidth = 2.0
        set2.circleRadius = 6.0 // the radius of the node circle
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor(red: 231/255, green: 139/255, blue: 0/255, alpha: 1)
        set2.highlightColor = UIColor(red: 231/255, green: 139/255, blue: 0/255, alpha: 1)
        set2.drawCircleHoleEnabled = true
        
        // 2 - create a data set with our array
        let set3: LineChartDataSet = LineChartDataSet(values: yVals3, label: "Qtde. Classes Sáb.")
        set3.axisDependency = .left // Line will correlate with left axis values
        set3.setColor(UIColor(red: 217/255, green: 65/255, blue: 46/255, alpha: 1)) // our line's opacity is 50%
        set3.setCircleColor(UIColor(red: 217/255, green: 65/255, blue: 46/255, alpha: 1)) // our circle will be dark red
        set3.lineWidth = 2.0
        set3.circleRadius = 6.0 // the radius of the node circle
        set3.fillAlpha = 65 / 255.0
        set3.fillColor = UIColor(red: 217/255, green: 65/255, blue: 46/255, alpha: 1)
        set3.highlightColor = UIColor(red: 217/255, green: 65/255, blue: 46/255, alpha: 1)
        set3.drawCircleHoleEnabled = true
        
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set2)
        dataSets.append(set3)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor(red: 51/255, green: 157/255, blue: 142/255, alpha: 1))
        
        //5 - finally set our data
        self.lineChartView.data = data
        
        //6 - add x-axis label
        let xaxis = self.lineChartView.xAxis
        xaxis.valueFormatter = MyXAxisFormatter(quarters)
        
    }

    func setAnimationChart() {
        
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.animate(yAxisDuration: 1.0, easingOption: .easeInCubic)
        
    }

    func reandChart() {
        
        // 1
        self.lineChartView.delegate = self
        // 2
        self.lineChartView.chartDescription?.text = "Central Paranaense"
        // 3
        self.lineChartView.chartDescription?.textColor = UIColor.white
        //self.lineChartView.gridBackgroundColor = UIColor(red: 52/255, green: 149/255, blue: 184/255, alpha: 0)
        // 4
        self.lineChartView.noDataText = "No data provided"
        // 5
        
        setChartData(quarters: quarters as! [String])
    }
    
    func configureHeader() {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo_cabecalho.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
    }
    
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
            entityId = userCurrent.entity_
           
            // Atributing information then class User for tableView Header
            
        } catch {
            
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
            
        }
    }
    
    func getInfo() {
        
        print("Buscou informações na API")
        
        let size = CGSize(width: 30, height:30)
        
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            NVActivityIndicatorPresenter.self
        }
        
        let getInfoParameters: [String : Any] = ["operacao": self.operation, "periodoId": self.periodId, "entidadeId": self.entityId]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/preenchimentoCartao/index_controller.php"
        
        print(getInfoParameters)
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseObject { (response: DataResponse<superReport>) in
            
            //let data = response
            
            switch response.result {
                
            case .failure( _):
                
                self.getArrayHistoryCoreData()
                self.getListCoreData()
                
                return
                
            case .success(let data):
                
                let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                self.contextObject = appDel.managedObjectContext
                self.newOneMore = NSEntityDescription.insertNewObject(forEntityName: "OneMoreLevel_", into: self.contextObject)
                
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
                        self.newListEntity = NSEntityDescription.insertNewObject(forEntityName: "ListEntity_", into: self.contextObject)
                        
                        if let name = _list.name {
                            self.newListEntity.setValue(name, forKey: "name_")
                        }
                        
                        if let numberOfClass = _list.numberOfClass {
                           
                            self.newListEntity.setValue(numberOfClass, forKey: "numberOfClass")
                    
                        }
                        
                        if let quantityFilledOut  = _list.quantityFilledOut {
                            
                            self.newListEntity.setValue(quantityFilledOut, forKey: "quantityFilledOut_")
                            
                        }
                        
                        if let entityId  = _list.entityId {
                            self.newListEntity.setValue(entityId, forKey: "entityId_")
                        }
                        
                        if let numberOfSaturday  = _list.numberOfSaturday {
                            self.newListEntity.setValue(numberOfSaturday, forKey: "numberOfSaturday_")
                        
                        
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
                        self.newHistory = NSEntityDescription.insertNewObject(forEntityName: "ArrayHistory_", into: self.contextObject)
                        
                        if let name = _history.namePeriod {
                            self.newHistory.setValue(name, forKey: "namePeriod_")
                            
                            if name == "2017 - 1º Trimestre" {
                                let valor = "1º Tri."
                                self.quarters.append(valor)
                            }
                            
                            if name == "2016 - 2º Trimestre" {
                                let valor = "2º Tri."
                                self.quarters.append(valor)
                            }
                            
                            if name == "2016 - 3º Trimestre" {
                                let valor = "3º Tri."
                                self.quarters.append(valor)
                            }
                            
                            if name == "2016 - 4º Trimestre" {
                                let valor = "4º Tri."
                                self.quarters.append(valor)
                            }
                            
                            //self.quarters.append(name)
                            
                        }
                       
                        if let quantityFilledOut = _history.quantityFilledOut {
                           
                            self.newHistory.setValue(quantityFilledOut, forKey: "quantityFilledOut_")
                        
                            let quantityFilledOutDouble = Double(quantityFilledOut)
                            
                            self.fullSaturdays.append(quantityFilledOutDouble)
                            
                            print(self.fullSaturdays)
                            
                        }
                        
                        
                        if let numberOfClass  = _history.numberOfClass {
                            self.newHistory.setValue(numberOfClass, forKey: "numberOfClass_")
                        
                            let numberOfClassDouble = Double(numberOfClass)
                            
                            self.classItem.append(numberOfClassDouble)
                            
                            print(self.classItem)
                            
                        }
                      
                        if let numberOfSaturday  = _history.numberOfSaturday {
                            self.newHistory.setValue(numberOfSaturday, forKey: "numberOfSaturaday_")
                            
                            if let numberOfClass  = _history.numberOfClass {
                                
                                let numeroSabados = numberOfSaturday * numberOfClass
                                
                                self.saturdaysItem.append(Double(numeroSabados))
                                
                            }
                            
                            
                            
                            print(self.saturdaysItem)
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
            self.setAnimationChart()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                self.stopAnimating()
            }
        }
    }
    
    func getListCoreData() {
        
        let presentRequest:NSFetchRequest<ListEntity_> = ListEntity_.fetchRequest()
        
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
        
        let presentRequest:NSFetchRequest<ArrayHistory_> = ArrayHistory_.fetchRequest()
        
        //        var predicate = NSPredicate(format: "name contains[c] %@", "001")
        //
        //        predicate = NSPredicate(format: "date == %@", dateChosenSegue)
        //
        //        presentRequest.predicate = predicate
        
        do {
            
            arrayHistory = try managedObjectContext.fetch(presentRequest)
            
            let history = arrayHistory?.last
            
            var plusClass = 0
            
            if let numberOfClass = history?.numberOfClass_ {
               
                plusClass = Int(numberOfClass)
                
                numberClass.text = String(describing: numberOfClass)
            
            }
            
            if let quantityFilledOut = history?.quantityFilledOut_ {
                
                saturdaysFull.text = String(describing: quantityFilledOut)
                
            }
            
            
            if let numbeOfSaturdays = history?.numberOfSaturaday_ {
                
                let totalOfSaturdays = (plusClass * Int(numbeOfSaturdays))
                
                saturdays.text = String(totalOfSaturdays)
                
            }
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func deleteEntity() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ListEntity_")
        
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

    func deleteArrayHistory() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArrayHistory_")
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.reportCell, for: indexPath) as! ParticipationReportTVCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let listEntityInformation = listEntity?[indexPath.row]
        
        cell.descriptionLabel.text = listEntityInformation?.name_
        
        cell.entity = listEntityInformation
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getMoreCoreData()
        let dateSegue = listEntity?[indexPath.row]
        
        if oneMoreLevel  == true {
            
            if dateSegue?.entityId_ != nil {
                
                entityIdForFirstReport = Int((dateSegue?.entityId_)!)
                nameEntityForFirstReport = (dateSegue?.name_)!
            }
            
            self.performSegue(withIdentifier: Storyboard.segueToFirstReport, sender: nil)
            
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
            
            deleteEntity()
            deleteArrayHistory()
            
            //deleteHeader()
            
            getInfo()
            
            
        } else {
            
            //Sem conexão
            print("Quando não tem internet")
            
            getListCoreData()
            getArrayHistoryCoreData()
            //loadHeader()
           
        }
        
    }
    
    func getCoreDataWhenNotReachable(_ reachability: Reachability) {
        
        
        print("Outra função que vai no CoreData")
        
        getListCoreData()
        getArrayHistoryCoreData()
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


class MyXAxisFormatter: NSObject, IAxisValueFormatter {
    
    let quarters: [String]
    
    init(_ quarters: [String]) {
        self.quarters = quarters
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return quarters[Int(value)]
    }
    
}
