//
//  RandomNumberViewController.swift
//  iUtility
//
//  Created by Dani Tox on 24/01/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit


class RandomNumberViewController: UIViewController, UITextFieldDelegate {

    //###########  LABEL INUTILI  ##########
    
    @IBOutlet weak var titoloLabel: UILabel!
    @IBOutlet weak var labelnumeritotlabel: UILabel!
    @IBOutlet weak var label3inutileLabel: UILabel!
    @IBOutlet weak var label4inutilelabel: UILabel!
    @IBOutlet weak var numeriDivLabel: UILabel!
    
  
    
    
    //###########  OBJECTS UTILI    ##########
    
    @IBOutlet weak var risultatoLabel: UILabel!
    @IBOutlet weak var numeroDiPartenzaField: UITextField!
    @IBOutlet weak var numeroFineField: UITextField!
    @IBOutlet weak var countNumeriGeneratiLabel: UILabel!
    @IBOutlet weak var numeriApparsiLabel: UILabel!
    @IBOutlet weak var arrayCount: UILabel!
    @IBOutlet weak var numeriDiversiSwitchLabel: UISwitch!
    @IBOutlet weak var parseArrayLabel: UISwitch!
    

    
    //###########  VARIABILI E COSTANTI   #########
    
    var count:UInt32 = 0
    var numeriDiversi: Bool?
    var numeriApparsiArray = [Int]()
    var sort: Bool?
    var pulisciInterfacciaError:Bool?
    
    
    
    private func changeColorMode(mode:String) {
        if mode == "dark" {
            //self.view.backgroundColor = UIColor(colorLiteralRed: 58, green: 58, blue: 58, alpha: 0.3)
            self.view.backgroundColor = UIColor.darkGray
            titoloLabel.textColor = UIColor.white
            labelnumeritotlabel.textColor = UIColor.white
            label3inutileLabel.textColor = UIColor.white
            label4inutilelabel.textColor = UIColor.white
            numeroDiPartenzaField.textColor = UIColor.white
            numeroFineField.textColor = UIColor.white
            arrayCount.textColor = UIColor.white
            numeriApparsiLabel.textColor = UIColor.white
            countNumeriGeneratiLabel.textColor = UIColor.white
            numeriDivLabel.textColor = UIColor.white
        }
        else {
            self.view.backgroundColor = UIColor.white
            titoloLabel.textColor = UIColor.black
            labelnumeritotlabel.textColor = UIColor.black
            label3inutileLabel.textColor = UIColor.black
            label4inutilelabel.textColor = UIColor.black
            numeroDiPartenzaField.textColor = UIColor.black
            numeroFineField.textColor = UIColor.black
            arrayCount.textColor = UIColor.black
            numeriApparsiLabel.textColor = UIColor.black
            countNumeriGeneratiLabel.textColor = UIColor.black
            numeriDivLabel.textColor = UIColor.white
        }
    }
    
    

    
    @IBAction func generateNumberButton() {
        if pulisciInterfacciaError == true {
            //pulisciInterfaccia()
            pulisciInterfacciaError = false
            //numeriApparsiArray.removeAll()
        }
        var numeroPartenza = UInt32(numeroDiPartenzaField.text!)
        let numeroFine = UInt32(numeroFineField.text!)! + 1
        
        if numeroPartenza == nil {
            numeroDiPartenzaField.text = "1"
            numeroPartenza = 1
        }
        
        let risultato = arc4random_uniform((numeroFine - numeroPartenza!)) + numeroPartenza!
        
    
        risultatoLabel.text = "\(risultato)"
        
        count += 1
        countNumeriGeneratiLabel.text = String(count)
        
        if numeriDiversi == true {
            if numeriApparsiArray.contains(Int(risultato)) == true {
                self.generateNumberButton()
            }
        }
        
        if numeriApparsiArray.contains(Int(risultato)) == false {
            numeriApparsiArray.append(Int(risultato))
            if sort == true {
                numeriApparsiArray.sort()
            }
            numeriApparsiLabel.text = String(describing: numeriApparsiArray)
            arrayCount.text = String(numeriApparsiArray.count)
            print("Differenza tra NumeroMax e NumeroMin: \(numeroFine - numeroPartenza!)    numeroCount:\(numeriApparsiArray.count)")
        }
        
        if (numeriApparsiArray.count >= Int(numeroFine - numeroPartenza!)) && (numeriDiversi == true) {
            let alert = UIAlertController(title: "Numeri non disponibili", message: "Sono finiti i numeri disponibili", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            pulisciInterfacciaError = true
            
        }
    }
    
    
    
    
    @IBAction func pulisciInterfaccia() {
        risultatoLabel.text = "0"
        numeroDiPartenzaField.text = "1"
        numeroFineField.text = "1"
        count = 0
        countNumeriGeneratiLabel.text = String(count)
        numeriApparsiArray.removeAll()
        numeriApparsiLabel.text = String(describing: numeriApparsiArray)
        arrayCount.text = String(numeriApparsiArray.count)
        
    }
    

    
    
    @IBAction func setNumeriDiversiSwitch() {
        if numeriDiversiSwitchLabel.isOn == true {
            numeriDiversi = true
            //countNumeriGeneratiLabel.text = "EXC_BAD_ACCESS"
        }
        else {
            numeriDiversi = false
            countNumeriGeneratiLabel.text = "0"
        }
    }
    
    @IBAction func parseArrayAction(_ sender: UISwitch) {
        if sender.isOn == true {
            sort = true
        }
        else {
            sort = false
        }
    }
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numeroDiPartenzaField.delegate = self
        numeroFineField.delegate = self
        
        
        numeriDiversiSwitchLabel.isOn = false
        parseArrayLabel.isOn = false
        
        numeriApparsiLabel.text = String(describing: numeriApparsiArray)
        arrayCount.text = String(numeriApparsiArray.count)

        numeroFineField.text = "0"
        numeroDiPartenzaField.text = "1"
        
        risultatoLabel.text = "0"
        
        numeroDiPartenzaField.keyboardType = .numberPad
        numeroFineField.keyboardType = .numberPad
        
        
        if numeriDiversiSwitchLabel.isOn == true {
            numeriDiversi = true
            //countNumeriGeneratiLabel.text = "EXC_BAD_ACCESS"
        }
        else {
            numeriDiversi = false
            countNumeriGeneratiLabel.text = "0"
        }
        
        if parseArrayLabel.isOn == true {
            sort = true
        }
        else {
            sort = false
        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "colormode") == "dark"{
            changeColorMode(mode: "dark")
        }
        else {
            changeColorMode(mode: "white")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
