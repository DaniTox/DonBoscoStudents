//
//  DBVerificheCatcher.swift
//  iUtility
//
//  Created by Dani Tox on 30/08/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import Foundation
import SwiftyJSON

var verifiche = [Verifica]()
var verificheInCorso = [Verifica]()
var verificheCompletate = [Verifica]()
var verificheinAttesadiValutazione = [Verifica]()


class DBVerificheCatcher {
    
    public func catchVerifiche() -> Int {
        
        var returnCode : Int = 1
        
        if let classe = UserDefaults.standard.string(forKey: "classe") {
            let url = "http://localhost:8888/AppScuola/catchVerificheNoToken.php?classe=\(classe)"
            let url2 = URL(string: url)
            
            if let data = try? Data(contentsOf: url2!) as Data {
                let json = JSON(data: data, options: .mutableContainers, error: nil)
                
                if let array = json.arrayObject as? [[String : String]] {
                    
                    verifiche.removeAll()
                    verificheinAttesadiValutazione.removeAll()
                    verificheCompletate.removeAll()
                    
                    for item in array {
                        
                        let id = item["idVerifica"]
                        let titolo = item["Titolo"]
                        let materia = item["Materia"]
                        let data = item["Data"]
                        let formatore = item["Formatore"]
                        let svolgimento = item["Svolgimento"]
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        let date = dateFormatter.date(from: data!)
                        
                        
                        let verifica = Verifica(idVerifica: id!, Titolo: titolo!, Materia: materia!, Data: date!, Formatore: formatore!, Svolgimento: svolgimento!)
                        verifiche.append(verifica)
                        
                        parseVerificheinSection()
                        
                        returnCode = 0
                    }
                }
                else {
                    verifiche.removeAll()
                    
                    returnCode = 1
                }
            }
        }
        else {
            print("DBVerificheCatcher: Non è stata trovata classe in UserDefaults - catchverifiche")
            returnCode = -1
        }
        
        return returnCode
        
    }
    
    
    private func parseVerificheinSection() {
        let currDate = Date()
        let calendar = Calendar.current
        
        verificheinAttesadiValutazione.removeAll()
        verificheCompletate.removeAll()
        verificheInCorso.removeAll()
        
        
        for verifica in verifiche {
            
            if currDate < verifica.Data {
                verificheInCorso.append(verifica)
            }
            
            if verifica.Svolgimento == "0" {
                
                if calendar.isDateInYesterday(verifica.Data) {
                    verificheinAttesadiValutazione.append(verifica)
                }
                else if currDate > verifica.Data {
                    verificheinAttesadiValutazione.append(verifica)
                }
                
            }
            else {
                verificheCompletate.append(verifica)
            }
            
            
            
        }
        
        
    }
    
    
}


struct Verifica {
    var idVerifica : String
    var Titolo : String
    var Materia : String
    var Data : Date
    var Formatore : String
    var Svolgimento : String
}
