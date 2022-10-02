//
//  ContentView.swift
//  CoreDataTest
//
//  Created by Ahmed Mgua on 02/10/2022.
//

import CoreData
import SwiftUI
import WidgetKit


struct ContentView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateOfBirth, order: .reverse)]) var people: FetchedResults<Person>
    let names = ["Harry", "John", "Emily", "Ben"]
    @Environment(\.managedObjectContext) var managedObjectContext
    var body: some View {
        VStack {
            List(people) { person in
                HStack {
                    Text(person.name ?? "No person")
                    Spacer()
                    Text(person.dateOfBirth ?? Date(), format: .dateTime)
                }
            }
            
            Button("Add person") {
                let person = Person(context: managedObjectContext)
                person.id = UUID()
                person.name = names.randomElement()!
                person.dateOfBirth = Date()
                try? managedObjectContext.save()
                WidgetCenter.shared.reloadAllTimelines()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Button("Clear", role: .destructive) {
                if !people.isEmpty {
                    managedObjectContext.delete(people[0])
                }
                try? managedObjectContext.save()
                WidgetCenter.shared.reloadAllTimelines()
            }
            .buttonStyle(.borderedProminent)
            
            .padding()
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
