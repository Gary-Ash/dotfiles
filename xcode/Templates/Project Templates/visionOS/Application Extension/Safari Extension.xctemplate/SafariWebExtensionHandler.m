___FILEHEADER___

#import "___FILEBASENAME___.h"

#import <SafariServices/SafariServices.h>

@implementation ___FILEBASENAME___

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context
{
    id message = [context.inputItems.firstObject userInfo][SFExtensionMessageKey];
    NSLog(@"Received message from browser.runtime.sendNativeMessage: %@", message);

    NSExtensionItem *response = [[NSExtensionItem alloc] init];
    response.userInfo = @{ SFExtensionMessageKey: @{ @"Response to": message } };

    [context completeRequestReturningItems:@[ response ] completionHandler:nil];
}

@end
