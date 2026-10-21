___FILEHEADER___

import SwiftUI
import RealityKit
import OSLog
import FoveatedStreaming
import Network

private extension FoveatedStreamingSession {
    var isDisconnected: Bool {
        switch status {
        case .disconnected, .initialized, .connecting: true
        default: false
        }
    }
}

struct visionOSContentView: View {

    let session: FoveatedStreamingSession

    var body: some View {
        NavigationStack {
            HStack(spacing: 0) {
                SessionConfigurationView(session: session)
            }
            .navigationTitle(Text("FoveatedStreaming Sample App"))
        }
    }
}

private struct ConnectView: View {

    @Environment(ReceiverModel.self) var receiver: ReceiverModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    @AppStorage("ipAddress") private var ipAddressEntry: String = "0.0.0.0"
    @AppStorage("port") private var portEntry: String = "55000"
    let session: FoveatedStreamingSession

    var body: some View {
        VStack{
            Text("Status: \(session.status.description)")
            Spacer()
            if !session.isDisconnected {
                // Connect/Disconnect button
                Button("Disconnect") {
                    Task { await session.disconnect() }
                }.disabled(session.status == .disconnecting)

                // Pause/Resume button
                switch session.status {
                case .initialized, .disconnected, .connecting, .disconnecting:
                    EmptyView()
                case .connected:
                    Button("Pause") { Task { try? await session.pause() } }
                case .paused:
                    Button("Resume") { Task { try? await session.resume() } }
                case .pausing:
                    Button("Pausing") {}.disabled(true)
                case .resuming:
                    Button("Resuming") {}.disabled(true)
                @unknown default:
                    EmptyView()
                }
            } else {
                Group {
                    VStack {
                        Text("IP Address + Port")
                        HStack{
                            TextField("0.0.0.0", text: $ipAddressEntry)
                                .autocorrectionDisabled(true)
                                .keyboardType(.decimalPad)
                                .textInputAutocapitalization(.never)
                                .searchDictationBehavior(.inline(activation: .onLook))
                                .onSubmit {
                                    // strip whitespace
                                    ipAddressEntry = ipAddressEntry.trimmingCharacters(
                                        in: .whitespacesAndNewlines
                                    )
                                }
                                .textFieldStyle(.roundedBorder)
                                .frame(height: 40)

                            TextField("55000", text: $portEntry)
                                .autocorrectionDisabled(true)
                                .keyboardType(.numberPad)
                                .textInputAutocapitalization(.never)
                                .searchDictationBehavior(.inline(activation: .onLook))
                                .onSubmit {
                                    // strip whitespace
                                    portEntry = portEntry.trimmingCharacters(
                                        in: .whitespacesAndNewlines
                                    )
                                }
                                .textFieldStyle(.roundedBorder)
                                .frame(height: 40)
                        }.padding(.vertical, 20)
                    }

                    Button("Connect") {
                        beginConnection(ipAddress: ipAddressEntry)
                    }
                }.disabled(session.status == .connecting)

            }
        }
        .padding()
    }

    private func beginConnection(ipAddress: String) {
        Task { @MainActor in
            // Set up automatic immersive presentation behaviors.
            session.immersivePresentationBehaviors = .automatic(openImmersiveSpace, dismissImmersiveSpace)

            do {
                if ipAddress == "" || ipAddress == "0.0.0.0" {
                    try await session.connect(endpoint: .systemDiscovered)
                } else {
                    try await session.connect(endpoint: .local(ipAddress: IPv4Address(ipAddress)!, port: NWEndpoint.Port(portEntry)!))
                }
            } catch {
                receiver.message = "Failed to connect to stream: \(error)"
                return
            }
        }
    }
}

private struct SessionConfigurationView: View {
    @Environment(ReceiverModel.self) var receiver: ReceiverModel
    let session: FoveatedStreamingSession

    var body: some View {
        TabView {
            Tab("Connect", systemImage: "rectangle.connected.to.line.below") {
                ConnectView(session: session).environment(receiver)
            }

            Tab("Data Channels", systemImage: "fibrechannel") {
                DataChannelView(session: session)
            }
        }
    }
}
