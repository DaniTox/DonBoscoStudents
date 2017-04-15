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

//DA FARE: EVITARE DI CREARE SEMPRE UN ALERT NUOVO SE IL MESSAGGIO DA DARE ALL'UTENTE è LO STESSO. FARLO INVECE TRAMITE UNA FUNZIONE UNICA

extension Sequence {
    var minimalDescription: String {
        return map { "\($0)" }.joined(separator: " ")
    }
}

var linksModificati:Bool?

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var classeTextField: UITextField!
    @IBOutlet weak var labeldarkMode: UILabel!
    @IBOutlet weak var switchLabel: UISwitch!
    
    @IBOutlet weak var altroButton: CircleButton!
    @IBOutlet weak var blueButton: CircleButton!
    @IBOutlet weak var redButton: CircleButton!
    @IBOutlet weak var darkButton: CircleButton!
    @IBOutlet weak var greenButton: CircleButton!
    
    
    var altroPressedperLaPrimaVolta:Bool = false
    var setColorNumbersPressedLaPrimaVolta:Bool = false
    
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
    var greenCenter: CGPoint!
    
    var blueNumbersCenter: CGPoint!
    var redNumbersCenter: CGPoint!
    var darkNumbersCenter: CGPoint!
    var greenNumbersCenter: CGPoint!
    var whiteNumbersCenter: CGPoint!
    
    @IBOutlet weak var whiteNumbersOutlet: CircleButton!
    @IBOutlet weak var darkNumbersOutlet: CircleButton!
    @IBOutlet weak var redNumbersOutlet: CircleButton!
    @IBOutlet weak var greenNumbersOutlet: CircleButton!
    @IBOutlet weak var blueNumbersOutlet: CircleButton!
    @IBOutlet weak var selectNumbersColorOutlet: CircleButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        altroPressedperLaPrimaVolta = false
        
        self.classeTextField.delegate = self
        
        classeTextField.text = UserDefaults.standard.string(forKey: "classe")
        
        blueCenter = blueButton.center
        redCenter = redButton.center
        darkCenter = darkButton.center
        greenCenter = greenButton.center
        
        blueNumbersCenter = blueNumbersOutlet.center
        redNumbersCenter = redNumbersOutlet.center
        darkNumbersCenter = darkNumbersOutlet.center
        greenNumbersCenter = greenNumbersOutlet.center
        whiteNumbersCenter = whiteNumbersOutlet.center
        
       portaButtonAStatoInziale()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        classeTextField.text = UserDefaults.standard.string(forKey: "classe")
        
        stepperOutlet.value = Double(UserDefaults.standard.float(forKey: "GrandezzaNumeri"))
        if stepperOutlet.value <= 1 {
            stepperOutlet.value = 30
        }
        labelGrandezzaNumeri.text = String(stepperOutlet.value)
        
        
        
        if let color = UserDefaults.standard.string(forKey: "ColorMode") {
            switch color {
            case "dark":
                altroButton.backgroundColor = UIColor.darkGray
            case "red":
                altroButton.backgroundColor = UIColor.red
            case "blue":
                altroButton.backgroundColor = UIColor.blue
            case "green":
                altroButton.backgroundColor = UIColor.green
            default:
                print("Erro")
            }
        }

        if let color = UserDefaults.standard.string(forKey: "ColorNumbers") {
            switch color {
            case "black":
                selectNumbersColorOutlet.backgroundColor = UIColor.darkGray
            case "red":
                selectNumbersColorOutlet.backgroundColor = UIColor.red
            case "blue":
                selectNumbersColorOutlet.backgroundColor = UIColor.blue
            case "green":
                selectNumbersColorOutlet.backgroundColor = UIColor.green
            case "white":
                selectNumbersColorOutlet.backgroundColor = UIColor.white
            default:
                print("Erro")
            }
        }
        
        
    }

    
    func buttonAnim() {
        UIView.animate(withDuration: 0.3) {
            self.blueButton.alpha = 1
            self.blueButton.center = self.blueCenter
            
            self.redButton.alpha = 1
            self.redButton.center = self.redCenter
            
            self.darkButton.alpha = 1
            self.darkButton.center = self.darkCenter
            
            self.greenButton.alpha = 1
            self.greenButton.center = self.greenCenter
        }
    }
    
    
    @IBAction func altroPressed(_ sender: UIButton) {
        altroPressedperLaPrimaVolta = !altroPressedperLaPrimaVolta
        
        if altroPressedperLaPrimaVolta == true {
            buttonAnim()
            altroPressedperLaPrimaVolta = true
        }
        else {
            animContraria()
        }
    }
    
    func portaButtonAStatoInziale() {
        blueButton.center = altroButton.center
        redButton.center = altroButton.center
        darkButton.center = altroButton.center
        greenButton.center = altroButton.center
        
        blueButton.alpha = 0
        redButton.alpha = 0
        darkButton.alpha = 0
        greenButton.alpha = 0
        
        blueNumbersOutlet.center = selectNumbersColorOutlet.center
        greenNumbersOutlet.center = selectNumbersColorOutlet.center
        whiteNumbersOutlet.center = selectNumbersColorOutlet.center
        darkNumbersOutlet.center = selectNumbersColorOutlet.center
        redNumbersOutlet.center = selectNumbersColorOutlet.center
        blueNumbersOutlet.center = selectNumbersColorOutlet.center
        
        blueNumbersOutlet.alpha = 0
        greenNumbersOutlet.alpha = 0
        whiteNumbersOutlet.alpha = 0
        darkNumbersOutlet.alpha = 0
        redNumbersOutlet.alpha = 0
        blueNumbersOutlet.alpha = 0
    }
    
    @IBAction func setBlueMode(_ sender: UIButton) {
        changeColorModeInUserDefaults(mode: "blue")
        animContraria()
        altroPressedperLaPrimaVolta = false

    }
    
    @IBAction func setRedMode(_ sender: UIButton) {
        changeColorModeInUserDefaults(mode: "red")
        animContraria()
        altroPressedperLaPrimaVolta = false

    }
    
    @IBAction func setDarkMode(_ sender: UIButton) {
        changeColorModeInUserDefaults(mode: "dark")
        animContraria()
        altroPressedperLaPrimaVolta = false

    }
    
    @IBAction func setGreenMode(_ sender: UIButton) {
        changeColorModeInUserDefaults(mode: "green")
        animContraria()
        altroPressedperLaPrimaVolta = false

    }
    
    
    func animContraria() {
        UIView.animate(withDuration: 0.3) { 
            self.blueButton.alpha = 0
            self.blueButton.center = self.altroButton.center
            
            self.redButton.alpha = 0
            self.redButton.center = self.altroButton.center
            
            self.darkButton.alpha = 0
            self.darkButton.center = self.altroButton.center
            
            self.greenButton.alpha = 0
            self.greenButton.center = self.altroButton.center
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
            case "green":
                altroButton.backgroundColor = UIColor.green
                altroButton.setImage(nil, for: .normal)
            default:
                print("Erro")
            }
        }
        print("ColorMode cambiata")
    }
    
    
    
    @IBAction func setWhiteNumbers(_ sender: UIButton) {
        setColorNumbers(mode: "white")
        animColorsNumbersContraria()
        setColorNumbersPressedLaPrimaVolta = false
        
    }
    
    @IBAction func setBlackNumbers(_ sender: UIButton) {
        setColorNumbers(mode: "black")
        animColorsNumbersContraria()
        setColorNumbersPressedLaPrimaVolta = false
    }
    
    @IBAction func setRedNumbers(_ sender: UIButton) {
        setColorNumbers(mode: "red")
        animColorsNumbersContraria()
        setColorNumbersPressedLaPrimaVolta = false
    }
    
    @IBAction func setGreenNumbers(_ sender: UIButton) {
        setColorNumbers(mode: "green")
        animColorsNumbersContraria()
        setColorNumbersPressedLaPrimaVolta = false
    }
    
    @IBAction func setBlueNumbers(_ sender: UIButton) {
        setColorNumbers(mode: "blue")
        animColorsNumbersContraria()
        setColorNumbersPressedLaPrimaVolta = false
    }
    
    func setColorNumbers(mode: String) {
        UserDefaults.standard.set(mode, forKey: "ColorNumbers")
        if let color = UserDefaults.standard.string(forKey: "ColorNumbers") {
            switch color {
            case "black":
                selectNumbersColorOutlet.backgroundColor = UIColor.darkGray
                selectNumbersColorOutlet.setImage(nil, for: .normal)
            case "red":
                selectNumbersColorOutlet.backgroundColor = UIColor.red
                selectNumbersColorOutlet.setImage(nil, for: .normal)
            case "blue":
                selectNumbersColorOutlet.backgroundColor = UIColor.blue
                selectNumbersColorOutlet.setImage(nil, for: .normal)
            case "green":
                selectNumbersColorOutlet.backgroundColor = UIColor.green
                selectNumbersColorOutlet.setImage(nil, for: .normal)
            case "white":
                selectNumbersColorOutlet.backgroundColor = UIColor.white
                selectNumbersColorOutlet.setImage(nil, for: .normal)
            default:
                print("Erro")
            }
        }
    }
    
    
    func animColorsNumbers() {
        UIView.animate(withDuration: 0.3) { 
            self.blueNumbersOutlet.center = self.blueNumbersCenter
            self.blueNumbersOutlet.alpha = 1
            
            self.redNumbersOutlet.center = self.redNumbersCenter
            self.redNumbersOutlet.alpha = 1
            
            self.darkNumbersOutlet.center = self.darkNumbersCenter
            self.darkNumbersOutlet.alpha = 1
            
            self.whiteNumbersOutlet.center = self.whiteNumbersCenter
            self.whiteNumbersOutlet.alpha = 1
            
            self.greenNumbersOutlet.center = self.greenNumbersCenter
            self.greenNumbersOutlet.alpha = 1
        }
    }
    
    func animColorsNumbersContraria() {
        UIView.animate(withDuration: 0.3) {
            self.blueNumbersOutlet.center = self.selectNumbersColorOutlet.center
            self.blueNumbersOutlet.alpha = 0
            
            self.redNumbersOutlet.center = self.selectNumbersColorOutlet.center
            self.redNumbersOutlet.alpha = 0
            
            self.darkNumbersOutlet.center = self.selectNumbersColorOutlet.center
            self.darkNumbersOutlet.alpha = 0
            
            self.whiteNumbersOutlet.center = self.selectNumbersColorOutlet.center
            self.whiteNumbersOutlet.alpha = 0
            
            self.greenNumbersOutlet.center = self.selectNumbersColorOutlet.center
            self.greenNumbersOutlet.alpha = 0
        }
    }
    
    @IBAction func setColorNumbersAction(_ sender: UIButton) {
        
        
        setColorNumbersPressedLaPrimaVolta = !setColorNumbersPressedLaPrimaVolta
        
        if setColorNumbersPressedLaPrimaVolta == true {
            animColorsNumbers()
            setColorNumbersPressedLaPrimaVolta = true
        }
        else {
            animColorsNumbersContraria()
        }
    }
    
    
    @IBOutlet weak var labelGrandezzaNumeri: UILabel!
    

    @IBAction func stepper(_ sender: UIStepper) {
        labelGrandezzaNumeri.text = String(sender.value)
        UserDefaults.standard.set(Float(labelGrandezzaNumeri.text!), forKey: "GrandezzaNumeri")
    }
    
    @IBOutlet weak var stepperOutlet: UIStepper!
    
    
    
    
    
    }
