#import <Foundation/Foundation.h>
#import "FTCore.h"

__attribute__((constructor))
static void FlexToolLiveContainerEntry(void) {
    @autoreleasepool {
        [[FTCore sharedInstance] installLifecycleMonitoring];
    }
}
