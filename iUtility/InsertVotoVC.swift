//
//  InsertVotoVC.swift
//  iUtility
//
//  Created by Dani Tox on 28/08/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

class InsertVotoVC: UIViewController {

    //MARK: - Outlets and Variables
    
    @IBOutlet weak var noLoggedView: UIView!
    
    
    //MARK: - Entry Point
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = UserDefaults.standard.object(forKey: USERLOGGED) {
            let user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! User
            print("Ciao, \(user.nome)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //MARK: - Functions


}
