//
//  VerificheViewController.swift
//  iUtility
//
//  Created by Dani Tox on 10/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleMobileAds

class VerificheViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {

    
    @IBOutlet weak var bannerAdView: GADBannerView!
    
    
    var materieArray = [String]()
    var materieDataArray = [String]()
    var materieArgomentoArray = [String]()
    
    var classeAllievo:String?
    
    var ref:FIRDatabaseReference?
    var handle:FIRDatabaseHandle?
    
    var ricaricaControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var latestUpdateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func parsaLeMaterie() {
        let start = Date()
        if let materie = UserDefaults.standard.dictionary(forKey: "verificheCache") {
            for (keys, _) in materie {
                let test = materie[keys] as? NSDictionary
                
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
                    //self.latestUpdateLabel.text = self.aggiornaDataUltimoAggiornamento()
                }
                
                
            }
        }
        let end = Date()
        print("Tempo impiegato per caricare le verifiche dalla Cache: \(end.timeIntervalSince(start))")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        materieArray.removeAll()
        materieDataArray.removeAll()
        materieArgomentoArray.removeAll()
        
        
        NotificationCenter.default.addObserver(forName: NOTIF_COLORMODE, object: nil, queue: nil) { (notification) in
            self.settaImageView()
        }
        
        settaImageView()
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "a9484684fa3d0b184eb1926824c424926e90dedb", "013ecc8866dae7a4f9d1ef7a0e14c650"]
        bannerAdView.delegate = self
        bannerAdView.adUnitID = "ca-app-pub-3178427291726733/3190297606"
        bannerAdView.rootViewController = self
        bannerAdView.load(request)
        
        
        statusBar.backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        
        
        if UserDefaults.standard.string(forKey: "latestVerificheUpdate") != nil {
            latestUpdateLabel.text = UserDefaults.standard.string(forKey: "latestVerificheUpdate")
        }
        
        classeAllievo = UserDefaults.standard.string(forKey: "classe")
        
        ricaricaControl.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = ricaricaControl
        } else {
            tableView.addSubview(ricaricaControl)
        }
        

        
        if verificaPlistVerifiche() {
            
            parsaLeMaterie()
            print("Trovata cache quini non cerco su internet")
        }
        else {
            caricaLeVerifiche()
            self.tableView.reloadData()
            print("Cache non trovata")
        }

        
        
        
    }
    
    func settaImageView() {
        imageView.image = UIImage(named: GETcolorMode())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell?.backgroundColor = UIColor.clear
        cell?.backgroundView?.backgroundColor = UIColor.clear
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.text = "\((materieArray[indexPath.row]).uppercased())\nARGOMENTO: \(materieArgomentoArray[indexPath.row])\nDATA: \(materieDataArray[indexPath.row])"
        

        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materieArray.count
    }
    
    
    
    func caricaLeVerifiche() {
        let start = Date()
        
        ref = FIRDatabase.database().reference()
        if let classeAllievo = UserDefaults.standard.string(forKey: "classe") {
            if classeAllievo != "" {
                ricaricaControl.beginRefreshing()
                
                ref?.child("Classi").child(classeAllievo).observeSingleEvent(of: .value, with: { (snapshot) in
                    self.classeAllievo = UserDefaults.standard.string(forKey: "classe")
                    if let materie = snapshot.value as? NSDictionary {
                        
                        
                        //CACHE
                        
                        
                        
                        //self.salvaInCache(obj: materie, key: "verificheCache")
                        self.salvaNelUserDefaults(key: "verificheCache", cosa: materie)
                        print("Cache SALVATA")
                        
                        //FINE CACHE
                        
                        
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
                                self.latestUpdateLabel.text = self.aggiornaDataUltimoAggiornamento()
                            }
                            
                            
                        }
                        
                        self.tableView.reloadData()
                        self.ricaricaControl.endRefreshing()
                        let end = Date()
                        print("Temo impiegato per caricare le verifiche: \(end.timeIntervalSince(start))")
                        
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
                
                // printaCache(key: "verificheCache")
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

    func verificaPlistVerifiche() -> Bool {
        if let value = UserDefaults.standard.dictionary(forKey: "verificheCache") {
            print(value)
            print("Cache TROVATA")
            return true
        }
        else {
            return false
        }
        
    }
    
    func salvaNelUserDefaults(key: String, cosa: NSDictionary) {
        UserDefaults.standard.set(cosa, forKey: key)
    }
    
    func aggiornaDataUltimoAggiornamento() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        
        let oraAttuale: String = "\(String(calendar.component(.hour, from: date))):\(String(calendar.component(.minute, from: date)))"
        UserDefaults.standard.set(("Ultimo aggioramento alle " + oraAttuale), forKey: "latestVerificheUpdate")
        return ("Ultimo aggioramento alle " + oraAttuale)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
