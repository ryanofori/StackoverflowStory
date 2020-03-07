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
        //let urlString = URLBuilder.oauth2PostgetAcceesTokenURL
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
                    //store below in core data or keychain
                    //URLBuilder.newAccessToken = seperateAnd[0]
                    
                    let coreToken = AccessModel()
                    //coreToken.token = seperateAnd[0]
                    
                    let totalTokens = CoreDataFetchOps.shared.getAllToken()
                    
                    if totalTokens.count == 1 {
                        // MARK: update token here
                        CoreDataUpdateOps.shared.updateToken(accessToken: seperateAnd[0])
                    } else {
                        CoreDataSaveOps.shared.saveToken(tokenObject: coreToken)
                    }
                    print("in this area")
                    performSegue(withIdentifier: "qList", sender: nil)
                }
                //https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow&access_token=z1vaGikM80AAqybQ5(QsNA))&key=tUo34InxiBQXN3La2wI7Bw((
            }
        }
        print("Finished navigating to url \(String(describing: webView.url))")
    }
}
