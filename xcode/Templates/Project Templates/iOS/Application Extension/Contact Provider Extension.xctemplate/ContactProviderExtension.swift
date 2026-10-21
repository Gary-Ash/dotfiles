___FILEHEADER___

import ExtensionFoundation
import Foundation
import ContactProvider

@main
class ___FILEBASENAME:identifier___: ContactProviderExtension {
    private let rootContainerEnumerator: ___PACKAGENAME:identifier___RootContainerEnumerator

    required init() {
        // Initialize your extension here.
        rootContainerEnumerator = ___PACKAGENAME:identifier___RootContainerEnumerator()
    }

    func configure(for domain: ContactProviderDomain) {
        // Configure your extension here.
        rootContainerEnumerator.configure(for: domain)
    }

    func enumerator(for collection: ContactItem.Identifier) -> ContactItemEnumerator {
        return rootContainerEnumerator
    }

    func invalidate() async throws {
        // TODO: Stop any enumeration and cleanup as the extension will be terminated.
    }
}
