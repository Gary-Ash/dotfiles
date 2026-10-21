___FILEHEADER___

import ExtensionFoundation
import Foundation
import FSKit

@main
struct ___FILEBASENAME:identifier___ : UnaryFileSystemExtension {
    var fileSystem : FSUnaryFileSystem & FSUnaryFileSystemOperations {
        ___PACKAGENAME:identifier___FileSystem()
    }
}
