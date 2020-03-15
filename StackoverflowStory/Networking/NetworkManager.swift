//
//  NetworkManager.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/7/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func getData(urlString: String, completion: @escaping(Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
    }
    
    func postData(urlString: String, param: String, completion: @escaping([String: Any]) -> Void) {
//        let alert = Alert()
        let param: String = param
        let data = param.data(using: .utf8)
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error  in
//            if let response = response {
//                print(response)
//            }
            if let error = error {
                print(error)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    //print(json)
                    completion(json ?? ["": (Any).self])
                    if let errorMessage = json?["error_message"] as? String? {
                        let errorTitle = json?["error_message"] as? String
//                        alert.showAlert(mesageTitle: errorTitle ?? "", messageDesc: errorMessage ?? "", viewController: viewController)
//                        Alert.showAlert(Alert)
                        
                    }
                } catch {
                    print(error)
                }
            }
            //                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            //print(response)
        })
        task.resume()
    }
}
