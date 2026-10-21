___FILEHEADER___

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            Text("Hello, world!")

            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(AppModel())
}
