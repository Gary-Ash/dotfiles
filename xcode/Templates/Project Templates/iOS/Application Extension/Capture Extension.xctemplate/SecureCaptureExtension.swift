___FILEHEADER___

import ExtensionKit
import Foundation
import LockedCameraCapture
import SwiftUI

@main
struct ___FILEBASENAME:identifier___: LockedCameraCaptureExtension {
    var body: some LockedCameraCaptureExtensionScene {
        LockedCameraCaptureUIScene { session in
            ___PACKAGENAME:identifier___ViewFinder(session: session)
        }
    }
}
