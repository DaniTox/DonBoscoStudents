//
//  ChangeLog.swift
//  iUtility
//
//  Created by Dani Tox on 01/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import SwiftyJSON

var changelogArray = [String]()

class GetChangeLog : NSObject {
    
    var url: URL?
    
    func getCangelog() {
        
        if UserDefaults.standard.bool(forKey: "linkCorretti") != true {
            let urlString = "http://ipswdownloaderpy.altervista.org/filesAppDonBosco/changelog.json"
            url = URL(string: urlString)
        }
        else  {
            if let urlString = UserDefaults.standard.string(forKey: "LinkChangeLog") {
                url = URL(string: urlString)
                
            }
            else {
                print("Qualcosa non va negli UserDefaults riguardo il link per il changelog")
            }
        }
        
        if Reachability.isConnectedToNetwork() {
            if let jsonData = try? Data(contentsOf: url!) as Data {
                
                let readableJson = JSON(data: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers , error: nil)
                
                let changes = readableJson["Changelog"]
                
                for i in 1...20 {
                    let change = changes[String(i)]
                    if change != "" {
                        changelogArray.append(String(describing: change))
                        changelogArray.append("\n")
                    }
                }
            }
        }
        else {
            changelogArray.append("ERRORE")
        }
    }
}
