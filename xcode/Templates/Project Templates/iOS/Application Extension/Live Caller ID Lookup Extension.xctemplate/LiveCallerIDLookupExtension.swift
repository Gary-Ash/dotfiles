___FILEHEADER___

import ExtensionFoundation
import IdentityLookup

@main
struct ___FILEBASENAME:identifier___: LiveCallerIDLookupProtocol {
    var context: LiveCallerIDLookupExtensionContext {
        LiveCallerIDLookupExtensionContext(
            serviceURL: URL(string: "https://service.example.com")!,
            tokenIssuerURL: URL(string: "https://token-issuer.example.com")!,
            userTierToken: Data())
    }
}
