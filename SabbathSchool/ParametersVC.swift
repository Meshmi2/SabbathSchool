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
    
    var period: [Period_]?
    
    var initialInformationPeriod: [periodMaster]?
    
    let operation: String = "getPeriodos"
    
    var contextObject: NSManagedObjectContext!
    var newPeriod: NSManagedObject!
    var newClass: NSManagedObject!
    
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
        choosePeriod.anchorView = choosePeriodButton
        
        choosePeriod.bottomOffset = CGPoint(x: 0, y: choosePeriodButton.bounds.height)
      
        choosePeriod.dataSource = [
            "2017 - 1º Trimestre",
            "2016 - 4º Trimestre",
            "2016 - 3º Trimestre",
            "2016 - 2º Trimestre"
        ]
        
        // Action triggered on selection
        choosePeriod.selectionAction = { [unowned self] (index, item) in
            self.choosePeriodButton.setTitle(item, for: .normal)
        }
        
    }
    
   
    

    func setupAgeRangeDropDown() {
        
        chooseAgeRange.anchorView = chooseAgeRangeButton
        
        chooseAgeRange.bottomOffset = CGPoint(x: 0, y: chooseAgeRangeButton.bounds.height)
        
    
        chooseAgeRange.dataSource = [
            "Todas as faixas etárias",
            "Infantil",
            "Jovens",
            "Adultos",
            "Adolescentes"
        ]
        
        // Action triggered on selection
        chooseAgeRange.selectionAction = { [unowned self] (index, item) in
            self.chooseAgeRangeButton.setTitle(item, for: .normal)
        }
        
    }
    
   
    func setupClassDropDown() {
        
        chooseClass.anchorView = chooseClassButton
        
        chooseClass.bottomOffset = CGPoint(x: 0, y: chooseClassButton.bounds.height)
        
        chooseClass.dataSource = [
            "Todas as classes",
            "Adultos"
        ]
        
        // Action triggered on selection
        chooseClass.selectionAction = { [unowned self] (index, item) in
            self.chooseClassButton.setTitle(item, for: .normal)
        }
        
    }
    
    

    
    func getClass() {
        
        let getClassParameters: [String : Any] = ["operacao": "getPeriodosClassesFaixasEtarias", "pessoaId": 24, "entidadeId": 660, "funcaoId": 4]
        
        let getClassEndPoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/paginaInicial/index_controller.php"
        
        Alamofire.request(getClassEndPoint, method: .post, parameters: getClassParameters).responseObject { (response: DataResponse<classMaster>) in
            
            self.deleteRecords()
            
            switch response.result {
                
            case .failure(let error):
                
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
                        } catch {
                            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }

    
    func getPeriod() {
        
        let getPeriodParameters: [String : Any] = ["operacao": "getPeriodosClassesFaixasEtarias", "pessoaId": 24, "entidadeId": 660, "funcaoId": 4]
        
        let getPeriodEndPoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/paginaInicial/index_controller.php"
        
        Alamofire.request(getPeriodEndPoint, method: .post, parameters: getPeriodParameters).responseObject { (response: DataResponse<periodMaster>) in
            
            //let data = response.result.value
            
            switch response.result {
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                self.deleteRecords()
                
                if let somePeriod = data.period {
                    for _period in somePeriod {
                        
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        
                        self.newPeriod = NSEntityDescription.insertNewObject(forEntityName: "Friend_", into: self.contextObject)
                    
                        
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






