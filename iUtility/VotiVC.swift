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
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    @IBOutlet weak var showAccediViewOutlet: UIButton!
    
    @IBOutlet weak var emailLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!
    @IBOutlet weak var accediLoginButtonOutlet: UIButton!
    
    
    
    
    //MARK: - Entry Point
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVoti()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setModeforView()
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
                
                setModeforView()
                
                
                
            default:
                print("Error. \(isRegistered)")
            }
            
  
        }
        
    
    }
    
    
    func setModeforView() {
        let isLogged = UserDefaults.standard.bool(forKey: ISLOGGED)
        
        if isLogged == true {
            showRegisterViewOutlet.isHidden = true
            showAccediViewOutlet.isHidden = true
            esciButtonOutlet.isHidden = false
            tableView.isHidden = false
        }
        else {
            esciButtonOutlet.isHidden = true
            showRegisterViewOutlet.isHidden = false
            showAccediViewOutlet.isHidden = false
            tableView.isHidden = true
        }
        
    }
    
    
    @IBAction func logoutAccountAction(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: USERLOGGED)
        UserDefaults.standard.set(false, forKey: ISLOGGED)
        setModeforView()
    }
    
    
    @IBAction func sowAccediViewAction(_ sender: UIButton) {
        
        self.loginView.isHidden = false
        self.loginView.alpha = 0
        
        UIView.animate(withDuration: 0.4) { 
            self.loginView.alpha = 1
        }
        
    }
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        var isAbletoLogin: Bool = true
        
        if emailLoginTextField.text == nil || emailLoginTextField.text == "" {
            isAbletoLogin = false
        }
        if passwordLoginTextField.text == nil || passwordLoginTextField.text == "" {
            isAbletoLogin = false
        }
        
        
        if isAbletoLogin {
            accediLoginButtonOutlet.isEnabled = false
            
            let email = emailLoginTextField.text
            let password = passwordLoginTextField.text
            
            let DBUserHelper = DBAccountHelper(email: email!, password: password!)
            
            let result = DBUserHelper.login()
            
            switch result {
            case 0:
                
                mostraAlert(titolo: "Completato", messaggio: "Login effettuato con successo", tipo: .alert)
                
                
                
                UIView.animate(withDuration: 1, animations: {
                    self.loginView.alpha = 0
                }, completion: { (completed) in
                    self.loginView.isHidden = true
                })
                
                setModeforView()
                
            case 1:
                mostraAlert(titolo: "Errore", messaggio: "La mail non è presente nel database. Assicurati di averla scritta giusta e riprova", tipo: .alert)
                accediLoginButtonOutlet.isEnabled = true
                
            case -1:
                mostraAlert(titolo: "Errore", messaggio: "C'è stato un errore del server. Se continua a non funzionare, riprova più tardi.", tipo: .alert)
                accediLoginButtonOutlet.isEnabled = true
            default:
                mostraAlert(titolo: "Errore", messaggio: "C'è stato un errore del server. Se continua a non funzionare, riprova più tardi.", tipo: .alert)
                accediLoginButtonOutlet.isEnabled = true
            }
            
        }
        
        
        
    }
    
    
    func getVoti() {
        
        let dbHelper = DBVotiHelper()
        let result = dbHelper.getVoti()
        
        switch result! {
        case -2:
            print("Nessun Voto")
        case 0:
            print("Voti recuperati con successo")
        default:
            print("Voti recuperati con successo")
        }
        
        
        tableView.reloadData()
        print(votiDict)
    }
    
    
    func calcMediaOf(_ voti: [Voto]) -> Double {
        
        var i = 0
        for voto in voti {
            i += voto.votoVerifica
        }
        
        let media = i / voti.count
        
//        if media.truncatingRemainder(dividingBy: 1) == 0 {
//            let mediaInt = Int(media)
//            return Double(mediaInt)
//        }
//        else {
//            return media
//        }
        
        return Double(media)
    }
    
    
}

//MARK: - Extension

extension VotiVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var keys = Array(votiDict.keys)
        for (index, key) in keys.enumerated() {
            if key == "MediaGenerale" {
                keys.remove(at: index)
                keys.insert(key, at: 0)
                break
            }
        }
        
        MateriaVotiSelezionata =  votiDict[keys[indexPath.row]]
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return votiDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MediaVotiCell
        
        
        
        var keys = Array(votiDict.keys)
        for (index, key) in keys.enumerated() {
            if key == "MediaGenerale" {
                keys.remove(at: index)
                keys.insert(key, at: 0)
                break
            }
        }
        
        let materia = String(keys[indexPath.row])
        
        cell.materiaLabel.text = String(keys[indexPath.row])
        
        
        if let voti = votiDict[materia] {
            cell.mediaMateriaLabel.text = "MEDIA: \(calcMediaOf(voti).cleanValue)"
        }
        
        
        return cell
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





