___FILEHEADER___

#import "___FILEBASENAME___.h"

@interface ___FILEBASENAME___ ()
@property (strong) void (^pendingStartCompletion)(NSError *);
@end

@implementation ___FILEBASENAME___

- (void)startFilterWithCompletionHandler:(void (^)(NSError *error))completionHandler {
    // Add code to initialize the filter.
}

- (void)stopFilterWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
    // Add code to clean up filter resources.
    completionHandler();
}

- (NEFilterNewFlowVerdict *)handleNewFlow:(NEFilterFlow *)flow {
    // Add code to determine if the flow should be dropped or not, downloading new rules if required.
    return [NEFilterNewFlowVerdict allowVerdict];
}

- (NEFilterDataVerdict *)handleInboundDataFromFlow:(NEFilterFlow *)flow readBytesStartOffset:(NSUInteger)offset readBytes:(NSData *)readBytes {
    // Add code to process the data and return the appropriate verdict.
    return [NEFilterDataVerdict allowVerdict];
}

- (NEFilterDataVerdict *)handleOutboundDataFromFlow:(NEFilterFlow *)flow readBytesStartOffset:(NSUInteger)offset readBytes:(NSData *)readBytes {
    // Add code to process the data and return the appropriate verdict.
    return [NEFilterDataVerdict allowVerdict];
}

- (NEFilterDataVerdict *)handleInboundDataCompleteForFlow:(NEFilterFlow *)flow {
    // Add code to make a final decision about the flow.
    return [NEFilterDataVerdict allowVerdict];
}

- (NEFilterDataVerdict *)handleOutboundDataCompleteForFlow:(NEFilterFlow *)flow {
    // Add code to make a final decision about the flow.
    return [NEFilterDataVerdict allowVerdict];
}

- (void)handleRulesChanged {
    // Add code to re-read rules from disk.
}

@end
