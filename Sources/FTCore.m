#import "FTCore.h"
#import <UIKit/UIKit.h>
#import "FTPreferences.h"
#import "FLEXBridge.h"

@implementation FTCore {
    BOOL _didInstallMonitoring;
}

+ (instancetype)sharedInstance {
    static FTCore *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [self new];
    });
    return shared;
}

- (void)installLifecycleMonitoring {
    if (_didInstallMonitoring) return;
    _didInstallMonitoring = YES;

    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
    [nc addObserver:self selector:@selector(handleLifecycleEvent:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [nc addObserver:self selector:@selector(handleLifecycleEvent:) name:UISceneDidActivateNotification object:nil];
}

- (void)handleLifecycleEvent:(NSNotification *)note {
    [self scheduleExplorerPresentationIfNeeded];
}

- (BOOL)hasUsableForegroundScene {
    UIApplication *app = UIApplication.sharedApplication;
    for (UIScene *scene in app.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if (windowScene.activationState != UISceneActivationStateForegroundActive) continue;
        for (UIWindow *window in windowScene.windows) {
            if (!window.hidden) return YES;
        }
    }
    return NO;
}

- (void)scheduleExplorerPresentationIfNeeded {
    NSString *bundleID = NSBundle.mainBundle.bundleIdentifier;
    if (![[FTPreferences sharedInstance] isEnabledForBundleIdentifier:bundleID]) return;
    if (![self hasUsableForegroundScene]) return;
    [[FLEXBridge sharedInstance] presentExplorerIfPossible];
}

@end
