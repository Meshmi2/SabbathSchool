//
//  ViewController.swift
//  SabbathSchool
//
//  Created by André Pimentel on 14/02/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EAIntroView
import Alamofire

class LoginVC: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable, EAIntroDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    // reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    
    var operation: String = "login"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ingropage1 = EAIntroPage.init(customViewFromNibNamed: "page1")
        let ingropage2 = EAIntroPage.init(customViewFromNibNamed: "page2")
        let ingropage3 = EAIntroPage.init(customViewFromNibNamed: "page3")
        let ingropage4 = EAIntroPage.init(customViewFromNibNamed: "page4")
        
        let introView = EAIntroView.init(frame: self.view.bounds, andPages: [ingropage1!,ingropage2!,ingropage3!,ingropage4!])
        introView?.delegate = self
        
        introView?.show(in: self.view, animateDuration: 0.0)
        
    }

    
    func login(username: String, password: String) {
        
        let todosEndpoint: String = "http://test-sistemas.usb.org.br/escolasabatina/APIMobile/metodos/login/index_controller.php"
        let newTodo: [String : Any] = ["operacao": "login", "login": username, "senha": password]
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo).responseJSON { response in
            let data = response
            print(data)
            switch response.result {
            case .failure(let error):
                print(error.localizedDescription)
                self.loginFail(status: true)
                return
                
            case .success(let data):
                
                UserDefaults.standard.set(data, forKey: "user")
                userDefault = UserDefaults.standard.value(forKey: "user") as? NSDictionary
                self.closeKeyboard()
                appDelegate.login()
            }
        }
    
    }
    
    func loginFail(status: Bool) {
        if status {
            
            print("fail")
            self.loginTextField.layer.borderWidth = 1.0
            self.loginTextField.layer.borderColor = UIColor.red.cgColor
            self.passwordTextField.layer.borderWidth = 1.0
            self.passwordTextField.layer.borderColor = UIColor.red.cgColor
        
        } else {
            
            print("success")
            self.loginTextField.layer.borderColor = UIColor.clear.cgColor
            self.passwordTextField.layer.borderColor = UIColor.clear.cgColor
            self.dismiss(animated: false, completion: nil)
        
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        if(wasSkipped) {
            
            print("Intro skipped")
            
        } else {
            
            print("Intro skipped")
        }
    }
    
    
    // Função chamada quando Return é pressionado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Esconde teclado quando Return é pressionado
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
        
    }
    // Função que esconde teclado
    func closeKeyboard () {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(0, 120), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(0, 0), animated: true)
    }
    
    // Chama função que esconde o teclado toda vez que a tela é tocada
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeKeyboard()
    }
    
    // hide keyboard if tapped
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    // show keyboard
    func showKeyboard(notification:NSNotification) {
        
        // define keyboard size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        // move up UI
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    // hide keyboard func
    func hideKeybard(notification:NSNotification) {
        
        // move down UI
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
 
    @IBAction func loginTouch(_ sender: DesignableButton) {
        
        if loginTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            
            if (loginTextField.text?.isEmpty)! && (passwordTextField.text != "") {
                appDelegate.errorView("Não esqueça de prencher seu e-mail")
                loginLabel.textColor = UIColor(red: 251/255.0, green: 0/255.0, blue: 78/255.0, alpha: 1.0)
                passwordLabel.textColor = UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1.0)
            }
            if (passwordTextField.text?.isEmpty)! && loginTextField.text != "" {
                appDelegate.errorView("Informe sua senha")
                passwordLabel.textColor = UIColor(red: 251/255.0, green: 0/255.0, blue: 78/255.0, alpha: 1.0)
                loginLabel.textColor = UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1.0)
            }
            if (loginTextField.text?.isEmpty)! && (passwordTextField.text?.isEmpty)! {
                appDelegate.errorView("Preecha as informações")
                passwordLabel.textColor = UIColor(red: 251/255.0, green: 0/255.0, blue: 78/255.0, alpha: 1.0)
                loginLabel.textColor = UIColor(red: 251/255.0, green: 0/255.0, blue: 78/255.0, alpha: 1.0)
            }
        
        } else {
            
             login(username: loginTextField.text!.lowercased(), password: passwordTextField.text!)
            
        }
    }
}









