___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME___

- (void)startFilterWithCompletionHandler:(void (^)(NSError *error))completionHandler {
    // Add code to initialize the filter.
    completionHandler(nil);
}

- (void)stopFilterWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
    // Add code to clean up filter resources.
    completionHandler();
}

- (void)handleNewFlow:(NEFilterFlow *)flow completionHandler:(void (^)(NEFilterControlVerdict *))completionHandler {
    // Add code to determine if the flow should be dropped or not, downloading new rules if required.
    completionHandler([NEFilterControlVerdict allowVerdictWithUpdateRules:NO]);
}

@end
