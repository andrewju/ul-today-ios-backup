//
//  WebBrowserVC.swift
//  UL Today
//
//  Created by Shilei Mao on 27/05/2018.
//  Copyright © 2018 Andrew Design. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class WebBrowserVC: SFSafariViewController, SFSafariViewControllerDelegate {
    var homeUrl: URL?
    var navTitle: String?
    var showCloseButton: Bool = true
    
    
    class func openBroswer(_ fromVc: UIViewController, url: URL?, title: String?, showCloseButton: Bool) {
        if let url = url {
            let browserVc = WebBrowserVC(url: url)
            browserVc.delegate = browserVc
            fromVc.present(browserVc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closeButtonTapped(_ sender: Any) {
        if let parent = self.parent as? UINavigationController {
            parent.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: webKitView delegate
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { (result, error) in
            if error == nil, let result = result as? String {
                self.title = result
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    // MARK: - safari view controller delegate
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
