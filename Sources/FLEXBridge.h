#import <UIKit/UIKit.h>
#import <FLEX/FLEXManager.h>

@interface FLEXBridge : NSObject
+ (instancetype)sharedInstance;
- (void)presentExplorerIfPossible;
- (void)hideExplorerIfNeeded;
@end
