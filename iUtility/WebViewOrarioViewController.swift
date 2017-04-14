//
//  WebViewOrarioViewController.swift
//  iUtility
//
//  Created by Dani Tox on 28/01/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

class WebViewOrarioViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    
    var giaCaricato:Bool = false
    
    @IBOutlet weak var statoPaginaLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var orarioWebView: UIWebView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var scrollView: UIScrollView!
    
    @IBAction func reloadPage() {
        orarioWebView.reload()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let urlOrario = URL(string: "http://www.donboscobrescia.it/file/orario.pdf")
        //orarioWebView.loadRequest(URLRequest(url: urlOrario!))
        //orarioWebView.delegate = self
        //caricaPagina()
        

        
        //imageView.image = UIImage(named: "dark")
        }

    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .background).async {
            self.caricaPagina()
        }
        
        if UserDefaults.standard.string(forKey: "ColorMode") != nil {
            switch UserDefaults.standard.string(forKey: "ColorMode")! {
            case "dark":
                imageView.image = UIImage(named: "dark")
            case "blue":
                imageView.image = UIImage(named: "blue")
            case "red":
                imageView.image = UIImage(named: "red")
            case "green":
                imageView.image = UIImage(named: "green")
            default:
                imageView.image = UIImage(named: "dark")
                print("Error in colormode")
            }
        }
        else {
            print("Error in CM")
        }
        
    }
    
    func caricaPagina() {
        if giaCaricato == false {
            var orarioStringUrl:String?
            if UserDefaults.standard.string(forKey: "ColorMode") != "zoom" {
                if UserDefaults.standard.bool(forKey: "linkCorretti") != true {
                    orarioStringUrl = "http://www.donboscobrescia.it/file/orario.pdf"
                    print("LOG: UserDefault per i link corretti NON SETTATO oppure è uguale a FALSE. Quindi si usa lo  standard link")
                }
                else {
                    orarioStringUrl = UserDefaults.standard.string(forKey: "LinkOrario")
                    print("LOG: UserDefault per i link corretti SETTATO a TRUE. Vuol dire che sono stati corretti e il link usato è quello negli UserDefault")
                }
                if let urlOrario = URL(string: orarioStringUrl!) {
                    orarioWebView.loadRequest(URLRequest(url: urlOrario))
                    orarioWebView.delegate = self
                    giaCaricato = true
                }
                else {
                    let alert = UIAlertController(title: "Errore", message: "Probabilmente c'è qualche errore con i link. Prova a coreggerli nelle impostazioni", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
            }
            else  {
                orarioWebView.loadRequest(URLRequest(url: URL(string: "https://fsmedia.imgix.net/49/dd/62/9d/6929/488f/b462/2e2778ca886e/the-flash-season-2-finale-zoom.jpeg?rect=0%2C30%2C800%2C400&auto=format%2Ccompress&w=1800&q=70")!))
            }
        }
        
    }
    
   
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        self.progressBar.setProgress(0.1, animated: false)
        self.statoPaginaLabel.textColor = UIColor.yellow
        self.statoPaginaLabel.text = "Sto caricando"
        self.progressBar.isHidden = false
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.progressBar.setProgress(1.0, animated: true)
        self.statoPaginaLabel.textColor = UIColor.green
        self.statoPaginaLabel.text = "Caricato"
        self.progressBar.isHidden = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.progressBar.setProgress(1.0, animated: true)
        self.statoPaginaLabel.textColor = UIColor.red
        self.statoPaginaLabel.text = "Errore di connessione"
        self.progressBar.isHidden = true
    }
    
    
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   
}
