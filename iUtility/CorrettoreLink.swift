//
//  CorrettoreLink.swift
//  iUtility
//
//  Created by Dani Tox on 27/03/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import Foundation
import SwiftyJSON

class CorrettoreLink: NSObject {
    
    func correggiLink() {
       
        let url = URL(string: "http://ipswdownloaderpy.altervista.org/filesAppDonBosco/correttoreLink.json")
        let jsonData = try? Data(contentsOf: url!) as Data
        let readableJson = JSON(data: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers , error: nil)
        
        let linkAvvisiGiusto = String(describing: readableJson["DeveloperNotes"])
        UserDefaults.standard.setValue(linkAvvisiGiusto, forKey: "LinkAvvisi")
        
        let linkAggiornamentiDisponibili = String(describing: readableJson["LatestAppVersion"])
        UserDefaults.standard.setValue(linkAggiornamentiDisponibili, forKey: "LinkControllaAggiornamenti")
        
        let linkMsgTester = String(describing: readableJson["msgForTestersUpdates"])
        UserDefaults.standard.setValue(linkMsgTester, forKey: "LinkMsgTester")
        
        let linkChangelog = String(describing: readableJson["changelog"])
        UserDefaults.standard.set(linkChangelog, forKey: "LinkChangeLog")
        
        let linkOrario = String(describing: readableJson["orarioLink"])
        UserDefaults.standard.setValue(linkOrario, forKey: "LinkOrario")
        
        //linksModificati = true
        UserDefaults.standard.set(true, forKey: "linkCorretti")
        
    }
    
}
