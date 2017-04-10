//
//  test.swift
//  iUtility
//
//  Created by Dani Tox on 09/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import SwiftyJSON

var avvisiArray = [String]()

class Sviluppatori: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    let developerModel = DeveloperModel()
    
    let ricaricaControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "dark")
        statusBar.backgroundColor = UIColor.clear
        
        ricaricaControl.addTarget(self, action: #selector(self.aggiornaTuttoCompresoLaView), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = ricaricaControl
        }
        else {
            tableView.addSubview(ricaricaControl)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avvisiArray.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controllaConnessioneECaricaAvvisi()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.text = avvisiArray[indexPath.row]
        return cell!
    }
    
    func aggiornaTuttoCompresoLaView() {
        controllaConnessioneECaricaAvvisi()
        tableView.reloadData()
        ricaricaControl.endRefreshing()
    }
    
    func controllaConnessioneECaricaAvvisi() {
        
        //SE C'È CONNESSIONE, ESEGUI QUESTO BLOCCO
        if Reachability.isConnectedToNetwork() == true {
            developerModel.estrapolaAvvisiDaInternet()
            ricaricaControl.endRefreshing()
        }
            
            // SE NON C'È, ESEGUI QUESTO BLOCCO
        else {
            presentaAvvisoErrore()
        }
        
        
        
    }
    
    
    
    func presentaAvvisoErrore() {
        print("No Connection")
        let alert = UIAlertController(title: "Nessuna Connessione", message: "Assicurati di essere connesso al Wi-Fi o al 3G/4G e riprova.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        ricaricaControl.endRefreshing()
    }
}
