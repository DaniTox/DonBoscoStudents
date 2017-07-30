//
//  AccediVC.swift
//  iUtility
//
//  Created by Dani Tox on 28/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CryptoSwift

class AccediVC: UIViewController {

    var presentError = false

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var ref: FIRDatabaseReference!
    var handle:FIRDatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
  
    
    
    
    @IBAction func loginAction() {
        
        
        if usernameTextField.text != nil && usernameTextField.text != "" {
            if passwordTextField.text != nil && passwordTextField.text != "" {
                progressView.isHidden = false
                progressView.startAnimating()
                
                var allUsers = [String]()
                ref = FIRDatabase.database().reference()
                ref.child("Utenti").observeSingleEvent(of: .value, with: { (snapshot) in
                    let username = self.usernameTextField.text?.trimTrailingWhitespace()
                    if let users = snapshot.value as? NSDictionary {
                        for (keys, _) in users {
                            allUsers.append(keys as! String)
                        }
                        if allUsers.contains(username!) {
                            self.checkPassword()
                        }
                        else {
                            self.mostraAlert(titolo: "Errore", messaggio: "L'username non esiste. Riprova", tipo: .alert)
                            self.progressView.stopAnimating()
                        }
                    }
                    
                })
            }
        }
    }
    
    func checkPassword() {
        let passwdTyped = passwordTextField.text
        let username = usernameTextField.text?.trimTrailingWhitespace()
        ref.child("Utenti").child(username!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let credentials = snapshot.value as? NSDictionary {
                
                if let salt = credentials["Salt"] as? String {
                    
                    print("Trovato salt nel database")
                    let passwdShaSalt = (passwdTyped! + salt).sha512()
                    
                    if let passwordServer = credentials["Password"] as? String {
                        if passwordServer == passwdShaSalt {
                            self.setValuesAcceduto(username: username!)
                            self.dismiss(animated: true, completion: nil)
                            self.progressView.stopAnimating()
                            
                            UserDefaults.standard.set(username!, forKey: "usernameAccount")
                            NotificationCenter.default.post(name: NOTIF_ACCEDUTO, object: nil)
                            
                            if let token = credentials["Access Token"] as? Int {
                                UserDefaults.standard.set(token, forKey: "AccessToken")
                                UserDefaults.standard.set(true, forKey: "accountLoggato")
                                
                            }
                            else {
                                print("C'è stato un errore mentre stavo ricevendo il token del tuo account. Contattami via mail scrivendo il tuo username in modo che possa aiutarti")
                                self.mostraAlert(titolo: "Errore Token", messaggio: "C'è stato un errore mentre stavo ricevendo il token del tuo account. Contattami via mail scrivendo il tuo username in modo che possa aiutarti", tipo: .alert)
                                
                                self.progressView.stopAnimating()
                            }
                        }
                        else {
                            
                            self.mostraAlert(titolo: "Errore", messaggio: "Password sbagliata", tipo: .alert)
                            self.progressView.stopAnimating()
                        }
                    }
                    
                    
                }
                
                
                else {
                    
                    let passwdServer = credentials["Password"] as? String
                    let passwdTypedCripted = passwdTyped?.sha512()
                    
                    if passwdTypedCripted == passwdServer {
                        self.setValuesAcceduto(username: username!)
                        
                        self.dismiss(animated: true, completion: nil)
                        self.progressView.stopAnimating()
                        
                        UserDefaults.standard.set(username!, forKey: "usernameAccount")
                        NotificationCenter.default.post(name: NOTIF_ACCEDUTO, object: nil)
                        
                        let salt = randomString(length: 30)
                        let passwdHashSaltata = (passwdTyped! + salt).sha512()
                        
                        self.ref.child("Utenti").child(username!).child("Salt").setValue(salt)
                        self.ref.child("Utenti").child(username!).child("Password").setValue(passwdHashSaltata)
                        
                        let versione = Bundle.main.releaseVersionNumber!
                        self.ref.child("Utenti").child(username!).child("Versione App").setValue(versione)
                        
                        
                        if let token = credentials["Access Token"] as? Int {
                            UserDefaults.standard.set(token, forKey: "AccessToken")
                            UserDefaults.standard.set(true, forKey: "accountLoggato")
                            
                        }
                        else {
                            print("C'è stato un errore mentre stavo ricevendo il token del tuo account. Contattami via mail scrivendo il tuo username in modo che possa aiutarti")
                            self.mostraAlert(titolo: "Errore Token", messaggio: "C'è stato un errore mentre stavo ricevendo il token del tuo account. Contattami via mail scrivendo il tuo username in modo che possa aiutarti", tipo: .alert)
                            
                            self.progressView.stopAnimating()
                        }

                        
                        
                    }
                    else {
                        
                        self.mostraAlert(titolo: "Errore", messaggio: "Password sbagliata", tipo: .alert)
                        self.progressView.stopAnimating()
                    }
                    
                }
                
                
                
            }
            
        })
        
    }

    
    func setValuesAcceduto(username:String) {
        let date = Date()
        let now = Calendar.current
        let hour = now.component(.hour, from: date)
        let minute = now.component(.minute, from: date)
        let day = now.component(.day, from: date)
        let month = now.component(.month, from: date)
        let year = now.component(.year, from: date)
        
        self.ref.child("Utenti").child(username).child("Ultimo Accesso").setValue("\(hour):\(minute) - \(day)/\(month)/\(year)")
        
        self.ref.child("Utenti").child(username).child("iForgot").setValue(false)
        
        self.ref.child("Utenti").child(username).child("iForgot_sent").setValue(false)
    }
    
    func presentaAlertSuccess() {
        let alert = UIAlertController(title: "Login", message: "Il login è stato completato con successo", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
