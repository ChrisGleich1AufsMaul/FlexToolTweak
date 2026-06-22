#import "FTCore.h"
#import "FTPreferences.h"
#import "FLEXBridge.h"
#import <UIKit/UIKit.h>

@implementation FTCore {
    BOOL _didInstallMonitoring;
}

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static FTCore *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [self new];
    });
    return shared;
}

#pragma mark - Lifecycle Monitoring

- (void)installLifecycleMonitoring {
    // Idempotent – verhindert doppelte Observer
    if (_didInstallMonitoring) return;
    _didInstallMonitoring = YES;

    NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;

    // Für klassische UIKit-Apps
    [nc addObserver:self
           selector:@selector(handleLifecycleEvent:)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];

    // Für Multi-Scene / SwiftUI-Apps (iOS 13+)
    [nc addObserver:self
           selector:@selector(handleLifecycleEvent:)
               name:UISceneDidActivateNotification
             object:nil];
}

- (void)handleLifecycleEvent:(NSNotification *)note {
    [self scheduleExplorerPresentationIfNeeded];
}

#pragma mark - Explorer Presentation

- (void)scheduleExplorerPresentationIfNeeded {
    NSString *bundleID = NSBundle.mainBundle.bundleIdentifier;

    // Preferences prüfen
    if (![[FTPreferences sharedInstance] isEnabledForBundleIdentifier:bundleID]) return;

    // Erst präsentieren wenn eine nutzbare Scene bereit ist
    if (![self hasUsableForegroundScene]) return;

    [[FLEXBridge sharedInstance] presentExplorerIfPossible];
}

#pragma mark - Scene Detection

- (BOOL)hasUsableForegroundScene {
    // Fallback für iOS < 13 ohne Scene-Support
    if (![UIApplication.sharedApplication respondsToSelector:@selector(connectedScenes)]) {
        return UIApplication.sharedApplication.applicationState == UIApplicationStateActive;
    }

    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;

        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if (windowScene.activationState != UISceneActivationStateForegroundActive) continue;

        // Mindestens ein sichtbares Fenster muss vorhanden sein
        for (UIWindow *window in windowScene.windows) {
            if (!window.hidden) return YES;
        }
    }

    return NO;
}

@end