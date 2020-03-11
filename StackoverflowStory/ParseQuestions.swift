//
//  ParseQuestions.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

struct ParseQuestions: Codable {
    var items: [Items]
}
struct Items: Codable {
    var tags: [String]?
    var answers: [Answers]?
    var owner: Owner?
    var is_accepted: Bool?
    var answer_count: Int
    var score: Int?
    var question_id: Int
    var link: String?
    var title: String?
    var body: String?
    var user_id: Int?
}
struct Answers: Codable {
    var owner: Owner?
    var is_accepted: Bool?
    var score: Int?
    var answer_id: Int
    var title: String?
    var body: String?
}
struct Owner: Codable {
    var reputation: Int?
    var profile_image: String?
    var display_name: String?
}
