___FILEHEADER___

import ExtensionFoundation
import FinanceKit

@main
class ___PACKAGENAMEASIDENTIFIER___Extension: BackgroundDeliveryExtension {
    required init() {
        // Set up any resources or storage used by the extension
    }

    func didReceiveData(for types: [FinanceStore.BackgroundDataType]) async {
        // The provided data types indicate what's changed in the finance store
        // You can use them to inform what the extension queries from FinanceKit

        // Returning from this function will close the extension
    }

    func willTerminate() async {
        // Called just before the extension will be terminated by the system
    }
}
