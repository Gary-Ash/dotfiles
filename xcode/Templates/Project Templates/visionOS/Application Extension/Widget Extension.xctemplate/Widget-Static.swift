___FILEHEADER___

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct ___PACKAGENAME:identifier___EntryView : View {
    var entry: Provider.Entry
    @Environment(\.levelOfDetail) var levelOfDetail: LevelOfDetail

    var body: some View {
        switch levelOfDetail {
        case .simplified:
            VStack {
                Text(entry.date, style: .time)
            }
        default:
            VStack {
                Text("Time:")
                Text(entry.date, style: .time)
            }
        }
    }
}

struct ___PACKAGENAME:identifier___: Widget {
    let kind: String = "___PACKAGENAME:identifier___"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ___PACKAGENAME:identifier___EntryView(entry: entry)
                    .containerBackground(.white.gradient, for: .widget)
            } else {
                ___PACKAGENAME:identifier___EntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated])
        .configurationDisplayName("My Widget")
        .widgetTexture(.paper)
        .description("This is an example widget.")
    }
}
