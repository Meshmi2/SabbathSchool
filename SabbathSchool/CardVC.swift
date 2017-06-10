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
import ReachabilitySwift
import NVActivityIndicatorView
import SwiftyJSON

class CardVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var registredLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var reachability: Reachability?
    
    var user = [User]()
    
    var header = [Header_]()
    
    var card: [Card_]? {
        didSet {
            tableView.reloadData()
        }
    }
    
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
    
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start reachability without a hostname intially
        setupReachability(nil, useClosures: true)
        startNotifier()
        
        loadUser()
        
        updataUI()
        
        configureCellSpace()
        
        configureHeader()
        
        let dic = ["nome": "André", "idade": 24] as [String : Any]

        let json = JSON(dic)
        
        print(json)
    }

    func configureHeader() {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 30))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo_cabecalho.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func updataUI() {
        
        // Chama função que carrega informações do cabeçalho do JSON
        //loadHeader()
        
        // Altera Header
        registredLabel.text = "\(registered)"
        
        dateLabel.text = dateChosenSegue
        
        classLabel.text = nameClass
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        
        let size = CGSize(width: 30, height:30)
        
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 1)!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            NVActivityIndicatorPresenter.self
        }
        
        let getInfoParameters: [String : Any] = ["operacao": "getPreenchimento", "classeId": 7793 /*self.classId*/, "data": dateChosenSegue]
        
        let getInfoEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/preenchimentoCartao/index_controller.php"
        
        //let info = Info(context: managedObjectContext)
        
        Alamofire.request(getInfoEndpoint, method: .post, parameters: getInfoParameters).responseObject { (response: DataResponse<superCard>) in
            
            switch response.result {
                
            case .failure(let error):
                
                self.getCardCoreData()
                self.loadHeader()
                
                print(error.localizedDescription)
                
                return
                
            case .success(let data):
                
                let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                self.contextObject = appDel.managedObjectContext
                self.newHeader = NSEntityDescription.insertNewObject(forEntityName: "Header_", into: self.contextObject)
                    
                if let registered = data.enrolled {
                    self.newHeader.setValue(registered, forKey: "registered_")
                    self.registredLabel.text = String(registered)
                    
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
                        
                        if dateChosenSegue != "" {
                        
                            self.newCard.setValue(dateChosenSegue, forKey: "date")
                        
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
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.3) {
                self.stopAnimating()
            }

            
        }
    }

    func saveCard(defineNumeroPresente: Int, questaoId: Int, valor: Int, formularioId: Int, pessoaId: Int, totalMatriculado: Int) {
        
        let questions = ["DefineNumeroPresente": 1/*defineNumeroPresente*/,
                         "QuestaoId": 1/*questaoId*/,
                         "Valor":  5/*valor*/] as [String: Any]
        
        let questionJson = JSON(questions)
        
        let saveCardParameters: [String : Any] = [
            "classeId": 7793/*classId*/,
            "data": dateChosenSegue,
            "formularioId": 1 /*formularioId*/,
            "PessoaId": 1576/*pessoaId*/,
            "TotalMatriculado": 8/*totalMatriculado*/,
            "operacao": oparationSave,
            "questoes": [questionJson]
        ]
        
        print(saveCardParameters)
        
        let saveCardEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/preenchimentoCartao/index_controller.php"
        
        
        Alamofire.request(saveCardEndpoint, method: .post, parameters: saveCardParameters).responseObject { (response: DataResponse<cSaveQuestions>) in
            
            switch response.result {
                
            case .failure( _):
                
                print("falhou")
                
                return
                
            case .success(let data):
                
                print(data.result)
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        //getCardCoreData()
        
        //loadHeader()
        
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
        
        var predicate = NSPredicate(format: "name contains[c] %@", "001")
        
        predicate = NSPredicate(format: "date == %@", dateChosenSegue)
        
        presentRequest.predicate = predicate
        
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
        
        var predicate = NSPredicate(format: "name contains[c] %@", "001")
        
        predicate = NSPredicate(format: "date == %@", dateChosenSegue)
        
        fetchRequest.predicate = predicate

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
    
    // Configura uma animação para a célula
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 1. Setar o estado inicial
        cell.alpha = 0
        
        // 2. Mudar o metodo de animação
        UIView.animate(withDuration: 1.0, animations: {
            cell.alpha = 1.0
        })
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
            
            deleteHeader()
            
            getCard()
            
        } else {
            
            //Sem conexão
            print("Quando não tem internet")
            
            getCardCoreData()
            loadHeader()
            
        }
        
    }
    
    func getCoreDataWhenNotReachable(_ reachability: Reachability) {
        
        
        print("Outra função que vai no CoreData")
        
        getCardCoreData()
        loadHeader()
        
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
