//
//  CoreDataTestWidget.swift
//  CoreDataTestWidget
//
//  Created by Ahmed Mgua on 02/10/2022.
//
import CoreData
import WidgetKit
import SwiftUI

let container = DataController().container

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CoreDataTestWidgetEntryView : View {
    var entry: Provider.Entry
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateOfBirth, order: .reverse)]) var people: FetchedResults<Person>
    var body: some View {
        if let person = people.first {
            Text(person.name ?? "No person")
        } else {
            Text("No person")
        }
    }
}

@main
struct CoreDataTestWidget: Widget {
    let kind: String = "CoreDataTestWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CoreDataTestWidgetEntryView(entry: entry)
                .environment(\.managedObjectContext, container.viewContext)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct CoreDataTestWidget_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataTestWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
