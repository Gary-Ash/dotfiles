___FILEHEADER___

import ActivityKit
import WidgetKit
import SwiftUI

struct ___PACKAGENAME:identifier___Attributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ___PACKAGENAME:identifier___LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ___PACKAGENAME:identifier___Attributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ___PACKAGENAME:identifier___Attributes {
    fileprivate static var preview: ___PACKAGENAME:identifier___Attributes {
        ___PACKAGENAME:identifier___Attributes(name: "World")
    }
}

extension ___PACKAGENAME:identifier___Attributes.ContentState {
    fileprivate static var smiley: ___PACKAGENAME:identifier___Attributes.ContentState {
        ___PACKAGENAME:identifier___Attributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ___PACKAGENAME:identifier___Attributes.ContentState {
         ___PACKAGENAME:identifier___Attributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ___PACKAGENAME:identifier___Attributes.preview) {
   ___PACKAGENAME:identifier___LiveActivity()
} contentStates: {
    ___PACKAGENAME:identifier___Attributes.ContentState.smiley
    ___PACKAGENAME:identifier___Attributes.ContentState.starEyes
}
