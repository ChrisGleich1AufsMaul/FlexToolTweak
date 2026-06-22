#import <Foundation/Foundation.h>

@interface FTCore : NSObject
+ (instancetype)sharedInstance;
- (void)installLifecycleMonitoring;
- (void)scheduleExplorerPresentationIfNeeded;
@end
