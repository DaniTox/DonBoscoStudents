//
//  VerificheVC.swift
//  iUtility
//
//  Created by Dani Tox on 28/08/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import SwiftyJSON




class VerificheVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Outlets and Variables
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var segentedControlOutlet: UISegmentedControl!
    
    
    var refreshControl : UIRefreshControl!
    
    //MARK: - Entry Point
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(catchVerifiche), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
        
        imageView.image = #imageLiteral(resourceName: "dark")
    
    
        catchVerifiche()
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        catchVerifiche()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    //MARK: Functions
    
    func catchVerifiche() {
        
        let DBVerificheHelper = DBVerificheCatcher()
        let result = DBVerificheHelper.catchVerifiche()
        
        switch result {
        case 1:
            print("Non sono state trovate verifiche o c'è stato un errore")
        case -1:
            mostraAlert(titolo: "Errore", messaggio: "C'è stato un errore nel prelevare le verifiche. errore classe", tipo: .alert)
        default:
            print("Verifiche prese con successo")
        }
        
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    @IBAction func showDifferentVerificheSection(_ sender: UISegmentedControl) {
        
       tableView.reloadData()
        
    }
    
    
    

}

//MARK: - Extensions

extension VerificheVC {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Hi, you just selected the row at index \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! VerificaCell
        
        switch segentedControlOutlet.selectedSegmentIndex {
        case 0:
            
            if verificheInCorso.count != 0 {
                
                verificheInCorso.sort(by: { ($0.Data).compare($1.Data) == .orderedAscending })
                cell.titoloMateriaLabel.text = verificheInCorso[indexPath.row].Materia
                cell.argomentoLabel.text = "ARGOMENTO: \(verificheInCorso[indexPath.row].Titolo)"
                
                let data = verificheInCorso[indexPath.row].Data
                let calendar = Calendar.current
                let dd = calendar.component(.day, from: data)
                let mm = calendar.component(.month, from: data)
                let yyyy = calendar.component(.year, from: data)
                cell.dataVerificaLabel.text = "DATA: \(dd)/\(mm)/\(yyyy)"
            }

        case 1:
            
            if verificheinAttesadiValutazione.count != 0 {
                
                verificheinAttesadiValutazione.sort(by: { ($0.Data).compare($1.Data) == .orderedAscending })
                cell.titoloMateriaLabel.text = verificheinAttesadiValutazione[indexPath.row].Materia
                cell.argomentoLabel.text = "ARGOMENTO: \(verificheinAttesadiValutazione[indexPath.row].Titolo)"
                
                let data = verificheinAttesadiValutazione[indexPath.row].Data
                let calendar = Calendar.current
                let dd = calendar.component(.day, from: data)
                let mm = calendar.component(.month, from: data)
                let yyyy = calendar.component(.year, from: data)
                cell.dataVerificaLabel.text = "DATA: \(dd)/\(mm)/\(yyyy)"
            }
            
        case 2:
            
            if verificheCompletate.count != 0 {
                
                verificheCompletate.sort(by: { ($0.Data).compare($1.Data) == .orderedAscending })
                cell.titoloMateriaLabel.text = verificheCompletate[indexPath.row].Materia
                cell.argomentoLabel.text = "ARGOMENTO: \(verificheCompletate[indexPath.row].Titolo)"
                
                let data = verificheCompletate[indexPath.row].Data
                let calendar = Calendar.current
                let dd = calendar.component(.day, from: data)
                let mm = calendar.component(.month, from: data)
                let yyyy = calendar.component(.year, from: data)
                cell.dataVerificaLabel.text = "DATA: \(dd)/\(mm)/\(yyyy)"
            }
            
        default:
            if verificheInCorso.count != 0 {
                
                verificheInCorso.sort(by: { ($0.Data).compare($1.Data) == .orderedAscending })
                cell.titoloMateriaLabel.text = verificheInCorso[indexPath.row].Materia
                cell.argomentoLabel.text = "ARGOMENTO: \(verificheInCorso[indexPath.row].Titolo)"
                
                let data = verificheInCorso[indexPath.row].Data
                let calendar = Calendar.current
                let dd = calendar.component(.day, from: data)
                let mm = calendar.component(.month, from: data)
                let yyyy = calendar.component(.year, from: data)
                cell.dataVerificaLabel.text = "DATA: \(dd)/\(mm)/\(yyyy)"
            }
        }
        
        
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segentedControlOutlet.selectedSegmentIndex {
        case 0:
            return verificheInCorso.count
        case 1:
            return verificheinAttesadiValutazione.count
        case 2:
            return verificheCompletate.count
        default:
            return 0
        }
        
    }
    
    //Mark: - Others enum, classes, etc.
    
    enum verificheDaVedere {
        case inProgramma
        case inAttesaDiVoto
        case completate
    }
    
    
}









