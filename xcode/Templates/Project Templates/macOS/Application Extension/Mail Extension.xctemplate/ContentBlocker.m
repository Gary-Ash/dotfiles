___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME___

+ (instancetype)sharedInstance {
    static ContentBlocker *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ContentBlocker alloc] init];
    });
    return sharedInstance;
}

- (NSData *)contentRulesJSON {
    // Read in the JSON file that contains the content blocking
    // rules and return it as data. The example rules file uses CSS
    // to hide all URLs that link to example.com.
    //
    // These rules are the same as Safari content blockers use.
    // For more information about creating content blocking rules, see:
    // https://developer.apple.com/documentation/safariservices/creating_a_content_blocker
    NSURL *url = [NSBundle.mainBundle URLForResource:@"ContentBlockerRules" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];

    return data;
}

@end

