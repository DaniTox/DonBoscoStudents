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
import AVFoundation

//DA FARE: EVITARE DI CREARE SEMPRE UN ALERT NUOVO SE IL MESSAGGIO DA DARE ALL'UTENTE è LO STESSO. FARLO INVECE TRAMITE UNA FUNZIONE UNICA

var zoomIsMorto: Bool = false

extension Sequence {
    var minimalDescription: String {
        return map { "\($0)" }.joined(separator: " ")
    }
}

var linksModificati:Bool?

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var classeTextField: UITextField!
    @IBOutlet weak var labeldarkMode: UILabel!
    @IBOutlet weak var switchLabel: UISwitch!
    
    @IBOutlet weak var altroButton: CircleButton!
    @IBOutlet weak var blueButton: CircleButton!
    @IBOutlet weak var redButton: CircleButton!
    @IBOutlet weak var darkButton: CircleButton!
    @IBOutlet weak var zoomButton: CircleButton!
    
    
    @IBAction func notificheAttivateSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge] , completionHandler: {didAllow, error in })
                
            } else {
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

              classeTextField.endEditing(true)
                classeTextField.resignFirstResponder()
            }
        }
    }
    
    @IBAction func verificaAggiornamenti() {
      
        var linkUltimaVersione: String?
        
        if UserDefaults.standard.bool(forKey: "linkCorretti") != true {
            linkUltimaVersione = "http://ipswdownloaderpy.altervista.org/filesAppDonBosco/DBStudentiVersion.json"
        }
        else {
            linkUltimaVersione = UserDefaults.standard.string(forKey: "LinkControllaAggiornamenti")
        }
        
        if let url = URL(string: linkUltimaVersione!) {
            if Reachability.isConnectedToNetwork() {
                let jsonData = try? Data(contentsOf: url) as Data
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
                        
                        if UserDefaults.standard.bool(forKey: "linkCorretti") != true {
                            let urlString = "http://ipswdownloaderpy.altervista.org/filesAppDonBosco/notaperibetatester.html"
                            let urlAggiornamento = URL(string: urlString)
                            UIApplication.shared.openURL(urlAggiornamento!)
                        }
                        else  {
                            if let urlString = UserDefaults.standard.string(forKey: "LinkMsgTester") {
                                let urlAggiornamento = URL(string: urlString)
                                UIApplication.shared.openURL(urlAggiornamento!)
                            }
                            else {
                                print("Qualcosa non va negli UserDefaults riguardo il link per il messaggio agli sviluppatori")
                            }
                        }
                    }))
                    present(alert, animated: true, completion: nil)
                    print("Aggiornamento Disponibile")
                }
            }
            else {
                let alert = UIAlertController(title: "Nessuna Connessione", message: "Assicurati di essere connesso a Internet e riprova", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                print("No connection")
            }
        }
        else {
            print("URL Errato")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        salvaClasseButton()
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.classeTextField.endEditing(true)
    }

    
    @IBAction func sendBugMessage() {
        let appVersion = UIDevice.current.appType + " " + UIDevice.current.appVersion
        let deviceModel = UIDevice.current.modelName
        let deviceModelIdentifier = UIDevice.current.model
        let deviceOSVersion = UIDevice.current.thisDeviceOS
        let orientationValue : String = UIDevice.current.deviceOrientation
        let numeroBuild :String = Bundle.main.buildVersionNumber!
        let appTypeOfRun:String = UIDevice.current.appTypeOfRun
        let linkSonoCorretti = UserDefaults.standard.bool(forKey: "linkCorretti")
        let allLinks = [UserDefaults.standard.string(forKey: "LinkAvvisi"), UserDefaults.standard.string(forKey: "LinkControllaAggiornamenti"), UserDefaults.standard.string(forKey: "LinkMsgTester"),UserDefaults.standard.string(forKey: "LinkOrario"), UserDefaults.standard.string(forKey: "LinkChangeLog"), UserDefaults.standard.string(forKey: "LinkBugs")]
        let bundleIdentifier = Bundle.main.bundleIdentifier
        
        
        
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
            mailVC.setMessageBody("SCRIVI QUA SOTTO INFORMAZIONI UTILI SUL BUG E SU COME POSSO TROVARLO:\n\n\n\nINFORMAZIONI DEL TUO DISPOSITIVO PER CAPIRE COME RIPRODURRE IL BUG. NON MODIFICARLE\n---------------\nDEVICE/APP INFO:\nVersione Applicazione: \(appVersion)\nNumero Build: \(numeroBuild)\nType: \(appTypeOfRun)\nDispositivo: \(deviceModel)\nDevice Type: \(deviceModelIdentifier)\nOS: \(deviceOSVersion)\nOrientation: \(orientationValue)\nLink aggiornati dalle impostazioni: \(linkSonoCorretti)\nLinks aggiornati: \(allLinks)\nBundle ID: \(bundleIdentifier)\n------------\n", isHTML: false)
            
            present(mailVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func correggiLinks() {
        
        let alert = UIAlertController(title: "Correzione dei link", message: "Se le tab che devono connettersi a internet per funzionare (es. Sviluppatore, Controllo Aggiornamento, Scarica aggiornamento e Orario) non funzionano (e magari fanno anche crashare), premi Correggi e dovrebbe tornare normale.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Correggi", style: UIAlertActionStyle.default, handler: { (correggiPremuto) in
            if Reachability.isConnectedToNetwork() {
                let correttore = CorrettoreLink()
                correttore.correggiLink()
            }
            else {
                let alert = UIAlertController(title: "Nessuna Connessione", message: "Assicurati di essere connesso a Internet e riprova", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Sconfiggi Zoom", style: .default, handler: { (displayWin) in
            let alert = UIAlertController(title: "Zoom", message: "Corri Barry, Corri!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Io sono Flash!", style: .default, handler: { (win) in
                self.audioPlayer2.play()
                let alert = UIAlertController(title: "Barry", message: "Hai sconfitto Zoom!\nOra ascolta tutta la musica della corsa finale!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Let's do Flashpoint now", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                zoomIsMorto = true
            }))
            self.present(alert, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func openGithub() {
        if let url = URL(string: "https://github.com/DaniTox/DonBoscoStudents/tree/master/iUtility") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func showChangeLog() {
        let changelog = GetChangeLog()
        changelogArray.removeAll()
        changelog.getCangelog()
        
        if changelogArray.last == "\n" {
            changelogArray.removeLast()
        }
        if changelogArray.first != "ERRORE" {
            let alert = UIAlertController(title: "Changelog", message: String(describing: changelogArray.minimalDescription), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else {
            print("Errore di connessione")
            let alert = UIAlertController(title: "Errore di connessione", message: "Assicurati di essere connesso a Internet e riprova", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            changelogArray.removeAll()
        }
    }
    
    
    @IBAction func consigliamiFunzione() {
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
            mailVC.setSubject("FUNZIONE DBStudenti")
            mailVC.setMessageBody("Scrivi qua sotto i dettagli su come posso migliorare l'app.\nATTENZIONE: non deve essere un bug da risolvere. Per quello c'è già la funzione \"Segnala bug\"\n", isHTML: false)
            
            present(mailVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func mostraBugRisolti() {
        var url:URL?
        
        if UserDefaults.standard.bool(forKey: "linkCorretti") != true {
            url = URL(string: "http://ipswdownloaderpy.altervista.org/filesAppDonBosco/PatchBugs/BugRisolti.html")
        }
        else {
            let urlString = UserDefaults.standard.string(forKey: "LinkBugs")
            url = URL(string: urlString!)
            
            
        }
        
        UIApplication.shared.openURL(url!)
    }
    
    var blueCenter: CGPoint!
    var redCenter: CGPoint!
    var darkCenter: CGPoint!
    var zoomCenter: CGPoint!
    
    var audioPlayer2 = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "zoom4", ofType: "aifc")!))
            audioPlayer.prepareToPlay()
            
            audioPlayer2 = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "ZoomTheme", ofType: "mp3")!))
            audioPlayer2.prepareToPlay()
        }
        catch {
            print(error)
        }
        
        self.classeTextField.delegate = self
        
        classeTextField.text = UserDefaults.standard.string(forKey: "classe")
        
        blueCenter = blueButton.center
        redCenter = redButton.center
        darkCenter = darkButton.center
        zoomCenter = zoomButton.center
        
        
       riportaButtonAStatoInziale()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        classeTextField.text = UserDefaults.standard.string(forKey: "classe")

    }

    
    func buttonAnim() {
        UIView.animate(withDuration: 0.3) {
            self.blueButton.alpha = 1
            self.blueButton.center = self.blueCenter
            
            self.redButton.alpha = 1
            self.redButton.center = self.redCenter
            
            self.darkButton.alpha = 1
            self.darkButton.center = self.darkCenter
            
            self.zoomButton.alpha = 1
            self.zoomButton.center = self.zoomCenter
        }
    }
    
    
    @IBAction func altroPressed(_ sender: UIButton) {
        buttonAnim()
    }
    
    func riportaButtonAStatoInziale() {
        blueButton.center = altroButton.center
        redButton.center = altroButton.center
        darkButton.center = altroButton.center
        zoomButton.center = altroButton.center
        
        blueButton.alpha = 0
        redButton.alpha = 0
        darkButton.alpha = 0
        zoomButton.alpha = 0
    }
    
    @IBAction func setBlueMode(_ sender: UIButton) {
        changeColorModeInUserDefaults(mode: "blue")
        animContraria()
    }
    
    @IBAction func setRedMode(_ sender: UIButton) {
        changeColorModeInUserDefaults(mode: "red")
        animContraria()
    }
    
    @IBAction func setDarkMode(_ sender: UIButton) {
        changeColorModeInUserDefaults(mode: "dark")
        animContraria()
    }
    
    @IBAction func setZOOMMode(_ sender: UIButton) {
        changeColorModeInUserDefaults(mode: "zoom")
        audioPlayer.play()
        animContraria()
    }
    
    
    func animContraria() {
        UIView.animate(withDuration: 0.3) { 
            self.blueButton.alpha = 0
            self.blueButton.center = self.altroButton.center
            
            self.redButton.alpha = 0
            self.redButton.center = self.altroButton.center
            
            self.darkButton.alpha = 0
            self.darkButton.center = self.altroButton.center
            
            self.zoomButton.alpha = 0
            self.zoomButton.center = self.altroButton.center
        }
    }
    
    func changeColorModeInUserDefaults(mode: String) {
        UserDefaults.standard.set(mode, forKey: "ColorMode")
        if let color = UserDefaults.standard.string(forKey: "ColorMode") {
            switch color {
            case "dark":
                altroButton.backgroundColor = UIColor.darkGray
                altroButton.setImage(nil, for: .normal)
            case "red":
                altroButton.backgroundColor = UIColor.red
                altroButton.setImage(nil, for: .normal)
            case "blue":
                altroButton.backgroundColor = UIColor.blue
                altroButton.setImage(nil, for: .normal)
            case "zoom":
                altroButton.setImage(UIImage(named: "zoom"), for: .normal)
            default:
                print("Erro")
            }
        }
        print("ColorMode cambiata")
    }
    
    
    
    }
