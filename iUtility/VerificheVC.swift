//
//  VerificheVC.swift
//  iUtility
//
//  Created by Dani Tox on 28/08/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import SwiftyJSON

var verifiche = [Verifica]()


class VerificheVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Outlets and Variables
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    //MARK: - Entry Point
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = #imageLiteral(resourceName: "dark")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        catchVerifiche()
    }

    //MARK: Functions
    
    func catchVerifiche() {
        
        if let classe = UserDefaults.standard.string(forKey: "classe") {
            let url = "http://localhost:8888/AppScuola/catchVerificheNoToken.php?classe=\(classe)"
            let url2 = URL(string: url)
            
            if let data = try? Data(contentsOf: url2!) as Data {
                let json = JSON(data: data, options: .mutableContainers, error: nil)
                
                if let array = json.arrayObject as? [[String : String]] {
                    
                    verifiche.removeAll()
                    
                    for item in array {
                        
                        let id = item["idVerifica"]
                        let titolo = item["Titolo"]
                        let materia = item["Materia"]
                        let data = item["Data"]
                        let formatore = item["Formatore"]
                        let svolgimento = item["Svolgimento"]
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        let date = dateFormatter.date(from: data!)
                        
                        
                        let verifica = Verifica(idVerifica: id!, Titolo: titolo!, Materia: materia!, Data: date!, Formatore: formatore!, Svolgimento: svolgimento!)
                        verifiche.append(verifica)
                                                
                        
                        
                    }
                }
                else {
                    verifiche.removeAll()
                    
                    mostraAlert(titolo: "Che culo!", messaggio: "Non ci sono verifiche per questa classe", tipo: .alert)
                    
                    tableView.reloadData()
                }
            }
        }
        else {
            
        }
 
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
        
        if verifiche.count != 0 {
            
            verifiche.sort(by: { ($0.Data).compare($1.Data) == .orderedAscending })
            cell.titoloMateriaLabel.text = verifiche[indexPath.row].Materia
            cell.argomentoLabel.text = "ARGOMENTO: \(verifiche[indexPath.row].Titolo)"
            
            let data = verifiche[indexPath.row].Data
            let calendar = Calendar.current
            let dd = calendar.component(.day, from: data)
            let mm = calendar.component(.month, from: data)
            let yyyy = calendar.component(.year, from: data)
            cell.dataVerificaLabel.text = "DATA: \(dd)/\(mm)/\(yyyy)"
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verifiche.count
    }
    
    
}


struct Verifica {
    var idVerifica : String
    var Titolo : String
    var Materia : String
    var Data : Date
    var Formatore : String
    var Svolgimento : String
}







