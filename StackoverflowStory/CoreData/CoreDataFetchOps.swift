//
//  CoreDataFetchOps.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/6/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//
import CoreData
import Foundation

class CoreDataFetchOps {
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.mainContext
    static let shared = CoreDataFetchOps()
    
    private init() {}
    
    func getAllToken() -> [Access] {
        let fetchRequest: NSFetchRequest<Access> = Access.fetchRequest()
        return coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context)
    }
    
    //need to be a string
    func getAccessToken() -> Access? {
        let fetchRequest: NSFetchRequest<Access> = Access.fetchRequest()
        return coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context).first
    }
    
}
