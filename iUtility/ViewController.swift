//
//  ViewController.swift
//  iUtility
//
//  Created by Dani Tox on 28/12/16.
//  Copyright © 2016 Dani Tox. All rights reserved.
//

import UIKit

let darkColor = UIColor(colorLiteralRed: 0.259, green: 0.259, blue: 0.259, alpha: 1)
let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

class ViewController: UIViewController {
    
    
    
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
    
    func changeColorMode(mode: String) {
        switch mode {
        case "dark":
            display.textColor = UIColor.white
            display.backgroundColor = darkColor
            statusBar.backgroundColor = darkColor
            self.view.backgroundColor = darkColor
        case "white":
            display.textColor = UIColor.black
            display.backgroundColor = UIColor.white
            statusBar.backgroundColor = UIColor.white
            self.view.backgroundColor = UIColor.green
            
        default:
            print("Error in color mode")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "colormode") != nil {
            switch UserDefaults.standard.string(forKey: "colormode")! {
            case "dark":
                changeColorMode(mode: "dark")
            case "white":
                changeColorMode(mode: "white")
            default:
                print("Nessuna color mode rilevata")
            }
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        UINavigationBar.appearance().clipsToBounds = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

