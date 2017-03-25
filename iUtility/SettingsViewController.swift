//
//  SettingsViewController.swift
//  iUtility
//
//  Created by Dani Tox on 24/01/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import UserNotifications
import MessageUI
import SwiftyJSON



class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var classeTextField: UITextField!
    @IBOutlet weak var switchDarkModeOn: UISwitch!
    @IBOutlet weak var labeldarkMode: UILabel!
    
    @IBOutlet weak var switchLabel: UISwitch!
    
    
    
    @IBAction func notificheAttivateSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge] , completionHandler: {didAllow, error in })
                
            } else {
                // Fallback on earlier versions
                let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(setting)
                
            }
            
        }
    }
    
    
    @IBAction func salvaClasseButton() {
        if classeTextField.text != nil && classeTextField.text != "" {
            UserDefaults.standard.set(classeTextField.text, forKey: "classe")
        }
        if let classe = UserDefaults.standard.string(forKey: "classe") {
            if classe == classeTextField.text {
                let alert1 = UIAlertController(title: "Fatto", message: "Classe Salvata", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert1, animated: true, completion: nil)

              classeTextField.endEditing(false)
            }
        }
    }
    
    @IBAction func verificaAggiornamenti() {
        let url = URL(string: "http://ipswdownloaderpy.altervista.org/filesAppDonBosco/DBStudentiVersion.json")
        let jsonData = try? Data(contentsOf: url!) as Data
        let readableJson = JSON(data: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers , error: nil)
        
        let latestVersion = String(describing: readableJson["latestVersion"])
        let versionInstalled = String(describing: UIDevice.current.appVersion)
        
        print("Versione attuale: \(versionInstalled)\nVersione più aggiornata: \(latestVersion)")
        
        if versionInstalled == latestVersion {
            let alert = UIAlertController(title: "Nessun Aggiornamento", message: "Hai già la versione più aggiornata", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            print("Nessun Aggiornamento Disponibile")
        } else {
            let alert = UIAlertController(title: "Aggiornamento Disponibile", message: "Nuova versione disponibile: \(latestVersion)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Non ora", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Scarica", style: UIAlertActionStyle.default, handler: { (aggiorna) in
                //AGGIORNARE L'URL QUANDO L'APP DOVRà USCIRE SULL'APP STORE
                let urlAggiornamento = URL(string: "http://ipswdownloaderpy.altervista.org/filesAppDonBosco/notaperibetatester.html")
                UIApplication.shared.openURL(urlAggiornamento!)
            }))
            present(alert, animated: true, completion: nil)
            print("Aggiornamento Disponibile")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.classeTextField.endEditing(true)
    }
    
   private func changeColorMode(mode:String) {
        if mode == "dark" {
            //view.backgroundColor = UIColor(colorLiteralRed: 58, green: 58, blue: 58, alpha: 0.3)
            view.backgroundColor = UIColor.darkGray
            //self.labeldarkMode.textColor = UIColor.white
        }
        else {
            view.backgroundColor = UIColor.white
            //self.labeldarkMode.textColor = UIColor.black
            
        }
    }
    
    
    @IBAction func darkModeSwitch(_ sender: UISwitch) {
        
        if sender.isOn == true {
            UserDefaults.standard.set(true, forKey: "darkmodeswitchon")
            UserDefaults.standard.set("dark", forKey: "colormode")
            changeColorMode(mode: "dark")
        }
        else {
            UserDefaults.standard.set(false, forKey: "darkmodeswitchon")
            UserDefaults.standard.set("white", forKey: "colormode")
            changeColorMode(mode: "white")
        }
    }
    
    @IBAction func sendBugMessage() {
        let appVersion = UIDevice.current.appType + " " + UIDevice.current.appVersion
        let deviceModel = UIDevice.current.modelName
        let deviceModelIdentifier = UIDevice.current.model
        let deviceOSVersion = UIDevice.current.thisDeviceOS
        let orientationValue : String = UIDevice.current.deviceOrientation
        let numeroBuild :String = Bundle.main.buildVersionNumber!
        let appTypeOfRun:String = UIDevice.current.appTypeOfRun
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let alert = UIAlertController(title: "Errore", message: "Probabilmente non hai impostato nessun indirizzo e-mail nell'app Mail.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
        else {

            
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["d.bazzani.cfp@gmail.com"])
            mailVC.setSubject("BUG DBStudenti " + appVersion)
            mailVC.setMessageBody("INFORMAZIONI DEL TUO DISPOSITIVO PER CAPIRE COME RIPRODURRE IL BUG. NON MODIFICARLE\n---------------\nDEVICE/APP INFO:\nVersione Applicazione: \(appVersion)\nNumero Build: \(numeroBuild)\nType: \(appTypeOfRun)\nDispositivo: \(deviceModel)\nDevice Type: \(deviceModelIdentifier)\nOS: \(deviceOSVersion)\nOrientation: \(orientationValue)\n------------\n\n\nSCRIVI QUA SOTTO INFORMAZIONI UTILI SUL BUG E SU COME POSSO TROVARLO:\n\n", isHTML: false)
            
            present(mailVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.classeTextField.delegate = self
        
        classeTextField.text = UserDefaults.standard.string(forKey: "classe")
        
        if UserDefaults.standard.bool(forKey: "darkmodeswitchon") == true {
            switchDarkModeOn.isOn = true
        }
        else {
            switchDarkModeOn.isOn = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        classeTextField.text = UserDefaults.standard.string(forKey: "classe")

        if UserDefaults.standard.string(forKey: "colormode") == "dark" {
            changeColorMode(mode: "dark")
        }
        else {
            changeColorMode(mode: "white")
        }
    }

    }
