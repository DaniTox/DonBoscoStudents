//
//  NumeriCasualiViewController.swift
//  iUtility
//
//  Created by Dani Tox on 17/03/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit



class NumeriCasualiViewController: UIViewController, UITextFieldDelegate {

    var togliFunzioneArray: Bool = false
    @IBOutlet weak var nMinTextField: UITextField!
    @IBOutlet weak var nMaxTextField: UITextField!
    @IBOutlet weak var risultatoLabel: UILabel!
    @IBOutlet weak var numeriUscitiLabel: UILabel!
    @IBOutlet weak var avvisoLabel: UILabel!
    
    
    
    var arrayNumeriUsciti = [Int]()
    
    let modelNCasuli = NumeriCasualiClass()
    
    var risultatoValue: Int {
        get {
            return Int(risultatoLabel.text!)!
        }
        set {
            risultatoLabel.text = String(newValue)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        nMinTextField.delegate = self
        nMaxTextField.delegate = self
       
        nMinTextField.text = nil
        nMaxTextField.text = nil
        risultatoValue = 0
        numeriUscitiLabel.text = nil
        
        avvisoLabel.text = nil
        
        avvisoLabel.numberOfLines = 0
        avvisoLabel.lineBreakMode = .byWordWrapping
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nMinTextField.endEditing(true)
        nMaxTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    @IBAction func generateNumber() {
        
        if let nMinimo = UInt32(nMinTextField.text!) {
            if let nMassimo = UInt32(nMaxTextField.text!) {
                
                if Int(nMassimo) - Int(nMinimo) >= 50 {
                    print("È un intervallo abbastanza grande")
                    avvisoLabel.text = "Per motivi di risorse, quando i numeri da generare sono maggiori di 5, la funzione dei numeri usciti viene disabilitata."
                    togliFunzioneArray = true
                }
                else {
                    togliFunzioneArray = false
                    avvisoLabel.text = nil
                }
                
                let result = modelNCasuli.generaNumero(nMin: nMinimo, nMax: nMassimo)
                if result != -1 {
                    risultatoValue = result
                    if togliFunzioneArray == false {
                        aggiungiInArray(numero: result)
                        numeriUscitiLabel.text = String(describing: arrayNumeriUsciti)
                    }
                    else {
                        print("Array disabilitato")
                    }
                }
                else {
                    let alert = UIAlertController(title: "Errore", message: "Il numero minimo è maggiore o uguale al numero massimo. Correggi e riprova", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
    @IBAction func pulisciButton() {
        arrayNumeriUsciti.removeAll()
        numeriUscitiLabel.text = String(describing: arrayNumeriUsciti)
        nMinTextField.text = nil
        nMaxTextField.text = nil
        risultatoValue = 0
        avvisoLabel.text = nil
    }
    
    
    
    func aggiungiInArray (numero : Int) {
        
        if !arrayNumeriUsciti.contains(numero) {
            arrayNumeriUsciti.append(numero)
        }
    }
    
   
}
