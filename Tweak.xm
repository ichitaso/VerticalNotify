@interface SBNotificationBannerWindow : NSObject @end
@interface NCNotificationContentView : UIView @end
@interface NCNotificationShortLookView : UIView @end
@interface NCNotificationViewControllerView : UIView @end

static float newYHeight;
static float notificationHeight;
static int notificationNumber;

%hook SBNotificationBannerWindow
- (void)didAddSubview:(UIView *)arg1 { //when a subview is added
    %orig;
    
    if ([arg1 isKindOfClass:%c(UITransitionView)]) { //custom method to find UIView of type
        if (notificationNumber < 1) {
            newYHeight = newYHeight + notificationHeight + 20;
        } else if (notificationNumber > 1) {
            newYHeight = newYHeight + notificationHeight + notificationHeight + 20;
        }
        notificationNumber++;
    }
}
- (void)willRemoveSubview:(UIView *)arg1 {
    %orig;
    notificationNumber = 0;
    newYHeight = 0;
}
%end

%hook NCNotificationViewControllerView
- (void)setHidden:(BOOL)arg1 { //KEEP NOTIFICATIONS FROM HIDING
    if (notificationNumber > 1) {
        %orig(NO);
    } else {
        %orig;
    }
}
%end

%hook NCNotificationShortLookView
- (void)layoutSubviews {
    %orig;

    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:%c(MTMaterialView)]) {
            notificationHeight = subview.bounds.size.height; //GET NOTIFICATION HEIGHT
            CGRect thisFrame = [[self valueForKey:@"frame"] CGRectValue];
            if (notificationNumber > 1) {
                thisFrame.origin.y = newYHeight; //move the y of the origin down on the screen
            }
            [self setValue:[NSValue valueWithCGRect:thisFrame] forKey:@"frame"];
        }
    }
}
%end

%ctor {
    @autoreleasepool {
        %init;
    }
}
