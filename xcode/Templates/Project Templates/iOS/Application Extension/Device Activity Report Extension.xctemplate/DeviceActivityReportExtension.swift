___FILEHEADER___

import DeviceActivity
import ExtensionKit
import SwiftUI

@main
struct ___FILEBASENAME___: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
