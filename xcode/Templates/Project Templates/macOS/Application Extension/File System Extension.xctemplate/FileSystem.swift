___FILEHEADER___

import Foundation
import FSKit

@objc
class ___FILEBASENAME:identifier___ : FSUnaryFileSystem & FSUnaryFileSystemOperations {
    func probeResource(resource: FSResource, replyHandler: @escaping (FSProbeResult?, (any Error)?) -> Void) {
        replyHandler(.notRecognized, nil)
    }
    
    func loadResource(resource: FSResource, options: FSTaskOptions, replyHandler: @escaping (FSVolume?, (any Error)?) -> Void) {
        replyHandler(FSVolume(volumeID: .init(uuid: UUID()), volumeName: FSFileName(string: "My Volume")), nil)
    }

    func unloadResource(resource: FSResource, options: FSTaskOptions) async throws {
    }
}
