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
        imageView.image = UIImage(named: "dark")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  

}
