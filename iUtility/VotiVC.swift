//
//  VotiVC.swift
//  iUtility
//
//  Created by Dani Tox on 27/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import FirebaseDatabase



class VotiVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var accediOutlet: UIButton!
    @IBOutlet weak var registratiOutlet: UIButton!
    @IBOutlet weak var infoOutlet: UILabel!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avvisoDaEliminare: UILabel!
    @IBOutlet weak var materieButtonsView: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var finallyLogged :Bool?
    
    var ref: FIRDatabaseReference!
    var handle:FIRDatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginIndicator.isHidden = true
        blurView.isHidden = true
        materieButtonsView.isHidden = true
        
        imageView.image = UIImage(named: GETcolorMode())
        infoOutlet.numberOfLines = 0
        infoOutlet.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        NotificationCenter.default.addObserver(forName: NOTIF_ACCEDUTO, object: nil, queue: nil) { (notification) in
            self.accediOutlet.isHidden = true
            self.registratiOutlet.isHidden = true
            self.infoOutlet.text = "Benvenuto in DaniToxCloud! Ora puoi vedere le statistiche del tuo anno scoastico.\nBuona fortuna, \(UserDefaults.standard.string(forKey: "usernameAccount") ?? "Error while getting username")!"
            self.avvisoDaEliminare.isHidden = true
            self.materieButtonsView.isHidden = false
        }
        
        NotificationCenter.default.addObserver(forName: NOTIF_LOGOUT, object: nil, queue: nil) { (notification) in
            self.accediOutlet.isHidden = false
            self.registratiOutlet.isHidden = false
            self.avvisoDaEliminare.isHidden = true
            self.materieButtonsView.isHidden = true
            self.infoOutlet.text = "Per salvare i tuoi voti e vedere le statistiche, devi registrarti al servizio DaniToxCloud"
            
            UserDefaults.standard.set(false, forKey: "accountLoggato")
            UserDefaults.standard.set(0, forKey: "AccessToken")
            UserDefaults.standard.set(nil, forKey: "usernameAccount")
        }
        
        NotificationCenter.default.addObserver(forName: NOTIF_COLORMODE, object: nil, queue: nil) { (notification) in
            self.imageView.image = UIImage(named: GETcolorMode())
        }
        
        checkIfLogged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutAction() {
        NotificationCenter.default.post(name: NOTIF_LOGOUT, object: nil)
    }

    func checkIfLogged() {
        let loggato = UserDefaults.standard.bool(forKey: "accountLoggato")
        let token = UserDefaults.standard.integer(forKey: "AccessToken")
        let username = UserDefaults.standard.string(forKey: "usernameAccount")
        
        
        if loggato == true {
            loginIndicator.isHidden = false
            blurView.isHidden = false
            loginIndicator.startAnimating()
            if username != nil && token != 0 {
                ref = FIRDatabase.database().reference()
                ref.child("Utenti").child(username!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let credentials = snapshot.value as? NSDictionary {
                        let tokenRight = credentials["Access Token"] as? Int
                        
                        if token == tokenRight {
                            self.finallyLogged = true

                            NotificationCenter.default.post(name: NOTIF_ACCEDUTO, object: nil)
                            self.loginIndicator.stopAnimating()
                            self.blurView.isHidden = true
                        }
                        else {
                            self.mostraAlert(titolo: "Error", messaggio: "ACCESS_TOKEN WRONG", tipo: .alert)
                            UserDefaults.standard.set("", forKey: "usernameAccount")
                            UserDefaults.standard.set(false, forKey: "accountLoggato")
                            UserDefaults.standard.set(0, forKey: "AccessToken")
                            
                            self.loginIndicator.stopAnimating()
                            self.blurView.isHidden = true
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func showStats(_ sender: UIButton) {
        if let nomeMateria = sender.currentTitle {
            materiaStats = nomeMateria
            print(materiaStats ?? "Error")
        }
        else {
            print("Error in getting materia nam for stats")
        }
        
        self.performSegue(withIdentifier: "viewStats", sender: self)
    }
    
}
