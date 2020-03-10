//
//  SubButton.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/10/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

class SubButton: UIButton {

    var row: Int?
    var section: Int?
    
    func rowSectionIdentifer(sender: Any) {
        let myButton = sender as? SubButton

        let section = myButton?.section
        let row = myButton?.row
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
