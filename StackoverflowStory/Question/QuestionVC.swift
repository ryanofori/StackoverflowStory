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
    let urlPath = URLBuilder()
    
    @IBAction private func postQuestion(_ sender: Any) {
        let alert = Alert()
        let title = "&title=" + (titleTxt.text ?? "")
        let body = "&body=" + (bodyTxt.text ?? "")
        let tags = "&tags=" + (tagsTxt.text ?? "")
        let sendUrl = title + body + tags
        if titleTxt.text?.count ?? 0 < 15 {
            alert.showAlert(mesageTitle: "Alert!", messageDesc: "Title must be at least 15 characters", viewController: self)
        } else if bodyTxt.text?.count ?? 0 < 30 {
            alert.showAlert(mesageTitle: "Alert", messageDesc: "Body must be at least 30 characters", viewController: self)
        } else {
            NetworkManager.shared.postData(urlString: urlPath.baseUrl + "questions/add/", param: urlPath.key + urlPath.newAccessToken + urlPath.site + sendUrl) { (json) in
                print(json)
                if json["error_message"] != nil {
                        alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                } else {
                    alert.showAlert(mesageTitle: "Success", messageDesc: "You have posted a question", viewController: self)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
}
