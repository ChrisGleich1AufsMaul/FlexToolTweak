#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLEXBridge : NSObject

+ (instancetype)sharedInstance;

/// Zeigt den FLEX-Explorer – nur einmal gleichzeitig, Main Thread gesichert.
- (void)presentExplorerIfPossible;

/// Versteckt den FLEX-Explorer.
- (void)hideExplorerIfNeeded;

/// Gibt an ob der Explorer gerade sichtbar ist.
@property (nonatomic, readonly) BOOL isExplorerVisible;

@end

NS_ASSUME_NONNULL_END