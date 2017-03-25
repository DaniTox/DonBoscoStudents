//
//  CaricaSchemiTest.swift
//  iUtility
//
//  Created by Dani Tox on 19/03/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import Foundation
import UIKit

class SchemiTest : NSObject {
    func caricaSchemi( testoSelezionato:String ) {
        if let keyWindow = UIApplication.shared.keyWindow {
            let viewSchemi = UIView(frame: keyWindow.frame)
            
            viewSchemi.backgroundColor = UIColor.white

            viewSchemi.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            keyWindow.addSubview(viewSchemi)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                viewSchemi.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
                print("Animazione finita")
            })
            
            let labelScritta = UILabel(frame: CGRect(x: keyWindow.frame.minX, y: keyWindow.frame.height / 2, width: keyWindow.frame.width, height: 50))
            labelScritta.text = "\t\(testoSelezionato)"
            labelScritta.textColor = UIColor.green
            
            labelScritta.lineBreakMode = .byWordWrapping
            labelScritta.font = UIFont(name: "PingFangTC-Thin", size: 50)
            labelScritta.textAlignment = .left
            viewSchemi.addSubview(labelScritta)
            
        }
    }
}
