//
//  ViewController.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/3/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//
import LocalAuthentication
import UIKit

class LoginViewController: UIViewController {
    var itemsObject = [Items]()
    
    @IBAction func webBtn(_ sender: Any) {
        performSegue(withIdentifier: "web", sender: nil)
    }
    
    @IBAction func infoBtn(_ sender: Any) {
        performSegue(withIdentifier: "info", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStringToJson(urlString: "https://api.stackexchange.com/2.2/questions?page=1&order=desc&sort=activity&filter=!b1MMEUblCwYno1&sort=activity&site=stackoverflow" + (URLBuilder.newAccessToken) + URLBuilder.key) { (info) in
            let jsonDecoder = JSONDecoder()
            do {
                let root = try jsonDecoder.decode(ParseQuestions.self, from: info)
                self.itemsObject = root.items
            } catch {
                print(error.localizedDescription)
            }
        }
        print("https://api.stackexchange.com/2.2/questions?page=1&order=desc&sort=activity&filter=!b1MMEUblCwYno1&sort=activity&site=stackoverflow" + (URLBuilder.newAccessToken) + URLBuilder.key)
        performAuthOrFallback()
    }
    
    func performAuthOrFallback(_ fallback: Bool = false) {
        let context = LAContext()
        var error: NSError?
        var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
        if fallback {
            policy = .deviceOwnerAuthentication
        }
        //&error is address of error
        if context.canEvaluatePolicy(policy, error: &error) {
            context.evaluatePolicy(policy, localizedReason: "Need bio auth"){ success, autError in DispatchQueue.main.async {
                if success {
                    print("you are in")
                    self.obtainedInfo()
                    //self.performSegue(withIdentifier: "Info", sender: nil)
                } else {
                    self.performAuthOrFallback(true)
                }
            }
            }
        } else {
            self.performAuthOrFallback(true)
        }
    }
    
    func obtainedInfo() {
        print(itemsObject.count)
        if itemsObject.count == 0 {
            performSegue(withIdentifier: "web", sender: nil)
        } else {
            performSegue(withIdentifier: "info", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as? WebViewController
        webVC?.passedUrl = URLBuilder.oauth2PostgetAcceesTokenURL
        let questListVC = segue.destination as? QuestionListVC
        //Passed Items abject here
        questListVC?.filteredArray = itemsObject
        print("all Totoal")
        print(itemsObject.count)
    }
}
