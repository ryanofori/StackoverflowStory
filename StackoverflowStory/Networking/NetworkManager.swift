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
}
