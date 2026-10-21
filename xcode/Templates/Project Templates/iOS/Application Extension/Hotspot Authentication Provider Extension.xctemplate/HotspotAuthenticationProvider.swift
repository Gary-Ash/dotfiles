___FILEHEADER___

import ExtensionFoundation
import Foundation
import NetworkExtension
import os.log

@main
class HotspotAuthenticationProvider: NEHotspotAuthenticationProvider {
    private var logger: os.Logger

    required init() {
        logger = os.Logger(subsystem: "HotspotAuthenticationProvider", category: "Debug")
    }

    func start() async -> Bool {
        logger.log("HotspotAuthenticationProvider: start")
        return true
    }

    func stop(reason: NEProviderStopReason) async {
        logger.log("HotspotAuthenticationProvider: stop")
    }

    func handleCommand(_ command: NEHotspotHelperCommand) async -> NEHotspotHelperResponse {
        logger.log("HotspotAuthenticationProvider: handleCommand: \(command)")
        return command.createResponse(.success)
    }
}
