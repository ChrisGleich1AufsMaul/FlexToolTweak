#import "FLEXBridge.h"

@implementation FLEXBridge {
    BOOL _isPresenting;
}

+ (instancetype)sharedInstance {
    static FLEXBridge *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [self new];
    });
    return shared;
}

- (void)presentExplorerIfPossible {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_isPresenting) return;
        self->_isPresenting = YES;
        [[FLEXManager sharedManager] showExplorer];
    });
}

- (void)hideExplorerIfNeeded {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[FLEXManager sharedManager] hideExplorer];
        self->_isPresenting = NO;
    });
}

@end
