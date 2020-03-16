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
    //first below?
    var favArray = [Items]()
    var urlPath = URLBuilder()
    var passedUserId = 0
    var favURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(passedUserId)
        if passedUserId == 0 {
            //failed to get iDNumber
            //get iDNumber again
            NetworkManager.shared.getData(urlString: "https://api.stackexchange.com/2.2/me?order=desc&sort=reputation&site=stackoverflow" + urlPath.newAccessToken + urlPath.key) { (info) in
                
                let jsonDecoder = JSONDecoder()
                do {
                    let root = try jsonDecoder.decode(ParseUser.self, from: info)
                    self.passedUserId = root.items[0].user_id ?? 0
                } catch {
                    print(error.localizedDescription)
                }
            }
            print(passedUserId)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                print("thos may work")
                print(self.passedUserId)
                NetworkManager.shared.getData(urlString: "https://api.stackexchange.com/2.2/users/" + String(self.passedUserId) +  "/favorites?order=desc&sort=activity&site=stackoverflow" + self.urlPath.newAccessToken + self.urlPath.key) { (data) in
//                    if let jsonString = String(data: data, encoding: .utf8){
//                        //Allows you to see the json in console
//                        print(jsonString)
//                    }
                    let jsonDecoder = JSONDecoder()
                    do {
                        let root = try jsonDecoder.decode(ParseQuestions.self, from: data)
                        //            let itemsGroup = root.items[0]
                        print("if favArray")
                        print(root.items.count)
                        self.favArray = root.items
                        DispatchQueue.main.async {
                            self.favTableView.reloadData()
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            //then show favs
        } else {
            //got the person's iDNumber
            //Now show there favs using
            //currently will never be called unless you can get the userID
            NetworkManager.shared.getData(urlString: "https://api.stackexchange.com/2.2/users/" + String(passedUserId) +  "/favorites?order=desc&sort=activity&site=stackoverflow" + urlPath.newAccessToken + urlPath.key) { (data) in
                let jsonDecoder = JSONDecoder()
                do {
                    let root = try jsonDecoder.decode(ParseQuestions.self, from: data)
                    //            let itemsGroup = root.items[0]
                    print("else favArray")
                    print(root.items.count)
                    self.favArray = root.items
                    DispatchQueue.main.async {
                        self.favTableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as? FavWebViewController
        print(favURL)
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
    
    //optional (delte if you can't get to it)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
        }
    }
}
