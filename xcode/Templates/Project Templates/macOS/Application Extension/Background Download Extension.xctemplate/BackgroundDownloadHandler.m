___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation BackgroundDownloadHandler

- (NSSet<BADownload *> *)downloadsForRequest:(BAContentRequest)contentRequest
                                 manifestURL:(NSURL *)manifestURL
                               extensionInfo:(BAAppExtensionInfo *)extensionInfo
{
    // Invoked by the system to request downloads from your extension.
    // The BAContentRequest argument will contain the reason downloads are requested.
    // The system will pre-download the contents of the URL specified in the `BAManifestURL`
    // key in your app's `Info.plist` before calling into your extension. The `manifestURL`
    // argument will point to a read-only file containing those contents. You are encouraged
    // to use this file to determine what assets need to be downloaded.

    NSString *appGroupIdentifier = @"$(TeamIdentifierPrefix)___VARIABLE_bundleIdentifierPrefix:bundleIdentifier___";

    // Parse the file at `manifestURL` to determine what assets are available
    // that might need to be scheduled for download.
    // Note: A downloads's identifier should be unique. It is what is used to track your
    // download between the extension and app.
    NSURL *assetURL = [NSURL URLWithString:@"https://example.com/large-asset.bin"];
    NSUInteger oneMB = 1024 * 1024;
    NSUInteger assetSize = oneMB * 4;

    // Then, create a set of downloads to return to the system.
    NSMutableSet<BAURLDownload *> *downloadsToSchedule = [NSMutableSet set];

    switch (contentRequest) {
        case BAContentRequestInstall:
        case BAContentRequestUpdate:
        {
            // In an install or update request, you can return both Essential and Non-Essential downloads.
            // Essential downloads will be started by the system while your app is installing/updating,
            // and the user cannot launch the app until they complete or fail.
            // To mark a download as Essential, pass `true` for the `essential` initializer argument.
            BAURLDownload *essentialDownload = [[BAURLDownload alloc] initWithIdentifier:@"Unique-Asset-Identifier"
                                                                                 request:[NSURLRequest requestWithURL:assetURL]
                                                                               essential:true
                                                                                fileSize:assetSize
                                                              applicationGroupIdentifier:appGroupIdentifier
                                                                                priority:BADownloaderPriorityDefault];
            [downloadsToSchedule addObject:essentialDownload];
            break;
        }

        case BAContentRequestPeriodic:
        {
            // In a periodic request, you can only return Non-Essential downloads.
            // Non-Essential downloads occur in the background and will not prevent the
            // user from launching your app.
            // To mark a download as Non-Essential, pass `false` for the `essential` initializer argument.
            BAURLDownload *nonEssentialDownload = [[BAURLDownload alloc] initWithIdentifier:@"Unique-Asset-Identifier"
                                                                                    request:[NSURLRequest requestWithURL:assetURL]
                                                                                  essential:false
                                                                                   fileSize:assetSize
                                                                 applicationGroupIdentifier:appGroupIdentifier
                                                                                   priority:BADownloaderPriorityDefault];
            [downloadsToSchedule addObject:nonEssentialDownload];
            break;
        }

        default:
            return [NSSet set];
    }

    // The downloads that are returned will be downloaded automatically by the system.
    return downloadsToSchedule;
}

- (void)backgroundDownload:(BADownload *)download failedWithError:(NSError *)error
{
    // Extension was woken because a download failed.
    // A download can be rescheduled with BADownloadManager if necessary.
}

- (void)backgroundDownload:(BADownload *)download finishedWithFileURL:(NSURL *)fileURL
{
    // Extension was woken because a download finished.
    // It is strongly advised to keep files in `Library/Caches` so that they may be
    // deleted when the device becomes low on storage.
}

@end
