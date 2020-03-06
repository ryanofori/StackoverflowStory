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
    
    @IBAction func webBtn(_ sender: Any) {
        performSegue(withIdentifier: "web", sender: nil)
    }
    
    @IBAction func infoBtn(_ sender: Any) {
        performSegue(withIdentifier: "info", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //performAuthOrFallback()
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
            context.evaluatePolicy(policy, localizedReason: "Need bio auth")
            { success, autError in DispatchQueue.main.async {
                if success {
                    print("you are in")
                    self.performSegue(withIdentifier: "Info", sender: nil)
                    //self.navigateToSecondVC()
                } else {
                    self.performAuthOrFallback(true)
                }
            }
            }
        } else {
            self.performAuthOrFallback(true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as? WebViewController
        webVC?.passedUrl = URLBuilder.oauth2PostgetAcceesTokenURL
    }
}
