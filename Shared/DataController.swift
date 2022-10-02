//
//  DataController.swift
//  CoreDataTest
//
//  Created by Ahmed Mgua on 02/10/2022.
//

import CoreData

final class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataTest")
    
    init() {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.mgua.coredatatest")!
        let storeURL = containerURL.appendingPathComponent("CoreDataTest.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            if let error {
                print(error)
            } else {
                print(description)
            }
        }
    }
}
