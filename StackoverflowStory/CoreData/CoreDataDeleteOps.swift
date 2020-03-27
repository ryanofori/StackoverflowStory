//
//  CoreDataDeleteOps.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/6/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//
import CoreData

class CoreDataDeleteOps {
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.mainContext
    static let shared = CoreDataDeleteOps()
    
    func deleteToken() {
        let fetchRequest: NSFetchRequest<Access> = Access.fetchRequest()
        let token = coreDataManager.fetchObjects(fetchRequest: fetchRequest, context: context)
        coreDataManager.batchDelete(objects: token, context: context)
    }
}
