___FILEHEADER___

#import <Foundation/Foundation.h>

#import "___PACKAGENAME:identifier___Provider.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        ___PACKAGENAME:identifier___ProviderSource *providerSource = [[___PACKAGENAME:identifier___ProviderSource alloc] initWithClientQueue:nil];
        [CMIOExtensionProvider startServiceWithProvider:providerSource.provider];
        CFRunLoopRun();
    }
    return 0;
}
