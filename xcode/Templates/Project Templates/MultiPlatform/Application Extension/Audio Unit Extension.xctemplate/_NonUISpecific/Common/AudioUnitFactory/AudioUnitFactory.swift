___FILEHEADER___

import CoreAudioKit
import os

private let log = Logger(subsystem: "com.bundle.id.___PACKAGENAMEASIDENTIFIER___", category: "AudioUnitFactory")

public class AudioUnitFactory: NSObject, AUAudioUnitFactory {
    var auAudioUnit: AUAudioUnit?

    private var observation: NSKeyValueObservation?

    public func beginRequest(with context: NSExtensionContext) {

    }

    @objc
    public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        auAudioUnit = try ___PACKAGENAMEASIDENTIFIER___AudioUnit(componentDescription: componentDescription, options: [])

        guard let audioUnit = auAudioUnit as? ___PACKAGENAMEASIDENTIFIER___AudioUnit else {
            fatalError("Failed to create ___PACKAGENAMEASIDENTIFIER___")
        }

        audioUnit.setupParameterTree(___PACKAGENAMEASIDENTIFIER___ParameterSpecs.createAUParameterTree())

        self.observation = audioUnit.observe(\.allParameterValues, options: [.new]) { object, change in
            guard let tree = audioUnit.parameterTree else { return }
            
            // This insures the Audio Unit gets initial values from the host.
            for param in tree.allParameters { param.value = param.value }
        }

        return audioUnit
    }
    
}
