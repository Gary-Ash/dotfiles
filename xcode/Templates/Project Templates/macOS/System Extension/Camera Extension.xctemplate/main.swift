___FILEHEADER___

import Foundation
import CoreMediaIO

let providerSource = ___PACKAGENAME:identifier___ProviderSource(clientQueue: nil)
CMIOExtensionProvider.startService(provider: providerSource.provider)

CFRunLoopRun()
