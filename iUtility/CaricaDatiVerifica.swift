//
//  CaricaDatiVerifica.swift
//  iUtility
//
//  Created by Dani Tox on 19/03/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

class GraficiView: UIView {
    
    var containerLabelAndCommandView : UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }
    
    
    var labelTest : UILabel {
//        let x : CGFloat = self.frame.width / 2
//        let y : CGFloat = 25
//        let width = CGFloat(200)
//        let height = CGFloat(30)
//        let frame = CGRect(x: x, y: y, width: width, height: height)
//        let label = UILabel(frame: frame)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.green
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 25)
        label.text = "Questa funziona non è ancora disponibile"
        return label
    }
    
    var spazioGraficiView : UIView {
        let view = UIView()
        //IMPOSTAZIONE DELLE COORDINATE/FRAME DELLA VIEW
        let x : CGFloat = 0
        let y : CGFloat = 125
        let width = CGFloat(self.frame.width) - x
        let height = CGFloat(self.frame.height) - y
        let frame = CGRect(x: x, y: y, width: width, height: height)
        view.frame = frame
        //FINE IMPOSTAZIONE DELLE COORDINATE/FRAME DELLA VIEW
        
        print("Height : \(self.frame.height)\nWidth: \(self.frame.width)")
        view.backgroundColor = UIColor.blue
        labelTest.frame = CGRect(x: 50, y: 50, width: 300, height: 50)

        addSubview(labelTest)
        return view
    }
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
        
        addSubview(spazioGraficiView)
        
        containerLabelAndCommandView.frame = frame
        addSubview(containerLabelAndCommandView)
        //labelTest.frame = CGRect(x: 50, y: 50, width: 300, height: 50)
        //addSubview(labelTest)

   //     labelTest.topAnchor.constraint(equalTo: self.containerLabelAndCommandView.topAnchor).isActive = true
   //     labelTest.leftAnchor.constraint(equalTo: self.containerLabelAndCommandView.centerXAnchor).isActive = true
   //     labelTest.widthAnchor.constraint(equalToConstant: 200).isActive = true
   //     labelTest.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CaricaDatiVerifica: NSObject {
   
    func caricaTabellaMateria() {
        if let keyWindow = UIApplication.shared.keyWindow {
           
            //INIZIALIZZAZIONE DELLA VIEW MADRE
            let frame = CGRect(x: keyWindow.frame.width, y: keyWindow.frame.height, width: 1, height: 1)
            let view = GraficiView(frame: keyWindow.frame)
            view.frame = frame
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                view.frame = keyWindow.frame
            }, completion: { (completedAnimation) in
                print("Animazione completata")
            })
            //FINE DELL'INIZIALIZZAZIONE
        }
    }
    
    
}
