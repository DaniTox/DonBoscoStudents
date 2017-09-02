//
//  InsertVotoVC.swift
//  iUtility
//
//  Created by Dani Tox on 28/08/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import SwiftyJSON

var VerificaSelezionata : Verifica!

class InsertVotoVC: UIViewController {

    //MARK: - Outlets and Variables
    
    @IBOutlet weak var noLoggedView: UIView!
    @IBOutlet weak var votoTextField: UITextField!
    @IBOutlet weak var insertVotoButtonOutlet: UIButton!
    
    
    //MARK: - Entry Point
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: ISLOGGED) {
            if let userData = UserDefaults.standard.object(forKey: USERLOGGED) {
                let user = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data) as! User
                print("Ciao, \(user.nome)")
            }
            
            
            
            
            
            
            
        }
        else {
            print("Ciao utente non loggato")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //MARK: - Functions

    @IBAction func sendVoto(_ sender: UIButton) {
        if let userData = UserDefaults.standard.object(forKey: USERLOGGED) {
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data) as! User
            
            
            if let voto = votoTextField.text {
                
                let idVerifica = VerificaSelezionata.idVerifica
                let email = user.email
                let token = user.token
                
                let parametri = "token=\(token)&idVerifica=\(idVerifica)&email=\(email)&voto=\(voto)"
                let urlString = "http://localhost:8888/AppScuola/insertVoto.php?\(parametri)"
                
                let url = URL(string: urlString)
                
                if let dataJson = try? Data(contentsOf: url!) {
                    let json = JSON(data: dataJson, options: .mutableContainers, error: nil)
                    
                    let codeResponse = json["code"].string
                    let messageResponse = json["message"].string
                    
                    if codeResponse == "200" {
                        mostraAlert(titolo: "Yay", messaggio: messageResponse!, tipo: .alert)
                        insertVotoButtonOutlet.isEnabled = false
                    }
                    else {
                        mostraAlert(titolo: "Fuck my life", messaggio: messageResponse!, tipo: .alert)
                    }
                    
                    
                }
                
                
            }
            
            
            
            
        }
    }

}
