//
//  CircularView.swift
//  iUtility
//
//  Created by Dani Tox on 27/04/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

@IBDesignable class CircularView: UIView {

    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
           self.layer.cornerRadius = cornerRadius
        }
    }
}

@IBDesignable class CircularLabel: UILabel {
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    
}
