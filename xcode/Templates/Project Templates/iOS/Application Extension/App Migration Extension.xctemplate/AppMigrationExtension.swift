___FILEHEADER___

import AppMigrationKit
import ExtensionFoundation

@main
final class AppMigrationHandler: AppMigrationExtension {
    var appDocumentsDirectory: URL {
        return self.appContainer.documentsDirectory
    }

    let resourcesImportProgress = Progress()
}

extension AppMigrationHandler: ResourcesExporting {
    func exportResources(to archiver: ResourcesArchiver, request: MigrationRequest) async throws {
        /// Export app resources to the archiver
        try await archiver.appendItem(at: self.appDocumentsDirectory)
    }

    var resourcesSizeEstimate: Int {
        /// Provide a size estimate (in bytes) of app resources
        fatalError("Return the estimated size of app resources to export. Extensions returning 0 will be skipped during the migration process.")
    }

    var resourcesVersion: String {
        /// Provide versioning around your app's resources format
        "1"
    }

    var resourcesCompressible: Bool {
        /// Hint the migration system about whether resources are compressible
        false
    }
}

extension AppMigrationHandler: ResourcesImporting {
    func importResources(at url: URL, request importRequest: ResourcesImportRequest) async throws {
        /// Import resources from an extracted resource URL
    }
}
