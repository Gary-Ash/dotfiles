___FILEHEADER___

import CrashReportExtension
import ExtensionFoundation
import Darwin.Mach
import os

@main
struct ___FILEBASENAME:identifier___: CrashReporterExtension {
    func processCrashReport(process: CrashedProcess) {
        // let corpsePort = process.corpsePort
        // let images = process.binaryImages
        // Generate your crash report...
    }
}
