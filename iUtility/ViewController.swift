//
//  ViewController.swift
//  iUtility
//
//  Created by Dani Tox on 28/12/16.
//  Copyright © 2016 Dani Tox. All rights reserved.
//

import UIKit

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

