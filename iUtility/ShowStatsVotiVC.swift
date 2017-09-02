//
//  ShowStatsVotiVC.swift
//  iUtility
//
//  Created by Dani Tox on 02/09/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

var MateriaVotiSelezionata : [Voto]!

class ShowStatsVotiVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for voto in MateriaVotiSelezionata {
            print(voto.votoVerifica)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
