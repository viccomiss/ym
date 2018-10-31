//
//  AppInfo.h
//  SuperEducation
//
//  Created by 123 on 2017/3/13.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

+(AppInfo*)shareInstance;
+(NSString *)currentVersion;
+(CGFloat)currentIOSVersion;
-(BOOL)checkAppVersion;

/**
 相机权限是否可用
 */
+ (BOOL)checkCameraAuthorizationStatus;
/**
 相册权限是否可用
 */
+ (BOOL)checkPhotoAuthorizationStatus;

/**
 判断麦克风
 */
+ (BOOL)checkMicAuthorizationStatus;

//前往系统设置界面
+ (void)goToSettting;

//跳转到wifi
+ (void)goToWiFi;

//跳转至微信
+(void)jumpToWechat;

//检测是否是第一次进入APP
+ (BOOL)isFirstLoad;

// 判断用户是否允许接收通知
+ (BOOL)isUserNotificationEnable;

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
+ (void)goToAppSystemSetting;

@end
