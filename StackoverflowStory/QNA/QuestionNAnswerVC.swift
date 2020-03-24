//
//  QuestionNAnswerVC.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import AVFoundation
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
    var audioSound = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        sectionManager()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc
    func handleKeyboardNotification(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        if keyboardShowing == true {
            view.frame.origin.y = -keyboardSize.height
        } else {
            view.frame.origin.y = 0
        }
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction private func postAnswerBtn(_ sender: Any) {
        let bodyText = "&body=" + (answerTxt.text ?? "")
        let questionIdString = String(questionNAnswerArray[mainIndex].question_id)
        if answerTxt.text?.count ?? 0 < 30 {
            alert.showAlert(mesageTitle: "Alert", messageDesc: "Body must be at least 30 characters", viewController: self)
        } else {
            NetworkManager.shared.postData(urlString: urlPath.baseUrl + "questions/" + questionIdString + "/answers/add/", param: urlPath.key + urlPath.newAccessToken + urlPath.site + bodyText) { (json) in
                if json["error_message"] != nil {
                        self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                } else {
                    self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have sent answer", viewController: self)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchUpdatedQNA(questionIdString: questionIdString)
        }
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
                NSLog(error.localizedDescription)
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
            cell?.profileName.text = questionNAnswerArray[mainIndex].owner?.display_name?.html2String
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
            cell?.profileName.text = questionNAnswerArray[mainIndex].answers?[indexType].owner?.display_name?.html2String
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
        let questionIdString = String(questionNAnswerArray[mainIndex].question_id)
        if section == 0 {
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
            if questionNAnswerArray[mainIndex].answers?[row].upvoted == true {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl + "answers/" + answerIdString + "/upvote/undo", param: urlPath.key + urlPath.newAccessToken + urlPath.site ) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have un-upvoted an answer", viewController: self)
                    }
                }
            } else {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl + "answers/" + answerIdString + "/upvote", param: urlPath.key + urlPath.newAccessToken + urlPath.site ) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have upvoted an answer", viewController: self)
                    }
                }
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchUpdatedQNA(questionIdString: questionIdString)
        }
    }
    
    func didTapDownVote(section: Int, row: Int) {
        let questionIdString = String(questionNAnswerArray[mainIndex].question_id)
        if section == 0 {
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
            if questionNAnswerArray[mainIndex].answers?[row].downvoted == true {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl + "answers/" + answerIdString + "/downvote/undo", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have un-downvoted an answer", viewController: self)
                    }
                }
            } else {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl + "answers/" + answerIdString + "/downvote", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have downvoted an answer", viewController: self)
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchUpdatedQNA(questionIdString: questionIdString)
        }
    }
    
    func didTapFav(section: Int, row: Int) {
        let questionIdString = String(questionNAnswerArray[mainIndex].question_id)
            if questionNAnswerArray[mainIndex].favorited == true {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl +  "questions/" + questionIdString + "/favorite/undo", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have unfavorited a question", viewController: self)
                    }
                }
            } else {
                NetworkManager.shared.postData(urlString: urlPath.baseUrl + "questions/" + questionIdString + "/favorite/", param: urlPath.key + urlPath.newAccessToken + urlPath.site) { (json) in
                    if json["error_message"] != nil {
                            self.alert.showAlert(mesageTitle: json["error_name"] as? String ?? "", messageDesc: json["error_message"] as? String ?? "", viewController: self)
                        
                    } else {
                        self.alert.showAlert(mesageTitle: "Success", messageDesc: "You have favorited a question", viewController: self)
                        if let staredSound = Bundle.main.path(forResource: "411460__inspectorj__power-up-bright-a", ofType: "wav") {
                            let soundUrl = URL(fileURLWithPath: staredSound)
                            do {
                                self.audioSound = try AVAudioPlayer(contentsOf: soundUrl)
                                self.audioSound.play()
                            } catch {
                                
                            }
                        }
                    }
                }
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchUpdatedQNA(questionIdString: questionIdString)
        }
        
    }
    
}
