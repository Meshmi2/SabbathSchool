//
//  AppDelegate.swift
//  SabbathSchool
//
//  Created by André Pimentel on 14/02/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit
import CoreData


let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

let fontSize12 = UIScreen.main.bounds.width / 31

var userDefault : NSDictionary?

let colorSmoothRed = UIColor(red: 255/255, green: 50/255, blue: 75/255, alpha: 1)
let colorLightGreen = UIColor(red: 30/255, green: 244/255, blue: 125/255, alpha: 1)
let colorSmoothGray = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
let colorBrandBlue = UIColor(red: 45 / 255, green: 213 / 255, blue: 255 / 255, alpha: 1)
let colorLineNaviBar = UIColor(red: 219/255.0, green: 219/255.0, blue: 219/255.0, alpha: 1)
let colorNaviBar = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
let pickerColor = UIColor(red: 178/255.0, green: 181/255.0, blue: 187/255.0, alpha: 1)


var managedObjectContext: NSManagedObjectContext!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
        
    var errorViewShowing = false
    
    var infoViewIsShowing = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        userDefault = UserDefaults.standard.value(forKey: "user") as? NSDictionary
        
        // Se usuário estiver feito login uma vez, mantem logado
        if userDefault != nil {
            let userArray = userDefault
            let peopleId = userArray?["PessoaId"] as? Int
            
            if peopleId != nil {
                
                login()
                
            } else {
                UserDefaults.standard.removeObject(forKey: "user")
                UserDefaults.standard.synchronize()
                //deleteRecords()
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SabbathSchool")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "co.pavaratha.sample-app.exampleCoreData" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "SabbathSchool", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SabbathSchool.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(String(describing: error)), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func errorView(_ message:String) {
        if errorViewShowing == false {
            errorViewShowing = true
            
            // Fundo vermelho
            let errorViewHeight = self.window!.bounds.height / 14.2
            let errorView_Y = 0 - errorViewHeight
            let smoothRedColor = UIColor(red: 255/255.0, green: 50/255.0, blue: 75/255.0, alpha: 1.0)
            
            let errorView = UIView(frame: CGRect(x: 0, y: errorView_Y, width: self.window!.bounds.width, height: errorViewHeight))
            errorView.backgroundColor = smoothRedColor
            self.window!.addSubview(errorView)
            
            // Definindo tamanhos do label que vai receber a mensagem
            let errorLabel_Width = errorView.bounds.width
            let errorlabel_Height = errorView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
            
            // Criando label pra receber o erro
            let errorLabelMessage = UILabel()
            errorLabelMessage.frame.size.width = errorLabel_Width
            errorLabelMessage.frame.size.height = errorlabel_Height
            errorLabelMessage.numberOfLines = 0
            
            errorLabelMessage.text = message
            errorLabelMessage.font = UIFont(name: "SF UI Display", size: 17)
            errorLabelMessage.textColor = UIColor.white
            errorLabelMessage.textAlignment = .center
            
            errorView.addSubview(errorLabelMessage)
            
            
            // Criando animação pra mensagem
            UIView.animate(withDuration: 0.2, animations: {
                
                // Movendo a view de erro pra baixo
                errorView.frame.origin.y = 0
                
                // Se a animação terminar
            }, completion: { (finisehd: Bool) in
                if finisehd {
                    UIView.animate(withDuration: 0.1, delay: 2, options: .curveLinear, animations: {
                        
                        // Movendo a view para cima
                        errorView.frame.origin.y = errorView_Y
                        
                        //Se completou toda a animação
                    }, completion: { (finished: Bool) in
                        
                        if finished {
                            errorView.removeFromSuperview()
                            errorLabelMessage.removeFromSuperview()
                            self.errorViewShowing = false
                        }
                    })
                }
            })
        }
    }
    
    // infoView no topo
    func infoView(message:String, color:UIColor) {
        
        // SE infoView não está sendo mostrada ...
        if infoViewIsShowing == false {
            
            infoViewIsShowing = true
            
            
            // infoView - background vermelho
            
            let infoView_Height = self.window!.bounds.height / 14.2
            let infoView_Y = 0 - infoView_Height
            
            let infoView = UIView(frame: CGRect(x: 0, y: infoView_Y, width: self.window!.bounds.width, height: infoView_Height))
            infoView.backgroundColor = color
            self.window!.addSubview(infoView)
            
            //
            
            // infoView - Label que mostra informação
            
            let infoLabel_Width = infoView.bounds.width
            let infoLabel_Height = infoView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
            
            let infoLabel = UILabel()
            infoLabel.frame.size.width = infoLabel_Width
            infoLabel.frame.size.height = infoLabel_Height
            infoLabel.numberOfLines = 0
            
            infoLabel.text = message
            infoLabel.font = UIFont(name: "HelveticaNeue", size: fontSize12)
            infoLabel.textColor = UIColor.white
            infoLabel.textAlignment = .center
            
            infoView.addSubview(infoLabel)
            
            //
            
            // Animação para a infoView
            UIView.animate(withDuration: 0.2, animations: {
                
                // Move a infoView para baixo
                infoView.frame.origin.y = 0
                
                // Se a animação terminou
            }, completion: { (finished:Bool) in
                
                // Se a animação acontecer
                if finished {
                    
                    UIView.animate(withDuration: 0.1, delay: 3, options: .curveLinear, animations: {
                        
                        // Move a infoView para cima
                        
                        infoView.frame.origin.y = infoView_Y
                        
                        //
                        
                        // Se todas as animações terminaram
                        
                    }, completion: { (finished:Bool) in
                        
                        if finished {
                            infoView.removeFromSuperview()
                            infoLabel.removeFromSuperview()
                            self.infoViewIsShowing = false
                        }
                        
                    })
                    
                }
                
            })
            
            
        }
        
    }
    
    
    // Função que direciona para a home
    func login() {
        

        if userDefault != nil {
            let userArray = userDefault
            let peopleId = userArray?["PessoaId"] as? Int
    
            if peopleId != nil {
                let userCurrent = User(context: managedObjectContext!)
                userCurrent.name_ = (userArray?["Nome"] as? String)!
                userCurrent.peopleId_ = (userArray?["PessoaId"] as? Int32)!
                userCurrent.entity_ = (userArray?["Entidade"] as? Int32)!
                userCurrent.entityName_ = (userArray?["NomeEntidade"] as? String)!
                userCurrent.entityTypeName_ = (userArray?["NomeTipoEntidade"] as? String)!
                userCurrent.functionName_ = (userArray?["NomeFuncao"] as? String)!
                userCurrent.periodName_ = (userArray?["NomePeriodo"] as? String)!
                userCurrent.periodId_ = (userArray?["PeriodoId"] as? Int32)!
                userCurrent.classId_ = (userArray?["ClasseId"] as? Int32)!
                userCurrent.className_ = (userArray?["ClasseName"] as? String)!
                userCurrent.ageGroupId_ = (userArray?["FaixaEtariaId"] as? Int32)!
                userCurrent.ageGroupName_ = (userArray?["FaixaEtariaNome"] as? String)!
                userCurrent.entityLevel_ = (userArray?["NivelEntidade"] as? Int32)!
               
                
                do {
                    try managedObjectContext?.save()
                } catch {
                    appDelegate.errorView("Isso é constrangedor! \(error.localizedDescription)")
                }
            }
        }

        
        
        // Referenciando a Main.storyboard
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //
        
        // Identificando tabBar na storyboard
        
        let taBar = storyboard.instantiateViewController(withIdentifier: "tabBar")
        
        //
        
        window?.rootViewController = taBar
    }
    
    
}



extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(1, 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}


