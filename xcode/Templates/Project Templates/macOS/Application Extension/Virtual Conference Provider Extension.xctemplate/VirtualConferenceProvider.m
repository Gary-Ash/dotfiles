___FILEHEADER___

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME___

- (void)fetchAvailableRoomTypesWithCompletionHandler:(void(^)(NSArray<EKVirtualConferenceRoomTypeDescriptor *> * _Nullable, NSError * _Nullable))completionHandler
{
    EKVirtualConferenceRoomTypeDescriptor *roomTypeDescriptor = [[EKVirtualConferenceRoomTypeDescriptor alloc] initWithTitle:@"My Virtual Conference Room" identifier:@"my_virtual_conference_room_identifier"];
    completionHandler(@[roomTypeDescriptor], nil);
}

- (void)fetchVirtualConferenceForIdentifier:(EKVirtualConferenceRoomTypeIdentifier)identifier completionHandler:(void(^)(EKVirtualConferenceDescriptor * _Nullable, NSError * _Nullable))completionHandler
{
    EKVirtualConferenceURLDescriptor *urlDescriptor = [[EKVirtualConferenceURLDescriptor alloc] initWithTitle:nil URL:[NSURL URLWithString:@"https://example.com/"]];
    EKVirtualConferenceDescriptor *virtualConferenceDescriptor = [[EKVirtualConferenceDescriptor alloc] initWithTitle:@"My Virtual Conference" URLDescriptors:@[urlDescriptor] conferenceDetails:@"Any other notes or details you wish to include about this virtual conference"];
    completionHandler(virtualConferenceDescriptor, nil);
}

@end
