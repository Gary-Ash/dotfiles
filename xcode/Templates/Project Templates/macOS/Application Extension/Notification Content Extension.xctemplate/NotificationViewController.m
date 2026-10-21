___FILEHEADER___

#import "___FILEBASENAME___.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface ___FILEBASENAME___ () <UNNotificationContentExtension>

@property IBOutlet NSTextField *label;

@end

@implementation ___FILEBASENAME___

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.stringValue = notification.request.content.body;
}

@end
