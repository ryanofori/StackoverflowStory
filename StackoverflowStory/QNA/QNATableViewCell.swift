//
//  QNATableViewCell.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

protocol QNACellDelegete {
    func didTapUpVote(tag: Int)
    func didTapDownVote()
    func didTapFav()
}

class QNATableViewCell: UITableViewCell {
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var questionAnswerDesc: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var tagsLbl: UILabel!
    @IBOutlet weak var reputationLbl: UILabel!
    
    var cellItems = [Items]()
    var cellDelegate: QNACellDelegete?
    func passItems(item: [Items]) {
        cellItems = item
    }
    
    @IBOutlet weak var upVote: UIButton!
    @IBAction func upVote(_ sender: Any) {
        cellDelegate?.didTapUpVote(tag: (sender as AnyObject).tag)
    }
    
    @IBOutlet weak var downVote: UIButton!
    @IBAction func downVote(_ sender: Any) {
        cellDelegate?.didTapDownVote()
    }
    
    @IBOutlet weak var favBtn: UIButton!
    
    @IBAction func favBtn(_ sender: Any) {
        cellDelegate?.didTapFav()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
