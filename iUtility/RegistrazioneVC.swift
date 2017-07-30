//
//  RegistrazioneVC.swift
//  iUtility
//
//  Created by Dani Tox on 27/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import FirebaseDatabase
import BlueSocket

class RegistrazioneVC: UIViewController {
    

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
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
    
    var availableMail:String?

    @IBAction func registerAction() {
        progressView.isHidden = false
        progressView.startAnimating()
        
       
        
        if usernameTextField.text != "" && usernameTextField.text != nil {
            if emailTextField.text != "" && emailTextField.text != nil {
                if passwordTextField.text != "" && passwordTextField.text != nil {
                    if (passwordTextField.text?.characters.count)! >= 4 {
                        
                    
                    do {
                        let socket = try Socket.create()
                        try socket.connect(to: "checkmaildbapp.ddns.net", port: 1234)
                        try socket.write(from: emailTextField.text!)
                        
                        //try socket.listen(on: 1234, maxBacklogSize: Socket.SOCKET_DEFAULT_MAX_BACKLOG)
                        availableMail = try socket.readString()
                        print(availableMail ?? "Error server")
                        socket.close()
                    } catch {
                        mostraAlert(titolo: "Errore", messaggio: "SOCKET ERROR\nContatta lo sviluppatore tramite Impostazioni > Segnala bug e spiega cosa è successo", tipo: .alert)
                    }
                    if availableMail == "True" {
                        ref = FIRDatabase.database().reference()
                        isUsernameAvailable(usernameArg: usernameTextField.text!)
                    }
                    else if availableMail == "False"{
                        mostraAlert(titolo: "Errore", messaggio: "La mail non esiste. Please, inserisci la tua mail reale", tipo: .alert)
                        progressView.stopAnimating()
                    }
                    else if availableMail == "None" {
                        mostraAlert(titolo: "Errore", messaggio: "La mail risulta non ancora in uso da nessuno. Please inserisci la tua mail giusta", tipo: .alert)
                        progressView.stopAnimating()
                    }
                    else {
                        mostraAlert(titolo: "Errore", messaggio: "Probabilmente il server che gestisce il check delle mail non funziona. Riprova più tardi", tipo: .alert)
                        progressView.stopAnimating()
                    }
                }
                    else {
                        mostraAlert(titolo: "Errore", messaggio: "La password deve essere lunga almeno 4 caratteri", tipo: .alert)
                        progressView.stopAnimating()
                    }
                }
                else {
                    mostraAlert(titolo: "Errore", messaggio: "Inserisci una password di almeno 4 caratteri", tipo: .alert)
                    progressView.stopAnimating()
                }
            }
        }
        else {
            print("Tutti i campi sono obbligatori. Completali e riprova")
            progressView.stopAnimating()
        }
    }
   
    func isUsernameAvailable(usernameArg: String) {
        var allUsernames = [String]()
        ref.child("Utenti").observeSingleEvent(of: .value, with: { (snapshot) in
            if let utenti = snapshot.value as? NSDictionary {
                for (keys, _) in utenti {
                    allUsernames.append(keys as! String)
                }
                if allUsernames.contains(usernameArg) {
                    self.mostraAlert(titolo: "Username non disponibile", messaggio: "L'username risulta già nel database. Scegline un altro", tipo: .alert)
                    self.progressView.stopAnimating()
                }
                else {
                    self.addUser()
                }
            }
            else {
                self.mostraAlert(titolo: "Errore", messaggio: "C'è stato un errore nello scambio di dati con il cloud", tipo: .alert)
                self.progressView.stopAnimating()
            }
        })
    }
    
    func addUser() {
        if let usernameInc = usernameTextField.text {
            
            let date = Date()
            let now = Calendar.current
            let hour = now.component(.hour, from: date)
            let minute = now.component(.minute, from: date)
            let day = now.component(.day, from: date)
            let month = now.component(.month, from: date)
            let year = now.component(.year, from: date)
            
            let username = usernameInc.trimTrailingWhitespace()
            let email = emailTextField.text?.trimTrailingWhitespace()
            let password = passwordTextField.text?.trimTrailingWhitespace()
            let token = generaNumero(nMin: 10001, nMax: UINT32_MAX - 1)
            
            let salt = randomString(length: 30)
            print("Salt: \(salt)")
            
            let passwdHashSalt = (password! + salt).sha512()
            
            let versione = String(describing: Bundle.main.releaseVersionNumber!)
            
            ref.child("Utenti").child(username).child("Username").setValue(username)
            ref.child("Utenti").child(username).child("E-Mail").setValue(email)
            ref.child("Utenti").child(username).child("Password").setValue(passwdHashSalt)
            ref.child("Utenti").child(username).child("Salt").setValue(salt)
            ref.child("Utenti").child(username).child("Codice").setValue(generaNumero(nMin: 1001, nMax: 9999))
            ref.child("Utenti").child(username).child("Access Token").setValue(token)
            ref.child("Utenti").child(username).child("iForgot").setValue(false)
            ref.child("Utenti").child(username).child("iForgot_sent").setValue(false)
            ref.child("Utenti").child(username).child("Ultimo Accesso").setValue("\(hour):\(minute) - \(day)/\(month)/\(year)")
            ref.child("Utenti").child(username).child("Versione App").setValue("v\(versione)")
            
            UserDefaults.standard.set(token, forKey: "AccessToken")
            
            UserDefaults.standard.set(true, forKey: "accountLoggato")
            
            UserDefaults.standard.set(username, forKey: "usernameAccount")
            
            NotificationCenter.default.post(name: NOTIF_ACCEDUTO, object: nil)
            
            progressView.stopAnimating()
            let alert = UIAlertController(title: "Registrazione Effettuata", message: "Grazie per esserti registrato. Ora puoi usufruire dei servizi che prima erano limitati", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (pressed) in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
