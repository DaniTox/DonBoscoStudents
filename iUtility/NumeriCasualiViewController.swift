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
    @IBOutlet weak var imageView: UIImageView!
    
    
    
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
        imageView.image = UIImage(named: "dark")
        statusBar.backgroundColor = UIColor.clear
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
                    avvisoLabel.text = "Per motivi di risorse, quando i numeri da generare sono maggiori di 50, la funzione dei numeri usciti viene disabilitata."
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
    
    
//    func changeColorMode(mode: String) {
//        switch mode {
//        case "dark":
//            self.view.backgroundColor = darkColor
//            
//        case "white":
//            self.view.backgroundColor = UIColor.white
//            
//        default:
//            print("Error in color mode")
//        }
//        
//    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if UserDefaults.standard.string(forKey: "colormode") != nil {
//            switch UserDefaults.standard.string(forKey: "colormode")! {
//            case "dark":
//                changeColorMode(mode: "dark")
//            case "white":
//                changeColorMode(mode: "white")
//            default:
//                print("Nessuna color mode rilevata")
//            }
//            
//        }
        if UserDefaults.standard.string(forKey: "ColorMode") != nil {
            switch UserDefaults.standard.string(forKey: "ColorMode")! {
            case "dark":
                imageView.image = UIImage(named: "dark")
            case "blue":
                imageView.image = UIImage(named: "blue")
            case "red":
                imageView.image = UIImage(named: "red")
            case "zoom":
                imageView.image = UIImage(named: "zoomB")
            default:
                imageView.image = UIImage(named: "dark")
                print("Error in colormode")
            }
        }
        else {
            print("Error in CM")
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
