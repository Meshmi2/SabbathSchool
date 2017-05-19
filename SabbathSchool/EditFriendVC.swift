//
//  EditFriendVC.swift
//  SabbathSchool
//
//  Created by André Pimentel on 03/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import CoreData

class EditFriendVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var instructorTextField: DesignableTextField!
    @IBOutlet weak var nameFriendTextField: DesignableTextField!
    @IBOutlet weak var chooseStatusButton: UIButton!
    
    let textField = UITextField()
    let chooseStatus = DropDown()

    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseStatus
        ]
    }()
    
    
    var status_ = [Status_]()
    
    let operation: String = "getStatusEstudo"
    var contextObject: NSManagedObjectContext!
    var newStatus: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chooseStatusButton.setTitle("Estudando", for: .normal)
        
        nameFriendTextField.text = nameFriendSegue
        

        getStatus()
        
        setupNavigationBar()
        
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: Setup
    
    fileprivate func setupNavigationBar(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38.0, height: 30.0))
        imageView.image = UIImage(named: "logo_cabecalho")
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    
    @IBAction func changeStatus(_ sender: AnyObject) {
        chooseStatus.show()
        print("Clicou no botão")
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
        
        setupChooseStatusDropDown()
        
    }
    
    
    func setupChooseStatusDropDown() {
        
        
        getStatusCoreData()
        
        var dataSourceStatus = Array<String>()
        
        for status in status_ {
            dataSourceStatus.append(status.name_!)
            
            print("Este é o Array")
            print(dataSourceStatus)
        }
        
        chooseStatus.anchorView = chooseStatusButton
        
        chooseStatus.bottomOffset = CGPoint(x: 0, y: chooseStatusButton.bounds.height)
        
        chooseStatus.dataSource = dataSourceStatus
        
        // Action triggered on selection
        chooseStatus.selectionAction = { [unowned self] (index, item) in
            self.chooseStatusButton.setTitle(item, for: .normal)
            
            let statusCurrent = self.status_[index]
            
            let statusId = Int32(statusCurrent.id_)
            
            self.saveStatus(statusId: Int(statusId))
            
        }
        
    }

    func saveStatus(statusId: Int) {
        
        let saveStatusParameters: [String : Any] = [
            "operacao": "salvarEditarAmigo",
            "instrutor": String(describing: instructorTextField.text),
            "status": statusId,
            "idclasse": 7793,
            "idEstudo": 2416,
            "amigo": "João Carlos"
        ]
        
        let saveStatusEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/amigosEstudo/index_controller.php"
        
        //let info = Info(context: managedObjectContext)
        
        Alamofire.request(saveStatusEndpoint, method: .post, parameters: saveStatusParameters).response { (response) in
            print(response)
        }
    }


    
    func getStatus() {
        
        let getStatusParameters: [String : Any] = ["operacao": operation]
        
        let getStatusEndPoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/amigosEstudo/index_controller.php"
        
        Alamofire.request(getStatusEndPoint, method: .post, parameters: getStatusParameters).responseArray { (response: DataResponse<[cStatus]>) in
            
            self.deleteStatus()
            
            switch response.result {
                
            case .failure(let error):
                
                self.getStatusCoreData()
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                self.deleteStatus()
                
                
                    for _status in data {
                        
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        self.newStatus = NSEntityDescription.insertNewObject(forEntityName: "Status_", into: self.contextObject)
                        
                        
                        if let id = _status.id {
                            
                            self.newStatus.setValue(id, forKey: "id_")
                            
                            print("Esse é o Id")
                            print(id)
                            
                        }
                        if let name = _status.name {
                            
                            self.newStatus.setValue(name, forKey: "name_")
                        
                            print("Este é o nome")
                            print(name)
                            
                        }
                        
                        do {
                            
                            try self.newStatus.managedObjectContext?.save()
                            
                            self.getStatusCoreData()
                            
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

    
    func deleteStatus() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Status_")
        
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
    
    func getStatusCoreData() {
        
        let presentRequest:NSFetchRequest<Status_> = Status_.fetchRequest()
        
        do {
            status_ = try managedObjectContext.fetch(presentRequest)
            print(status_)
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }

    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    

}
