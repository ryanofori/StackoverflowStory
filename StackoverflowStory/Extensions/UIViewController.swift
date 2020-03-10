//
//  ViewController.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/6/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

extension UIViewController {
    func getStringToJson(urlString: String, completion: @escaping(Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
    }
    
    func postFunc(urlString: String, param: String) {
        let param: String = param
        let data = param.data(using: .utf8)
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error  in
            if let response = response {
                print(response)
            }
            if let error = error {
                print(error)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("This is an error and that is bad")
                    print(json)
                } catch {
                    print(error)
                }
            }
            //                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            //print(response)
        })
        task.resume()
    }
    
    func showAlert(mesageTitle: String, messageDesc: String) {
        let alertController = UIAlertController(title: mesageTitle,
                                                message: messageDesc,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //result
    //be a singleton
//    func loadData(urlString: String, completed: @escaping (Data) -> Void) {
//        guard let url = URL(string: urlString) else { return }
//        let task = URLSession.shared.dataTask(with: url) { data, response, error) in
//            guard let data = data else { return }
//            completion(data)
//        }task.resume
//    }
    
}
