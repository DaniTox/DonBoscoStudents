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
    
    @IBOutlet weak var labeldarkMode: UILabel!
    @IBOutlet weak var switchLabel: UISwitch!
    
    @IBOutlet weak var altroButton: CircleButton!
    @IBOutlet weak var blueButton: CircleButton!
    @IBOutlet weak var redButton: CircleButton!
    @IBOutlet weak var darkButton: CircleButton!
    @IBOutlet weak var greenButton: CircleButton!
    
    
    var pEcenter:CGPoint!
    var sEcenter:CGPoint!
    var tEcenter:CGPoint!
    var qEcenter:CGPoint!
    
    var pMcenter:CGPoint!
    var sMcenter:CGPoint!
    var tMcenter:CGPoint!
    var qMcenter:CGPoint!
    
    var altroPressedperLaPrimaVolta:Bool = false
    var setColorNumbersPressedLaPrimaVolta:Bool = false
    
    @IBAction func notificheAttivateSwitch(_ sender: UISwitch) {
//        if sender.isOn == true {
//            
//            if #available(iOS 10.0, *) {
//                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge] , completionHandler: {didAllow, error in })
//                
//            } else {
//                let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//                UIApplication.shared.registerUserNotificationSettings(setting)
//                
//            }
//            
//        }
        
        print("Notificehe in fase di miglioramento")
    }
    
    

    
    
    @IBAction func verificaAggiornamenti() {
      
        var linkUltimaVersione: String?
        
        if UserDefaults.standard.bool(forKey: "linkCorretti") != true {
            linkUltimaVersione = "http://ipswdownloaderpy.altervista.org/filesAppDonBosco/DBStudentiVersion.json"
        }
        else {
            linkUltimaVersione = UserDefaults.standard.string(forKey: "LinkControllaAggiornamenti")
        }
        
        
        DispatchQueue.global(qos: .background).async {
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
                        self.present(alert, animated: true, completion: nil)
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
                        self.present(alert, animated: true, completion: nil)
                        print("Aggiornamento Disponibile")
                    }
                }
                else {
                    let alert = UIAlertController(title: "Nessuna Connessione", message: "Assicurati di essere connesso a Internet e riprova", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print("No connection")
                }
            }
            else {
                print("URL Errato")
            }
        }
        
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
            mailVC.setMessageBody("SCRIVI QUA SOTTO INFORMAZIONI UTILI SUL BUG E SU COME POSSO TROVARLO:\n\n\n\nINFORMAZIONI DEL TUO DISPOSITIVO PER CAPIRE COME RIPRODURRE IL BUG. NON MODIFICARLE\n---------------\nDEVICE/APP INFO:\nVersione Applicazione: \(appVersion)\nNumero Build: \(numeroBuild)\nType: \(appTypeOfRun)\nDispositivo: \(deviceModel)\nDevice Type: \(deviceModelIdentifier)\nOS: \(deviceOSVersion)\nOrientation: \(orientationValue)\nLink aggiornati dalle impostazioni: \(linkSonoCorretti)\nLinks aggiornati: \(allLinks)\nBundle ID: \(String(describing: bundleIdentifier))\n------------\n", isHTML: false)
            
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
        DispatchQueue.global(qos: .background).async {
            changelog.getCangelog()
            
            if changelogArray.last == "\n" {
                changelogArray.removeLast()
            }
            if changelogArray.first != "ERRORE" {
                let alert = UIAlertController(title: "Changelog", message: String(describing: changelogArray.minimalDescription), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                print("Errore di connessione")
                let alert = UIAlertController(title: "Errore di connessione", message: "Assicurati di essere connesso a Internet e riprova", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                changelogArray.removeAll()
            }

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
        
        setClasseOutlet.titleLabel?.text = UserDefaults.standard.string(forKey: "classe")
        
       
        
        blueCenter = blueButton.center
        redCenter = redButton.center
        darkCenter = darkButton.center
        greenCenter = greenButton.center
        
        blueNumbersCenter = blueNumbersOutlet.center
        redNumbersCenter = redNumbersOutlet.center
        darkNumbersCenter = darkNumbersOutlet.center
        greenNumbersCenter = greenNumbersOutlet.center
        whiteNumbersCenter = whiteNumbersOutlet.center
        
        
        blueFontCenter = BlueFontOutlet.center
        greenFontCenter = GreenFontOutlet.center
        redFontCenter = RedFontOutlet.center
        blackFontCenter = BlackFontOutlet.center
        whiteFontCenter = WhiteFontOutlet.center
        
        
        pEcenter = pElettroOutlet.center
        sEcenter = sElettroOutlet.center
        tEcenter = tElettroOutlet.center
        qEcenter = qElettroOutlet.center
        
        pMcenter = pMotoOutlet.center
        sMcenter = sMotoOutlet.center
        tMcenter = tMotoOutlet.center
        qMcenter = qMotoOutlet.center
        
        
        portaButtonAStatoInziale()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tickDone.alpha = 0

        stepperOutlet.value = Double(UserDefaults.standard.float(forKey: "GrandezzaNumeri"))
        if stepperOutlet.value <= 1 {
            stepperOutlet.value = 30
        }
        labelGrandezzaNumeri.text = String(stepperOutlet.value.cleanValue)
        
        
        
        if let classe = UserDefaults.standard.string(forKey: "classe") {
            switch classe {
            case "1E", "2E", "3E", "4E":
                setClasseOutlet.backgroundColor = UIColor.yellow
                setClasseOutlet.setTitle(classe, for: .normal)
            case "1M", "2M", "3M", "4M":
                setClasseOutlet.backgroundColor = UIColor.darkGray
                setClasseOutlet.setTitle(classe, for: .normal)
                
            default:
                print("Error in color setClasseOutlet")
            }
        }
        
        if let color = UserDefaults.standard.string(forKey: "ColorMode") {
            switch color {
            case "dark":
                altroButton.backgroundColor = UIColor.black
                altroButton.borderWidth = 2.0
                altroButton.borderColor = UIColor.darkGray
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
                selectNumbersColorOutlet.backgroundColor = UIColor.black
                selectNumbersColorOutlet.borderWidth = 2.0
                selectNumbersColorOutlet.borderColor = UIColor.darkGray
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
        
        
        if let colorFont = UserDefaults.standard.string(forKey: "FontNumeriColor") {
            switch colorFont {
            case "black":
                selectFontColor.backgroundColor = UIColor.black
                selectFontColor.borderWidth = 2.0
                selectFontColor.borderColor = UIColor.darkGray
            case "red":
                selectFontColor.backgroundColor = UIColor.red
            case "blue":
                selectFontColor.backgroundColor = UIColor.blue
            case "green":
                selectFontColor.backgroundColor = UIColor.green
            case "white":
                selectFontColor.backgroundColor = UIColor.white
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
        
        BlueFontOutlet.center = selectFontColor.center
        GreenFontOutlet.center = selectFontColor.center
        RedFontOutlet.center = selectFontColor.center
        BlackFontOutlet.center = selectFontColor.center
        WhiteFontOutlet.center = selectFontColor.center
        
        BlueFontOutlet.alpha = 0
        GreenFontOutlet.alpha = 0
        RedFontOutlet.alpha = 0
        BlackFontOutlet.alpha = 0
        WhiteFontOutlet.alpha = 0
        
        pElettroOutlet.center = setClasseOutlet.center
        sElettroOutlet.center = setClasseOutlet.center
        tElettroOutlet.center = setClasseOutlet.center
        qElettroOutlet.center = setClasseOutlet.center
        pElettroOutlet.alpha = 0
        sElettroOutlet.alpha = 0
        tElettroOutlet.alpha = 0
        qElettroOutlet.alpha = 0
        
        pMotoOutlet.center = setClasseOutlet.center
        sMotoOutlet.center = setClasseOutlet.center
        tMotoOutlet.center = setClasseOutlet.center
        qMotoOutlet.center = setClasseOutlet.center
        pMotoOutlet.alpha = 0
        sMotoOutlet.alpha = 0
        tMotoOutlet.alpha = 0
        qMotoOutlet.alpha = 0
        
    }
    
    @IBAction func setBlueMode(_ sender: UIButton) {
        SETBackgroundColor(color: "blue")
        animContraria()
        altroButton.borderWidth = 0
        altroButton.borderColor = UIColor.darkGray
        altroButton.backgroundColor = UIColor.blue
        altroPressedperLaPrimaVolta = false

    }
    
    @IBAction func setRedMode(_ sender: UIButton) {
        SETBackgroundColor(color: "red")
        animContraria()
        altroButton.borderWidth = 0
        altroButton.borderColor = UIColor.darkGray
        altroButton.backgroundColor = UIColor.red
        altroPressedperLaPrimaVolta = false

    }
    
    @IBAction func setDarkMode(_ sender: UIButton) {
        SETBackgroundColor(color: "dark")
        animContraria()
        altroButton.borderWidth = 2.0
        altroButton.borderColor = UIColor.darkGray
        altroButton.backgroundColor = UIColor.black
        altroPressedperLaPrimaVolta = false

    }
    
    @IBAction func setGreenMode(_ sender: UIButton) {
        SETBackgroundColor(color: "green")
        animContraria()
        altroButton.borderWidth = 0
        altroButton.borderColor = UIColor.darkGray
        altroButton.backgroundColor = UIColor.green
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
                selectNumbersColorOutlet.borderWidth = 2.0
                selectNumbersColorOutlet.borderColor = UIColor.darkGray
                selectNumbersColorOutlet.backgroundColor = UIColor.black
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
        labelGrandezzaNumeri.text = String(sender.value.cleanValue)
        UserDefaults.standard.set(Float(labelGrandezzaNumeri.text!), forKey: "GrandezzaNumeri")
    }
    
    @IBOutlet weak var stepperOutlet: UIStepper!
    
    
    var blueFontCenter: CGPoint!
    var greenFontCenter: CGPoint!
    var redFontCenter: CGPoint!
    var blackFontCenter: CGPoint!
    var whiteFontCenter: CGPoint!
    
    
    @IBOutlet weak var selectFontColor: CircleButton!
    @IBOutlet weak var BlueFontOutlet: CircleButton!
    @IBOutlet weak var GreenFontOutlet: CircleButton!
    @IBOutlet weak var RedFontOutlet: CircleButton!
    @IBOutlet weak var BlackFontOutlet: CircleButton!
    @IBOutlet weak var WhiteFontOutlet: CircleButton!
    
    var setColorFontNumbers:Bool = false
    @IBAction func slectFontColorAction(_ sender: Any) {
        setColorFontNumbers = !setColorFontNumbers
        
        if setColorFontNumbers == true {
            animateFontColorButtons()
            setColorFontNumbers = true
        }
        else {
            animFontColorContraria()
        }
    }
    
    @IBAction func setBlueFont(_ sender: Any) {
        changeFontColor(color: "blue")
        selectFontColor.backgroundColor = UIColor.blue
        animFontColorContraria()
        setColorFontNumbers = false
    }
    
    @IBAction func setGreenFont(_ sender: Any) {
        changeFontColor(color: "green")
        selectFontColor.backgroundColor = UIColor.green
        animFontColorContraria()
        setColorFontNumbers = false
    }
    
    @IBAction func setRedFont(_ sender: Any) {
        changeFontColor(color: "red")
        selectFontColor.backgroundColor = UIColor.red
        animFontColorContraria()
        setColorFontNumbers = false
    }
    
    @IBAction func setBlackFont(_ sender: Any) {
        changeFontColor(color: "black")
        selectFontColor.backgroundColor = UIColor.darkGray
        animFontColorContraria()
        setColorFontNumbers = false
    }
    
    @IBAction func setWhiteFont(_ sender: Any) {
        changeFontColor(color: "white")
        selectFontColor.backgroundColor = UIColor.white
        animFontColorContraria()
        setColorFontNumbers = false
    }
    
    
    func changeFontColor(color: String) {
        UserDefaults.standard.set(color, forKey: "FontNumeriColor")
    }
    
    
    func animateFontColorButtons() {
        UIView.animate(withDuration: 0.3) { 
            self.BlueFontOutlet.center = self.blueFontCenter
            self.BlueFontOutlet.alpha = 1
            
            self.GreenFontOutlet.center = self.greenFontCenter
            self.GreenFontOutlet.alpha = 1
            
            self.RedFontOutlet.center = self.redFontCenter
            self.RedFontOutlet.alpha = 1
            
            self.BlackFontOutlet.center = self.blackFontCenter
            self.BlackFontOutlet.alpha = 1
            
            self.WhiteFontOutlet.center = self.whiteFontCenter
            self.WhiteFontOutlet.alpha = 1
        }
        
    }
    
    func animFontColorContraria() {
        UIView.animate(withDuration: 0.3) { 
            self.BlueFontOutlet.center = self.selectFontColor.center
            self.BlueFontOutlet.alpha = 0
            
            self.GreenFontOutlet.center = self.selectFontColor.center
            self.GreenFontOutlet.alpha = 0
            
            self.RedFontOutlet.center = self.selectFontColor.center
            self.RedFontOutlet.alpha = 0
            
            self.BlackFontOutlet.center = self.selectFontColor.center
            self.BlackFontOutlet.alpha = 0
            
            self.WhiteFontOutlet.center = self.selectFontColor.center
            self.WhiteFontOutlet.alpha = 0
        }
    
    }
    
    @IBOutlet weak var tickDone: UILabel!
    @IBAction func resetColors(_ sender: Any) {
        UserDefaults.standard.set("white", forKey: "ColorNumbers")
        UserDefaults.standard.set("black", forKey: "FontNumeriColor")
        UserDefaults.standard.set(30.0, forKey: "GrandezzaNumeri")
        tickDone.alpha = 1
        
        if let color = UserDefaults.standard.string(forKey: "ColorNumbers") {
            switch color {
            case "black":
                selectNumbersColorOutlet.backgroundColor = UIColor.black
                selectNumbersColorOutlet.borderColor = UIColor.darkGray
                selectNumbersColorOutlet.borderWidth = 2.0
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
        
        
        if let colorFont = UserDefaults.standard.string(forKey: "FontNumeriColor") {
            switch colorFont {
            case "black":
                selectFontColor.backgroundColor = UIColor.black
                selectFontColor.borderWidth = 2.0
                selectFontColor.borderColor = UIColor.darkGray
            case "red":
                selectFontColor.backgroundColor = UIColor.red
            case "blue":
                selectFontColor.backgroundColor = UIColor.blue
            case "green":
                selectFontColor.backgroundColor = UIColor.green
            case "white":
                selectFontColor.backgroundColor = UIColor.white
            default:
                print("Erro")
            }
        }
        
        stepperOutlet.value = 30.0
        labelGrandezzaNumeri.text = String(30.0.cleanValue)
    }
    
    //CLASSI
    
    @IBOutlet weak var setClasseOutlet: CircleButton!
    
    @IBOutlet weak var pElettroOutlet: CircleButton!
    @IBOutlet weak var sElettroOutlet: CircleButton!
    @IBOutlet weak var tElettroOutlet: CircleButton!
    @IBOutlet weak var qElettroOutlet: CircleButton!
    
    @IBOutlet weak var pMotoOutlet: CircleButton!
    @IBOutlet weak var sMotoOutlet: CircleButton!
    @IBOutlet weak var tMotoOutlet: CircleButton!
    @IBOutlet weak var qMotoOutlet: CircleButton!
    
    var classeSelected:Bool = false
    
    
    
    @IBAction func setClasseAction(_ sender: Any) {
        classeSelected = !classeSelected
        
        if classeSelected == true {
            animaCassi()
            classeSelected = true
        }
        else {
            animClassiInversa()
        }
    }
    
    @IBAction func setClassebySender(_ sender: UIButton) {
        if let classe = sender.currentTitle {
            setClasse(classe)
            print(classe)
            setClasseOutlet.setTitle(classe, for: .normal)
        }
        animClassiInversa()
        classeSelected = false
        setClasseOutlet.titleLabel?.textColor = UIColor.white
        if let classe = UserDefaults.standard.string(forKey: "classe") {
            switch classe {
            case "1E", "2E", "3E", "4E":
                setClasseOutlet.backgroundColor = UIColor.yellow
            case "1M", "2M", "3M", "4M":
                setClasseOutlet.backgroundColor = UIColor.darkGray
            default:
                print("Error in color setClasseOutlet")
            }
        }
        
    }
    
    func animClassiInversa() {
        UIView.animate(withDuration: 0.3) { 
            self.pElettroOutlet.center = self.setClasseOutlet.center
            self.pElettroOutlet.alpha = 0
            self.sElettroOutlet.center = self.setClasseOutlet.center
            self.sElettroOutlet.alpha = 0
            self.tElettroOutlet.center = self.setClasseOutlet.center
            self.tElettroOutlet.alpha = 0
            self.qElettroOutlet.center = self.setClasseOutlet.center
            self.qElettroOutlet.alpha = 0
            
            self.pMotoOutlet.center = self.setClasseOutlet.center
            self.pMotoOutlet.alpha = 0
            self.sMotoOutlet.center = self.setClasseOutlet.center
            self.sMotoOutlet.alpha = 0
            self.tMotoOutlet.center = self.setClasseOutlet.center
            self.tMotoOutlet.alpha = 0
            self.qMotoOutlet.center = self.setClasseOutlet.center
            self.qMotoOutlet.alpha = 0
        }
    }
    
    func animaCassi() {
        UIView.animate(withDuration: 0.3) {
            self.pElettroOutlet.center = self.pEcenter
            self.pElettroOutlet.alpha = 1
            self.sElettroOutlet.center = self.sEcenter
            self.sElettroOutlet.alpha = 1
            self.tElettroOutlet.center = self.tEcenter
            self.tElettroOutlet.alpha = 1
            self.qElettroOutlet.center = self.qEcenter
            self.qElettroOutlet.alpha = 1
            
            self.pMotoOutlet.center = self.pMcenter
            self.pMotoOutlet.alpha = 1
            self.sMotoOutlet.center = self.sMcenter
            self.sMotoOutlet.alpha = 1
            self.tMotoOutlet.center = self.tMcenter
            self.tMotoOutlet.alpha = 1
            self.qMotoOutlet.center = self.qMcenter
            self.qMotoOutlet.alpha = 1
        }
    }
    
    
    func setClasse(_ classe: String) {
        UserDefaults.standard.set(classe, forKey: "classe")
        
    }
    
    
    }
