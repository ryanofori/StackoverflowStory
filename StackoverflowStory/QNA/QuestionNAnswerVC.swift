//
//  QuestionNAnswerVC.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

class QuestionNAnswerVC: UIViewController {
    @IBOutlet weak var qNATableView: UITableView!
    @IBOutlet weak var postAnswerTxt: UITextField!
    var questionNAnswerArray = [Items]()
    var mainIndex = 0
    var sections = ["Question", "Answer"]
    var sectionAmountArray: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionManager()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func postAnswerBtn(_ sender: Any) {
        postFunc()
    }
    
    func sectionManager() {
        for row in 0...1 {
            sectionAmountArray.append([String]())
            if row == 0 {
                sectionAmountArray[row].append("0")
            } else {
                if questionNAnswerArray[mainIndex].answers?.count != nil {
                    for index in 0...questionNAnswerArray[mainIndex].answers!.count - 1 {
                        sectionAmountArray[row].append(String(index))
                    }
                }
            }
        }
    }
    
    func postFunc() {
        let param: [String: String] = ["key": "tUo34InxiBQXN3La2wI7Bw((",  "access_token": "Wk2E5egkdj(sYLgus*g(2Q))", "site": "stackoverflow.com"]
        guard let url = URL(string: "https://api.stackexchange.com/2.2/questions/25827033/favorite") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            let data = try JSONSerialization.data(withJSONObject: param, options: [])
            request.httpBody = data
        } catch {
            print(error)
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error  in
            if let response = response {
                print(response)
            }
            if let error = error {
                print(error)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
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
extension QuestionNAnswerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .systemGroupedBackground
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .secondaryLabel
    }
}
extension QuestionNAnswerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return questionNAnswerArray[mainIndex].answer_count + 1
        return sectionAmountArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell") as? QNATableViewCell
        cell?.profileName.textColor = .systemBlue
        if indexPath.section == 0 {
            cell?.title.text = questionNAnswerArray[mainIndex].title?.html2String
            cell?.title.font = .boldSystemFont(ofSize: 17.0)
            cell?.questionAnswerDesc.text = questionNAnswerArray[mainIndex].body?.html2String
            cell?.score.text = questionNAnswerArray[mainIndex].score?.description
            if questionNAnswerArray[mainIndex].is_accepted == true {
                cell?.checkmark.isHidden = false
            } else {
                cell?.checkmark.isHidden = true
            }
            cell?.profileName.text = questionNAnswerArray[mainIndex].owner?.display_name
            let tagCommaSeperatedString = questionNAnswerArray[mainIndex].tags?.joined(separator: ", ")
            cell?.tagsLbl.text = tagCommaSeperatedString
            cell?.tagsLbl.textColor = UIColor().colorFromHexString("39729D")
            cell?.reputationLbl.text = questionNAnswerArray[mainIndex].owner?.reputation?.description
            if let imageUrl = URL(string: questionNAnswerArray[mainIndex].owner?.profile_image ?? "") {
                if let data = try? Data(contentsOf: imageUrl) {
                    cell?.profileImage.image = UIImage(data: data)
                }
            }
        } else {
            let indexType = indexPath.row
            cell?.title.text = ""
            cell?.questionAnswerDesc.text = questionNAnswerArray[mainIndex].answers?[indexType].body?.html2String
            cell?.score.text = questionNAnswerArray[mainIndex].answers?[indexType].score?.description
            if questionNAnswerArray[mainIndex].answers?[indexType].is_accepted == true {
                cell?.checkmark.isHidden = false
            } else {
                cell?.checkmark.isHidden = true
            }
            cell?.profileName.text = questionNAnswerArray[mainIndex].answers?[indexType].owner?.display_name
            cell?.reputationLbl.text = questionNAnswerArray[mainIndex].answers?[indexPath.row].owner?.reputation?.description
            cell?.tagsLbl.text = ""
            if let imageUrl = URL(string: questionNAnswerArray[mainIndex].answers?[indexType].owner?.profile_image ?? "") {
                if let data = try? Data(contentsOf: imageUrl) {
                    cell?.profileImage.image = UIImage(data: data)
                }
            }
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionAmountArray.count
    }
}
