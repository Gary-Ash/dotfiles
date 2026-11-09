___FILEHEADER___

import ExtensionFoundation
import LiveCommunicationKit

@main
struct ___FILEBASENAME:identifier___: LiveCommunicationKit.LiveAssistanceExtension {
    func prepareAssistanceRequest(_ request: LiveAssistanceRequest) async throws -> LiveAssistanceRequest.Response {
        // Check that the person is eligible, then send request.url to your backend.
        // Return .requiresUserInput(reason: .signIn) to open your app first.
        // Your app then calls LiveAssistance.returnToCall(requestID:), so the app
        // target also needs the com.apple.developer.conversation-accessibility entitlement.
        // Throw LiveAssistanceRequestError.cannotFulfill if you can't help.
        return .proceed
    }

    func resumeRequest(_ request: LiveAssistanceRequest) async throws -> LiveAssistanceRequest.Response {
        // Your app finished setup. Check again, then send request.url.
        return .proceed
    }
}
