//
//  iForgotVC.swift
//  iUtility
//
//  Created by Dani Tox on 30/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import FirebaseDatabase


class iForgotVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var ref: FIRDatabaseReference!
    var handle:FIRDatabaseHandle!
    
    @IBOutlet weak var sendiForgotRequestView: CircularView!
    @IBOutlet weak var getConfirmationView: CircularView!
    @IBOutlet weak var changePasswdView: CircularView!
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var newPasswdTextField: UITextField!
    @IBOutlet weak var confirmPasswdTextField: UITextField!
    
    var username : String?
    var email: String?
    var codeTyped: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getConfirmationView.isHidden = true
        changePasswdView.isHidden = true
        
        newPasswdTextField.isSecureTextEntry = true
        confirmPasswdTextField.isSecureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendVerificationCode() {
        if usernameTextField.text != nil && usernameTextField.text != "" && emailTextField.text != nil && emailTextField.text != "" {
            var allUsers = [String]()
            username = usernameTextField.text?.trimTrailingWhitespace()
            email = emailTextField.text?.trimTrailingWhitespace()
            
            ref = FIRDatabase.database().reference()
            ref.child("Utenti").observeSingleEvent(of: .value, with: { (snapshot) in
                if let users = snapshot.value as? NSDictionary {
                    for (key, _) in users {
                        allUsers.append(key as! String)
                    }
                    if allUsers.contains(self.username!) {
//                        self.ref.child("Utenti").child(self.username!).child("iForgot").setValue(true)
//                        self.sendiForgotRequestView.isHidden = true
//                        self.getConfirmationView.isHidden = false
                        self.checkEmail()
                    }
                    else {
                        self.mostraAlert(titolo: "Errore", messaggio: "L'username non esiste.", tipo: .alert)
                    }
                }
                
            })
        }
        else {
            mostraAlert(titolo: "Errore", messaggio: "Non tutti i campi sono compilati", tipo: .alert)
        }
    }

    func checkEmail() {
        ref.child("Utenti").child(username!).child("E-Mail").observeSingleEvent(of: .value, with: { (snapshot) in
            if let mailRight = snapshot.value as? String {
                print("Email from Firebase: \(mailRight)\nEmail Typed: \(self.email!)")
                if self.email == mailRight {
                    self.ref.child("Utenti").child(self.username!).child("iForgot").setValue(true)
                    self.sendiForgotRequestView.isHidden = true
                    self.getConfirmationView.isHidden = false
                }
                else {
                    self.mostraAlert(titolo: "Errore", messaggio: "La mail che hai scritto non risulta quella con cui ti sei iscritto", tipo: .alert)
                }
            }
        })
    }
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confermaCodice() {
        if codeTextField.text != nil && codeTextField.text != "" {
            codeTyped = Int(codeTextField.text!)
        }
        else {
            mostraAlert(titolo: "Errore", messaggio: "Non hai inserito il codice", tipo: .alert)
        }
        ref.child("Utenti").child(username!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let credentials = snapshot.value as? NSDictionary {
                let code = credentials["Codice"]
                if self.codeTyped! == code as! Int {
                    self.sendiForgotRequestView.isHidden = true
                    self.changePasswdView.isHidden = false
                }
                else {
                    self.mostraAlert(titolo: "Errore", messaggio: "Codice Errato", tipo: .alert)
                }
            }
        })
    }

    @IBAction func finallyChangePasswd() {
        let newPasswd = newPasswdTextField.text
        let confirmNewPasswd = confirmPasswdTextField.text
        
        if newPasswd != "" && newPasswd != nil {
        if newPasswd == confirmNewPasswd {
            let newPasswdCripted = newPasswd?.sha512()
            let newCodeForVerification = generaNumero(nMin: 1001, nMax: 9999)
            ref.child("Utenti").child(username!).child("Password").setValue(newPasswdCripted)
            ref.child("Utenti").child(username!).child("iForgot").setValue(false)
            ref.child("Utenti").child(username!).child("Codice").setValue(newCodeForVerification)
            ref.child("Utenti").child(username!).child("iForgot_sent").setValue(false)
//            ref.child("Utenti").child(username!).child("Access Token").observeSingleEvent(of: .value, with: { (snapshot) in
//                if let tokenServer = snapshot.value as? Int {
//                    UserDefaults.standard.set(tokenServer, forKey: "AccessToken")
//                }
//            })
//            UserDefaults.standard.set(username!, forKey: "usernameAccount")
//            UserDefaults.standard.set(true, forKey: "accountLoggato")
//            NotificationCenter.default.post(name: NOTIF_ACCEDUTO, object: nil)
            
            let alert = UIAlertController(title: "Password Cambiata", message: "La password è stata modificata. Ora puoi loggare con i nuovi dati di accesso", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (pressed) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            self.mostraAlert(titolo: "Errore", messaggio: "Le due password non corrispondono", tipo: .alert)
        }
        }
        else {
            mostraAlert(titolo: "Errore", messaggio: "La password deve contenere almeno un carattere", tipo: .alert)
        }
    }
    
    
    
}
