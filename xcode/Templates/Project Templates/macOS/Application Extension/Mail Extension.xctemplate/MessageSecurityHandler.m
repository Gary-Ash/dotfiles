___FILEHEADER___

#import "___FILEBASENAME___.h"
#import "MessageSecurityViewController.h"

@implementation ___FILEBASENAME___

+ (instancetype)sharedInstance {
    static MessageSecurityHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MessageSecurityHandler alloc] init];
    });
    return sharedInstance;
}

// MARK: - Encoding Messages

- (void)getEncodingStatusForMessage:(nonnull MEMessage *)message composeContext:(nonnull MEComposeContext *)composeContext completionHandler:(nonnull void (^)(MEOutgoingMessageEncodingStatus * _Nonnull))completionHandler  {
    // Indicate whether you support signing, encrypting, or both. If the
    // message contains recipients that you can't sign or encrypt for,
    // specify an error and include the addresses in the
    // addressesFailingEncryption array parameter. Update this code with
    // the options your extension supports.
    MEOutgoingMessageEncodingStatus *status = [[MEOutgoingMessageEncodingStatus alloc] initWithCanSign:NO canEncrypt:NO securityError:nil addressesFailingEncryption:@[]];
    
    // Call the completion handler with the message status.
    completionHandler(status);
}

- (void)encodeMessage:(nonnull MEMessage *)message composeContext:(nonnull MEComposeContext *)composeContext completionHandler:(nonnull void (^)(MEMessageEncodingResult * _Nonnull))completionHandler {
    // The result of the encoding operation. This object contains
    // the encoded message or an error to indicate what failed.
    MEMessageEncodingResult *result = nil;
    
    // Add code here to sign and/or encrypt the message.
    //
    // If the encoding is successful, you create an instance
    // of MEEncodedOutgoingMessage that contains the encoded data and
    // indications whether the data is signed and/or encrypted.
    // For example:
    //
    // MEEncodedOutgoingMessage *encodedMessage = [[MEEncodedOutgoingMessage alloc] initWithRawData:encodedData isSigned:YES isEncrypted:YES];
    //
    // Finally, create an MEMessageEncodingResult that includes the
    // MEEncodedOutgoingMessage or errors to indicate why the encoding
    // failed. If the message doesn't need to be encoded, pass nil,
    // otherwise pass an MEEncodedOutgoingMessage as shown above.
    result = [[MEMessageEncodingResult alloc] initWithEncodedMessage:nil signingError:nil encryptionError:nil];
  
    // Call the completion handler with the result, or nil if
    // the extension didn't attempt to encode the message at all.
    completionHandler(result);
}

// MARK: - Decoding Messages

- (nullable MEDecodedMessage *)decodedMessageForMessageData:(nonnull NSData *)data {
    // In this method, you decode the message data. Create an
    // MEMessageSecurityInformation object to capture details about the decoded
    // message. If an error occurs, create an NSError that describes the
    // failure, and specify it in the security information object. For example:
    //
    // MEMessageSecurityInformation *securityInfo = [[MEMessageSecurityInformation alloc] initWithSigners:@[] isEncrypted:NO signingError:nil encryptionError:error];
    //
    // Create a decoded message object that contains the decoded data and the
    // security information. For example:
    //
    // NSData *decodedData = ...
    // MEDecodedMessage *decodedMessage = [[MEDecodedMessage alloc] initWithData:decodedData securityInformation:securityInfo context:nil];
    
    // If the message doesn't need to be decoded, return nil.
    // Otherwise return an MEDecodedMessage, as shown above.
    return nil;
}

// MARK: - Displaying Encoding Information

- (nullable MEExtensionViewController *)extensionViewControllerForMessageSigners:(nonnull NSArray<MEMessageSigner *> *)messageSigners {
    // Return a view controller that shows details about the encoded message.
    return [[MessageSecurityViewController alloc] initWithNibName:@"MessageSecurityViewController" bundle:[NSBundle mainBundle]];
}

// MARK: mark - Displaying Additional Context

- (nullable MEExtensionViewController *)extensionViewControllerForMessageContext:(nonnull NSData *)context {
    // Return a view controller that can show additional message context.
    return nil;
}

- (void)primaryActionClickedForMessageContext:(nonnull NSData *)context completionHandler:(nonnull void (^)(MEExtensionViewController * _Nullable))completionHandler {
    // Provide a view controller that is displayed when user clicks on the message banner that is displayed when viewing a decoded mail message.
    completionHandler(nil);
}

@end
