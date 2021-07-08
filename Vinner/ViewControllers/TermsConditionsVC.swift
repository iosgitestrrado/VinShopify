//
//  TermsConditionsVC.swift
//  Vinner
//
//  Created by softnotions on 27/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import WebKit

class TermsConditionsVC: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webViewTerms: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.navigationController?.navigationBar.topItem?.title = "Terms And Conditions"
        
        self.title = "Terms And Conditions"
          self.navigationController?.navigationBar.topItem?.title = " "
        self.webViewTerms.navigationDelegate = self
        let url = URL(string: Constants.termConditionURL)!
        self.webViewTerms.load(URLRequest(url: url))
        self.webViewTerms.allowsBackForwardNavigationGestures = true
        
        self.view.activityStartAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url \(String(describing: webView.url))");
        self.view.activityStopAnimating()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
