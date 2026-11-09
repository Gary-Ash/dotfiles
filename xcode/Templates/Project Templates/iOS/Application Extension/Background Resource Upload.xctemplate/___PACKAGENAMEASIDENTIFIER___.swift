___FILEHEADER___

import Foundation
import ExtensionFoundation
import Photos

@main
class BackgroundUploadExtension: PHBackgroundResourceUploadJobExtension {

    required init() {
        print("Initialized")
    }

    func processJobs() async -> PHBackgroundResourceUploadProcessingResult {
        print("Processing")
        
        /// Please refer to documentation on uploading asset resources in the background. Some todos include:
        
        ///     Retry any failed jobs.
        ///     Acknowledge completed jobs to free up the in-flight job limit.
        ///     Create new upload jobs for unprocessed assets.
        
        /// Return .completed when you are up to date with the photos library
        /// Otherwise return .processing to continue library uploads
        return .processing
    }
    
    func willTerminate() async {
        print("Terminating")
        
        /// Perform any actions here that you need before the extension terminates
    }
}
