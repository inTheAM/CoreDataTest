//
//  CoreDataTestWidget.swift
//  CoreDataTestWidget
//
//  Created by Ahmed Mgua on 02/10/2022.
//
import CoreData
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    // Add ManagedObjectContext to Provider and initialize
    let managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        let person = Person(context: managedObjectContext)
        person.name = "Test person"
        return SimpleEntry(date: Date(), person: person)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let person = Person(context: managedObjectContext)
        person.name = "Test person"
        let entry = SimpleEntry(date: Date(), person: person)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var people = [Person]()
        
        // Create NSFetchRequest and sort
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.sortDescriptors = [NSSortDescriptor(key: "dateOfBirth", ascending: false)]
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            // In case fetching fails, display test person
            let testPerson = Person(context: managedObjectContext)
            testPerson.name = "Test person"
            
            // Fetch the people from CoreData
            do {
                people = try managedObjectContext.fetch(request) as? [Person] ?? []
            } catch {
                print(error)
            }
            
            // Assign to TimelineEntry
            let entry = SimpleEntry(date: entryDate, person: people.first ?? testPerson)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    
    // Add person to entry
    let person: Person
}

struct CoreDataTestWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text(entry.person.name ?? "No person")
    }
}

@main
struct CoreDataTestWidget: Widget {
    let kind: String = "CoreDataTestWidget"
    
    // Setting the container where data is stored
    let container = DataController().container
    
    var body: some WidgetConfiguration {
        
        // Pass container context to Provider
        StaticConfiguration(kind: kind, provider: Provider(context: container.viewContext)) { entry in
            CoreDataTestWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CoreDataTestWidget_Previews: PreviewProvider {
    static var previews: some View {
        let person = Person()
        person.name = "Test person"
        return CoreDataTestWidgetEntryView(entry: SimpleEntry(date: Date(), person: person))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
