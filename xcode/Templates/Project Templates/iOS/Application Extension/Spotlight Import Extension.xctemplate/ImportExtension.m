___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME___

- (BOOL)updateAttributes:(CSSearchableItemAttributeSet *)attributes forFileAtURL:(NSURL *)contentURL error:(NSError **)error {
    // Add attributes that describe the file at contentURL.
    // Return NO on error, and provide an NSError with details.
    return YES;
}

@end
