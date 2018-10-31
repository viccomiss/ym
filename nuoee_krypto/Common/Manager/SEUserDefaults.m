//
//  SEUserDefaults.m
//  SuperEducation
//
//  Created by 123 on 2017/2/24.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "SEUserDefaults.h"
#import "NSString+JLAdd.h"


#define UserInfoModel @"userModel"
#define PhoneAreaCode @"areaCode"
#define Token @"token"
#define UserAvatarPath @"UserAvatarPath"
#define PromotionSettingPath @"PromotionSetting"
#define DeviceToken @"deviceToken"

@implementation SEUserDefaults
+(instancetype)shareInstance{
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}

-(void)saveUserModel:(UserModel*)model{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:UserInfoModel];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(UserModel*)getUserModel{
   NSData *data  =  [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoModel];
    UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return model;
}

-(void)saveSesstionId{
    UserModel *user = [self getUserModel];
    [[NSUserDefaults standardUserDefaults]setObject:user.token forKey:Token];
}

-(void)saveDeviceToken:(NSString *)deviceToken{
    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:DeviceToken];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)getDeviceToken{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:DeviceToken];
    return deviceToken.length == 0 ? @"" : deviceToken;
}

- (UIColor *)getRiseOrFallColor:(RoseOrFallType)type{
    UserModel *user = [self getUserModel];
    if (type == RoseType) {
        //上涨
        return user.markColor ? MainRedColor : MainGreenColor;
    }
    return user.markColor ? MainGreenColor : MainRedColor;
}

-(BOOL)userIsLogin{
    NSString *code = [[NSUserDefaults standardUserDefaults]objectForKey:Token];
    if (code && [code notEmptyOrNull]) {
        return YES;
    }else{
        return NO;
    }
}

-(void)saveAreaCode:(NSString *)code{
    [[NSUserDefaults standardUserDefaults]setObject:code forKey:PhoneAreaCode];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)getAreaCode{
    NSString *code = [[NSUserDefaults standardUserDefaults]objectForKey:PhoneAreaCode];
    return code;
}
-(void)userLogout{
    //清空用户基本信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserInfoModel];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Token];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserAvatarPath];
}

- (void)setUserLocalAvatar:(NSString *)imageKey {
    [[NSUserDefaults standardUserDefaults] setObject:imageKey forKey:UserAvatarPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getUserLocalAvatarKey {
    if ([self userIsLogin]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:UserAvatarPath];
    }
    return nil;
}
@end
