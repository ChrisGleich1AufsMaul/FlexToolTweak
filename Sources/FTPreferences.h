#import <Foundation/Foundation.h>

@interface FTPreferences : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isEnabledForBundleIdentifier:(NSString *)bundleIdentifier;
@end
