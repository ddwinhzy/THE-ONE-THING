//
//  Widgets.swift
//  Widgets
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), currentTask: "Complete the mobile app prototype", isTimerRunning: false, timeRemaining: 25*60)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), currentTask: "Complete the mobile app prototype", isTimerRunning: false, timeRemaining: 25*60)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, currentTask: getCurrentTask(), isTimerRunning: false, timeRemaining: 25*60)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getCurrentTask() -> String {
        // In a real implementation, this would read from shared container
        // For now, return a placeholder
        return "Focus on your One Thing"
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let currentTask: String
    let isTimerRunning: Bool
    let timeRemaining: TimeInterval
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("Your One Thing")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: "target")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Current task
            Text(entry.currentTask)
                .font(.headline)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            // Timer info
            HStack {
                if entry.isTimerRunning {
                    Image(systemName: "timer")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text(timeString(from: entry.timeRemaining))
                        .font(.caption)
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "play.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Ready to focus")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct Widgets: Widget {
    let kind: String = "TheOneThingWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("The One Thing")
        .description("Keep your current task in focus.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    Widgets()
} timeline: {
    SimpleEntry(date: .now, currentTask: "Complete the mobile app prototype", isTimerRunning: false, timeRemaining: 25*60)
    SimpleEntry(date: .now, currentTask: "Write the quarterly report", isTimerRunning: true, timeRemaining: 18*60)
}
