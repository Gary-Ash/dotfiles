___FILEHEADER___

import SwiftUI

@main
struct ___PACKAGENAME:identifier___App: App {
    var body: some Scene {
        DocumentGroup { document in
            ContentView(document: document)
        } makeDocument: { configuration, context in
            ___PACKAGENAME:identifier___Document()
        }
    }
}
