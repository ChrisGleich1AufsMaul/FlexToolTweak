
#import <UIKit/UIKit.h>
#import "FTCore.h"

// ─────────────────────────────────────────────
// MARK: - SpringBoard Hook (nur im Jailbreak-Build)
// ─────────────────────────────────────────────

%hook SpringBoard

// Wird aufgerufen wenn sich der vorderste Prozess ändert.
// Ersetzt den alten frontDisplayDidChange:-Hook durch
// einen stabileren modernen Einstiegspunkt.
- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    [[FTCore sharedInstance] installLifecycleMonitoring];
}

%end


// ─────────────────────────────────────────────
// MARK: - UIApplication Hook (alle Zielprozesse)
// ─────────────────────────────────────────────

%hook UIApplication

// Sicherer Einstiegspunkt: App ist foreground-active,
// aber noch vor erster User-Interaction.
- (void)applicationDidBecomeActive:(UIApplication *)application {
    %orig;
    [[FTCore sharedInstance] scheduleExplorerPresentationIfNeeded];
}

%end


// ─────────────────────────────────────────────
// MARK: - UIWindowScene Hook (Multi-Scene Support)
// ─────────────────────────────────────────────

%hook UIWindowScene

// Wird aufgerufen wenn eine Scene foreground-active wird.
// Deckt SwiftUI-Apps und Multi-Window-Szenarien ab.
- (void)scene:(UIScene *)scene
    didUpdateActivationState:(UISceneActivationState)previousActivationState {
    %orig;

    if (self.activationState == UISceneActivationStateForegroundActive) {
        [[FTCore sharedInstance] scheduleExplorerPresentationIfNeeded];
    }
}

%end


// ─────────────────────────────────────────────
// MARK: - Constructor
// ─────────────────────────────────────────────

%ctor {
    @autoreleasepool {
        // Nur Monitoring installieren –
        // keine direkte UI-Interaktion hier,
        // da noch kein Fenster existiert.
        [[FTCore sharedInstance] installLifecycleMonitoring];
    }
}