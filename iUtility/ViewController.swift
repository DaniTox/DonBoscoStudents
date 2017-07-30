//
//  ViewController.swift
//  iUtility
//
//  Created by Dani Tox on 28/12/16.
//  Copyright © 2016 Dani Tox. All rights reserved.
//

import UIKit
import FirebaseMessaging

//let darkColor = UIColor(colorLiteralRed: 0.259, green: 0.259, blue: 0.259, alpha: 1)
let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

class ViewController: UIViewController {
    //let colorMode = ColorMode()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var numbers: [UIButton]!
    @IBOutlet var ImportantOperations: [UIButton]!
    @IBOutlet var secondaryOperations: [UIButton]!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false {
        didSet {
            if !userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfFloatingPointNumber = false
            }
        }
    }
    private var userIsInTheMiddleOfFloatingPointNumber = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        var digit = sender.currentTitle!
        if digit == "." {
            if userIsInTheMiddleOfFloatingPointNumber {
                return
            }
            if !userIsInTheMiddleOfTyping {
                digit = "0."
            }
            userIsInTheMiddleOfFloatingPointNumber = true
        }
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }

    }
    
    var displayValue: Double  {
        get {
            return Double(display.text!)!
        }

        set {
            
            display.text = String(newValue.cleanValue)
        }
        
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            
            displayValue = result
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {

        coloraButtons()
        modificaGrandezzaNumeri()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        coloraFont()
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        //FIRMessaging.messaging().subscribe(toTopic: "orario")
        
        
        UINavigationBar.appearance().clipsToBounds = true
        statusBar.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(forName: NOTIF_COLORMODE, object: nil, queue: nil) { (notification) in
            self.changeBackground()
        }
        
        changeBackground()
    }

    func changeBackground() {
        if GETcolorMode() == "customImage" {
            let imageURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/customImage.jpg")
            print("URL dell'immagine: \(imageURL)")
            if let image = UIImage(contentsOfFile: imageURL) {
                imageView.image = image
            }
            
        }
        else {
            imageView.image = UIImage(named: GETcolorMode())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func coloraButtons() {
        if let colorNumbers = UserDefaults.standard.string(forKey: "ColorNumbers") {
            switch colorNumbers {
            case "blue":
                for button in numbers {
                    button.backgroundColor = UIColor.blue
                }
            case "green":
                for button in numbers {
                    button.backgroundColor = UIColor.green
                }
            case "red":
                for button in numbers {
                    button.backgroundColor = UIColor.red
                }
            case "black":
                for button in numbers {
                    button.backgroundColor = UIColor.black
                }
            case "white":
                for button in numbers {
                    button.backgroundColor = UIColor.white
                }
            default:
                for button in numbers {
                    button.backgroundColor = UIColor.white
                    
                }
                print("Error in ColorNumbers. Set to default white")
            }
        }
        
        if let colorFirstOperations = UserDefaults.standard.string(forKey: "ColorOperations") {
            switch colorFirstOperations {
            case "blue":
                for button in ImportantOperations {
                    button.backgroundColor = UIColor.blue
                }
            case "green":
                for button in ImportantOperations {
                    button.backgroundColor = UIColor.green
                }
            case "red":
                for button in ImportantOperations {
                    button.backgroundColor = UIColor.red
                }
            case "black":
                for button in ImportantOperations {
                    button.backgroundColor = UIColor.black
                }
            case "white":
                for button in ImportantOperations {
                    button.backgroundColor = UIColor.white
                }
            default:
                for button in ImportantOperations {
                    button.backgroundColor = UIColor.white
                }
                print("Error in ColorNumbers. Set to default white")
            }
 
            
        }
        
        
    }
    
    func coloraFont() {
        if let colorFontNumbers = UserDefaults.standard.string(forKey: "FontNumeriColor") {
            switch colorFontNumbers {
            case "blue":
                for button in numbers {
                    //button.titleLabel?.textColor = UIColor.blue
                    button.setTitleColor(.blue, for: .normal)
                }
            case "green":
                for button in numbers {
                    //button.titleLabel?.textColor = UIColor.green
                    button.setTitleColor(.green, for: .normal)
                }
            case "red":
                for button in numbers {
                    //button.titleLabel?.textColor = UIColor.red
                    button.setTitleColor(.red, for: .normal)
                }
            case "black":
                for button in numbers {
                    //button.titleLabel?.textColor = UIColor.black
                    button.setTitleColor(.black, for: .normal)
                }
            case "white":
                for button in numbers {
                    //button.titleLabel?.textColor = UIColor.white
                    button.setTitleColor(.white, for: .normal)
                }
            default:
                for button in numbers {
                    //button.titleLabel?.textColor = UIColor.black
                    button.setTitleColor(.black, for: .normal)
                    print("Error in font color")
                }
            }
        }
    }
    
    func modificaGrandezzaNumeri() {
        var grandezza = UserDefaults.standard.float(forKey: "GrandezzaNumeri")
        if grandezza <= 1.0 {
            grandezza = 30
        }
            for number in numbers {
                number.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(grandezza))
            }

    
    }
    
    
}

