//
//  ContentView.swift
//  CoreDataTest
//
//  Created by Ahmed Mgua on 02/10/2022.
//

import CoreData
import SwiftUI


final class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataTest")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error {
                print(error)
            } else {
                print(description)
            }
        }
    }
}
struct ContentView: View {
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    let names = ["Harry", "John", "Emily", "Ben"]
    @Environment(\.managedObjectContext) var managedObjectContext
    var body: some View {
        VStack {
            List(people) { person in
                Text(person.name ?? "No person")
            }
            
            Button("Add person") {
                let person = Person(context: managedObjectContext)
                person.id = UUID()
                person.name = names.randomElement()!
                try? managedObjectContext.save()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, DataController().container.viewContext)
    }
}
