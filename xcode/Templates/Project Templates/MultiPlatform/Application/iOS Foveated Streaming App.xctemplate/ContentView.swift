___FILEHEADER___

import SwiftUI
import CloudXRKit
import StreamingSession
import Network

struct iOSContentView: View {
    
    @State private var session = FoveatedStreamingSession()
    
    var body: some View {
        Group {
            if case .connected = session.status {
                // Show the streaming view when connected
                FoveatedStreamingView(session: session)
            } else {
                // Show connection UI when not connected
                ConnectionView(session: session)
            }
        }
        .deviceDiscovery(session: session)
        .devicePairing(session: session)
    }
}

struct ConnectionView: View {
    
    let session: FoveatedStreamingSession
    @State private var isConnecting = false
    @State private var errorMessage: String?
    @State private var serverIP = ""
    @State private var port = "55000"

    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 12) {
                Text("StreamingSession Sample")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Status: \(isConnecting ? "Connecting" : session.status.description)")
            }
            
            // Connection Form
            VStack(alignment: .leading, spacing: 16) {
                
                TextField("IP Address", text: $serverIP)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .disabled(isConnecting)

                TextField("Port", text: $port)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .frame(width: 100)
                    .disabled(isConnecting)

                Text("Leave empty to automatically discover devices")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                
                Button {
                    Task {
                        await connectToServer()
                    }
                } label: {
                    HStack {
                        if isConnecting {
                            ProgressView()
                                .tint(.white)
                        }
                        Text(isConnecting ? "Connecting..." : "Connect")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isConnecting ? Color.gray : Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                .disabled(isConnecting)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            
        }
        .padding()
        .animation(.default, value: session.status)
    }
    
    private func connectToServer() async {
        isConnecting = true
        errorMessage = nil

        do {
            let endpoint: FoveatedStreamingSession.Endpoint

            if serverIP.isEmpty || serverIP == "0.0.0.0" {
                endpoint = .systemDiscovered
            } else {
                endpoint = .local(ipAddress: IPv4Address(serverIP)!, port: NWEndpoint.Port(port)!)
            }

            try await session.connect(endpoint: endpoint)
            isConnecting = false
        } catch {
            errorMessage = "Failed to connect: \(error.localizedDescription)"
            isConnecting = false
        }
    }
}
