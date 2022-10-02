//
//  CoreDataTestApp.swift
//  CoreDataTest
//
//  Created by Ahmed Mgua on 02/10/2022.
//

import SwiftUI

@main
struct CoreDataTestApp: App {
    @StateObject var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
