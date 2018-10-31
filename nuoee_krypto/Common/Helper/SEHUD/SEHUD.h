//
//  SEHUD.h
//  SuperEducation
//
//  Created by 123 on 2017/2/27.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface SEHUD : NSObject
/**
 *  show indicator in current view
 *
 *  @return hud
 */
+ (MBProgressHUD *)showUIBlockingIndicator;
+ (MBProgressHUD *)showUIBlockingIndicatorLoading;
+ (MBProgressHUD *)showUIBlockingIndicatorWithText:(NSString *)str;
//+ (MBProgressHUD *)showUIBlockingIndicatorWithText:(NSString *)str;
+ (MBProgressHUD *)showUIBlockingIndicatorWithText:(NSString *)str withTimeout:(NSTimeInterval)seconds;

+ (MBProgressHUD *)showUIBlockingProgressIndicatorWithText:(NSString *)str andProgress:(float)progress;

/**
 *  show correct alert in current view, and hide after 1.0s
 *
 *  @return hud
 */
+ (MBProgressHUD *)showAlertWithText:(NSString *)text;
+ (MBProgressHUD *)showAlertWithTitle:(NSString *)titleText text:(NSString *)text;
+ (MBProgressHUD *)showAlertWithTitle:(NSString *)titleText text:(NSString *)text target:(id)t action:(SEL)sel;

/**
 *  show correct alert in target view, and hide after 1.0s
 *
 *  @return hud
 */
//+ (MBProgressHUD *)showUIBlockingIndicatorToView:(UIView *)view;


/**
 *  show error alert in current view, and hide after 1.0s
 *
 *  @return hud
 */
+ (MBProgressHUD *)showAlertErrWthText:(NSString *)text;
+ (MBProgressHUD *)showAlertErrWithTitle:(NSString *)titleText text:(NSString *)text;
+ (MBProgressHUD *)showAlertErrWithTitle:(NSString *)titleText text:(NSString *)text target:(id)t action:(SEL)sel;

/**
 *  show alert with no image in current view, and hide after 1.0s
 *
 *  @return hud
 */
+ (MBProgressHUD *)showAlertNetWorkNotGood;
+ (MBProgressHUD *)showAlertNetWorkUnavaiable;
+ (MBProgressHUD *)showAlertNoImageWithText:(NSString *)text;

/**
 *  show indicator in window
 *
 *  @return hud
 */
+ (MBProgressHUD *)showIndicatorInWindow;
+ (MBProgressHUD *)showIndicatorInWindowWithText:(NSString *)text;
+ (MBProgressHUD *)showAlertInWindowWithText:(NSString *)string;

+ (void)hideUIBlockingIndicator;

@end
