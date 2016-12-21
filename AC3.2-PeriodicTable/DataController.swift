//
//  DataController.swift
//  AC3.2-PeriodicTable
//
//  Created by Erica Y Stevens on 12/21/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import Foundation
import CoreData

class DataController: NSObject {
    var managedObjectContext: NSManagedObjectContext
    
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        
        managedObjectContext.persistentStoreCoordinator = psc
       
        self.managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // I'm not sure why this was being queued thusly but it was creating a race condition
        //DispatchQueue.main.async {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls.last!
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("Model.sql")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        }
        catch {
            fatalError("Error migrating store: \(error)")
        }
        //}
    }
    
    // should be called from the thread using the private context
    var privateContext: NSManagedObjectContext {
        get {
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = managedObjectContext
            privateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            return privateContext
        }
    }
}
