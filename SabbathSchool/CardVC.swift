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

class CardVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var registredLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user = [User]()
    
    var header = [Header_]()
    
    var card: [Card_]?
    
    var initialInformationCard: [cCard]?
    
    let operation: String = "getPreenchimento"
    var classId: Int32 = 0
    var nameClass: String = ""
    var peopleId: Int32 = 0
    var registered: Int16 = 0
    var form: Int16 = 0
    var contextObject: NSManagedObjectContext!
    var newCard: NSManagedObject!
    var newHeader: NSManagedObject!
    let oparationSave = "salvar"
    
    
    
    struct Storyboard {
        
        static let cardCell = "CellCard"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Esta é a data escolhida")
        print(dateChosenSegue)
        
        loadUser()
        
        getCard()
        
        //getCardCoreData()
        
        //saveCard()
        
        updataUI()
        
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        
        deleteRecords()
        deleteHeader()
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUser()
        
        getCard()
        getCardCoreData()
        print("Me chamou")
    }
    
    func updataUI() {
        
        // Chama função que carrega informações do cabeçalho do JSON
        loadHeader()
        
        // Altera Header
        registredLabel.text = "\(registered)"
        
        dateLabel.text = dateChosenSegue
        
        classLabel.text = nameClass
        
    }
    
    func loadUser() {
        
        let presentRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            user = try managedObjectContext.fetch(presentRequest)
            
            let userCurrent = user[0]
            
            // Recovery information then Class User for use in request class Info
            
            classId = userCurrent.classId_
            peopleId =  userCurrent.peopleId_
            nameClass = userCurrent.className_!
        
            // Atributing information then class User for tableView Header
            self.classLabel.text = userCurrent.className_
            
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    
    func loadHeader() {
        
        let presentRequest:NSFetchRequest<Header_> = Header_.fetchRequest()
        
        do {
            header = try managedObjectContext.fetch(presentRequest)
            
            let headerCurrent = header[0]
            
            // Recovery information then Class User for use in request class Info
            
            registered =  headerCurrent.registered_
            form = headerCurrent.form_
    
        } catch {
            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
        }
    }
    
    func getCard() {
        
        let getInfoParameters: [String : Any] = ["operacao": "getPreenchimento", "classeId": self.classId, "data": dateChosenSegue]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/preenchimentoCartao/index_controller.php"
        
        //let info = Info(context: managedObjectContext)
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseObject { (response: DataResponse<superCard>) in
            
            switch response.result {
                
            case .failure(let error):
                
                self.getCardCoreData()
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                self.deleteRecords()
                self.deleteHeader()
        
                let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                self.contextObject = appDel.managedObjectContext
                self.newHeader = NSEntityDescription.insertNewObject(forEntityName: "Header_", into: self.contextObject)
                    
                if let registered = data.enrolled {
                    self.newHeader.setValue(registered, forKey: "registered_")
                }
                
                if let form = data.form {
                    self.newHeader.setValue(form, forKey: "form_")
                }
                
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
                            
                            self.getCardCoreData()
                            
                        } catch {
                            appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }

    func saveCard(defineNumeroPresente: Int, questaoId: Int, valor: Int, formularioId: Int, pessoaId: Int, totalMatriculado: Int) {
        
        let saveCardParameters: [String : Any] = [
            "questoes": ["DefineNumeroPresente": defineNumeroPresente,
                         "QuestaoId":questaoId,
                         "Valor":valor],
            "operacao": oparationSave,
            "classeId": classId,
            "data": dateChosenSegue,
            "formularioId": formularioId,
            "PessoaId": pessoaId,
            "totalMatriculados": totalMatriculado
        ]
        
        let saveCardEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/preenchimentoCartao/index_controller.php"
        
        //let info = Info(context: managedObjectContext)
        
        Alamofire.request(saveCardEndpoint, method: .post, parameters: saveCardParameters).response { (response) in
            print(response)
        }
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        getCardCoreData()
        
        loadHeader()
        
        let tag = textField.tag
        
        let initialInformationCard = card?[tag]
        
        var defineNumeroPresenca: Int32 = 0
        
        if let number = initialInformationCard?.presence {
            
            defineNumeroPresenca = number
            
        }
        
        var questaoId: Int32 = 0
        
        if let id = initialInformationCard?.id_ {
            
            questaoId = id
      
        }
        
        var valor: Int = 0
        
        if (textField.text != nil) {
            
            valor = Int(textField.text!)!
        
        }
    
        saveCard(defineNumeroPresente: Int(defineNumeroPresenca), questaoId: Int(questaoId), valor: valor, formularioId: Int(form), pessoaId: Int(peopleId), totalMatriculado: Int(registered))
        
        return true;
    
    }
    
    func textField(valueQuestionTextField textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let tag = textField.tag
        print(tag)
        
        if (textField.text != nil) {
            print(textField.text!)
        }
        print("OI")
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let tag = textField.tag
        print(tag)
        
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    
    }
    
    
    
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
    
    func deleteHeader() -> Void {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Header_")
        
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
        
        cell.valueQuestionTextField.tag = indexPath.row
        
        return cell
        
    }
    
}
