//
//  DeveloperTableViewController.swift
//  iUtility
//
//  Created by Dani Tox on 13/03/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

var avvisiArray = [String]()

class DeveloperTableViewController: UITableViewController {
    
    
    
    let developerModel = DeveloperModel()
    
    let ricaricaControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ricaricaControl.addTarget(self, action: #selector(self.aggiornaTuttoCompresoLaView), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = ricaricaControl
        }
        else {
            tableView.addSubview(ricaricaControl)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        controllaECaricaAvvisi()
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avvisiArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.backgroundView?.backgroundColor = UIColor.darkGray
        cell.backgroundColor = UIColor.darkGray
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = avvisiArray[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let CaricatoreSchema = SchemiTest()
//        CaricatoreSchema.caricaSchemi(testoSelezionato: avvisiArray[indexPath.row])
    }
    
    func aggiornaTuttoCompresoLaView() {
        controllaECaricaAvvisi()
        tableView.reloadData()
        ricaricaControl.endRefreshing()
    }
    
    
    
    func controllaECaricaAvvisi() {
        
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
