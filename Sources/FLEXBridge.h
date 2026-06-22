#import <UIKit/UIKit.h>
#import "FLEXManager.h"

@interface FLEXBridge : NSObject
+ (instancetype)sharedInstance;
- (void)presentExplorerIfPossible;
- (void)hideExplorerIfNeeded;
@end
