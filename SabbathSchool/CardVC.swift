//
//  CardVC.swift
//  SabbathSchool
//
//  Created by André Pimentel on 04/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit
import CoreData
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class CardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var registredLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    var user = [User]()
    
    var card: [Card_]?
    
    var initialInformationCard: [cCard]?
    
    let operation: String = "getPreenchimento"
    var data: String = "31/12/2016"
    var classId: Int32 = 0
    var contextObject: NSManagedObjectContext!
    var newCard: NSManagedObject!
    let oparationSave = "salvar"
    

    struct Storyboard {
        
        static let cardCell = "CellCard"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dateChosenSegue)
        
        loadUser()
        
        getCard()
        
        getCardCoreData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadUser() {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            
            let userCurrent = user[0]
            
            // Recovery information then Class User for use in request class Info
            
            classId = userCurrent.classId_
        
            // Atributing information then class User for tableView Header
            self.classLabel.text = userCurrent.className_
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func getCard() {
        
        let getInfoParameters: [String : Any] = ["operacao": "getPreenchimento", "classeId": self.classId, "data": data]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/preenchimentoCartao/index_controller.php"
        
        //let info = Info(context: managedObjectContext)
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseObject { (response: DataResponse<superCard>) in
            
            switch response.result {
                
            case .failure(let error):
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                self.deleteRecords()
                
                if let someCard = data.collection {
                    for _card in someCard {
                
                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                        self.contextObject = appDel.managedObjectContext
                        self.newCard = NSEntityDescription.insertNewObject(forEntityName: "Card_", into: self.contextObject)
                        
                        if let id = _card.questionId {
                            self.newCard.setValue(id, forKey: "id_")
                        }
                        
                        if let title = _card.title {
                            self.newCard.setValue(title, forKey: "title_")
                        }
                       
                        if let description  = _card.description {
                            self.newCard.setValue(description, forKey: "description_")
                        }
                       
                        if let value = _card.value {
                            self.newCard.setValue(value, forKey: "value_")
                        }
                        
                        if let answer = _card.answerId {
                            self.newCard.setValue(answer, forKey: "answer_")
                        }
                        
                        if let presence = _card.defineNumberPresence {
                            self.newCard.setValue(presence, forKey: "presence")
                        }
                        
                        if let target = _card.targetPercentual {
                            self.newCard.setValue(target, forKey: "target_")
                        }
                        
                    
                        do {
                            try self.newCard.managedObjectContext?.save()
                        } catch {
                            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }

    /*func saveCard() {
        let getInfoParameters: [String : Any] = [{"DefineNumeroPresente":1,"QuestaoId":1,"Valor":"1"},{"DefineNumeroPresente":0,"QuestaoId":2,"Valor":"2"},{"DefineNumeroPresente":0,"QuestaoId":3,"Valor":"3"},{"DefineNumeroPresente":0,"QuestaoId":4,"Valor":"4"},{"DefineNumeroPresente":0,"QuestaoId":5,"Valor":"5"},{"DefineNumeroPresente":0,"QuestaoId":6,"Valor":"6"}]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/preenchimentoCartao/index_controller.php"
        
        //let info = Info(context: managedObjectContext)
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseObject { (response: DataResponse<superCard>) in
    }*/
    
    
    func getCardCoreData() {
        
        let presentRequest:NSFetchRequest<Card_> = Card_.fetchRequest()
        
        do {
            card = try managedObjectContext.fetch(presentRequest)
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func deleteRecords() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Card_")
        
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
        if self.card == nil {
            return 0
        }
        return (self.card?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cardCell, for: indexPath) as! CardTVCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let initialInformationCard = card?[indexPath.row]
        
        cell.descriptionQuestionLabel.text = initialInformationCard?.description_
        cell.titleQuestionLabel.text = initialInformationCard?.title_
        cell.valueQuestionTextField.text = initialInformationCard?.value_

        return cell
        
    }
    

   
}
