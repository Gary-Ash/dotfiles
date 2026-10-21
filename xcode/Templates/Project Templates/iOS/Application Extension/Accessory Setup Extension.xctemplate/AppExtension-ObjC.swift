___FILEHEADER___

import DeviceDiscoveryExtension
import ExtensionFoundation

// This extension adds conformance to the Swift protocol to the Objective-C class, and delegates start and stop of the discovery to it.

@main
extension ___FILEBASENAME:identifier___: DDDiscoveryExtension {
    
    public func startDiscovery(session: DDDiscoverySession) {
        startDiscovery(with: session)
    }
    
    public func stopDiscovery(session: DDDiscoverySession) {
        stopDiscovery(with: session)
    }
}
