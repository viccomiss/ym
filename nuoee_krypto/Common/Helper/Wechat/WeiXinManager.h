//
//  WeiXinManager.h
//  Super-Learning
//
//  Created by runlin on 2016/12/23.
//  Copyright © 2016年 SiNetWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
typedef void (^WMCodeHandler)(NSString *code);

@interface WeiXinManager : NSObject<WXApiDelegate>
{
    WMCodeHandler _WMCodeHandler;
}
+ (WeiXinManager*)sharedManager;
+ (BOOL)isWXAppInstalled;
+ (BOOL)handleOpenURL:(NSURL *)url;
+ (void)registWeChat:(NSString *)appkey;
+ (void)sendAuthRequest:(UIViewController*)viewController codeHandler:(WMCodeHandler)WMCodeHandler;
//
////分享
//+ (void)shareWithType:(ShareType)type shareUrl:(NSString *)shareUrl Id:(NSString *)Id sessionType:(SessionType)sessionType isCopy:(BOOL)isCopy copyUrlBlock:(BaseIdBlock)copyUrlBlock;
//
////分享成为直播管理员
//+ (void)shareWithManagerType:(NSString *)typeUrl ID:(NSString *)ID coverImage:(NSString *)img title:(NSString *)title sessionType:(SessionType)sessionType isCopy:(BOOL)isCopy copyUrlBlock:(BaseIdBlock)copyUrlBlock;

@end
