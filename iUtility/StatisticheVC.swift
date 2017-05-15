//
//  StatisticheVC.swift
//  iUtility
//
//  Created by Dani Tox on 07/05/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

var materiaStats: String?

class StatisticheVC: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addMarkTxtField: UITextField!
    @IBOutlet weak var allMarks: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    
    var votiInglese = [Int]()
    var votiItaliano = [Int]()
    var votiMatematica = [Int]()
    var votiLaboratorio = [Int]()
    var votiTeconlogia = [Int]()
    var votiDisegno = [Int]()
    var votiInformatica = [Int]()
    var votiScienze = [Int]()
    var votiNarrativa = [Int]()
    var votiReligione = [Int]()
    var votiPneumatica = [Int]()
    var votiPLC = [Int]()
    var votiEDFisica = [Int]()
    var votiElettrotecnica = [Int]()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: GETcolorMode())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func usrDef(value: Any, chiave: String) {
        UserDefaults.standard.set(value, forKey: chiave)
    }
    
    
    @IBAction func addMarkButton() {
        
    }
    
    @IBAction func bacButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func calcMedia(voti: [Int]) -> Double {
        var total = 0.0
        
        for i in voti {
            total += Double(i)
        }
        
        let media = total / Double(voti.count)
        return media
    }

}
