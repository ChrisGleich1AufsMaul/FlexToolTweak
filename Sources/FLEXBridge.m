#import "FLEXBridge.h"
#import "FLEXManager.h"

@implementation FLEXBridge {
    BOOL _isPresenting;
}

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static FLEXBridge *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [self new];
    });
    return shared;
}

#pragma mark - Explorer Control

- (void)presentExplorerIfPossible {
    // Reentrancy-Schutz – verhindert Doppelpräsentation
    if (_isPresenting) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        // Nochmal prüfen auf Main Thread (thread-safe)
        if (self->_isPresenting) return;

        self->_isPresenting = YES;
        [[FLEXManager sharedManager] showExplorer];
    });
}

- (void)hideExplorerIfNeeded {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->_isPresenting) return;

        [[FLEXManager sharedManager] hideExplorer];
        self->_isPresenting = NO;
    });
}

#pragma mark - State

- (BOOL)isExplorerVisible {
    return _isPresenting;
}

@end