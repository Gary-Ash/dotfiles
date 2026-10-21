___FILEHEADER___

import Foundation
import ExtensionFoundation

/// The AppExtension protocol to which this extension will conform.
/// This is typically defined by the extension host in a framework.
protocol ExampleExtension : AppExtension {
}

extension ExampleExtension {
    var configuration: some AppExtensionConfiguration {
        // Return your extension's configuration upon request.
        return ConnectionHandler(onSessionRequest: { request in
            request.reject(reason: "unimplemented")
        })
    }
}

@main
struct EnhancedSecurityHelper: ExampleExtension {
    @AppExtensionPoint.Bind
    var boundExtensionPoint: AppExtensionPoint {
        AppExtensionPoint.Identifier(host: "com.example.ExtensionHost", name: "enhancedSecurity")
    }
}
