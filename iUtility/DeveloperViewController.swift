//
//  test.swift
//  iUtility
//
//  Created by Dani Tox on 09/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMobileAds

var avvisiArray = [String]()

class Sviluppatori: UIViewController, UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate {

    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    let developerModel = DeveloperModel()
    
    let ricaricaControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBar.backgroundColor = UIColor.clear
        
        ricaricaControl.addTarget(self, action: #selector(self.aggiornaTuttoCompresoLaView), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = ricaricaControl
        }
        else {
            tableView.addSubview(ricaricaControl)
        }
        
        NotificationCenter.default.addObserver(forName: NOTIF_COLORMODE, object: nil, queue: nil) { (notification) in
            self.changeBackground()
        }
        
        changeBackground()
        
        //TODO: Disattivato momentaneamente
        
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID, "a9484684fa3d0b184eb1926824c424926e90dedb", "013ecc8866dae7a4f9d1ef7a0e14c650"]
//        bannerView.delegate = self
//        bannerView.adUnitID = "ca-app-pub-3178427291726733/6133430803"
//        bannerView.rootViewController = self
//        bannerView.load(request)
        
    }
    
    func changeBackground() {
        if GETcolorMode() == "customImage" {
            let imageURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/customImage.jpg")
            print("URL dell'immagine: \(imageURL)")
            if let image = UIImage(contentsOfFile: imageURL) {
                imageView.image = image
            }
            
        }
        else {
            imageView.image = UIImage(named: GETcolorMode())
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avvisiArray.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .background).async {
            self.controllaConnessioneECaricaAvvisi()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
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
        DispatchQueue.global(qos: .background).async {
            self.controllaConnessioneECaricaAvvisi()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.ricaricaControl.endRefreshing()
            }
            
        }
        
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
