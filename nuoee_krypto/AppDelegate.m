//
//  AppDelegate.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/29.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "BaseNavigationControllerKit.h"
#import "BaseTabBarControllerConfig.h"
#import "XGPush.h"
#import "Constant.h"
#import "NSString+JLAdd.h"
#import "LoginViewController.h"
#import "SEUserDefaults.h"
#import "NotificationTool.h"

//share
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

@interface AppDelegate ()<UITabBarControllerDelegate,CYLTabBarControllerDelegate,XGPushDelegate,XGPushTokenManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupIQkeyborad];
    [self setupLogin];//登录设置
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self monitorNetwork];
    [self registerXGPush:application];
    [self registerShare];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)registerXGPush:(UIApplication *)application{
    
    [[XGPush defaultManager] startXGWithAppID:2200296231 appKey:XGSECRETKEY  delegate:self];
//    [[XGPush defaultManager] setEnableDebug:YES];
}

- (void)registerShare{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformSubTypeWechatTimeline),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:SINA_KEY
                                           appSecret:SINA_SECRET
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WEIXIN_SSO_ID
                                       appSecret:WEIXIN_SECRET];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQ_ID
                                      appKey:QQ_KEY
                                    authType:SSDKAuthTypeBoth];
                 break;
             
             default:
                 break;
         }
     }];
}

- (void)setupIQkeyborad {
    [IQKeyboardManager sharedManager].enable=YES;
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [IQKeyboardManager sharedManager].canAdjustTextView = YES;
}

-(void)setupLogin{
    
    BaseTabBarControllerConfig *tabBarControllerConfig = [[BaseTabBarControllerConfig alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    [self.window setRootViewController:tabBarController];
    tabBarController.delegate = self;

    [self customizeInterfaceWithTabBarController:tabBarController];
}

- (void)customizeInterfaceWithTabBarController:(CYLTabBarController *)tabBarController {
    
    [tabBarController hideTabBadgeBackgroundSeparator];
    //添加小红点
    UIViewController *viewController = tabBarController.viewControllers[0];
    UIView *tabBadgePointView0 = [UIView cyl_tabBadgePointViewWithClolor:[UIColor redColor] radius:4.5];
    [viewController.tabBarItem.cyl_tabButton cyl_setTabBadgePointView:tabBadgePointView0];
    [viewController cyl_showTabBadgePoint];
    
    UIView *tabBadgePointView1 = [UIView cyl_tabBadgePointViewWithClolor:[UIColor redColor] radius:4.5];
    @try {
        [tabBarController.viewControllers[1] cyl_setTabBadgePointView:tabBadgePointView1];
        [tabBarController.viewControllers[1] cyl_showTabBadgePoint];

        UIView *tabBadgePointView2 = [UIView cyl_tabBadgePointViewWithClolor:[UIColor redColor] radius:4.5];
        [tabBarController.viewControllers[2] cyl_setTabBadgePointView:tabBadgePointView2];
        [tabBarController.viewControllers[2] cyl_showTabBadgePoint];


        //添加提示动画，引导用户点击
        [self addScaleAnimationOnView:tabBarController.viewControllers[2].cyl_tabButton.cyl_tabImageView repeatCount:20];
    } @catch (NSException *exception) {}
}

#pragma mark - delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;

    if ([control cyl_isTabButton]) {
        //更改红标状态
        if ([[self cyl_tabBarController].selectedViewController cyl_isShowTabBadgePoint]) {
            [[self cyl_tabBarController].selectedViewController cyl_removeTabBadgePoint];
        }
        
        animationView = [control cyl_tabImageView];
    }
    
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if ([control cyl_isPlusButton]) {
        UIButton *button = CYLExternPlusButton;
        animationView = button.imageView;
    }
    
    [self addScaleAnimationOnView:animationView repeatCount:1];

    //点击动效
//    if ([self cyl_tabBarController].selectedIndex % 2 == 0) {
//        [self addScaleAnimationOnView:animationView repeatCount:1];
//    } else {
//        [self addRotateAnimationOnView:animationView];
//    }
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.1,@1.02,@1.0]; //,@0.9,@1.15,@0.95
    animation.duration = 0.3;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

- (void)monitorNetwork{
    //重连网络成功刷新用户信息（数据表+IM）
    [SENotificationCenter addObserver:self selector:@selector(reconnectionSuccess) name:RECONNECTIONSUCCESS object:nil];
    [SENotificationCenter addObserver:self selector:@selector(networkBreak) name:NETBREAK object:nil];
}

- (void)reconnectionSuccess{
    //重连成功
    
}

- (void)networkBreak{

}

#pragma mark - notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    
    if (application.applicationIconBadgeNumber > 0) {
        application.applicationIconBadgeNumber = 0;
    }
}

// iOS 10 新增回调 API
// App 用户点击通知
// App 用户选择通知中的行为
// App 用户在通知中心清除消息
// 无论本地推送还是远程推送都会走这个回调
#if __IPHONE_OS_VERSION_MAX_ALLOWED >=     __IPHONE_10_0
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center
      didReceiveNotificationResponse:(UNNotificationResponse *)response
               withCompletionHandler:(void (^)(void))completionHandler
API_AVAILABLE(ios(10.0)){
    
    //后台回调
    [[XGPush defaultManager] reportXGNotificationResponse:response];
    
    [[NotificationTool shareInstance] reviceNotification:response.notification.request.content.userInfo enterBackground:YES];
    
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center
             willPresentNotification:(UNNotification *)notification
               withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)){
    [[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    
    [[NotificationTool shareInstance] reviceNotification:notification.request.content.userInfo enterBackground:NO];
}
#endif

/**
 @brief 监控信鸽推送服务地启动情况
 
 @param isSuccess 信鸽推送是否启动成功
 @param error 信鸽推送启动错误的信息
 */
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(nullable NSError *)error{
    if (isSuccess) {
        NSLog(@"XG register success");
    }
}

/**
 @brief 监控信鸽服务的终止情况
 
 @param isSuccess 信鸽推送是否终止
 @param error 信鸽推动终止错误的信息
 */
- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(nullable NSError *)error{
    if (isSuccess) {
        NSLog(@"XG stop success");
    }
}


/**
 @brief 监控信鸽服务上报推送消息的情况
 
 @param isSuccess 上报是否成功
 @param error 上报失败的信息
 */
- (void)xgPushDidReportNotification:(BOOL)isSuccess error:(nullable NSError *)error{
    if (isSuccess) {
        NSLog(@"XG report success");
    }
}


/**
 @brief 监控设置信鸽服务器下发角标的情况
 
 @param isSuccess isSuccess 上报是否成功
 @param error 设置失败的信息
 */
- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(nullable NSError *)error{
    if (isSuccess) {
        NSLog(@"XG set badge success");
    }
}

/**
 @brief 注册设备token的回调
 
 @param deviceToken 当前设备的token
 @param error 错误信息
 */
- (void)xgPushDidRegisteredDeviceToken:(nullable NSString *)deviceToken error:(nullable NSError *)error{
    NSLog(@"xg device Token == %@",deviceToken);
    [[SEUserDefaults shareInstance] saveDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *pushToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[SEUserDefaults shareInstance] saveDeviceToken:pushToken];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (application.applicationIconBadgeNumber > 0) {
        application.applicationIconBadgeNumber = 0;
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
