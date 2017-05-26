//
//  CircularTextView.swift
//  iUtility
//
//  Created by Dani Tox on 24/05/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

class CircularTextView: UITextView {

    
    @IBDesignable class CircularTextView : UITextView {
        @IBInspectable var cornerRadius : CGFloat = 0 {
            didSet {
                self.layer.cornerRadius = cornerRadius
            }
        }
    }


}
