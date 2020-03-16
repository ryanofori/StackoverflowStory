//
//  ParseUser.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/8/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

struct ParseUser: Codable {
    var items: [ItemsO]
}
struct ItemsO: Codable {
    var user_id: Int?
}
