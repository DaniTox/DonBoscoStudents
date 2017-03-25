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
        }

    
    override func viewDidAppear(_ animated: Bool) {
       caricaPagina()
    }
    
    func caricaPagina() {
        if giaCaricato == false {
            let urlOrario = URL(string: "http://www.donboscobrescia.it/file/orario.pdf")
            orarioWebView.loadRequest(URLRequest(url: urlOrario!))
            orarioWebView.delegate = self
            giaCaricato = true
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
