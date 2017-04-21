//
//  ParametersVC.swift
//  SabbathSchool
//
//  Created by André Pimentel on 26/03/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import ObjectMapper
import CoreData
import DropDown

class ParametersVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var choosePeriodButton: UIButton!
    @IBOutlet weak var chooseAgeRangeButton: UIButton!
    @IBOutlet weak var chooseClassButton: UIButton!
    
    
    let textField = UITextField()
    let choosePeriod = DropDown()
    let chooseAgeRange = DropDown()
    let chooseClass = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.choosePeriod,
            self.chooseAgeRange,
            self.chooseClass
        ]
    }()
    
    var user = [User]()
    
    var period_ = [Period_]()
    
    var class_ = [Class_]()
    
    var age_ = [Age_]()
    
    var initialInformationPeriod: [periodMaster]?
    
    let operation: String = "getPeriodos"
    
    var contextObject: NSManagedObjectContext!
    var newPeriod: NSManagedObject!
    var newClass: NSManagedObject!
    var newAge: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo_cabecalho.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        choosePeriodButton.setTitle("Selecione um Periodo", for: .normal)
        chooseClassButton.setTitle("Selecione uma Classe", for: .normal)
        chooseAgeRangeButton.setTitle("Selecione um Faixa", for: .normal)
        
        getClass()
        
        getPeriod()
        
        getAge()
        
        loadUser()
        
    }
    
    func loadUser() {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            
            user = try managedObjectContext.fetch(presentRequest)
            
            let userCurrent = user[0]
        
            choosePeriodButton.setTitle(userCurrent.periodName_, for: .normal)
            chooseAgeRangeButton.setTitle(userCurrent.ageGroupName_, for: .normal)
            chooseClassButton.setTitle(userCurrent.className_, for: .normal)
            
        } catch {
            
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        
        }
    }
    
    @IBAction func changePeriod(_ sender: AnyObject) {
        choosePeriod.show()
    }
    
    @IBAction func changeAgeRange(_ sender: AnyObject) {
        chooseAgeRange.show()
    }
    
    @IBAction func changeClass(_ sender: AnyObject) {
        chooseClass.show()
    }
    
    
    func setupDefaultDropDown() {
        DropDown.setupDefaultAppearance()
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            $0.customCellConfiguration = nil
        }
    }
    
    func customizeDropDown(_ sender: AnyObject) {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        //		appearance.textFont = UIFont(name: "Georgia", size: 14)
        
        dropDowns.forEach {
            /*** FOR CUSTOM CELLS ***/
            $0.cellNib = UINib(nibName: "MyCell", bundle: nil)
            
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? MyCell else { return }
                
                // Setup your custom UI components
                cell.suffixLabel.text = "Suffix \(index)"
            }
            /*** ---------------- ***/
        }
    }
    
    
    func setupDropDowns() {
        
        setupChoosePeriodDropDown()
        
        setupAgeRangeDropDown()
        
        setupClassDropDown()
       
    }
    
    
    func setupChoosePeriodDropDown() {
        
        
        loadPeriod()
        
        var dataSourcePeriod = Array<String>()
        
        for periodo in period_ {
            dataSourcePeriod.append(periodo.name_!)
        }
        
        choosePeriod.anchorView = choosePeriodButton
        
        choosePeriod.bottomOffset = CGPoint(x: 0, y: choosePeriodButton.bounds.height)
      
        choosePeriod.dataSource = dataSourcePeriod
        
        // Action triggered on selection
        choosePeriod.selectionAction = { [unowned self] (index, item) in
            self.choosePeriodButton.setTitle(item, for: .normal)
            
            let id = self.period_[index]
            
            let periodId = Int32(id.id_)
            
            self.updateUserPeriod(periodId: periodId, periodName: item)
            
        }
        
    }
    
   
    

    func setupAgeRangeDropDown() {
        
        loadAge()
        
        var dataSourceAge = Array<String>()
        
        for idade in age_ {
            dataSourceAge.append(idade.name_!)
        }
        
        
        chooseAgeRange.anchorView = chooseAgeRangeButton
        
        chooseAgeRange.bottomOffset = CGPoint(x: 0, y: chooseAgeRangeButton.bounds.height)
        
    
        chooseAgeRange.dataSource = dataSourceAge
        
        // Action triggered on selection
        chooseAgeRange.selectionAction = { [unowned self] (index, item) in
            self.chooseAgeRangeButton.setTitle(item, for: .normal)
            
            let id = self.age_[index]
            
            let ageGroupId = Int32(id.id_)
            
            self.updateUserAge(ageGroupId: ageGroupId, ageGroupName: item)
            
        }
        
    }
    
   
    func setupClassDropDown() {
        
        loadClass()
        
        var dataSourceClass = Array<String>()
        
        for classe in class_ {
            dataSourceClass.append(classe.name_!)
        }
     
        chooseClass.anchorView = chooseClassButton
        
        chooseClass.bottomOffset = CGPoint(x: 0, y: chooseClassButton.bounds.height)
        
        chooseClass.dataSource = dataSourceClass
        
        // Action triggered on selection
        chooseClass.selectionAction = { [unowned self] (index, item) in
            self.chooseClassButton.setTitle(item, for: .normal)
            
            let id = self.class_[index]
            
            let classId = Int32(id.id_)
            
            self.updateUserClass(classId: classId, className: item)
            
        }
        
    }
    
    func updateUserClass(classId: Int32, className: String) {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            let userCurrent = user[0]
            
            userCurrent.setValue(classId, forKey: "classId_")
            userCurrent.setValue(className, forKey: "className_")
            
            try managedObjectContext.save()
        } catch {
            print("Ocorreu um erro \(error.localizedDescription)")
        }
    }
    
    func updateUserPeriod(periodId: Int32, periodName: String) {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            let userCurrent = user[0]
            
            userCurrent.setValue(periodId, forKey: "periodId_")
            userCurrent.setValue(periodName, forKey: "periodName_")
            
            try managedObjectContext.save()
        } catch {
            print("Ocorreu um erro \(error.localizedDescription)")
        }
    }
    
    func updateUserAge(ageGroupId: Int32, ageGroupName: String) {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            let userCurrent = user[0]
            
            userCurrent.setValue(ageGroupId, forKey: "ageGroupId_")
            userCurrent.setValue(ageGroupName, forKey: "ageGroupName_")
            
            try managedObjectContext.save()
        } catch {
            print("Ocorreu um erro \(error.localizedDescription)")
        }
    }
    
    
    func getClass() {
        
        let getClassParameters: [String : Any] = ["operacao": "getPeriodosClassesFaixasEtarias", "pessoaId": 24, "entidadeId": 660, "funcaoId": 4]
        
        let getClassEndPoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/paginaInicial/index_controller.php"
        
        Alamofire.request(getClassEndPoint, method: .post, parameters: getClassParameters).responseObject { (response: DataResponse<classMaster>) in
            
            self.deleteRecords()
            
            switch response.result {
                
            case .failure(let error):
                
                self.loadClass()
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                self.deleteClass()
                
                if let someClass = data.classe {
                    for _classe in someClass {
                        
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        self.newClass = NSEntityDescription.insertNewObject(forEntityName: "Class_", into: self.contextObject)
                        
                        
                        if let id = _classe.id {
                            self.newClass.setValue(id, forKey: "id_")
                            
                        }
                        if let name = _classe.name {
                            self.newClass.setValue(name, forKey: "name_")
                        }
                        
                        do {
                            
                            try self.newClass.managedObjectContext?.save()
                            
                            self.loadClass()
                            
                        } catch {
                            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }

    
    func loadClass() {
        
        let presentRequest:NSFetchRequest<Class_> = Class_.fetchRequest()
        
        do {
            class_ = try managedObjectContext.fetch(presentRequest)
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    
    func getAge() {
        
        let getAgeParameters: [String : Any] = ["operacao": "getPeriodosClassesFaixasEtarias", "pessoaId": 24, "entidadeId": 660, "funcaoId": 4]
        
        let getAgeEndPoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/paginaInicial/index_controller.php"
        
        Alamofire.request(getAgeEndPoint, method: .post, parameters: getAgeParameters).responseObject { (response: DataResponse<ageMaster>) in
            
            self.deleteRecords()
            
            switch response.result {
                
            case .failure(let error):
                
                self.loadAge()
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                self.deleteClass()
                
                if let someAge = data.age {
                    for _age in someAge {
                        
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        self.newAge = NSEntityDescription.insertNewObject(forEntityName: "Age_", into: self.contextObject)
                        
                        
                        if let id = _age.id {
                            self.newAge.setValue(id, forKey: "id_")
                            
                        }
                        if let name = _age.name {
                            self.newAge.setValue(name, forKey: "name_")
                        }
                        
                        do {
                            
                            try self.newAge.managedObjectContext?.save()
                            
                            self.loadAge()
                            
                        } catch {
                            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    
    func loadAge() {
        
        let presentRequest:NSFetchRequest<Age_> = Age_.fetchRequest()
        
        do {
            age_ = try managedObjectContext.fetch(presentRequest)
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    


    
    func getPeriod() {
        
        let getPeriodParameters: [String : Any] = ["operacao": "getPeriodosClassesFaixasEtarias", "pessoaId": 24, "entidadeId": 660, "funcaoId": 4]
        
        let getPeriodEndPoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/paginaInicial/index_controller.php"
        
        Alamofire.request(getPeriodEndPoint, method: .post, parameters: getPeriodParameters).responseObject { (response: DataResponse<periodMaster>) in
            
            //let data = response.result.value
            
            switch response.result {
                
            case .failure(let error):
                
                self.loadPeriod()
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                self.deleteRecords()
                
                if let somePeriod = data.period {
                    for _period in somePeriod {
                        
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        
                        self.newPeriod = NSEntityDescription.insertNewObject(forEntityName: "Period_", into: self.contextObject)
                    
                        
                        if let id = _period.id {
                            print(id)
                            self.newPeriod.setValue(id, forKey: "id_")
                        }
                        
                        if let name = _period.name {
                            print(name)
                            self.newPeriod.setValue(name, forKey: "name_")
                        }
                        
                        do {
                            
                            try self.newPeriod.managedObjectContext?.save()
                        
                            self.loadPeriod()
                        
                        } catch {
                            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                        }
                    }
                    
                }
                
                self.setupDropDowns()
                
                self.dropDowns.forEach { $0.dismissMode = .onTap }
                
                self.dropDowns.forEach { $0.direction = .any }
                
                self.view.addSubview(self.textField)

            }
        
        }
    }

    func loadPeriod() {
        
        let presentRequest:NSFetchRequest<Period_> = Period_.fetchRequest()
        
        do {
            period_ = try managedObjectContext.fetch(presentRequest)
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func deleteRecords() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Period_")
        
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
    
    
    func deleteClass() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Class_")
        
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

    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}






