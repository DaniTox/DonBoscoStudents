//
//  VerificheNuovoTableViewController.swift
//  iUtility
//
//  Created by Dani Tox on 04/03/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import FirebaseDatabase



class VerificheNuovoTableViewController: UITableViewController {
    
    var materieArray = [String]()
    var materieDataArray = [String]()
    var materieArgomentoArray = [String]()
    
    
    var classeAllievo:String?
    
    var ref:FIRDatabaseReference?
    var handle:FIRDatabaseHandle?
    
    var ricaricaControl = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classeAllievo = UserDefaults.standard.string(forKey: "classe")
        
        ricaricaControl.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = ricaricaControl
        } else {
            tableView.addSubview(ricaricaControl)
        }
        
        
        ref = FIRDatabase.database().reference()
        caricaLeVerifiche()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materieArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let caricatoreDatiVerifica = CaricaDatiVerifica()
        //caricatoreDatiVerifica.caricaTabellaMateria()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell1")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.backgroundColor = UIColor.darkGray
        cell.backgroundView?.backgroundColor = UIColor.darkGray
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = "\((materieArray[indexPath.row]).uppercased())\nARGOMENTO: \(materieArgomentoArray[indexPath.row])\nDATA: \(materieDataArray[indexPath.row])"
        
        return cell
    }
    
    func caricaLeVerifiche() {
        if let classeAllievo = UserDefaults.standard.string(forKey: "classe") {
            if classeAllievo != "" {
            ref?.child("Classi").child(classeAllievo).observeSingleEvent(of: .value, with: { (snapshot) in
                self.classeAllievo = UserDefaults.standard.string(forKey: "classe")
                if let materie = snapshot.value as? NSDictionary {
                    for (keys, _) in materie {
                        let test = materie[keys] as? NSDictionary
                        //print(test!)
                        if test?["Verifica"] as? String == "yes" {
                            //self.materieArray.removeAll()
                            //self.materieDataArray.removeAll()
                            //self.materieArgomentoArray.removeAll()
                            let verificaProgrammataNome = test!["Nome"] as! String
                            let verificaProgrammataData = test!["Data"] as! String
                            let verificaProgrammataArgomento = test!["Argomento"] as! String
                            print("+1   \(verificaProgrammataNome)")
                            self.materieArray.append(verificaProgrammataNome)
                            self.materieDataArray.append(verificaProgrammataData)
                            self.materieArgomentoArray.append(verificaProgrammataArgomento)
                        }
                        
                        
                    }
                
                    self.tableView.reloadData()
                    self.ricaricaControl.endRefreshing()
                    
                    //self.materieArray.append(item)
                    //self.tableView.reloadData()
                    
                }
                else {
                    let alert1 = UIAlertController(title: "Errore", message: "La classe selezionata ha qualche errore di scrittura. Assicurati di averla scritta giusta nelle impostazioni e riprova. \nSintassi: 1E, 2E, 3E, 4E, 1M, 2M, 3M, 4M", preferredStyle: .alert)
                    alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert1, animated: true, completion: nil)
                    self.ricaricaControl.endRefreshing()
                    print("error")
                }
                
                
            })
            }
        } else if classeAllievo == "" {
            let alert1 = UIAlertController(title: "Nessuna classe", message: "Non hai selezionato nessuna classe. Puoi farlo nelle impostazioni", preferredStyle: .alert)
            alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert1, animated: true, completion: nil)
        }
        else {
            self.ricaricaControl.endRefreshing()
            
            let alert = UIAlertController(title: "Nessuna classe", message: "Non hai selezionato la tua classe. Puoi farlo nelle impostazioni", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            print ("no classe")
        }
    }
    
    
    func refreshData() {
        clearArrays()
        caricaLeVerifiche()
    }
    
    
    func clearArrays() {
        self.materieArray.removeAll()
        self.materieDataArray.removeAll()
        self.materieArgomentoArray.removeAll()
    }
    
}
