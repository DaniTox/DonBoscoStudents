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
    
    func changeBackgroundProva() {
       
        print("Changing background")
    }
  

    override func viewWillAppear(_ animated: Bool) {
        checkAndSetColorMode()
    }
    
    func checkAndSetColorMode() {
        if UserDefaults.standard.string(forKey: "ColorMode") != nil {
            switch UserDefaults.standard.string(forKey: "ColorMode")! {
            case "dark":
                imageView.image = UIImage(named: "dark")
            case "blue":
                imageView.image = UIImage(named: "blue")
            case "red":
                imageView.image = UIImage(named: "red")
            case "zoom":
                    imageView.loadGif(name: "Zoom_CW")
            //imageView.image = UIImage(named: "dark")
            default:
                imageView.image = UIImage(named: "dark")
                print("Error in colormode")
            }
        }
        else {
            print("Error in CM")
        }

    }
    
}
