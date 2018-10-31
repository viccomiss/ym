//
//  UserModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/6.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

/* accountId */
@property (nonatomic, copy) NSString *accountId;
/* token */
@property (nonatomic, copy) NSString *token;
/* avatarUrl */
@property (nonatomic, copy) NSString *avatarUrl;
/* cell */
@property (nonatomic, copy) NSString *cell;
/* gender */
@property (nonatomic, copy) NSString *gender;
/* hasPassword */
@property (nonatomic, assign) BOOL hasPassword;
/* username */
@property (nonatomic, copy) NSString *username;
/* markColor */
@property (nonatomic, assign) BOOL markColor;
/* ring */
@property (nonatomic, assign) BOOL ring;
/* vibrate */
@property (nonatomic, assign) BOOL vibrate;


+(NSURLSessionDataTask*)login:(NSDictionary *)option
                      Success:(void (^)(UserModel *user))success
                      Failure:(void (^)(NSError *error))failue;

//找回密码
+(NSURLSessionDataTask*)retrievePassword:(NSDictionary *)option
                                 Success:(void (^)(UserModel *user))success
                                 Failure:(void (^)(NSError *error))failue;

//修改用户信息
+(NSURLSessionDataTask*)account_change:(NSDictionary *)option
                               Success:(void (^)(UserModel *user))success
                               Failure:(void (^)(NSError *error))failue;

//发送验证码
+(NSURLSessionDataTask*)send_message:(NSDictionary *)option
                             Success:(void (^)(UserModel *user))success
                             Failure:(void (^)(NSError *error))failue;

//发送修改手机号和密码的验证码
+(NSURLSessionDataTask*)send_updateMessage:(NSDictionary *)option
                                   Success:(void (^)(NSString *code))success
                                   Failure:(void (^)(NSError *error))failue;

//修改手机号
+(NSURLSessionDataTask*)changePhone:(NSDictionary *)option
                            Success:(void (^)(UserModel *user))success
                            Failure:(void (^)(NSError *error))failue;

//修改密码
+(NSURLSessionDataTask*)changePassword:(NSDictionary *)option
                               Success:(void (^)(UserModel *user))success
                               Failure:(void (^)(NSError *error))failue;

//修改红绿信息
+(NSURLSessionDataTask*)changeMarkColor:(NSDictionary *)option
                                Success:(void (^)(UserModel *user))success
                                Failure:(void (^)(NSError *error))failue;

//退出登录
+(NSURLSessionDataTask*)sign_destory:(NSDictionary *)option
                             Success:(void (^)(UserModel *user))success
                             Failure:(void (^)(NSError *error))failue;

//修改头像
+(NSURLSessionDataTask*)account_uploadfile:(NSDictionary *)option
                                     image:(UIImage *)image
                                   Success:(void (^)(UserModel *user))success
                                   Failure:(void (^)(NSError *error))failue;

//预警提示
+(NSURLSessionDataTask*)alerts_style:(NSDictionary *)option
                             Success:(void (^)(UserModel *user))success
                             Failure:(void (^)(NSError *error))failue;

//消息中心红点
+(NSURLSessionDataTask*)account_initcontent:(NSDictionary *)option
                                    Success:(void (^)(NSDictionary *item))success
                                    Failure:(void (^)(NSError *error))failue;

@end
