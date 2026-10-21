___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME___

- (void)searchableIndex:(CSSearchableIndex *)searchableIndex reindexAllSearchableItemsWithAcknowledgementHandler:(void (^)(void))acknowledgementHandler
{
    
}

- (void)searchableIndex:(CSSearchableIndex *)searchableIndex reindexSearchableItemsWithIdentifiers:(NSArray<NSString *> *)identifiers acknowledgementHandler:(void (^)(void))acknowledgementHandler
{
    
}

- (nullable NSData *)dataForSearchableIndex:(CSSearchableIndex *)searchableIndex itemIdentifier:(NSString *)itemIdentifier typeIdentifier:(NSString *)typeIdentifier error:(out NSError ** __nullable)outError
{
    return nil;
}

- (nullable NSURL *)fileURLForSearchableIndex:(CSSearchableIndex *)searchableIndex itemIdentifier:(NSString *)itemIdentifier typeIdentifier:(NSString *)typeIdentifier inPlace:(BOOL)inPlace error:(out NSError ** __nullable)outError
{
    return nil;
}

- (void)searchableIndexDidThrottle:(CSSearchableIndex *)searchableIndex
{
    
}

- (void)searchableIndexDidFinishThrottle:(CSSearchableIndex *)searchableIndex
{

}

@end
