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
    @IBOutlet weak var answerTxt: UITextField!
    var questionNAnswerArray = [Items]()
    var mainIndex = 0
    var sections = ["Question", "Answer"]
    var sectionAmountArray: [[String]] = []
    let alert = Alert()
    let urlPath = URLBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(questionNAnswerArray[mainIndex].question_id)
        hideKeyboardWhenTappedAround()
        sectionManager()
    }
    
    @IBAction private func postAnswerBtn(_ sender: Any) {
        let bodyText = "&body=" + (answerTxt.text ?? "")
        if answerTxt.text?.count ?? 0 < 30 {
            alert.showAlert(mesageTitle: "Alert", messageDesc: "Body must be at least 30 characters", viewController: self)
        } else {
            NetworkManager.shared.postData(urlString: urlPath.baseUrl + "questions/" + "60604558" + "/answers/add/", param: urlPath.key + urlPath.newAccessToken + urlPath.site + bodyText) { (json) in
                if json["error_message"] != nil {
                        self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                } else {
                    self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have sent answer", viewController: self)
                }
            }
        }
    }
    
    func sectionManager() {
        print("mainIndex")
        print(mainIndex)
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
        return sectionAmountArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell") as? QNATableViewCell
        cell?.profileName.textColor = .systemBlue
        cell?.cellDelegate = self
        cell?.upVote.row = indexPath.row
        cell?.upVote.section = indexPath.section
        cell?.downVote.row = indexPath.row
        cell?.downVote.section = indexPath.section
        cell?.favBtn.row = indexPath.row
        cell?.favBtn.section = indexPath.section
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
            cell?.favBtn.isHidden = false
            //if true yellow else false gray
            if questionNAnswerArray[mainIndex].upvoted == true {
                cell?.upVote.tintColor = .yellow
            } else {
                cell?.upVote.tintColor = .gray
            }
            if questionNAnswerArray[mainIndex].downvoted == true {
                cell?.downVote.tintColor = .yellow
            } else {
                cell?.downVote.tintColor = .gray
            }
            if questionNAnswerArray[mainIndex].favorited == true {
                cell?.favBtn.tintColor = .yellow
            } else {
                cell?.favBtn.tintColor = .gray
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
            cell?.favBtn.isHidden = true
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
extension QuestionNAnswerVC: QNACellDelegete {
    func didTapUpVote(section: Int, row: Int) {
        print("section: \(section) and row: \(row)")
        let questionIdString = String(questionNAnswerArray[mainIndex].question_id)
        if section == 0 {
            print(questionNAnswerArray[mainIndex].question_id)
            print("section:")
            
            //upVotes a question
            if questionNAnswerArray[mainIndex].upvoted == true {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl + "questions/" + questionIdString + "/upvote/undo", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have un-upvoted a question", viewController: self)
                    }
                }
            } else {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl + "questions/" + questionIdString + "/upvote/", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have upvoted a question", viewController: self)
                    }
                }
            }

        } else {
            let answerIdString = questionNAnswerArray[mainIndex].answers?[row].answer_id.description ?? ""
            NetworkManager.shared.postData(urlString: urlPath.baseUrl + "answers/" + answerIdString + "/upvote", param: urlPath.key + urlPath.newAccessToken + urlPath.site ) { (json) in
                if json["error_message"] != nil {
                        self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                } else {
                    self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have upvoted an answer", viewController: self)
                }
            }
        }
        //answer
        fetchUpdatedQNA(questionIdString: questionIdString)
    }
    
    func didTapDownVote(section: Int, row: Int) {
        print("section- \(section) and row- \(row)")
        let questionIdString = String(questionNAnswerArray[mainIndex].question_id)
        if section == 0 {
            //Downvote a question
            if questionNAnswerArray[mainIndex].downvoted == true {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl + "questions/" + questionIdString + "/downvote/undo", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have un-downvoted a question", viewController: self)
                    }
                }
            } else {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl + "questions/" + questionIdString + "/downvote", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have downvoted a question", viewController: self)
                    }
                }
            }
        } else {
            let answerIdString = questionNAnswerArray[mainIndex].answers?[row].answer_id.description ?? ""
            
            NetworkManager.shared.postData(urlString: urlPath.baseUrl + "answers/" + answerIdString + "/downvote", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                if json["error_message"] != nil {
                        self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                } else {
                    self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have downvoted an answer", viewController: self)
                }
            }
        }
        fetchUpdatedQNA(questionIdString: questionIdString)
    }
    
    func didTapFav(section: Int, row: Int) {
        print("section* \(section) and row* \(row)")
        let questionIdString = String(questionNAnswerArray[mainIndex].question_id)
        if section == 0 {
            //fav a question
            if questionNAnswerArray[mainIndex].favorited == true {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl +  "questions/" + questionIdString + "/favorite/undo", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have unfavorited a question", viewController: self)
                    }
                }
                print("I have unfavorited")
                
            } else {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl + "questions/" + questionIdString + "/favorite/", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                        
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have favorited a question", viewController: self)
                    }
                }
            }
            fetchUpdatedQNA(questionIdString: questionIdString)
        }
        
    }
    func fetchUpdatedQNA(questionIdString: String) {
        NetworkManager.shared.getData(urlString: urlPath.baseUrl + "questions/" + questionIdString + "?order=desc&sort=activity&site=stackoverflow" + urlPath.filter + urlPath.newAccessToken + urlPath.key ) { (data) in
            let jsonDecoder = JSONDecoder()
            do {
                let root = try jsonDecoder.decode(ParseQuestions.self, from: data)
                self.questionNAnswerArray[self.mainIndex] = root.items[0]
                DispatchQueue.main.async {
                    self.qNATableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
