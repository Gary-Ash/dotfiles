___FILEHEADER___

#import <MailKit/MailKit.h>

@interface ___FILEBASENAME___ : NSObject <MEMessageSecurityHandler, MEMessageDecoder, MEMessageEncoder>

+ (instancetype)sharedInstance;

@end
