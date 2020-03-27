//
//  UIViewController.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/16/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

@objc extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        view.frame.origin.y = 0
    }
}
