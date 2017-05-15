//
//  ModelNumeriCasuali.swift
//  iUtility
//
//  Created by Dani Tox on 17/03/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import Foundation

class NumeriCasualiClass : NSObject {
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
}
