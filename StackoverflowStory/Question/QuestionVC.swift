//
//  QuestionVC.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/6/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {
    
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var bodyTxt: UITextField!
    @IBOutlet weak var tagsTxt: UITextField!
    
    @IBAction func postQuestion(_ sender: Any) {
        let title = "&title=" + (titleTxt.text ?? "")
        let body = "&body=" + (bodyTxt.text ?? "")
        let tags = "&tags=" + (tagsTxt.text ?? "")
        //var sendUrl = "&title=" + title + "&body=" + body + "&tags=" + tags
        let sendUrl = title + body + tags
        print(sendUrl)
        postFunc(urlString: "https://api.stackexchange.com/2.2/questions/add/", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=d4sFBk6dHwrUwLdIPXX(ZQ))&site=stackoverflow.com" + sendUrl)
//        if titleTxt.text?.count ?? 0 <  15 {
//            showAlert(mesageTitle: "Alert!", messageDesc: "Title must be at least 15 characters")
//        } else if bodyTxt.text?.count ?? 0 < 30 {
//            showAlert(mesageTitle: "Alert", messageDesc: "Body must be at least 30 characters")
//        } else {
//            postFunc(urlString: "https://api.stackexchange.com/2.2/questions/add/", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=d4sFBk6dHwrUwLdIPXX(ZQ))&site=stackoverflow.com" + sendUrl)
//        }
        //post question
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
