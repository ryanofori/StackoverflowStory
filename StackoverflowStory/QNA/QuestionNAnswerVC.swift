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
    var isFavortied = false
    let alert = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionManager()
    }
    
    @IBAction func postAnswerBtn(_ sender: Any) {
        let bodyText = "&body=" + (answerTxt.text ?? "")
        if answerTxt.text?.count ?? 0 < 30 {
            alert.showAlert(mesageTitle: "Alert", messageDesc: "Body must be at least 30 characters", viewController: self)
        } else {
            NetworkManager.shared.postData(urlString: "https://api.stackexchange.com/2.2/questions/60604558/answers/add/", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=d4sFBk6dHwrUwLdIPXX(ZQ))&site=stackoverflow.com" + bodyText) { (json) in
                if let errorMessage = json["error_message"] as? String? {
                    let errorTitle = json["error_message"] as? String
                    self.alert.showAlert(mesageTitle: errorTitle ?? "", messageDesc: errorMessage ?? "", viewController: self)
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
        if section == 0 {
            print(questionNAnswerArray[mainIndex].question_id)
            print("section:")
            let questionIdString = String(questionNAnswerArray[mainIndex].question_id)
            //upVotes a question
            if questionNAnswerArray[mainIndex].upvoted == true {
                NetworkManager.shared.postData(urlString: "https://api.stackexchange.com/2.2/questions/" + questionIdString + "/upvote/undo", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=d4sFBk6dHwrUwLdIPXX(ZQ))&site=stackoverflow.com") { (json) in
                    if let errorMessage = json["error_message"] as? String? {
                        let errorTitle = json["error_message"] as? String
                        self.alert.showAlert(mesageTitle: errorTitle ?? "", messageDesc: errorMessage ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have un-upvoted a question", viewController: self)
                    }
                }
            } else {
                NetworkManager.shared.postData(urlString: "https://api.stackexchange.com/2.2/questions/" + questionIdString + "/upvote/", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=d4sFBk6dHwrUwLdIPXX(ZQ))&site=stackoverflow.com") { (json) in
                    if let errorMessage = json["error_message"] as? String? {
                        let errorTitle = json["error_message"] as? String
                        self.alert.showAlert(mesageTitle: errorTitle ?? "", messageDesc: errorMessage ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have upvoted a question", viewController: self)
                    }
                }
            }

        } else {
            let answerIdString = questionNAnswerArray[mainIndex].answers?[row].answer_id.description ?? ""
            NetworkManager.shared.postData(urlString: "https://api.stackexchange.com/2.2/answers/" + answerIdString + "/upvote", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=d4sFBk6dHwrUwLdIPXX(ZQ))&site=stackoverflow.com") { (json) in
                if let errorMessage = json["error_message"] as? String? {
                    let errorTitle = json["error_message"] as? String
                    self.alert.showAlert(mesageTitle: errorTitle ?? "", messageDesc: errorMessage ?? "", viewController: self)
                } else {
                    self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have upvoted an answer", viewController: self)
                }
            }
        }
        //answer
    }
    
    func didTapDownVote(section: Int, row: Int) {
        print("section- \(section) and row- \(row)")
        if section == 0 {
            let questionId = String(questionNAnswerArray[mainIndex].question_id)
            //Downvote a question
            if questionNAnswerArray[mainIndex].downvoted == true {
                NetworkManager.shared.postData(urlString: "https://api.stackexchange.com/2.2/questions/" + questionId + "/downvote/undo", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=d4sFBk6dHwrUwLdIPXX(ZQ))&site=stackoverflow.com") { (json) in
                    if let errorMessage = json["error_message"] as? String? {
                        let errorTitle = json["error_message"] as? String
                        self.alert.showAlert(mesageTitle: errorTitle ?? "", messageDesc: errorMessage ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have un-downvoted a question", viewController: self)
                    }
                }
            } else {
                NetworkManager.shared.postData(urlString: "https://api.stackexchange.com/2.2/questions/" + questionId + "/downvote", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=d4sFBk6dHwrUwLdIPXX(ZQ))&site=stackoverflow.com") { (json) in
                    if let errorMessage = json["error_message"] as? String? {
                        let errorTitle = json["error_message"] as? String
                        self.alert.showAlert(mesageTitle: errorTitle ?? "", messageDesc: errorMessage ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have downvoted a question", viewController: self)
                    }
                }
            }
        } else {
            let answerIdString = questionNAnswerArray[mainIndex].answers?[row].answer_id.description ?? ""
            
            NetworkManager.shared.postData(urlString: "https://api.stackexchange.com/2.2/answers/" + answerIdString + "/downvote", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=d4sFBk6dHwrUwLdIPXX(ZQ))&site=stackoverflow.com") { (json) in
                if let errorMessage = json["error_message"] as? String? {
                    let errorTitle = json["error_message"] as? String
                    self.alert.showAlert(mesageTitle: errorTitle ?? "", messageDesc: errorMessage ?? "", viewController: self)
                } else {
                    self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have downvoted an answer", viewController: self)
                }
            }
        }
    }
    
    func didTapFav(section: Int, row: Int) {
        print("section* \(section) and row* \(row)")
        if section == 0 {
            let questionIdString = String(questionNAnswerArray[mainIndex].question_id)
            //fav a question
            if questionNAnswerArray[mainIndex].favorited == true {
                NetworkManager.shared.postData(urlString: "https://api.stackexchange.com/2.2/questions/" + questionIdString + "/favorite/undo", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=CpajrRM4j(1Nv9WChhQEWw))&site=stackoverflow.com") { (json) in
                    if let errorMessage = json["error_message"] as? String? {
                        let errorTitle = json["error_message"] as? String
                        DispatchQueue.main.async {
                            self.alert.showAlert(mesageTitle: errorTitle ?? "", messageDesc: errorMessage ?? "", viewController: self)
                        }

                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have unfavorited a question", viewController: self)
                    }
                }
                print("I have unfavorited")
                
            } else {
                NetworkManager.shared.postData(urlString: "https://api.stackexchange.com/2.2/questions/" + questionIdString + "/favorite/", param: "key=tUo34InxiBQXN3La2wI7Bw((&access_token=CpajrRM4j(1Nv9WChhQEWw))&site=stackoverflow.com") { (json) in
                    if let errorMessage = json["error_message"] as? String? {
                        let errorTitle = json["error_message"] as? String
                        DispatchQueue.main.async {
                            self.alert.showAlert(mesageTitle: errorTitle ?? "", messageDesc: errorMessage ?? "", viewController: self)
                        }
                        
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have favorited a question", viewController: self)
                    }
                }
            }
            
        }
    }
    
}
