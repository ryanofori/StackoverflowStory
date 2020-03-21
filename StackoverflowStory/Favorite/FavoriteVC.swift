//
//  FavoriteVC.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/6/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController {
    
    @IBOutlet weak var favTableView: UITableView!
    let queue = OperationQueue()
    var favArray = [Items]()
    var urlPath = URLBuilder()
    var passedUserId = 0
    var favURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if passedUserId == 0 {
            let oneBlock = BlockOperation {
                NetworkManager.shared.getData(urlString: self.urlPath.baseUrl + "me?order=desc&sort=reputation&site=stackoverflow" + self.urlPath.newAccessToken + self.urlPath.key) { (info) in
                    
                    let jsonDecoder = JSONDecoder()
                    do {
                        let root = try jsonDecoder.decode(ParseUser.self, from: info)
                        self.passedUserId = root.items[0].user_id ?? 0
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                }
            }
            
            let twoBlock = BlockOperation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    NetworkManager.shared.getData(urlString: self.urlPath.baseUrl + "users/" + String(self.passedUserId) +  "/favorites?order=desc&sort=activity&site=stackoverflow" + self.urlPath.newAccessToken + self.urlPath.key) { (data) in
                        let jsonDecoder = JSONDecoder()
                        do {
                            let root = try jsonDecoder.decode(ParseQuestions.self, from: data)
                            self.favArray = root.items
                            DispatchQueue.main.async {
                                self.favTableView.reloadData()
                            }
                        } catch {
                            NSLog(error.localizedDescription)
                        }
                    }
                }
            }
            queue.addOperation(oneBlock)
            queue.addOperation(twoBlock)
            twoBlock.addDependency(oneBlock)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as? FavWebViewController
        webVC?.passedUrl = favURL
    }
}

extension FavoriteVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favURL = favArray[indexPath.row].link ?? ""
        performSegue(withIdentifier: "favWeb", sender: nil)
    }
}
extension FavoriteVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as? FavoriteTableViewCell
        cell?.favTitle.text = favArray[indexPath.row].title?.html2String
        return cell ?? UITableViewCell()
    }
}
