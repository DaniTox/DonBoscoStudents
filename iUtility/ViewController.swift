//
//  ViewController.swift
//  iUtility
//
//  Created by Dani Tox on 28/12/16.
//  Copyright © 2016 Dani Tox. All rights reserved.
//

import UIKit
import AVFoundation

//let darkColor = UIColor(colorLiteralRed: 0.259, green: 0.259, blue: 0.259, alpha: 1)
let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

class ViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    @IBOutlet weak var imageView: UIImageView!
    
    
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
        
        if UserDefaults.standard.string(forKey: "ColorMode") == "zoom" {
                audioPlayer.play()
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {

        
        if UserDefaults.standard.string(forKey: "ColorMode") != nil {
            switch UserDefaults.standard.string(forKey: "ColorMode")! {
            case "dark":
                imageView.image = UIImage(named: "dark")
            case "blue":
                imageView.image = UIImage(named: "blue")
            case "red":
                imageView.image = UIImage(named: "red")
            case "zoom":
                imageView.image = UIImage(named: "dark")
            default:
                imageView.image = UIImage(named: "dark")
                print("Error in colormode")
            }
        }
        else {
            print("Error in CM")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().clipsToBounds = true
        
        imageView.image = UIImage(named: "dark")
        statusBar.backgroundColor = UIColor.clear
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "zoom2", ofType: "aifc")!))
            audioPlayer.prepareToPlay()
        }
        catch {
            print(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

