//
//  OnBoardingViewController.swift
//  iUtility
//
//  Created by Dani Tox on 13/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    var colorModeisSelected: Bool = false
    var classeIsSelected: Bool = false
    
    var selectedBlue:Bool = false
    var selectedRed:Bool = false
    var selectedBlack:Bool = false
    var selectedGreen:Bool = false
    
    var selected1E:Bool = false
    var selected2E:Bool = false
    var selected3E:Bool = false
    var selected4E:Bool = false
    
    var selected1M:Bool = false
    var selected2M:Bool = false
    var selected3M:Bool = false
    var selected4M:Bool = false
    
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var frase1: UILabel!
    @IBOutlet weak var frase2: UILabel!
    @IBOutlet weak var frase3: UILabel!
    @IBOutlet weak var frase4: UILabel!
    @IBOutlet weak var button: UIButton!
    
    //Classi Button
    @IBOutlet weak var classe1: CircleButton!
    @IBOutlet weak var classe2: CircleButton!
    @IBOutlet weak var classe3: CircleButton!
    @IBOutlet weak var classe4: CircleButton!
    @IBOutlet weak var classe5: CircleButton!
    @IBOutlet weak var classe6: CircleButton!
    @IBOutlet weak var classe7: CircleButton!
    @IBOutlet weak var classe8: CircleButton!
    
    
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var blueModeButton: CircleButton!
    @IBOutlet weak var redModeButton: CircleButton!
    @IBOutlet weak var darkModeButton: CircleButton!
    @IBOutlet weak var greenModeButton: CircleButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "dark")
        
        imageView.alpha = 0
        titolo.alpha = 0
        frase1.alpha = 0
        frase2.alpha = 0
        frase3.alpha = 0
        frase4.alpha = 0
        button.alpha = 0
        
        classe1.alpha = 0
        classe2.alpha = 0
        classe3.alpha = 0
        classe4.alpha = 0
        classe5.alpha = 0
        classe6.alpha = 0
        classe7.alpha = 0
        classe8.alpha = 0
        
        blueModeButton.alpha = 0
        redModeButton.alpha = 0
        darkModeButton.alpha = 0
        greenModeButton.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animazione()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func go(_ sender: UIButton) {
        if classeIsSelected && colorModeisSelected {
            UserDefaults.standard.set("true", forKey: "OnboardingEffettuato")
            performSegue(withIdentifier: "gotoMainScreen", sender: self)
            UserDefaults.standard.set("white", forKey: "ColorNumbers")
            UserDefaults.standard.set("black", forKey: "FontNumeriColor")
        }
        else {
            print("Devi selezionare sia la classe che la Color Mode prima di continuare")
        }
        
    }
   
    
    
    @IBAction func bluColorAction(_ sender: UIButton) {
        settaColorMode(mode: "blue")
        printaLaMode()
        
        if selectedBlue == false {
            seleziona(sender: sender, siOno: true)
            selectedBlue = true
            disattivaAltriButton(buttons: [redModeButton, darkModeButton, greenModeButton])
        }
        else {
            seleziona(sender: sender, siOno: false)
            selectedBlue = false
        }
    }
    
    @IBAction func redColorAction(_ sender: UIButton) {
        settaColorMode(mode: "red")
        printaLaMode()
        
        if selectedRed == false {
            seleziona(sender: sender, siOno: true)
            selectedRed = true
            disattivaAltriButton(buttons: [blueModeButton, darkModeButton, greenModeButton])

        }
        else {
            seleziona(sender: sender, siOno: false)
            selectedRed = false
        }
    }
    
    @IBAction func darkColorAction(_ sender: UIButton) {
        settaColorMode(mode: "dark")
        printaLaMode()
        
        if selectedBlack == false {
            seleziona(sender: sender, siOno: true)
            selectedBlack = true
            disattivaAltriButton(buttons: [blueModeButton, redModeButton, greenModeButton])

        }
        else {
            seleziona(sender: sender, siOno: false)
            selectedBlack = false
        }
    }
    
    @IBAction func greenModeAction(_ sender: UIButton) {
        settaColorMode(mode: "green")
        printaLaMode()
        
        if selectedGreen == false {
            seleziona(sender: sender, siOno: true)
            selectedGreen = true
            disattivaAltriButton(buttons: [blueModeButton, redModeButton, darkModeButton])

        }
        else {
            seleziona(sender: sender, siOno: false)
            selectedGreen = false
        }
    }
    
    
    func settaColorMode(mode: String) {
        UserDefaults.standard.set(mode, forKey: "ColorMode")
        colorModeisSelected = true
    }
    
    func printaLaMode() {
        if let color = UserDefaults.standard.string(forKey: "ColorMode") {
            print(color)
        }
        else {
            print("Error")
        }
    }
    
    
    func seleziona(sender: UIButton, siOno: Bool ) {
        if siOno == true {
            sender.layer.borderColor = UIColor.orange.cgColor
            sender.layer.borderWidth = 1.5
            switch sender {
            case blueModeButton:
                selectedBlue = true
                selectedGreen = false
                selectedBlack = false
                selectedRed = false
            case redModeButton:
                selectedBlue = false
                selectedGreen = false
                selectedBlack = false
                selectedRed = true
            case darkModeButton:
                selectedBlue = false
                selectedGreen = false
                selectedBlack = true
                selectedRed = false
            case greenModeButton:
                selectedBlue = false
                selectedGreen = true
                selectedBlack = false
                selectedRed = false
            case classe1:
                selected1E = true
                selected2E = false
                selected3E = false
                selected4E = false
                selected1M = false
                selected2M = false
                selected3M = false
                selected4M = false
            case classe2:
                selected1E = false
                selected2E = true
                selected3E = false
                selected4E = false
                selected1M = false
                selected2M = false
                selected3M = false
                selected4M = false
            case classe3:
                selected1E = false
                selected2E = false
                selected3E = true
                selected4E = false
                selected1M = false
                selected2M = false
                selected3M = false
                selected4M = false
            case classe4:
                selected1E = false
                selected2E = false
                selected3E = false
                selected4E = true
                selected1M = false
                selected2M = false
                selected3M = false
                selected4M = false
            case classe5:
                selected1E = false
                selected2E = false
                selected3E = false
                selected4E = false
                selected1M = true
                selected2M = false
                selected3M = false
                selected4M = false
            case classe6:
                selected1E = false
                selected2E = false
                selected3E = false
                selected4E = false
                selected1M = false
                selected2M = true
                selected3M = false
                selected4M = false
            case classe7:
                selected1E = false
                selected2E = false
                selected3E = false
                selected4E = false
                selected1M = false
                selected2M = false
                selected3M = true
                selected4M = false
            case classe8:
                selected1E = false
                selected2E = false
                selected3E = false
                selected4E = false
                selected1M = false
                selected2M = false
                selected3M = false
                selected4M = true
            default:
                print("Error")
            }
        }
        else {
            sender.layer.borderColor = UIColor.green.cgColor
            sender.layer.borderWidth = 0
        }
    }
    
    @IBAction func setta1E(_ sender: UIButton) {
        settaClasse(classe: sender.currentTitle!)
        
        if selected1E == false {
            seleziona(sender: sender, siOno: true)
            selected1E = true
            disattivaAltriButton(buttons: [classe2,classe3,classe4,classe5,classe6,classe7,classe8])
        }
        else {
            seleziona(sender: sender, siOno: false)
            selected1E = false
        }
    }
    
    @IBAction func setta2E(_ sender: UIButton) {
        settaClasse(classe: sender.currentTitle!)
        
        if selected2E == false {
            seleziona(sender: sender, siOno: true)
            selected2E = true
            disattivaAltriButton(buttons: [classe1,classe3,classe4,classe5,classe6,classe7,classe8])
        }
        else {
            seleziona(sender: sender, siOno: false)
            selected2E = false
        }

    }
    
    @IBAction func setta3E(_ sender: UIButton) {
        settaClasse(classe: sender.currentTitle!)
        
        if selected3E == false {
            seleziona(sender: sender, siOno: true)
            selected3E = true
            disattivaAltriButton(buttons: [classe2,classe1,classe4,classe5,classe6,classe7,classe8])
        }
        else {
            seleziona(sender: sender, siOno: false)
            selected3E = false
        }

    }
    
    @IBAction func setta4E(_ sender: UIButton) {
        settaClasse(classe: sender.currentTitle!)
        
        if selected4E == false {
            seleziona(sender: sender, siOno: true)
            selected4E = true
            disattivaAltriButton(buttons: [classe2,classe3,classe1,classe5,classe6,classe7,classe8])
        }
        else {
            seleziona(sender: sender, siOno: false)
            selected4E = false
        }

    }
    
    @IBAction func setta1M(_ sender: UIButton) {
        settaClasse(classe: sender.currentTitle!)
        
        if selected1M == false {
            seleziona(sender: sender, siOno: true)
            selected1M = true
            disattivaAltriButton(buttons: [classe2,classe3,classe4,classe1,classe6,classe7,classe8])
        }
        else {
            seleziona(sender: sender, siOno: false)
            selected1M = false
        }

    }
    
    @IBAction func setta2M(_ sender: UIButton) {
        settaClasse(classe: sender.currentTitle!)
        
        if selected2M == false {
            seleziona(sender: sender, siOno: true)
            selected2M = true
            disattivaAltriButton(buttons: [classe2,classe3,classe4,classe5,classe1,classe7,classe8])
        }
        else {
            seleziona(sender: sender, siOno: false)
            selected2M = false
        }

    }
    
    @IBAction func setta3M(_ sender: UIButton) {
        settaClasse(classe: sender.currentTitle!)
        
        if selected3M == false {
            seleziona(sender: sender, siOno: true)
            selected3M = true
            disattivaAltriButton(buttons: [classe2,classe3,classe4,classe5,classe6,classe1,classe8])
        }
        else {
            seleziona(sender: sender, siOno: false)
            selected3M = false
        }

    }
    
    @IBAction func setta4M(_ sender: UIButton) {
        settaClasse(classe: sender.currentTitle!)
        
        if selected4M == false {
            seleziona(sender: sender, siOno: true)
            selected4M = true
            disattivaAltriButton(buttons: [classe2,classe3,classe4,classe5,classe6,classe7,classe1])
        }
        else {
            seleziona(sender: sender, siOno: false)
            selected4M = false
        }

    }
    
    
    func settaClasse(classe : String) {
        UserDefaults.standard.set(classe, forKey: "classe")
        printaLaClasse()
        classeIsSelected = true
    }
    
    func printaLaClasse() {
        if let classe =  UserDefaults.standard.string(forKey: "classe") {
            print(classe)
        }
    }
    
    
    
    
//    func disattivaAltriButton(num1:UIButton, num2: UIButton, num3:UIButton) {
//        seleziona(sender: num1, siOno: false)
//        seleziona(sender: num2, siOno: false)
//        seleziona(sender: num3, siOno: false)
//    }
    
    
    
    func disattivaAltriButton(buttons: [UIButton]) {
        for button in buttons {
            seleziona(sender: button, siOno: false)
        }
    }
    
    
    func animazione() {
        showBackground()
    }
    
    func showBackground() {
        UIView.animate(withDuration: 1, animations: { 
            self.imageView.image = UIImage(named: "dark")
            self.imageView.alpha = 1
        }) { (true) in
            self.show1()
        }
    }
    
    func show1() {
        UIView.animate(withDuration: 1.5, animations: { 
            self.titolo.alpha = 1
        }) { (true) in
            self.show2()
        }
    }
    
    func show2() {
        UIView.animate(withDuration: 1.5, animations: { 
            self.frase1.alpha = 1
        }) { (true) in
            self.show3()
        }
    }
    
    func show3() {
        UIView.animate(withDuration: 1.5, animations: { 
            self.frase2.alpha = 1
        }) { (true) in
            self.show4()
        }
    }
    
    func show4() {
        UIView.animate(withDuration: 1.5, animations: { 
            self.frase3.alpha = 1
        }) { (true) in
            self.showClasse1()
        }
    }
    
    
    func showClasse1() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.classe1.alpha = 1
        }) { (true) in
            self.showClasse2()
        }
    }
    
    func showClasse2() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.classe2.alpha = 1
        }) { (true) in
            self.showClasse3()
        }
    }
    
    func showClasse3() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.classe3.alpha = 1
        }) { (true) in
            self.showClasse4()
        }
    }
    
    func showClasse4() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.classe4.alpha = 1
        }) { (true) in
            self.showClasse5()
        }
    }
    
    func showClasse5() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.classe5.alpha = 1
        }) { (true) in
            self.showClasse6()
        }
    }
    
    func showClasse6() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.classe6.alpha = 1
        }) { (true) in
            self.showClasse7()
        }
    }
    
    func showClasse7() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.classe7.alpha = 1
        }) { (true) in
            self.showClasse8()
        }
    }
    
    func showClasse8() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.classe8.alpha = 1
        }) { (true) in
            self.show5()
        }
    }
    
    func show5() {
        UIView.animate(withDuration: 1, animations: { 
            self.frase4.alpha = 1
        }) { (true) in
            self.showColor1()
        }
    }
    
    func showColor1() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.blueModeButton.alpha = 1
        }) { (true) in
            self.showColor2()
        }
    }
    
    func showColor2() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.redModeButton.alpha = 1
        }) { (true) in
            self.showColor3()
        }
    }
    
    func showColor3() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.darkModeButton.alpha = 1
        }) { (true) in
            self.showColor4()
        }
    }
    
    func showColor4() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.greenModeButton.alpha = 1
        }) { (true) in
            self.showStartButton()
        }
    }
    
    
    func showStartButton() {
        UIView.animate(withDuration: 1) { 
            self.button.alpha = 1
        }
    }
    
    
    
    
    
//    func animation() {
//        UIView.animate(withDuration: 1, animations: {
//            self.imageView.image = UIImage(named: "dark")
//            self.imageView.alpha = 1
//        }) { (true) in
//            UIView.animate(withDuration: 1.5, animations: {
//                self.titolo.alpha = 1
//            }) { (true) in
//                UIView.animate(withDuration: 1.5, animations: {
//                    self.frase1.alpha = 1
//                }, completion: { (true) in
//                    UIView.animate(withDuration: 1.5, animations: {
//                        self.frase2.alpha = 1
//                    }, completion: { (true) in
//                        UIView.animate(withDuration: 1.5, animations: {
//                            self.frase3.alpha = 1
//                        }, completion: { (true) in
//                            UIView.animate(withDuration: 1.5, animations: {
//                                self.textField.alpha = 1
//                            }, completion: { (true) in
//                                UIView.animate(withDuration: 1, animations: {
//                                    self.frase4.alpha = 1
//                                }, completion: { (true) in
//                                    UIView.animate(withDuration: 0.3, animations: {
//                                        self.blueModeButton.alpha = 1
//                                    }, completion: {(true) in
//                                        UIView.animate(withDuration: 0.3, animations: {
//                                            self.redModeButton.alpha = 1
//                                        }, completion: { (true) in
//                                            UIView.animate(withDuration: 0.3, animations: {
//                                                self.darkModeButton.alpha = 1
//                                            }, completion: { (true) in
//                                                UIView.animate(withDuration: 0.3, animations: {
//                                                    self.greenModeButton.alpha = 1
//                                                }, completion: { (true) in
//                                                    UIView.animate(withDuration: 1, animations: {
//                                                        self.button.alpha = 1
//                                                    })
//                                                })
//                                            })
//                                        })
//                                    })
//                                })
//                                
//                            })
//                        })
//                    })
//                })
//            }
//            
//            
//        }
//
//    }

}
