//
//  GenerateFiles.swift
//  CompositorServices_XcodeTemplates
//
//  Created by Jacob Wilson on 6/3/25.
//

import Foundation

let projectDir = CommandLine.arguments[1]
let activeCompilationConditions = CommandLine.arguments[2].split(separator: " ").filter{ $0.hasPrefix("CP_TEMPLATE") }

let templatePrefix = "CP_TEMPLATE_"

func parseFile(_ filePath: String) throws -> String {
    let fileContents = try String(contentsOf: URL(fileURLWithPath: projectDir + filePath), encoding: .utf8)
    var outputString = ""
    outputString.reserveCapacity(fileContents.count)

    let ifPrefix = "#if "
    enum CompilationConditionState {
        case none
        case included
        case excluded
        case nestedExcluded
    }
    var compilationConditionStateStack = [CompilationConditionState]()

    let deleteNextComment = "// CP_TEMPLATE_DELETE_NEXT"
    var skipNext = false

    for line in fileContents.components(separatedBy: "\n") {
        func endIfCheck() -> Bool {
            guard !compilationConditionStateStack.isEmpty else { return true }
            guard line.hasSuffix("#endif") else { return true }
            let last = compilationConditionStateStack.removeLast()
            guard last != .none else { return true }
            return false
        }
        func elseCheck(_ state: CompilationConditionState) -> Bool {
            guard !compilationConditionStateStack.isEmpty else { return true }
            guard line.hasSuffix("#else") else { return true }
            assert(compilationConditionStateStack.last! != .none)
            compilationConditionStateStack[compilationConditionStateStack.count - 1] = state
            return false
        }

        switch compilationConditionStateStack.last ?? .none {
        case .included:
            guard endIfCheck() else { continue }
            guard elseCheck(.excluded) else { continue }
            // Handle nested compilation conditions
            fallthrough
        case .none:
            if let ifIndex = line.range(of: ifPrefix) {
                if let index = line.range(of: templatePrefix, range: ifIndex.upperBound..<line.endIndex) {
                    if activeCompilationConditions.contains(line[index.lowerBound...]) {
                        compilationConditionStateStack.append(.included)
                    } else {
                        compilationConditionStateStack.append(.excluded)
                    }
                    continue
                } else {
                    compilationConditionStateStack.append(.none)
                }
            } else if !endIfCheck() {
            } else if skipNext {
                skipNext = false
                continue
            } else if line.hasSuffix(deleteNextComment) {
                skipNext = true
                continue
            }
            outputString += line + "\n"
        case .excluded:
            guard elseCheck(.included) else { continue }
            fallthrough
        case .nestedExcluded:
            guard endIfCheck() else { continue }
            if line.contains(ifPrefix) { compilationConditionStateStack.append(.nestedExcluded) }
        }
    }
    assert(compilationConditionStateStack.isEmpty)
    assert(!skipNext)

    outputString.removeLast(2) // remove last newlines
    return outputString
}

enum TemplateError: Swift.Error {
    case invalidSecondarySceneType
}

let primarySceneType = activeCompilationConditions.contains("\(templatePrefix)VOLUME") ? "Volume" : "Window"
let immersiveSpaceStyle: String
let secondarySceneType: String
if activeCompilationConditions.contains("\(templatePrefix)FULL") {
    immersiveSpaceStyle = "Full"
    secondarySceneType = "Mixed-Full"
} else if activeCompilationConditions.contains("\(templatePrefix)MIXED") {
    immersiveSpaceStyle = "Mixed"
    secondarySceneType = "Mixed-Full"
} else if activeCompilationConditions.contains("\(templatePrefix)PROGRESSIVE") {
    immersiveSpaceStyle = "Progressive"
    secondarySceneType = immersiveSpaceStyle
} else {
    throw TemplateError.invalidSecondarySceneType
}
let metal = activeCompilationConditions.contains("\(templatePrefix)MTL4") ? "Metal 4" : "Metal"

let appOutput: String

if activeCompilationConditions.contains("\(templatePrefix)MACOS") {
    let baseDir = "\(projectDir)/../../../../macOS/Application/Spatial Rendering App.xctemplate/\(metal)/\(immersiveSpaceStyle)"
    appOutput = "\(baseDir)/App.swift"
} else {
    appOutput = "\(projectDir)/../primarySceneType/\(primarySceneType)/secondarySceneType/\(metal)/immersiveSpaceStyle/\(immersiveSpaceStyle)/App.swift"
}

let rendererOutput = "\(projectDir)/../../../../MultiPlatform/Application/Compositor Services.xctemplate/\(metal)/\(secondarySceneType)/Renderer.swift"

do {
    let app = try parseFile("/CompositorServices_XcodeTemplates/App.swift")

    try app.write(toFile: appOutput, atomically: false, encoding: .utf8)

    let renderer = try parseFile("/CompositorServices_XcodeTemplates/Renderer.swift")
    try renderer.write(toFile: rendererOutput, atomically: false, encoding: .utf8)
} catch {
    fatalError("Error: \(error)")
}
