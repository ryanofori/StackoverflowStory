//
//  String.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/4/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
