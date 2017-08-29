//
//  VotiVC.swift
//  iUtility
//
//  Created by Dani Tox on 28/08/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

class VotiVC: UIViewController {

    //MARK: - Outlets and Variables
    
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    
    @IBOutlet weak var esciButtonOutlet: UIButton!
    
    //REGISTRAZIONE
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var cognomeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!

    @IBOutlet weak var registerIndicator: UIActivityIndicatorView!
    @IBOutlet var registrationTextFields: [UITextField]!
    
    
    @IBOutlet weak var showRegisterViewOutlet: UIButton!
    
    //LOGIN
    
    
    
    
    
    //MARK: - Entry Point
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.data(forKey: USERLOGGED) != nil {
            setModeforView(isLogged: true)
        }
        else {
            setModeforView(isLogged: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Functions
    
    @IBAction func showRegisterViewAction(_ sender: UIButton) {
        self.registerView.isHidden = false
        self.registerView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.registerView.alpha = 1
        }
    }
    
    @IBAction func Registrati(_ sender: UIButton) {
       
        var isAbleToRegister: Bool = true
        
        for textfield in registrationTextFields {
            if textfield.text == "" || textfield.text == nil {
                isAbleToRegister = false
            }
            
            if password1TextField.text != password2TextField.text {
                isAbleToRegister = false
            }
            
        }
        
        if isAbleToRegister {
            registerButtonOutlet.isEnabled = false
            registerIndicator.startAnimating()
            
            let nome = nomeTextField.text
            let cognome = cognomeTextField.text
            let email = emailTextField.text
            let password = password1TextField.text
            let classe = UserDefaults.standard.string(forKey: "classe")
            
            let DBHelper = DBAccountHelper(nome: nome!, cognome: cognome!, email: email!, password: password!, classe: classe!)
            let isRegistered = DBHelper.registerUser()
            
            switch isRegistered {
            case 1:
                mostraAlert(titolo: "Errore", messaggio: "C'è stato un errore durante la fase di registrazione. Prova a controllare i dati inseriti e riprova", tipo: .alert)
                registerIndicator.stopAnimating()
                registerButtonOutlet.isEnabled = true
                
            case 2:
                mostraAlert(titolo: "Errore", messaggio: "La mail è già presente nel database", tipo: .alert)
                registerIndicator.stopAnimating()
                registerButtonOutlet.isEnabled = true
                
            case 0:
                mostraAlert(titolo: "Completato", messaggio: "La registrazione è stata completate", tipo: .alert)
                
                UIView.animate(withDuration: 1, animations: {
                    self.registerView.alpha = 0
                }, completion: { (completed) in
                    self.registerView.isHidden = true
                })
                
                setModeforView(isLogged: true)
                
                
                
            default:
                print("Error. \(isRegistered)")
            }
            
            
            
            
            
        }
        
    
    }
    
    
    func setModeforView(isLogged: Bool) {
        if isLogged == true {
            registerButtonOutlet.isHidden = true
            esciButtonOutlet.isHidden = false
        }
        else {
            esciButtonOutlet.isHidden = true
            registerButtonOutlet.isHidden = false
        }
        
    }
    
    
    @IBAction func logoutAccountAction(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: USERLOGGED)
        UserDefaults.standard.set(false, forKey: ISLOGGED)
        setModeforView(isLogged: false)
    }
    
    
    
}



//MARK: - Others

class User: NSObject, NSCoding {
    public var id : String
    public var nome : String
    public var cognome : String
    public var classe : String
    public var email : String
    public var token : String
    
    init(id: String, nome: String, cognome: String, classe: String, email:String, token:String) {
        self.id = id
        self.nome = nome
        self.cognome = cognome
        self.classe = classe
        self.email = email
        self.token = token
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! String
        nome = aDecoder.decodeObject(forKey: "nome") as! String
        cognome = aDecoder.decodeObject(forKey: "cognome") as! String
        classe = aDecoder.decodeObject(forKey: "classe") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        token = aDecoder.decodeObject(forKey: "token") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(nome, forKey: "nome")
        aCoder.encode(cognome, forKey: "cognome")
        aCoder.encode(classe, forKey: "classe")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(token, forKey: "token")
    }
    
    
}





