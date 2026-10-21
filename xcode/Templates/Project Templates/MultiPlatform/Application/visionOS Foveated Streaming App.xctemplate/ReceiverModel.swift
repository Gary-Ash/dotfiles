___FILEHEADER___

import SwiftUI
import Observation

@MainActor
@Observable
class ReceiverModel {
    var message: String?
    var displayPingMs: Int?
    var servicePingMs: Int?
}
