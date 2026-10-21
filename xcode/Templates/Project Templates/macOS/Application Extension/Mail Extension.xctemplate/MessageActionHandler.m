___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME___

+ (instancetype)sharedInstance {
    static MessageActionHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MessageActionHandler alloc] init];
    });
    return sharedInstance;
}

- (void)decideActionForMessage:(nonnull MEMessage *)message completionHandler:(nonnull void (^)(MEMessageActionDecision * _Nullable))completionHandler {
    // The action to take on the message, if any.
    MEMessageActionDecision *decision = nil;

    // Check if the subject of the message contains the word Mars.
    // If it does, specify an action to set the background color to red.
    if ([message.subject containsString:@"Mars"]) {
        decision = [MEMessageActionDecision decisionApplyingAction:[MEMessageAction setBackgroundColorActionWithColor:MEMessageActionMessageColorRed]];
    }
    
    // Always call the completion handler, passing the action
    // to take, or nil if there's no action.
    completionHandler(decision);
}

@end

