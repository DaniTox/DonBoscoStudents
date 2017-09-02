//
//  DBVotiHelper.swift
//  iUtility
//
//  Created by Dani Tox on 01/09/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import Foundation
import SwiftyJSON

var votiGenerale : [Voto] = [Voto]()

var votiDict = [String : [Voto]]()


class DBVotiHelper {
    
    public func getVoti() {
        
        
        
        if UserDefaults.standard.bool(forKey: ISLOGGED) == true {
            
            let userData = UserDefaults.standard.object(forKey: USERLOGGED) as! Data
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as! User
            
            let token = user.token
            
            let urlString = "http://localhost:8888/AppScuola/getVoti.php?token=\(token)"
            let url = URL(string: urlString)
            
            if let dataVoti = try? Data(contentsOf: url!) as Data {
                
                let json = JSON(data: dataVoti, options: .mutableContainers, error: nil)
                
                let arrayVotiTemp = json.arrayObject as? [[String : String]]
                
                
                for votoItem in arrayVotiTemp! {
                    
                    let voto = Int(votoItem["Voto"]!)
                    let titolo = votoItem["Titolo"]!
                    let materia = votoItem["Materia"]!
                    let data = votoItem["Data"]!
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-mm-yyyy"
                    let date = dateFormatter.date(from: data)
                    
                    let votoVerifica = Voto(voto: voto!, titolo: titolo, materia: materia, data: date!)
                    votiGenerale.append(votoVerifica)

                    let materiaTemp = votoVerifica.materiaVerifica
                    
                    
                    
                    if votiDict[materiaTemp] == nil {
                        votiDict[materiaTemp] = [votoVerifica]
                    }
                    else {
                        votiDict[materiaTemp]?.append(votoVerifica)
                    }
                    
                    
                }
                votiDict["MediaGenerale"] = votiGenerale
                
                
            }
            else {
                print("Ciao scemo. Non funziona una cippa")
            }
        }
    }
    
    
    
}


class Voto: NSObject {
    var votoVerifica : Int
    var titoloVerifica : String
    var materiaVerifica : String
    var dataVerifica : Date
    
    init(voto : Int, titolo: String, materia: String, data: Date) {
        self.votoVerifica = voto
        self.titoloVerifica = titolo
        self.materiaVerifica = materia
        self.dataVerifica = data
    }
    
}




