//
//  WordsCountVC.swift
//  iUtility
//
//  Created by Dani Tox on 24/05/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

class WordsCountVC: UIViewController {

    @IBOutlet weak var cancellaButtonOutlet: UIButton!
    @IBOutlet weak var incollaButtonOutlet: UIButton!
    @IBOutlet weak var contaButtonOutlet: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = nil
        changeBackground()
        
        NotificationCenter.default.addObserver(forName: NOTIF_COLORMODE, object: nil, queue: nil) { (notification) in
            self.changeBackground()
        }
        
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 10
        
        countLabel.layer.masksToBounds = true
        countLabel.layer.cornerRadius = 20
        
        contaButtonOutlet.layer.cornerRadius = 10
        incollaButtonOutlet.layer.cornerRadius = 10
        cancellaButtonOutlet.layer.cornerRadius = 10
        
        
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
    
    @IBAction func countAction() {
       conta()
    }

    @IBAction func clear() {
        textView.text = nil
        conta()
        countLabel.text = "0"
    }

    @IBAction func paste() {
        if let clipboardString = UIPasteboard.general.string {
            textView.text = clipboardString
            conta()
        }
    }
    
    func conta() {
        if textView.text == "" {
            countLabel.text = "0"
        } else {
            let string = textView.text!
            let components = string.components(separatedBy: .whitespacesAndNewlines)
            let words = components.filter({!$0.isEmpty})
            
            countLabel.text = String(describing: words.count)
        }
    }
    
}
