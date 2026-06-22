#import "FTPreferences.h"

@implementation FTPreferences

+ (instancetype)sharedInstance {
    static FTPreferences *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [self new];
    });
    return shared;
}

- (BOOL)isEnabledForBundleIdentifier:(NSString *)bundleIdentifier {
    if (bundleIdentifier.length == 0) return NO;
    NSString *key = [NSString stringWithFormat:@"FlexToolEnabled-%@", bundleIdentifier];
    CFPropertyListRef value = CFPreferencesCopyAppValue((CFStringRef)key, CFSTR("com.pba.FlexTool"));
    if (!value) return NO;
    BOOL enabled = CFGetTypeID(value) == CFBooleanGetTypeID() ? CFBooleanGetValue((CFBooleanRef)value) : NO;
    CFRelease(value);
    return enabled;
}

@end
