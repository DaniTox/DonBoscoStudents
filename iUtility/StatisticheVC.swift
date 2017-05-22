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
                "Tec. Elettrica" : [Int](),
                "Disegno" : [Int](),
                "Informatica" : [Int](),
                "Scienze" : [Int](),
                "Narrativa" : [Int](),
                "Religione" : [Int](),
                "Pneumatica" : [Int](),
                "PLC" : [Int](),
                "Ed. Fisica" : [Int](),
                "Elettrotecnica" : [Int](),
                ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: NOTIF_UPDATE_VOTI, object: nil)
        
        imageView.image = UIImage(named: GETcolorMode())
        
        if UserDefaults.standard.dictionary(forKey: "voti") == nil {
            
        }
        
    }
    
    func updateView() {
       
        mediaLabel.text = String(format: "%.2f", calcMedia(voti: voti[materiaStats!]!))
        allMarks.text = String(describing: voti[materiaStats!]!).replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        
        usrDef(value: voti, chiave: "voti")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
        if let votiSaved = UserDefaults.standard.dictionary(forKey: "voti") {
            voti = votiSaved as! [String : [Int]]
        }
       
        
        updateView()
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
            
            voti[materiaStats!]!.append(voto)
            NotificationCenter.default.post(name: NOTIF_UPDATE_VOTI, object: nil)
            
            addMarkTxtField.text = nil
            
            
            
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
        NotificationCenter.default.post(name: NOTIF_UPDATE_VOTI, object: nil)
    }
    
    
    @IBAction func deleteAll() {
        voti[materiaStats!]?.removeAll()
        NotificationCenter.default.post(name: NOTIF_UPDATE_VOTI, object: nil)
    }
    
    
    
}
