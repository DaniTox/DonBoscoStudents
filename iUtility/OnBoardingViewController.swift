//
//  OnBoardingViewController.swift
//  iUtility
//
//  Created by Dani Tox on 13/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import AVFoundation

class OnBoardingViewController: UIViewController {

    var audioPlayer = AVAudioPlayer()
    
    var colorModeisSelected: Bool = false
    var selectedBlue:Bool = false
    var selectedRed:Bool = false
    var selectedBlack:Bool = false
    var selectedZoom:Bool = false
    
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var frase1: UILabel!
    @IBOutlet weak var frase2: UILabel!
    @IBOutlet weak var frase3: UILabel!
    @IBOutlet weak var frase4: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var blueModeButton: CircleButton!
    @IBOutlet weak var redModeButton: CircleButton!
    @IBOutlet weak var darkModeButton: CircleButton!
    @IBOutlet weak var zoomModeButton: CircleButton!
    
    
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
        textField.alpha = 0
        
        blueModeButton.alpha = 0
        redModeButton.alpha = 0
        darkModeButton.alpha = 0
        zoomModeButton.alpha = 0
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "zoom1", ofType: "aifc")!))
            audioPlayer.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func go(_ sender: UIButton) {
        if textField.text != nil && textField.text != "" && colorModeisSelected {
            UserDefaults.standard.set(textField.text, forKey: "classe")
            
            UserDefaults.standard.set("true", forKey: "OnboardingEffettuato")
            performSegue(withIdentifier: "gotoMainScreen", sender: self)
        }
    }
   
    
    
    @IBAction func bluColorAction(_ sender: UIButton) {
        settaColorMode(mode: "blue")
        printaLaMode()
        
        if selectedBlue == false {
            seleziona(sender: sender, siOno: true)
            selectedBlue = true
            disattivaAltriButton(num1: redModeButton, num2: darkModeButton, num3: zoomModeButton)
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
            disattivaAltriButton(num1: blueModeButton, num2: darkModeButton, num3: zoomModeButton)
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
            disattivaAltriButton(num1: blueModeButton, num2: redModeButton, num3: zoomModeButton)
        }
        else {
            seleziona(sender: sender, siOno: false)
            selectedBlack = false
        }
    }
    
    @IBAction func zoomModeAction(_ sender: UIButton) {
        settaColorMode(mode: "zoom")
        printaLaMode()
        
        if selectedZoom == false {
            seleziona(sender: sender, siOno: true)
            selectedZoom = true
            disattivaAltriButton(num1: blueModeButton, num2: redModeButton, num3: darkModeButton)
            audioPlayer.play()
        }
        else {
            seleziona(sender: sender, siOno: false)
            selectedZoom = false
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
            sender.layer.borderColor = UIColor.green.cgColor
            sender.layer.borderWidth = 1
            switch sender {
            case blueModeButton:
                selectedBlue = true
                selectedZoom = false
                selectedBlack = false
                selectedRed = false
            case redModeButton:
                selectedBlue = false
                selectedZoom = false
                selectedBlack = false
                selectedRed = true
            case darkModeButton:
                selectedBlue = false
                selectedZoom = false
                selectedBlack = true
                selectedRed = false
            case zoomModeButton:
                selectedBlue = false
                selectedZoom = true
                selectedBlack = false
                selectedRed = false
            default:
                print("Error")
            }
        }
        else {
            sender.layer.borderColor = UIColor.green.cgColor
            sender.layer.borderWidth = 0
        }
    }
    
    
    
    
    func disattivaAltriButton(num1:UIButton, num2: UIButton, num3:UIButton) {
        seleziona(sender: num1, siOno: false)
        seleziona(sender: num2, siOno: false)
        seleziona(sender: num3, siOno: false)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func animation() {
        UIView.animate(withDuration: 1, animations: {
            self.imageView.image = UIImage(named: "dark")
            self.imageView.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.titolo.alpha = 1
            }) { (true) in
                UIView.animate(withDuration: 1.5, animations: {
                    self.frase1.alpha = 1
                }, completion: { (true) in
                    UIView.animate(withDuration: 1.5, animations: {
                        self.frase2.alpha = 1
                    }, completion: { (true) in
                        UIView.animate(withDuration: 1.5, animations: {
                            self.frase3.alpha = 1
                        }, completion: { (true) in
                            UIView.animate(withDuration: 1.5, animations: {
                                self.textField.alpha = 1
                            }, completion: { (true) in
                                UIView.animate(withDuration: 1, animations: {
                                    self.frase4.alpha = 1
                                }, completion: { (true) in
                                    UIView.animate(withDuration: 0.3, animations: {
                                        self.blueModeButton.alpha = 1
                                    }, completion: {(true) in
                                        UIView.animate(withDuration: 0.3, animations: {
                                            self.redModeButton.alpha = 1
                                        }, completion: { (true) in
                                            UIView.animate(withDuration: 0.3, animations: {
                                                self.darkModeButton.alpha = 1
                                            }, completion: { (true) in
                                                UIView.animate(withDuration: 0.3, animations: {
                                                    self.zoomModeButton.alpha = 1
                                                }, completion: { (true) in
                                                    UIView.animate(withDuration: 1, animations: {
                                                        self.button.alpha = 1
                                                    })
                                                })
                                            })
                                        })
                                    })
                                })
                                
                            })
                        })
                    })
                })
            }
            
            
        }

    }

}
