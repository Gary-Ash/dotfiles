___FILEHEADER___

import UIKit

class ___FILEBASENAME___: UIPrintServiceExtension {
    
    override func printerDestinations(for printInfo: UIPrintInfo) -> [UIPrinterDestination] {
        var destinations: [UIPrinterDestination] = []
        
        // Use an app group to obtain shared preferences. Replace the suite name with the one in your app's entitlements.
        
        let groupDefaults = UserDefaults(suiteName: "group.com.example.PrinterServiceSampleApp")
        
        if let cloudPreferences = groupDefaults?.dictionary(forKey: "cloud_prefs"),
           let urlString = cloudPreferences["cloud_url"] as? String,
           let url = URL(string: urlString)
        {
            let destination = UIPrinterDestination(url: url)
            
            destination.displayName = cloudPreferences["cloud_dpy"] as? String
            
            if let txtDict = cloudPreferences["cloud_txt"] as? Dictionary<String, String> {
                let txtDataDict: [String: Data] = txtDict.compactMapValues { $0.data(using: .ascii) }
                
                destination.txtRecord = NetService.data(fromTXTRecord: txtDataDict)
            }
            
            destinations.append(destination)
        }
        
        return destinations
    }
    
}
