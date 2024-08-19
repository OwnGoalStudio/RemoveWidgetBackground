#import <UIKit/UIKit.h>

#import <HBLog.h>

static BOOL kIsEnabled = YES;
static NSSet<NSString *> *kWidgetBundleIdentifiers = nil;
static CGFloat kMaxWidgetWidth = 150;
static CGFloat kMaxWidgetHeight = 150;

@interface CHSWidget : NSObject
@property (nonatomic, copy, readonly) NSString *extensionBundleIdentifier;
@end

@interface CHUISWidgetScene : UIWindowScene
@property (nonatomic, copy, readonly) CHSWidget *widget;
@end

@interface CHUISAvocadoWindowScene : UIWindowScene
@property (nonatomic, copy, readonly) CHSWidget *widget; 
@end

@interface UIWindow (RWB)
@property (nonatomic, strong) NSNumber *rwb_shouldHideBackground;
@end

@interface RBLayer : CALayer
@end

@interface RBDisplayList : NSObject
- (id)xmlDescription;
@end

@interface SBHWidgetViewController : UIViewController
@end

@interface SBHWidgetStackViewController : UIViewController
@end

@interface WGWidgetListItemViewController : UIViewController
@end

@interface SBIcon : NSObject
@end

@interface SBIconView : NSObject
@property (nonatomic, strong) SBIcon *icon;
@end

%group RWBSpringBoard

%hook SBHWidgetViewController

- (void)viewWillAppear:(BOOL)arg1 {
    %orig;
    UIView *firstChild = nil;
    firstChild = self.view.subviews.firstObject;
    if ([firstChild isKindOfClass:%c(UIVisualEffectView)]) {
        [firstChild setAlpha:0];
    }
}

%end

%hook SBIconView

- (double)iconLabelAlpha {
    if (self.icon && [self.icon isKindOfClass:%c(SBWidgetIcon)]) {
        return 0;
    }
    return %orig;
}

- (double)effectiveIconLabelAlpha {
    if (self.icon && [self.icon isKindOfClass:%c(SBWidgetIcon)]) {
        return 0;
    }
    return %orig;
}

%end

%hook SBHWidgetStackViewController

- (void)viewWillAppear:(BOOL)arg1 {
    %orig;
    UIView *firstChild = nil;
    firstChild = self.view.subviews.firstObject;
    firstChild = firstChild.subviews.firstObject;
    if ([firstChild isKindOfClass:%c(MTMaterialView)]) {
        [firstChild setAlpha:0];
    }
}

%end

%hook WGWidgetListItemViewController

- (void)viewWillAppear:(BOOL)arg1 {
    %orig;
    UIView *firstChild = self.view.subviews.firstObject;
    if ([firstChild isKindOfClass:%c(MTMaterialView)]) {
        [firstChild setAlpha:0];
    }
}

%end

%end

%group RWB

%hook UIWindow

%property (nonatomic, strong) NSNumber *rwb_shouldHideBackground;

- (UIWindow *)initWithWindowScene:(UIWindowScene *)scene {
    if ([scene isKindOfClass:%c(CHUISAvocadoWindowScene)]) {
        CHUISAvocadoWindowScene *avocadoScene = (CHUISAvocadoWindowScene *)scene;
        HBLogDebug(@"initWithWindowScene: %@", avocadoScene.widget.extensionBundleIdentifier);
        if (avocadoScene.widget.extensionBundleIdentifier && [kWidgetBundleIdentifiers containsObject:avocadoScene.widget.extensionBundleIdentifier]) {
            self.rwb_shouldHideBackground = @YES;
        }
    }
    else if ([scene isKindOfClass:%c(CHUISWidgetScene)]) {
        CHUISWidgetScene *widgetScene = (CHUISWidgetScene *)scene;
        HBLogDebug(@"initWithWindowScene: %@", widgetScene.widget.extensionBundleIdentifier);
        if (widgetScene.widget.extensionBundleIdentifier && [kWidgetBundleIdentifiers containsObject:widgetScene.widget.extensionBundleIdentifier]) {
            self.rwb_shouldHideBackground = @YES;
        }
    }
    UIWindow *window = %orig;
    if (window) {
        [window setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
    }
    return window;
}

%end

%hook CHUISWidgetScene

- (unsigned long long)colorScheme {
    return 2;
}

%end

%hook CHSMutableScreenshotPresentationAttributes

- (long long)colorScheme {
    return 2;
}

%end

%hook CHSScreenshotPresentationAttributes

- (long long)colorScheme {
    return 2;
}

%end

%hook UIView

- (void)layoutSubviews {
    %orig;

    if (![NSStringFromClass([self class]) containsString:@"UIHostingView"]) {
        [self setBackgroundColor:UIColor.clearColor];
    }
}

%end

%hook RBLayer

- (void)display {
    UIView *view = (UIView *)self.delegate;
    if ([view isKindOfClass:[UIView class]] && view.window.rwb_shouldHideBackground.boolValue) {
        [NSThread currentThread].threadDictionary[@"rwb_shouldHideBackground"] = @YES;
        %orig;
        [NSThread currentThread].threadDictionary[@"rwb_shouldHideBackground"] = nil;
        [NSThread currentThread].threadDictionary[@"rwb_didSkipFirst"] = nil;
        return;
    }
    %orig;
}

%end

%end

%group RWB_15

%hook RBShape

- (void)setRect:(CGRect)arg1 {
    if ([NSThread currentThread].threadDictionary[@"rwb_shouldHideBackground"]) {
        if (arg1.size.width > kMaxWidgetWidth && arg1.size.height > kMaxWidgetHeight) {
            %orig(CGRectZero);
            return;
        }
    }
    %orig;
}

%end

%end

%group RWB_16

%hook RBShape

- (void)setRect:(CGRect)arg1 {
    if ([NSThread currentThread].threadDictionary[@"rwb_shouldHideBackground"]) {
        if (arg1.size.width > kMaxWidgetWidth && arg1.size.height > kMaxWidgetHeight) {
            if ([[NSThread currentThread].threadDictionary[@"rwb_didSkipFirst"] boolValue]) {
                %orig(CGRectZero);
                return;
            }
            [NSThread currentThread].threadDictionary[@"rwb_didSkipFirst"] = @YES;
        }
    }
    %orig;
}

%end

%end

%ctor {
    if (!kIsEnabled) {
        return;
    }

    kWidgetBundleIdentifiers = [NSSet setWithArray:@[
        @"com.growing.topwidgetsplus.Widget",
        @"com.apple.mobiletimer.WorldClockWidget", // 时钟
        @"com.apple.mobilecal.CalendarWidgetExtension", // 日历
        @"com.apple.mobilemail.MailWidgetExtension", // 邮件
        @"com.apple.ScreenTimeWidgetApplication.ScreenTimeWidgetExtension", // 使用时间
        @"com.apple.reminders.WidgetExtension", // 提醒事项
        @"com.apple.weather.widget", // 天气
    ]];

    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        %init(RWBSpringBoard);
    }
    else if ([bundleIdentifier isEqualToString:@"com.apple.chronod"]) {
        %init(RWB);
        if (@available(iOS 16, *)) {
            %init(RWB_16);
        } else {
            %init(RWB_15);
        }
    }
}