#import <UIKit/UIKit.h>
#import "FTCore.h"

%hook UIApplication

- (void)_sendWillEnterForegroundCallbacks {
    %orig;
    [[FTCore sharedInstance] scheduleExplorerPresentationIfNeeded];
}

%end

%ctor {
    @autoreleasepool {
        [[FTCore sharedInstance] installLifecycleMonitoring];
    }
}
