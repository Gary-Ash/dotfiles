___FILEHEADER___

#import <Foundation/Foundation.h>
#import <CoreMediaIO/CMIOExtension.h>

@interface ___PACKAGENAME:identifier___ProviderSource : NSObject<CMIOExtensionProviderSource>

- (instancetype)initWithClientQueue:(dispatch_queue_t)clientQueue;

@property(nonatomic, readonly) CMIOExtensionProvider *provider;

@end
