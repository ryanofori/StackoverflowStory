//
//  CoreDataSaveOps.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/6/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//
import CoreData
import Foundation

class CoreDataSaveOps {
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.mainContext
    static let shared = CoreDataSaveOps()
    private init() {}
    
    func saveToken(tokenObject: AccessModel) {
        let tokenManagedObject = Access(context: context)
        tokenManagedObject.token = tokenObject.token
        coreDataManager.saveContext(context: context)
    }
    
}
