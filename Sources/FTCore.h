#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTCore : NSObject

+ (instancetype)sharedInstance;

/// Registriert alle Lifecycle-Observer (Scene + App).
/// Darf mehrfach aufgerufen werden – intern idempotent.
- (void)installLifecycleMonitoring;

/// Prüft Preferences + aktive Scene, startet Explorer falls passend.
- (void)scheduleExplorerPresentationIfNeeded;

@end

NS_ASSUME_NONNULL_END