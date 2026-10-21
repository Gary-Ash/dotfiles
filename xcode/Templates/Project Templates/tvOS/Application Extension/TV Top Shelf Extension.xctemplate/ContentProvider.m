___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME:identifier___

- (void)loadTopShelfContentWithCompletionHandler:(void (^) (id<TVTopShelfContent> content))completionHandler {
    // Fetch content and call completionHandler
    completionHandler(nil);
}

@end
