___FILEHEADER___

import ExtensionFoundation
import Foundation
import NetworkExtension
import os.log

@main
class HotspotEvaluationProvider: NEHotspotEvaluationProvider {
    private var logger: os.Logger
    var localizedDisplayName: String

    required init() {
        logger = os.Logger(subsystem: "HotspotEvaluationProvider", category: "Debug")
        localizedDisplayName = "hotspot evaluation provider"
    }

    func start() async -> Bool {
        logger.log("EvaluationProvider: start")
        return true
    }

    func stop(reason: NEProviderStopReason) async {
        logger.log("HotspotEvaluationProvider: stop")
    }

    func handleCommand(_ command: NEHotspotHelperCommand) async -> NEHotspotHelperResponse {
        logger.log("HotspotEvaluationProvider: handleCommand: \(command)")
        return command.createResponse(.success)
    }
}
