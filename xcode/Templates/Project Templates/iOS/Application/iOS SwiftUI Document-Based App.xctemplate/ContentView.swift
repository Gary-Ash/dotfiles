___FILEHEADER___

import SwiftUI

struct ContentView: View {
    @Bindable var document: ___PACKAGENAME:identifier___Document
    @Environment(\.undoManager) private var undoManager

    var body: some View {
        TextEditor(text: $document.text)
            .onChange(of: document.text) { oldValue, _ in
                undoManager?.registerUndo(withTarget: document) { document in
                    document.text = oldValue
                }
            }
            .font(.system(size: 16, weight: .regular, design: .monospaced))
    }
}

#Preview {
    ContentView(document: ___PACKAGENAME:identifier___Document())
}
