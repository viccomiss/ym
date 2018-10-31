//
//  SEUserDefaults.h
//  SuperEducation
//
//  Created by 123 on 2017/2/24.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface SEUserDefaults : NSObject
+(instancetype)shareInstance;

-(void)saveUserModel:(UserModel*)model;
-(UserModel*)getUserModel;
-(BOOL)userIsLogin;
-(void)userLogout;
-(void)saveSesstionId;

-(void)saveAreaCode:(NSString *)code;
-(NSString *)getAreaCode;
- (void)setUserLocalAvatar:(NSString *)imageKey;
- (NSString *)getUserLocalAvatarKey;

//红涨绿跌颜色
- (UIColor *)getRiseOrFallColor:(RoseOrFallType)type;

//存deviceToken
-(void)saveDeviceToken:(NSString *)deviceToken;
-(NSString *)getDeviceToken;

@end
