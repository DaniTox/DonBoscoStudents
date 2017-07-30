//
//  ContainerViewController.swift
//  Pods
//
//  Created by Dani Tox on 10/04/17.
//
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NOTIF_COLORMODE, object: nil, queue: nil) { (notification) in
            self.settaImageView()
        }
        
        settaImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    
    
    func settaImageView() {
        if GETcolorMode() != "customImage" {
            imageView.image = UIImage(named: GETcolorMode())
        }
        else {
            let fileManager = FileManager.default
            let path = (getDirectoryPath() as NSString).appendingPathComponent("customImage.jpg")
            if fileManager.fileExists(atPath: path) {
                print("esiste")
                imageView.image = UIImage(contentsOfFile: path)
            }
        }
    }
    
    
    
    
}
