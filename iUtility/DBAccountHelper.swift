//
//  DBAccountHelper.swift
//  iUtility
//
//  Created by Dani Tox on 29/08/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import Foundation
import SwiftyJSON

class DBAccountHelper {
    
    private var nome : String?
    private var cognome : String?
    private var email : String
    private var password : String
    private var classe : String?
    
    init(nome: String, cognome:String, email: String, password: String, classe : String) {
        self.nome = nome
        self.cognome = cognome
        self.email = email
        self.password = password
        self.classe = classe
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    public func registerUser() -> Int {
        var returnCode = 2
        
        if let nome = self.nome, let cognome = self.cognome, let classe = self.classe {
            
            let parametri = "nome=\(nome)&cognome=\(cognome)&email=\(email)&password=\(password)&classe=\(classe)"
            let urlString = "http://192.168.1.10:8888/AppScuola/register.php?\(parametri)"
            
            if let data = try? Data(contentsOf: URL(string: urlString)!) as Data {
                let json = JSON(data: data, options: .mutableContainers, error: nil).dictionaryObject
                
                let responseMessage = json?["message"] as! String?
                print(responseMessage!)
                
                let code = json?["code"] as! String?
                
                switch code! {
                case "200":
                    returnCode = 0
                    
                    let id = json?["id"] as? String
                    let nome = json?["nome"] as? String
                    let cognome = json?["cognome"] as? String
                    let email = json?["email"] as? String
                    let classe = json?["classe"] as? String
                    let token = json?["token"] as? String
                    
                    let user = User(id: id!, nome: nome!, cognome: cognome!, classe: classe!, email: email!, token: token!)
                    
                    let dataUser = NSKeyedArchiver.archivedData(withRootObject: user)
                     
                    UserDefaults.standard.set(dataUser, forKey: USERLOGGED)
                    UserDefaults.standard.set(true, forKey: ISLOGGED)
                    
                case "300":
                    returnCode = 2
                case "400":
                    returnCode = 1
                default:
                    returnCode = 1
                }
                
            }
            
            
      
        }

        return returnCode
    }
    
    public func login() -> Bool {
        
        return false
    }
    
    deinit {
        print("DBHelper è stato deinizializzato")
    }
    
}
