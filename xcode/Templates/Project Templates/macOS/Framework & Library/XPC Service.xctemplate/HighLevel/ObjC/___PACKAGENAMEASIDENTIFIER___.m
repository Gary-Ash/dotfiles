___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME___

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)performCalculationWithNumber:(NSNumber *)firstNumber andNumber:(NSNumber *)secondNumber withReply:(void (^)(NSNumber *))reply {
    NSInteger result = firstNumber.integerValue + secondNumber.integerValue;
    reply(@(result));
}

@end
