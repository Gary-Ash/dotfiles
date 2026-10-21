___FILEHEADER___

import SwiftUI
import RealityKit
import OSLog
import FoveatedStreaming

struct DataChannelView: View {

    let session: FoveatedStreamingSession
    @State var receivedMessages: [String] = []
    @State var channelinfo: FoveatedStreamingSession.MessageChannel? = nil
    @State var availableChannels: Set<FoveatedStreamingSession.MessageChannel.ID> = []
    @State var selectedChannelID: FoveatedStreamingSession.MessageChannel.ID? = nil
    @State var messageToSend: String = "Hello server"

    var body: some View {
        VStack(spacing: 20) {
            // Channel Selection Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Channel Selection")
                    .font(.headline)

                HStack {
                    Button("Get Channels") {
                        availableChannels = session.availableMessageChannels
                        Logger.app.info("Total channels: \(availableChannels.count)")
                        if let firstChannel = availableChannels.first {
                            Logger.app.info("found channel")
                            selectedChannelID = firstChannel
                        } else {
                            Logger.app.info("No channels available")
                            selectedChannelID = nil
                        }
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    if !availableChannels.isEmpty {
                        let channelBinding = Binding<FoveatedStreamingSession.MessageChannel.ID?>(
                            get: { selectedChannelID },
                            set: { selectedChannelID = $0 }
                        )

                        let channelsArray = Array(availableChannels)

                        Picker("Channel", selection: channelBinding) {
                            ForEach(Array(channelsArray.enumerated()), id: \.element) { index, channelID in
                                Text("Channel \(index + 1)")
                                    .tag(channelID as FoveatedStreamingSession.MessageChannel.ID?)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(minWidth: 120)
                    } else {
                        Text("No channels available")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .cornerRadius(10)

            // Message Sending Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Send Message")
                    .font(.headline)

                HStack(spacing: 12) {
                    TextField("Enter message", text: $messageToSend)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            sendMessage()
                        }

                    Button("Send") {
                        sendMessage()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedChannelID == nil || messageToSend.isEmpty)
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .cornerRadius(10)

            // Received Messages Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Received Messages")
                        .font(.headline)

                    Spacer()

                    Button("Start Receiving") {
                        startReceivingMessages()
                    }
                    .buttonStyle(.bordered)
                    .disabled(selectedChannelID == nil)

                    if !receivedMessages.isEmpty {
                        Button("Clear") {
                            receivedMessages.removeAll()
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
                    }
                }

                if receivedMessages.isEmpty {
                    Text("No messages received")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(Color(UIColor.tertiarySystemGroupedBackground))
                        .cornerRadius(8)
                } else {
                    List(receivedMessages, id: \.self) { message in
                        Text(message)
                            .font(.system(.body, design: .monospaced))
                    }
                    .frame(minHeight: 100, maxHeight: 300)
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .cornerRadius(10)

            // Close Channel Section
            HStack {
                Spacer()

                Button("Close Channel") {
                    channelinfo?.disconnect()
                    channelinfo = nil
                    receivedMessages.removeAll() // Clear messages when closing channel
                }
                .buttonStyle(.bordered)
                .disabled(channelinfo == nil)

                Spacer()
            }

            Spacer()
        }
        .padding()
    }

    private func sendMessage() {
        guard let channelID = selectedChannelID,
              !messageToSend.isEmpty else { return }

        if let channel = session.messageChannel(for: channelID) {
            channelinfo = channel
            let message = messageToSend.data(using: .utf8)!
            do {
                try channel.sendMessage(message)
                Logger.app.info("Message sent to server: \(messageToSend)")
            } catch {
                Logger.app.error("Failed to send message: \(error)")
            }
        }
    }

    private func startReceivingMessages() {
        guard let channelID = selectedChannelID else { return }

        if let channel = session.messageChannel(for: channelID) {
            channelinfo = channel

            Task {
                for await message in channel.receivedMessageStream {
                    if let messageString = String(data: message, encoding: .utf8) {
                        await MainActor.run {
                            Logger.app.info("Message received: \(messageString)")
                            receivedMessages.append(messageString)
                        }
                    }
                }
            }
        }
    }
}
