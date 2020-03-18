//
//  Alert.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/11/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

class Alert {
    func showAlert(mesageTitle: String, messageDesc: String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: mesageTitle, message: messageDesc, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            viewController.present(alertController, animated: true, completion: nil)
        }
            
    }
}
