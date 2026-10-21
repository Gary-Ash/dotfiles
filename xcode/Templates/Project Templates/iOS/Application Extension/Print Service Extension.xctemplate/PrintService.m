___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME___

- (NSArray <UIPrinterDestination *> *)printerDestinationsForPrintInfo:(UIPrintInfo *)printInfo
{
    NSMutableArray <UIPrinterDestination *> *destinations = [NSMutableArray new];
    
    // Use an app group to obtain shared preferences. This App Group must also be specified in the app's entitlements.
    
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.example.PrintServiceApp"];
    NSDictionary *cloudPreferences = [groupDefaults dictionaryForKey:@"cloud_prefs"];
    
    if (cloudPreferences) {
        NSString *urlString = cloudPreferences[@"cloud_url"];
        
        NSURL *url = [NSURL URLWithString:urlString];
        if (url != nil) {
            UIPrinterDestination *destination = [[UIPrinterDestination alloc] initWithURL:url];
            
            destination.displayName = cloudPreferences[@"cloud_dpy"];
            
            NSDictionary <NSString *, NSString *> *txtDict = cloudPreferences[@"cloud_txt"];
            if (txtDict) {
                NSMutableDictionary<NSString*, NSData*> *txtDataDict = [NSMutableDictionary new];
                
                [txtDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                    txtDataDict[key] = [obj dataUsingEncoding:NSASCIIStringEncoding];
                }];
                
                destination.txtRecord = [NSNetService dataFromTXTRecordDictionary:txtDataDict];
            }
            
            [destinations addObject:destination];
        }
    }
    
    return destinations;
}

@end
