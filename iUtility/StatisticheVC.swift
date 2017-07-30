//
//  StatisticheVC.swift
//  iUtility
//
//  Created by Dani Tox on 07/05/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import FirebaseDatabase

var materiaStats: String?

class StatisticheVC: UIViewController {

    var ref: FIRDatabaseReference!
    var handle:FIRDatabaseHandle!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addMarkTxtField: UITextField!
    @IBOutlet weak var allMarks: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    
    
    var voti = ["Italiano" : [Int](),
                "Inglese" : [Int](),
                "Matematica" : [Int](),
                "Laboratorio" : [Int](),
                "Tec Elettrica" : [Int](),
                "Disegno" : [Int](),
                "Informatica" : [Int](),
                "Scienze" : [Int](),
                "Narrativa" : [Int](),
                "Religione" : [Int](),
                "Pneumatica" : [Int](),
                "PLC" : [Int](),
                "Ed Fisica" : [Int](),
                "Elettrotecnica" : [Int](),
                ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: NOTIF_UPDATE_VOTI, object: nil)
        
        imageView.image = UIImage(named: GETcolorMode())
        
        if let votiS = UserDefaults.standard.dictionary(forKey: "voti") {
            voti = votiS as! [String : [Int]]
        } else {
            if let username = UserDefaults.standard.string(forKey: "usernameAccount") {
                ref = FIRDatabase.database().reference()
                ref.child("Utenti").child(username).child("Voti").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let votiS = snapshot.value as? NSDictionary {
                        self.usrDef(value: votiS, chiave: "voti")
                        self.voti = votiS as! [String : [Int]]
                        self.updateView()
                    }
                })
            }
        }
        
        updateView()
        
        
    }
    
    func updateView() {
       
        if voti[materiaStats!] != nil {
            mediaLabel.text = String(format: "%.2f", calcMedia(voti: voti[materiaStats!]!))
            allMarks.text = String(describing: voti[materiaStats!]!).replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        }
        else {
            voti[materiaStats!] = [Int]()
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func usrDef(value: Any, chiave: String) {
        UserDefaults.standard.set(value, forKey: chiave)
    }
    
    
    @IBAction func addMarkButton() {
        
        let date = Date()
        let now = Calendar.current
        let month = now.component(.month, from: date)
        let year = now.component(.year, from: date)
        _ = "\(month)/\(year)"
        
        if let voto = Int(addMarkTxtField.text!) {
            
            if voto <= 100 {
            
            voti[materiaStats!]!.append(voto)
            updateView()
            usrDef(value: voti, chiave: "voti")
            
            addMarkTxtField.text = nil
            
            }
            else {
                mostraAlert(titolo: "Errore", messaggio: "I voti non possono superare il 100", tipo: .alert)
            }
            
        } else {
            mostraAlert(titolo: "Errore", messaggio: "Hai scritto il voto in modo sbagliato", tipo: .alert)
        }
        
        
    }
    
    @IBAction func bacButton() {
        self.dismiss(animated: true, completion: nil)
        
        DispatchQueue.global(qos: .background).async {
            if let username = UserDefaults.standard.string(forKey: "usernameAccount") {
                self.ref = FIRDatabase.database().reference()
                self.ref.child("Utenti").child(username).child("Voti").setValue(self.voti)
                
            }
        }
    }
    
    func calcMedia(voti: [Int]) -> Double {
        var total = 0.0
        
        for i in voti {
            total += Double(i)
        }
        
        let media = total / Double(voti.count)
        return media
    }

    
    @IBAction func deleteLast() {
        voti[materiaStats!]?.removeLast()
        usrDef(value: voti, chiave: "voti")
        NotificationCenter.default.post(name: NOTIF_UPDATE_VOTI, object: nil)
    }
    
    
    @IBAction func deleteAll() {
        voti[materiaStats!]?.removeAll()
        usrDef(value: voti, chiave: "voti")
        NotificationCenter.default.post(name: NOTIF_UPDATE_VOTI, object: nil)
    }
    
    
    
    
    
    
    
    
    
    
}
