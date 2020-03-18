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
    
    var passedUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: passedUrl) else { return }
        let request = URLRequest(url: url)
        favWebView.load(request)
        favWebView.allowsLinkPreview = true
    }
}
