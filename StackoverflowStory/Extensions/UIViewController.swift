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
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
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
