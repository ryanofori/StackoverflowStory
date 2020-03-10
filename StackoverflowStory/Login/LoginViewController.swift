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
    var userId = 0
    
    @IBAction func webBtn(_ sender: Any) {
        performSegue(withIdentifier: "web", sender: nil)
    }
    @IBAction func infoBtn(_ sender: Any) {
        performSegue(withIdentifier: "info", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if access token works
        getStringToJson(urlString: "https://api.stackexchange.com/2.2/me?order=desc&sort=reputation&site=stackoverflow" + URLBuilder.newAccessToken + URLBuilder.key) { (info) in
            let jsonDecoder = JSONDecoder()
            do {
                let root = try jsonDecoder.decode(ParseUser.self, from: info)
                print(root.items[0].user_id)
                self.userId = root.items[0].user_id ?? 0
                print("something else is happening")
                print(self.userId)
            } catch {
                self.userId = 0
                print(error.localizedDescription)
            }
        }
        
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
            context.evaluatePolicy(policy, localizedReason: "Need bio auth") { success, autError in DispatchQueue.main.async {
                if success {
                    print("you are in")
                    self.obtainedInfo()
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
        print(userId)
        if userId == 0 {
            performSegue(withIdentifier: "web", sender: nil)
        } else {
            performSegue(withIdentifier: "info", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as? WebViewController
        webVC?.passedUrl = URLBuilder.oauth2PostgetAcceesTokenURL
        let favVC = segue.destination as? FavoriteVC
        favVC?.passedUserId = userId
        
    }
}
