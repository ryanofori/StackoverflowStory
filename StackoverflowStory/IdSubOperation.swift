//
//  SubOperation.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/20/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

class IdSubOperation: Operation {
    
    var favsVC = FavoriteVC()
    let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    override func main() {
                
        NetworkManager.shared.getData(urlString: urlString) { (data) in
            let jsonDecoder = JSONDecoder()
            do {
                let root = try jsonDecoder.decode(ParseUser.self, from: data)

                self.favsVC.passedUserId = root.items[0].user_id ?? 0
//                print("I am 1")
//                print(root.items[0].user_id)
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        
    }
    
//    func getData(urlString: String, completion: @escaping(Data) -> Void) {
//        guard let url = URL(string: urlString) else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        let task = URLSession.shared.dataTask(with: request) {data, response, error in
//            guard let data = data else { return }
//            completion(data)
//        }
//        task.resume()
//    }
    
}

class DataSubOperation: IdSubOperation {
    
    var tableView: UITableView
    
    init(urlString: String, tableView: UITableView) {
        self.tableView = tableView
        super.init(urlString: urlString)
    }
    override func main() {
        print(favsVC.passedUserId)
        NetworkManager.shared.getData(urlString: urlString) { (data) in
            print(self.urlString)
            if let jsonString = String(data: data, encoding: .utf8){
                //Allows you to see the json in console
                print(jsonString)
            }
            let jsonDecoder = JSONDecoder()
            do {
                let root = try jsonDecoder.decode(ParseQuestions.self, from: data)
                self.favsVC.favArray = root.items
                self.favsVC.hasMore = root.has_more
                print(self.favsVC.favArray.count)
                print("I am 2")
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
}
