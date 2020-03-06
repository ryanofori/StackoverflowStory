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
    var itemsArray = [Items]()
    var filteredArray = [Items]()
    var favSwitcher = false
    var mainIndex = 0
    var fetchMore = false
    var searchString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        let newBackButton = UIBarButtonItem(title: "Question", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(fav))
        self.navigationItem.leftBarButtonItem = newBackButton
        searchQuestions.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        print(URLBuilder.newAccessToken)
        guard let url = URL(string: "https://api.stackexchange.com/2.2/questions?page=1&order=desc&sort=activity&filter=!b1MMEUblCwYno1&sort=activity&site=stackoverflow" + Token.token + URLBuilder.key) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            guard let data = data else { return }
            self.parseJSON(data: data)
        })
        task.resume()
    }
    
    func parseJSON(data: Data) {
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
    
    @objc func fav() {
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
            
            getStringToJson(urlString: "https://api.stackexchange.com/2.2/questions?page=" + pageString + "&order=desc&sort=activity&filter=!b1MMEUblCwYno1&sort=activity&site=stackoverflow") { (nextSet) in
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
    @objc
    func switcher(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        print("I found you!")
        print(indexPath?.row)
        if favSwitcher == false {
            favSwitcher = true
        } else {
            favSwitcher = false
        }
        // MARK: Switch color fill
        // MARK: Add core data after here
        //        let cell = self.tableView.cellForRow(at: indexPath) as! UITableViewCell
        //        print(cell.itemLabel.text)//print or get item
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
            getStringToJson(urlString: "https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=" + (trimString ?? "") + "&filter=!b1MMEUblCwYno1&site=stackoverflow") { (searchTerm) in
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
