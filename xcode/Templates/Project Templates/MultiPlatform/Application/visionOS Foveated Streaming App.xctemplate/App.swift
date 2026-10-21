___FILEHEADER___

import SwiftUI
import FoveatedStreaming

@main
struct FoveatedStreamingApp: App {
    @State private var appModel = AppModel()
    @State private var receiverModel = ReceiverModel()
    @State private var session: FoveatedStreamingSession = FoveatedStreamingSession()

    var body: some Scene {
        WindowGroup {
            visionOSContentView(session: session)
                .environment(appModel)
                .environment(receiverModel)
                .task {
                    session.requestedInputCapabilities = [.accessoryTracking]
                }
        }
        .defaultSize(width: 480, height: 640)

        ImmersiveSpace(foveatedStreaming: session) {
            ImmersiveView()
                .environment(appModel)
        }
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}
