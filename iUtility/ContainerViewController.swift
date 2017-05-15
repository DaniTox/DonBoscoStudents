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
        imageView.image = UIImage(named: GETcolorMode())
    }
    
    
    
    
}
