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
    var urlPath = URLBuilder()
    
    @IBAction private func loginBtn(_ sender: Any) {
        getUserAccessToken()
    }
    @IBAction private func touchIdBtn(_ sender: Any) {
        performAuthOrFallback()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getUserAccessToken() {
        NetworkManager.shared.getData(urlString: urlPath.baseUrl + "me?order=desc&sort=reputation&site=stackoverflow" + urlPath.newAccessToken + urlPath.key) { (info) in
            let jsonDecoder = JSONDecoder()
            do {
                let root = try jsonDecoder.decode(ParseUser.self, from: info)
                self.userId = root.items[0].user_id ?? 0
                self.obtainedInfo()
            } catch {
                self.userId = 0
                self.obtainedInfo()
                NSLog(error.localizedDescription)
            }
        }
    }
    
    func performAuthOrFallback(_ fallback: Bool = false) {
        let context = LAContext()
        var error: NSError?
        var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
        if fallback {
            policy = .deviceOwnerAuthentication
        }
        if context.canEvaluatePolicy(policy, error: &error) {
            context.evaluatePolicy(policy, localizedReason: "bio login auth") { success, autError in
                DispatchQueue.main.async {
                    if success {
                        self.getUserAccessToken()
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
        if userId == 0 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "web", sender: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "info", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as? WebViewController
        webVC?.passedUrl = urlPath.oauth2PostgetAcceesTokenURL
        let favVC = segue.destination as? FavoriteVC
        favVC?.passedUserId = userId
        
    }
}
