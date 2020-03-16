//
//  WebViewController.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var passedUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //this should be passed from previous controller via segue
        print(passedUrl)
        guard let url = URL(string: passedUrl) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = self
        //optionals
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
    }
    func navigateToQuestions() {
        performSegue(withIdentifier: "qList", sender: nil)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url?.absoluteURL {
            //if accesstoken contains used ...
            print("url: \(url)")
            let urlString: String = url.absoluteString
            if urlString.contains("access_token=") {
                print("you passed correct url")
                let seperateEqual = urlString.components(separatedBy: "=")
                print(seperateEqual[1])
                let tokenExtra = seperateEqual[1]
                let seperateAnd = tokenExtra.components(separatedBy: "&")
                if !seperateAnd[0].isEmpty {
                    let coreToken = AccessModel()
                    let totalTokens = CoreDataFetchOps.shared.getAllToken()
                    
                    if totalTokens.count == 1 {
                        CoreDataUpdateOps.shared.updateToken(accessToken: seperateAnd[0])
                    } else {
                        CoreDataSaveOps.shared.saveToken(tokenObject: coreToken)
                    }
                    performSegue(withIdentifier: "qList", sender: nil)
                }
            }
        }
        print("Finished navigating to url \(String(describing: webView.url))")
    }
}
