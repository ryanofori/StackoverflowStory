//
//  FavWebViewController.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/6/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit
import WebKit
class FavWebViewController: UIViewController {
    
    @IBOutlet weak var favWebView: WKWebView!
    var passedUrl = "https://www.google.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: passedUrl) else { return }
        let request = URLRequest(url: url)
        favWebView.load(request)
        
        //optionals
        favWebView.allowsBackForwardNavigationGestures = true
        favWebView.allowsLinkPreview = true
        // Do any additional setup after loading the view.
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
