//
//  WebRegisterController.swift
//  MonicaPublic
//
//  Created by Daniel Eriksson on 2019-03-11.
//  Copyright © 2019 CNet. All rights reserved.
//

import UIKit
import WebKit

class WebSurveyController: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    

    override func loadView() {
        super.loadView()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.title = "Answer survey"
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
        
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)
        webView = WKWebView(frame: .zero, configuration: conf)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: "https://da.surveymonkey.com/r/Tivoli_SoundApp")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    
    
    
}
