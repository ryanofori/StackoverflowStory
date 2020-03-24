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
    @IBOutlet weak var sortPicker: UIPickerView!
    var urlPath = URLBuilder()
    var itemsArray = [Items]()
    var filteredArray = [Items]()
    var sortArray = ["activity", "votes", "creation", "hot", "week", "month"]
    var mainIndex = 0
    var fetchMore = false
    var searchString = ""
    var trimString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        let newBackButton = UIBarButtonItem(title: "Question", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(quest))
        self.navigationItem.leftBarButtonItem = newBackButton
        searchQuestions.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        hideKeyboardWhenTappedAround()
        NetworkManager.shared.getData(urlString: urlPath.baseUrl + "questions?page=1&order=desc" + urlPath.sort + urlPath.filter + urlPath.sort + "&site=stackoverflow" + urlPath.newAccessToken + urlPath.key) { (data) in
            let jsonDecoder = JSONDecoder()
            do {
                let root = try jsonDecoder.decode(ParseQuestions.self, from: data)
                self.itemsArray = root.items
                self.filteredArray = self.itemsArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
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
            var pickedUrl = ""
            if searchString.isEmpty {
                pickedUrl = urlPath.baseUrl + "questions?page=" + pageString + "&order=desc&sort=activity" + urlPath.filter + "&sort=activity&site=stackoverflow" + urlPath.newAccessToken + urlPath.key
            } else {
                pickedUrl = urlPath.baseUrl + "search?order=desc" + urlPath.sort + "&intitle=" + (trimString) + "&page=" + pageString + urlPath.filter + urlPath.newAccessToken + urlPath.key + urlPath.site
            }
            
            NetworkManager.shared.getData(urlString: pickedUrl) { (nextSet) in
                let jsonDecoder = JSONDecoder()
                do {
                    let root = try jsonDecoder.decode(ParseQuestions.self, from: nextSet)
                    self.filteredArray += root.items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    NSLog(error.localizedDescription)
                }
            }
            fetchMore = false
        }
    }
    
}
extension QuestionListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        if searchText.isEmpty {
            filteredArray = itemsArray
            tableView.reloadData()
        }
        if !searchText.isEmpty {
            trimString = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            NetworkManager.shared.getData(urlString: urlPath.baseUrl + "search?order=desc" + urlPath.sort + "&intitle=" + (trimString) + urlPath.filter + urlPath.newAccessToken + urlPath.key + urlPath.site) { (searchTerm) in
                let jsonDecoder = JSONDecoder()
                do {
                    let root = try jsonDecoder.decode(ParseQuestions.self, from: searchTerm)
                    self.filteredArray = root.items
                    self.searchString = searchText
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    NSLog(error.localizedDescription)
                }
            }
        }
    }
}
extension QuestionListVC: UIPickerViewDelegate {
    
}

extension QuestionListVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        urlPath.sort = "&sort=" + sortArray[row]
        NetworkManager.shared.getData(urlString: urlPath.baseUrl + "questions?order=desc" + urlPath.sort + urlPath.filter + urlPath.sort + urlPath.site + urlPath.newAccessToken + urlPath.key) { (data) in
            let jsonDecoder = JSONDecoder()
            do {
                let root = try jsonDecoder.decode(ParseQuestions.self, from: data)
                self.itemsArray = root.items
                self.filteredArray = self.itemsArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
    
}
