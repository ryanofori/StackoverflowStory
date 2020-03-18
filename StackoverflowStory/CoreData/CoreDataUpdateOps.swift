//
//  CoreDataUpdateOps.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/6/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//
import CoreData

class CoreDataUpdateOps {
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.mainContext
    static let shared = CoreDataUpdateOps()
    
    func updateToken(accessToken: String) {
        let token = CoreDataFetchOps.shared.getAccessToken()
        token?.token = accessToken

        coreDataManager.saveContext(context: context)
    }
}
