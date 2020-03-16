//
//  QNATableViewCell.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

@objc
protocol QNACellDelegete {
    func didTapUpVote(section: Int, row: Int)
    func didTapDownVote(section: Int, row: Int)
    func didTapFav(section: Int, row: Int)
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
    
    weak var cellDelegate: QNACellDelegete?
    
    @IBOutlet weak var upVote: SubButton!
    @IBAction func upVote(_ sender: Any) {
        cellDelegate?.didTapUpVote(section: (sender as? SubButton)?.section ?? 0, row: (sender as? SubButton)?.row ?? 0)
    }
    
    @IBOutlet weak var downVote: SubButton!
    @IBAction func downVote(_ sender: Any) {
        cellDelegate?.didTapDownVote(section: (sender as? SubButton)?.section ?? 0, row: (sender as? SubButton)?.row ?? 0)
    }
    
    @IBOutlet weak var favBtn: SubButton!
    
    @IBAction func favBtn(_ sender: Any) {
        cellDelegate?.didTapFav(section: (sender as? SubButton)?.section ?? 0, row: (sender as? SubButton)?.row ?? 0)
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
