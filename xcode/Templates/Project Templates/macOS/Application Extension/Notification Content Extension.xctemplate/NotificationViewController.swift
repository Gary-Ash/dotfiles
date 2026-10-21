___FILEHEADER___

import Cocoa
import UserNotifications
import UserNotificationsUI

class ___FILEBASENAME___: NSViewController, UNNotificationContentExtension {

    @IBOutlet var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label.stringValue = notification.request.content.body
    }

}
