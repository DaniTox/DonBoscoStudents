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
   
    func estrapolaAvvisiDaInternet() {
        
        avvisiArray.removeAll()
        let url = URL(string: "http://www.ipswdownloaderpy.altervista.org/filesAppDonBosco/avvisi.json")
        let jsonData = try? Data(contentsOf: url!) as Data
        let readableJson = JSON(data: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers , error: nil)
        
        let avvisi = readableJson["Avvisi"]
        
        for i in 1...15 {
            let avviso = avvisi[String(i)]
            if avviso != "" {
                avvisiArray.append(String(describing: avviso))
            }
        }
        
    }
}
