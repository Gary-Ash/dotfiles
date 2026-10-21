___FILEHEADER___

#import "___FILEBASENAME___.h"

#import "SafariExtensionViewController.h"

@interface ___FILEBASENAME___ ()

@end

@implementation ___FILEBASENAME___

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    NSExtensionItem *request = context.inputItems.firstObject;

    NSUUID *profile;
    if (@available(iOS 17.0, macOS 14.0, *)) {
        profile = request.userInfo[SFExtensionProfileKey];
    } else {
        profile = request.userInfo[@"profile"];
    }

    NSLog(@"The extension received a request for profile: %@", profile.UUIDString ?: @"none");
}

- (void)messageReceivedWithName:(NSString *)messageName fromPage:(SFSafariPage *)page userInfo:(NSDictionary *)userInfo {
    [page getPagePropertiesWithCompletionHandler:^(SFSafariPageProperties *properties) {
        NSLog(@"The extension received a message (%@) from a script injected into (%@) with userInfo (%@)", messageName, properties.url, userInfo);
    }];
}

- (void)toolbarItemClickedInWindow:(SFSafariWindow *)window {
    NSLog(@"The extension's toolbar item was clicked");
}

- (void)validateToolbarItemInWindow:(SFSafariWindow *)window validationHandler:(void (^)(BOOL enabled, NSString *badgeText))validationHandler {
    validationHandler(YES, nil);
}

- (SFSafariExtensionViewController *)popoverViewController {
    return [SafariExtensionViewController sharedController];
}

@end
