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

var dateChosenSegue = ""


class CalendarVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var entityTypeLabel: UILabel!
    @IBOutlet weak var entityLabel: UILabel!
    @IBOutlet weak var periodNameLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var ageRangeLabel: UILabel!
   

    var user = [User]()
    
    var calendar: [Calendar_]?
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo_cabecalho.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadUser()
        
        print(classId)
        
        print(periodId)
        
        getCalendar()
        
        getCalendarCoreData()
       
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
        
        let getInfoParameters: [String : Any] = ["operacao": "getCalendario", "periodoId": self.periodId, "classeId": self.classId]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/preenchimentoCartao/index_controller.php"
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseArray { (response: DataResponse<[cCalendar]>) in
            
            switch response.result {
                
            case .failure(let error):
                
                self.getCalendarCoreData()
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                self.deleteRecords()
                
                for _calendar in data {
                    
                    let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                    self.contextObject = appDel.managedObjectContext
                    self.newCalendar = NSEntityDescription.insertNewObject(forEntityName: "Calendar_", into: self.contextObject)
                    
                    self.newCalendar.setValue(_calendar.date, forKey: "date_")
                    self.newCalendar.setValue(_calendar.released, forKey: "released_")
                    self.newCalendar.setValue(_calendar.saturday, forKey: "saturday_")
                    self.newCalendar.setValue(_calendar.status, forKey: "status_")
                    
                    do {
                        
                        try self.newCalendar.managedObjectContext?.save()
                        
                        self.getCalendarCoreData()
                        
                    } catch {
                        appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                    }
                }
                
            }
            
        }
        
    }
    
    
    func getCalendarCoreData() {
        
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
        UIView.animate(withDuration: 1.0, animations: {
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
