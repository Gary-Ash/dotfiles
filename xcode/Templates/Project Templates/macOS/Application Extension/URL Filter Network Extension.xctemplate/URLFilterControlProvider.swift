___FILEHEADER___

import ExtensionFoundation
import NetworkExtension

@main
class URLFilterControlProvider: NEURLFilterControlProvider {
    required internal init() {
    }

    func start() async throws {
        // Add code to initialize.
    }

    func stop(reason: NEProviderStopReason) async throws {
        // Add code to clean up resources.
    }

    func fetchPrefilter(existingPrefilterTag: String?) async throws -> NEURLFilterPrefilter? {
        // Add code to fetch Bloom Filter and return to system
        return nil
    }
}
