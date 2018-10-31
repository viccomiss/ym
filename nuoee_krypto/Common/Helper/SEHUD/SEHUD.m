//
//  SEHUD.m
//  SuperEducation
//
//  Created by 123 on 2017/2/27.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "SEHUD.h"
#import "CommonUtils.h"
#import <UIImageView+WebCache.h>
#import <UIImage+GIF.h>

#define hudColor [UIColor whiteColor]
#define hudActivityIndicatorColor [UIColor blackColor]
#define HUDAlertShowTime 2.0f

static UIView *lastViewWithHUD = nil;
static NSString * const kReminderTextLoading = @"加载中...";
static NSString * const kReminderTextNetworkUnavailable = @"网络链接不可用，请稍后再试";
static NSString * const kReminderTextNetworkNotGood = @"当前网络环境较差，请稍后再试";
static NSString * const kReminderTextNoData = @"没有相关记录";
@interface GlowButton : UIButton

@end
@implementation GlowButton {
    NSTimer *timer;
    float glowDelta;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //effect
        glowDelta = 0.2;
        timer = [NSTimer timerWithTimeInterval:0.05
                                        target:self
                                      selector:@selector(glow)
                                      userInfo:nil
                                       repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)glow {
    if (self.layer.shadowRadius > 7.0 || self.layer.shadowRadius < 0.1) {
        glowDelta *= -1;
    }
    self.layer.shadowRadius += glowDelta;
}

- (void)dealloc {
    [timer invalidate];
    timer = nil;
}
@end
@implementation SEHUD
/**
 *  获取到当前视图
 *
 *  @return 当前视图
 */
+ (UIView *)visibleView {
    
    UIViewController *visibleVC = [CommonUtils currentViewController];
    
    if (visibleVC) {
        return visibleVC.view;
    } else {
        return nil;
    }
}
#pragma mark - UIBlockingIndicator

+ (MBProgressHUD *)showUIBlockingIndicator {
    return [self showUIBlockingIndicatorWithText:nil];
}

+ (MBProgressHUD *)showUIBlockingIndicatorLoading {
    return [self showUIBlockingIndicatorWithText:kReminderTextLoading];
}

+ (MBProgressHUD *)showUIBlockingIndicatorWithText:(NSString *)str {
    //    if (GLobalRealReachability.currentReachabilityStatus != RealStatusViaWWAN &&
    //        GLobalRealReachability.currentReachabilityStatus != RealStatusViaWiFi) {
    //        return nil;
    //    }
    
    [self hideUIBlockingIndicator];
    //show the HUD
    UIView *targetView = [self visibleView];
    if (targetView == nil) return nil;
    
    lastViewWithHUD = targetView;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    hud.label.text = str;
    hud.mode = MBProgressHUDModeIndeterminate;
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = hudActivityIndicatorColor;
    hud.mode = MBProgressHUDModeIndeterminate;
//     hud.mode = MBProgressHUDModeCustomView;
//   UIImageView *gifV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 29)];
//    gifV.image = [UIImage sd_animatedGIFNamed:@"loading"];
//     hud.customView = gifV;
   
    //    hud.color = [UIColor whiteColor];
    //    gifV.backgroundColor = [UIColor blackColor];
    //    hud.dimBackground = YES;
    
    
    [targetView bringSubviewToFront:hud];
    return hud;
}

+ (MBProgressHUD *)showUIBlockingIndicatorWithText:(NSString *)str withTimeout:(NSTimeInterval)seconds {
    MBProgressHUD *hud = [self showUIBlockingIndicatorWithText:str];
    hud.customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    hud.mode = MBProgressHUDModeDeterminate;
    [hud hideAnimated:YES afterDelay:seconds];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    return hud;
}

+ (MBProgressHUD *)showUIBlockingProgressIndicatorWithText:(NSString *)str andProgress:(float)progress {
    //    if (GLobalRealReachability.currentReachabilityStatus != RealStatusViaWWAN &&
    //        GLobalRealReachability.currentReachabilityStatus != RealStatusViaWiFi) {
    //        return nil;
    //    }
    
    [self hideUIBlockingIndicator];
    
    //show the HUD
    UIView *targetView = [self visibleView];
    if (targetView == nil) return nil;
    
    lastViewWithHUD = targetView;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    //set the text
    hud.label.text = str;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.progress = progress;
    hud.removeFromSuperViewOnHide = YES;
    [targetView bringSubviewToFront:hud];
    return hud;
}

#pragma mark - alertShowInView

+ (MBProgressHUD *)showAlertWithText:(NSString *)text {
    return [self showAlertWithTitle:nil text:text];
}

+ (MBProgressHUD *)showAlertWithTitle:(NSString *)titleText text:(NSString *)text {
    MBProgressHUD *hud = [self showAlertWithTitle:titleText text:text target:nil action:NULL];
    [hud hideAnimated:YES afterDelay:HUDAlertShowTime];
    return hud;
}

+ (MBProgressHUD *)showAlertWithTitle:(NSString *)titleText text:(NSString *)text target:(id)t action:(SEL)sel {
    return [self showAlertWithTitle:titleText text:text target:t action:sel imageName:nil];
}

+ (MBProgressHUD *)showAlertErrWthText:(NSString *)text {
    return [self showAlertErrWithTitle:nil text:text];
}

+ (MBProgressHUD *)showAlertErrWithTitle:(NSString *)titleText text:(NSString *)text {
    MBProgressHUD *hud = [self showAlertErrWithTitle:titleText text:text target:nil action:NULL];
   [hud hideAnimated:YES afterDelay:HUDAlertShowTime];
    return hud;
}

+ (MBProgressHUD *)showAlertErrWithTitle:(NSString *)titleText text:(NSString *)text target:(id)t action:(SEL)sel {
    return [self showAlertWithTitle:titleText text:text target:t action:sel imageName:nil];
}

+ (MBProgressHUD *)showAlertWithTitle:(NSString *)titleText text:(NSString *)text target:(id)t action:(SEL)sel imageName:(NSString *)imageName {
    [self hideUIBlockingIndicator];
    
    //show the HUD
    UIView *targetView = [self visibleView];
    if (targetView == nil) return nil;
    
    lastViewWithHUD = targetView;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    
    //set the color
//    hud.bezelView.color = hudColor;
//    hud.alpha = 0.8f;
    hud.label.text = titleText;
    hud.label.font = Font(15);
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = Font(17);
    
//    //set the close button
//    GlowButton *btnClose = [GlowButton buttonWithType:UIButtonTypeCustom];
//    if (t != nil && sel != NULL) {
//        [btnClose addTarget:t action:sel forControlEvents:UIControlEventTouchUpInside];
//    } else {
//        [btnClose addTarget:hud action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    if (imageName) {
//        UIImage *imgClose = [UIImage imageNamed:imageName];
//        [btnClose setImage:imgClose forState:UIControlStateNormal];
//        [btnClose setFrame:CGRectMake(0, 0, imgClose.size.width, imgClose.size.height)];
//    }
    hud.mode = MBProgressHUDModeText;
    if (imageName && ![imageName isEqualToString:@""]) {
//        hud.customView = btnClose;
        hud.mode = MBProgressHUDModeCustomView;
    }

    hud.removeFromSuperViewOnHide = YES;
    
    [targetView bringSubviewToFront:hud];
    
    return hud;
}

+ (MBProgressHUD *)showUIBlockingIndicatorToView:(UIView *)view {
    
    [self hideUIBlockingIndicator];
    //show the HUD
    UIView *targetView = view;
    if (targetView == nil) return nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    hud.bezelView.color = hudColor;
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *gifV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 29)];
    gifV.image = [UIImage sd_animatedGIFNamed:@"loading"];
    gifV.backgroundColor = [UIColor whiteColor];
    hud.customView = gifV;
    [targetView bringSubviewToFront:hud];
    return hud;
}

#pragma mark - alertWithoutErrorImage

+ (MBProgressHUD *)showAlertNetWorkNotGood {
    return [self showAlertNoImageWithText:kReminderTextNetworkNotGood];
}

+ (MBProgressHUD *)showAlertNetWorkUnavaiable {
    return [self showAlertNoImageWithText:kReminderTextNetworkUnavailable];
}

+ (MBProgressHUD *)showAlertNoImageWithText:(NSString *)text {
    MBProgressHUD *hud = [self showAlertWithTitle:nil text:text target:nil action:NULL imageName:nil];
   [hud hideAnimated:YES afterDelay:HUDAlertShowTime];
    return hud;
}

#pragma mark - alertShowInWindow

+ (MBProgressHUD *)showIndicatorInWindow {
    return [self showIndicatorInWindowWithText:nil];
}

+ (MBProgressHUD *)showIndicatorInWindowWithText:(NSString *)text {
    //    if (GLobalRealReachability.currentReachabilityStatus != RealStatusViaWWAN &&
    //        GLobalRealReachability.currentReachabilityStatus != RealStatusViaWiFi) {
    //        return nil;
    //    }
    
    [self hideUIBlockingIndicator];
    
    lastViewWithHUD = [UIApplication sharedApplication].keyWindow;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:lastViewWithHUD animated:YES];
//    hud.bezelView.color = hudColor;
    hud.label.text = text;
    hud.bezelView.color = hudColor;
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *gifV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 29)];
    gifV.image = [UIImage sd_animatedGIFNamed:@"loading"];
    gifV.backgroundColor = [UIColor whiteColor];
    hud.customView = gifV;
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = hudActivityIndicatorColor;
    [lastViewWithHUD bringSubviewToFront:hud];
    
    return hud;
}


+ (MBProgressHUD *)showAlertInWindowWithText:(NSString *)string {
    
    [self hideUIBlockingIndicator];
    
    lastViewWithHUD = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:lastViewWithHUD animated:YES];
    
    //set the color
//    hud.bezelView.color = hudColor;
//    hud.alpha = 0.6f;
    hud.label.text = string;
    hud.label.font = Font(15);
    hud.detailsLabel.font = Font(17);
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:HUDAlertShowTime];
    return hud;
}

#pragma mark - hide

+ (void)hideUIBlockingIndicator {
    [MBProgressHUD hideHUDForView:lastViewWithHUD animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
@end
