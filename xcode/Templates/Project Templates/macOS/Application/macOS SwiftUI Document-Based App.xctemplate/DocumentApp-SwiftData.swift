___FILEHEADER___

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@main
struct ___PACKAGENAME:identifier___App: App {
    var body: some Scene {
        DocumentGroup(editing: .itemDocument, migrationPlan: ___PACKAGENAME:identifier___MigrationPlan.self) {
            ContentView()
        }
    }
}

extension UTType {
    static var itemDocument: UTType {
        UTType(importedAs: "com.example.item-document")
    }
}

struct ___PACKAGENAME:identifier___MigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] = [
        ___PACKAGENAME:identifier___VersionedSchema.self,
    ]

    static var stages: [MigrationStage] = [
        // Stages of migration between VersionedSchema, if required.
    ]
}

struct ___PACKAGENAME:identifier___VersionedSchema: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] = [
        Item.self,
    ]
}
