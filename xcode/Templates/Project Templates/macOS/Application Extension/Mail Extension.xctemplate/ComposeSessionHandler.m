___FILEHEADER___

#import "___FILEBASENAME___.h"
#import "ComposeSessionViewController.h"

@implementation ___FILEBASENAME___

- (void)mailComposeSessionDidBegin:(MEComposeSession *)session {
    // Perform any setup necessary for handling the compose session.
}

- (void)mailComposeSessionDidEnd:(MEComposeSession *)session {
    // Perform any cleanup now that the compose session is over.
}

// MARK: - Annotating Address Tokens

- (void)session:(MEComposeSession *)session annotateAddressesWithCompletionHandler:(void (^)(NSDictionary<MEEmailAddress *,MEAddressAnnotation *> * _Nonnull))completionHandler {
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    // Iterate through all the receipients in the message.
    //
    // NOTE: If there isn't any definitive information we can provide about
    // the address, don't add an annotation for it.
    for (MEEmailAddress *address in session.mailMessage.allRecipientAddresses) {
        // If the address ends in @example.com, indicate that's an error.
        if ([address.rawString hasSuffix:@"@example.com"]) {
            // Create an address annotation that Mail shows in the address token.
            NSString *error = @"example.com is not a valid domain.";
            MEAddressAnnotation *annotation = [MEAddressAnnotation errorWithLocalizedDescription:error];
            
            // Add the annotation to the results dictionary.
            results[address] = annotation;
        }
    }

    // Call the Completion handler with the results.
    completionHandler(results);
}

// MARK: - Displaying Custom Compose Options

- (nonnull MEExtensionViewController *)viewControllerForSession:(nonnull MEComposeSession *)session {
    return [[ComposeSessionViewController alloc] initWithNibName:@"ComposeSessionViewController" bundle:[NSBundle mainBundle]];
}

// MARK: - Adding Custom Headers

- (NSDictionary<NSString *,NSArray<NSString *> *> *)additionalHeadersForSession:(MEComposeSession *)session {
    // To insert custom headers into a message, return a dictionary with
    // the key and an array of one or more values.
    return @{ @"X-CustomHeader": @[@"This is a custom header."] };
}

// MARK: - Confirming Message Delivery

- (void)session:(MEComposeSession *)session canSendMessageWithCompletionHandler:(void (^)(NSError * _Nullable))completion {
    // Before Mail sends a message, your extension can validate the
    // contents of the compose session. If the message is ready to be sent,
    // call the compltion block with nil. If the message isn't ready to be
    // sent, call the completion with an error.
    BOOL canSend = YES;
    
    for (MEEmailAddress *recipient in session.mailMessage.allRecipientAddresses) {
        if ([recipient.rawString hasSuffix:@"@example.com"]) {
            canSend = NO;
            break;
        }
    }
    
    if (!canSend) {
        NSError *error = [NSError errorWithDomain:MEComposeSessionErrorDomain code:MEComposeSessionErrorCodeInvalidRecipients userInfo:@{NSLocalizedDescriptionKey: @"example.com is not a valid recipient domain"}];
        completion(error);
    } else {
        completion(nil);
    }
}

@end

