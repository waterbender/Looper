//
//  LoginWithSiteViewContoller.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/6/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import NVActivityIndicatorView

class LoginWithSiteViewContoller: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    var url = URL(string:"https://www.google.com")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = UIModalPresentationStyle.currentContext
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        //let request = URLRequest(url: URL(string:"https://www.google.com")!)
        let request = URLRequest(url: url!)
        webView.load(request)
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.orange
        activityIndicatorView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LoginWithSiteViewContoller {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       
        let isDebug = false
        if isDebug {
            //print("webView:\(webView) decidePolicyForNavigationAction:\(navigationAction) decisionHandler:\(decisionHandler)")
        }
        
        let launch = LauncherModel()
        if let urlString = navigationAction.request.url {
            launch.recordIfNeedded(url: urlString.absoluteString, compileHendler: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
        }
        
        decisionHandler(.allow)
    }
}
