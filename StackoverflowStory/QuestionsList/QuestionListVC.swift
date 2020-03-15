//
//  QuestionListVC.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

class QuestionListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchQuestions: UISearchBar!
    var urlPath = URLBuilder()
    var itemsArray = [Items]()
    var filteredArray = [Items]()
    var favSwitcher = false
    var mainIndex = 0
    var fetchMore = false
    var searchString = ""
    
    @IBOutlet weak var sortBtn: UIButton!
    @IBAction func sortBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Select sort type", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Activity", style: .default, handler: { action in
            self.sortBtn.titleLabel?.text = "Activity"
        }))
        alert.addAction(UIAlertAction(title: "Votes", style: .default, handler: { action in
            self.sortBtn.titleLabel?.text = "Votes"
        }))
        alert.addAction(UIAlertAction(title: "Creation", style: .default, handler: { action in
            self.sortBtn.titleLabel?.text = "Creation"
        }))
        alert.addAction(UIAlertAction(title: "Hot", style: .default, handler: { action in
            self.sortBtn.titleLabel?.text = action.title
        }))
        alert.addAction(UIAlertAction(title: "Week", style: .default, handler: { action in
            self.sortBtn.titleLabel?.text = action.title
        }))
        alert.addAction(UIAlertAction(title: "Month", style: .default, handler: { action in
            self.sortBtn.titleLabel?.text = "Month"
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        print(sortBtn.titleLabel?.text)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sortBtn.titleLabel?.text = "Sort"
        navigationItem.setHidesBackButton(true, animated: true)
        let newBackButton = UIBarButtonItem(title: "Question", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(quest))
        self.navigationItem.leftBarButtonItem = newBackButton
        searchQuestions.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        print(urlPath.newAccessToken)
        print(itemsArray.count)
        guard let url = URL(string: "https://api.stackexchange.com/2.2/questions?page=1&order=desc&sort=activity&filter=!FnhX5sXiIrG3hI*4CNkiuWygeb&sort=activity&site=stackoverflow" + urlPath.newAccessToken + urlPath.key) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            guard let data = data else { return }
            self.parseJSON(data: data)
        })
        task.resume()
        
    }
    
    func parseJSON(data: Data) {
//        if let jsonString = String(data: data, encoding: .utf8){
//            //Allows you to see the json in console
//            print(jsonString)
//        }
        let jsonDecoder = JSONDecoder()
        do {
            let root = try jsonDecoder.decode(ParseQuestions.self, from: data)
            //            let itemsGroup = root.items[0]
            self.itemsArray = root.items
            self.filteredArray = self.itemsArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let questionNAnswerVC = segue.destination as? QuestionNAnswerVC
        questionNAnswerVC?.mainIndex = mainIndex
        questionNAnswerVC?.questionNAnswerArray = filteredArray
    }
    
    @objc
    func quest() {
        performSegue(withIdentifier: "quest", sender: nil)
    }
    
}
extension QuestionListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainIndex = indexPath.row
        //        questionId = filteredArray[indexPath.row].question_id ?? 0
        //        questionTitle = filteredArray[indexPath.row].title?.html2String ?? ""
        performSegue(withIdentifier: "qna", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var pageCount = 1
        if indexPath.row == filteredArray.count - 1 {
            fetchMore = true
        }
        if fetchMore == true {
            pageCount += 1
            let pageString = String(pageCount)
            
            if searchString.isEmpty == true {
                
            } else {
                
            }
            
            NetworkManager.shared.getData(urlString: "https://api.stackexchange.com/2.2/questions?page=" + pageString + "&order=desc&sort=activity&filter=!b1MMEUblCwYno1&sort=activity&site=stackoverflow") { (nextSet) in
                let jsonDecoder = JSONDecoder()
                do {
                    let root = try jsonDecoder.decode(ParseQuestions.self, from: nextSet)
                    self.filteredArray += root.items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            fetchMore = false
        }
    }
    
}
extension QuestionListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("I'm messing with things!")
        print(filteredArray.count)
        return filteredArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "qCell") as? QuestionTableViewCell
        cell?.questionTxt.text = filteredArray[indexPath.row].title?.html2String
        return cell ?? UITableViewCell()
    }
}

extension QuestionListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.isEmpty == true {
            filteredArray = itemsArray
            tableView.reloadData()
        }
        //        } else {
        //            filteredArray = itemsArray.filter({ item -> Bool in
        //                return item.title?.range(of: searchText) != nil
        //            })
        //        }
        if searchText.isEmpty == false {
            let trimString = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            NetworkManager.shared.getData(urlString: "https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=" + (trimString ?? "") + "&filter=!b1MMEUblCwYno1&site=stackoverflow") { (searchTerm) in
                let jsonDecoder = JSONDecoder()
                do {
                    let root = try jsonDecoder.decode(ParseQuestions.self, from: searchTerm)
                    self.filteredArray = root.items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
