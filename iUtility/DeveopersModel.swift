//
//  DeveopersModel.swift
//  iUtility
//
//  Created by Dani Tox on 18/03/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import Foundation
import SwiftyJSON


class DeveloperModel : NSObject {
    
    var url:URL?
    
    func estrapolaAvvisiDaInternet() {
       
        if UserDefaults.standard.bool(forKey: "linkCorretti") != true {
            let urlString = "http://ipswdownloaderpy.altervista.org/filesAppDonBosco/avvisi.json"
            url = URL(string: urlString)
        }
        else  {
            if let urlString = UserDefaults.standard.string(forKey: "LinkAvvisi") {
                url = URL(string: urlString)
                
            }
            else {
                print("Qualcosa non va negli UserDefaults riguardo il link per gli avvisi")
            }
        }
        avvisiArray.removeAll()
       // let url = URL(string: linkAvvisi!)
        if let jsonData = try? Data(contentsOf: url!) as Data {
            
            let readableJson = JSON(data: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers , error: nil)
            
            let avvisi = readableJson["Avvisi"]
            
            for i in 1...15 {
                let avviso = avvisi[String(i)]
                if avviso != "" {
                    avvisiArray.append(String(describing: avviso))
                }
            }
        }
        
    }
}
