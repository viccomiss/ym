//
//  AppInfo.m
//  SuperEducation
//
//  Created by 123 on 2017/3/13.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "AppInfo.h"
#import "APIManager.h"
#import "Constant.h"
#import "NSDictionary+JKSafeAccess.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation AppInfo
+(AppInfo*)shareInstance{
    static AppInfo *info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[AppInfo alloc]init];
    });

    return info;
}

+ (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    } else { // iOS版本 <8.0 处理逻辑
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
    }
    return isEnable;
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
+ (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}

+ (BOOL)isFirstLoad{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    return NO;
}

+(void)jumpToWechat{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }else {
        [SEHUD showAlertWithText:@"您还没有安转微信客户端\n请前往App Store下载"];
    }
}

+(NSString *)currentVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(CGFloat)currentIOSVersion{
  return  [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (BOOL)checkPhotoAuthorizationStatus {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied) { //无权限
            return NO;
        }
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) { //无权限
            return NO;

        }
    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
        AVAuthorizationStatus author =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied) { //无权限
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkMicAuthorizationStatus {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
        AVAuthorizationStatus author =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied) { //无权限
            return NO;
        }
    }
    return YES;
}

+ (void)goToSettting{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)goToWiFi{
    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        NSLog(@"can not open");
    }
}


@end
