//
//  Extensions.swift
//  
//
//  Created by Dani Tox on 23/04/17.
//
//

import UIKit

    let NOTIF_COLORMODE = NSNotification.Name("ColorMode")
    let NOTIF_ACCEDUTO = NSNotification.Name("loginAccount")
    let NOTIF_LOGOUT = NSNotification.Name("Logout")
    let NOTIF_UPDATE_VOTI = NSNotification.Name("updateVotiView")

    func GETcolorMode() -> String {
        if let colorMode = UserDefaults.standard.string(forKey: "ColorMode") {
            switch colorMode {
            case "dark":
                return "dark"
            case "green":
                return "green"
            case "blue":
                return "blue"
            case "red" :
                return "red"
            default:
                print("error in colorMode In Userdefaults -- Func GETcolorMode() ")
                return "dark"
            }
        }
        else {
            print("Error")
            return "Error"
        }
    }
    
    ///////////
    func SETBackgroundColor(color: String) {
       userDefaults(value: color, chiave: "ColorMode")
        NotificationCenter.default.post(name: NOTIF_COLORMODE, object: nil)
    }
    
    func userDefaults(value: String, chiave: String) {
        UserDefaults.standard.set(value, forKey: chiave)
    }
    ///////////


func generaNumero(nMin: UInt32, nMax: UInt32) -> Int {
    let numeroMinimo = UInt32(nMin)
    let numeroMassimo = UInt32(nMax) + 1
    
    if numeroMassimo > numeroMinimo {
        let result = arc4random_uniform((numeroMassimo - numeroMinimo)) + numeroMinimo
        return Int(result)
    }
        
    else {
        return -1
    }
    
}

func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}


extension String {
    func trimTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
}



extension UIViewController {
    func mostraAlert(titolo: String, messaggio: String, tipo: UIAlertControllerStyle) {
        let alert = UIAlertController(title: titolo, message: messaggio, preferredStyle: tipo)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
