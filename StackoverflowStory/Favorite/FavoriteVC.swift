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
    let dependentQueue = OperationQueue()
    var favArray = [Items]()
    var urlPath = URLBuilder()
    var passedUserId = 0
    var hasMore = false
    var pageCount = 1
    var favURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if passedUserId == 0 {

            let sema = DispatchSemaphore(value: 0)
            queue.addOperation {
                NetworkManager.shared.getData(urlString: self.urlPath.baseUrl + "me?order=desc&sort=reputation&site=stackoverflow" + self.urlPath.newAccessToken + self.urlPath.key) { (info) in
                    let jsonDecoder = JSONDecoder()
                    do {
                        let root = try jsonDecoder.decode(ParseUser.self, from: info)
                        self.passedUserId = root.items[0].user_id ?? 0
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                    sema.signal()
                }
                _ = sema.wait(timeout: .distantFuture)
            }

            dependentQueue.addOperation {
                self.queue.waitUntilAllOperationsAreFinished()
                NetworkManager.shared.getData(urlString: self.urlPath.baseUrl + "users/" + String(self.passedUserId) +  "/favorites?order=desc&sort=activity&site=stackoverflow" + self.urlPath.newAccessToken + self.urlPath.key) { (data) in
                    let jsonDecoder = JSONDecoder()
                    do {
                        let root = try jsonDecoder.decode(ParseQuestions.self, from: data)
                        self.favArray = root.items
                        self.hasMore = root.has_more
                        DispatchQueue.main.async {
                            self.favTableView.reloadData()
                        }
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                }
            }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == favArray.count - 1 {
            if hasMore {
                pageCount += 1
                let pageString = String(pageCount)
                NetworkManager.shared.getData(urlString: self.urlPath.baseUrl + "users/" + String(self.passedUserId) +  "/favorites?page=" + pageString + "&order=desc&sort=activity&site=stackoverflow"  + self.urlPath.newAccessToken + self.urlPath.key) { (data) in
                    let jsonDecoder = JSONDecoder()
                    do {
                        let root = try jsonDecoder.decode(ParseQuestions.self, from: data)
                        self.favArray += root.items
                        self.hasMore = root.has_more
                        DispatchQueue.main.async {
                            self.favTableView.reloadData()
                        }
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                }
            }
        }
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
