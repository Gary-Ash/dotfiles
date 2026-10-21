___FILEHEADER___

#import "___FILEBASENAME___.h"


@interface ___FILEBASENAME___ () <ILMessageFilterQueryHandling, ILMessageFilterCapabilitiesQueryHandling>
@end

@implementation ___FILEBASENAME___

- (void)handleCapabilitiesQueryRequest:(ILMessageFilterCapabilitiesQueryRequest *)capabilitiesQueryRequest context:(ILMessageFilterExtensionContext *)context completion:(void (^)(ILMessageFilterCapabilitiesQueryResponse *))completion {
    ILMessageFilterCapabilitiesQueryResponse *response = [[ILMessageFilterCapabilitiesQueryResponse alloc] init];
    
    // TODO: Update subActions from ILMessageFilterSubAction enum
    // response.transactionalSubActions = @[ ... ];
    // response.promotionalSubActions = @[ ... ]
    
    completion(response);
}

- (void)handleQueryRequest:(ILMessageFilterQueryRequest *)queryRequest context:(ILMessageFilterExtensionContext *)context completion:(void (^)(ILMessageFilterQueryResponse *))completion {
    // First, check whether to filter using offline data (if possible).
    ILMessageFilterAction offlineAction;
    ILMessageFilterSubAction offlineSubAction;
    [self getOfflineAction:&offlineAction andOfflineSubAction:&offlineSubAction forQueryRequest:queryRequest];
    
    switch (offlineAction) {
        case ILMessageFilterActionAllow:
        case ILMessageFilterActionJunk:
        case ILMessageFilterActionPromotion:
        case ILMessageFilterActionTransaction: {
            // Based on offline data, we know this message should either be Allowed, Filtered as Junk, Promotional or Transactional. Send response immediately.
            ILMessageFilterQueryResponse *response = [[ILMessageFilterQueryResponse alloc] init];
            response.action = offlineAction;
            response.subAction = offlineSubAction;
            
            completion(response);
            break;
        }
            
        case ILMessageFilterActionNone: {
            // Based on offline data, we do not know whether this message should be Allowed or Filtered. Defer to network.
            // Note: Deferring requests to network requires the extension target's Info.plist to contain a key with a URL to use. See documentation for details.
            [context deferQueryRequestToNetworkWithCompletion:^(ILNetworkResponse *_Nullable networkResponse, NSError *_Nullable error) {
                ILMessageFilterQueryResponse *response = [[ILMessageFilterQueryResponse alloc] init];
                response.action = ILMessageFilterActionNone;
                response.subAction = ILMessageFilterSubActionNone;
                
                if (networkResponse) {
                    // If we received a network response, parse it to determine an action to return in our response.
                    ILMessageFilterAction networkAction;
                    ILMessageFilterSubAction networkSubAction;
                    [self getNetworkAction:&networkAction andNetworkSubAction:&networkSubAction forNetworkResponse:networkResponse];
                    response.action = networkAction;
                    response.subAction = networkSubAction;
                } else {
                    NSLog(@"Error deferring query request to network: %@", error);
                }
                
                completion(response);
            }];
            break;
        }
    }
}

- (void)getOfflineAction:(ILMessageFilterAction *)offlineAction andOfflineSubAction:(ILMessageFilterSubAction *)offlineSubAction forQueryRequest:(ILMessageFilterQueryRequest *)queryRequest {
    NSParameterAssert(offlineAction != NULL);
    NSParameterAssert(offlineSubAction != NULL);
    
    // TODO: Replace with logic to perform offline check whether to filter first (if possible).
    
    *offlineAction = ILMessageFilterActionNone;
    *offlineSubAction = ILMessageFilterSubActionNone;
}

- (void)getNetworkAction:(ILMessageFilterAction *)networkAction andNetworkSubAction:(ILMessageFilterSubAction *)networkSubAction forNetworkResponse:(ILNetworkResponse *)networkResponse {
    NSParameterAssert(networkAction != NULL);
    NSParameterAssert(networkSubAction != NULL);
    
    // TODO: Replace with logic to parse the HTTP response and data payload of `networkResponse` to return an action.
    
    *networkAction = ILMessageFilterActionNone;
    *networkSubAction = ILMessageFilterSubActionNone;
}

@end
