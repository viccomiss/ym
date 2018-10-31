//
//  UserModel.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/6.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "UserModel.h"
#import "SEUserDefaults.h"

@implementation UserModel
MJCodingImplementation

//登录
+(NSURLSessionDataTask*)login:(NSDictionary *)option
                      Success:(void (^)(UserModel *user))success
                      Failure:(void (^)(NSError *error))failue{
    
    
    return [APIManager SafePOST:URI_SIGNIN parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        [[SEUserDefaults shareInstance]saveUserModel:user];
        
        success(user);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//找回密码
+(NSURLSessionDataTask*)retrievePassword:(NSDictionary *)option
                      Success:(void (^)(UserModel *user))success
                      Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_SIGN_RETRIEVEPASSWORD parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        [[SEUserDefaults shareInstance]saveUserModel:user];
        
        success(user);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//修改用户信息
+(NSURLSessionDataTask*)account_change:(NSDictionary *)option
                      Success:(void (^)(UserModel *user))success
                      Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_ACCOUNT_CHANGE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        [[SEUserDefaults shareInstance]saveUserModel:user];
        
        success(user);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//发送验证码
+(NSURLSessionDataTask*)send_message:(NSDictionary *)option
                               Success:(void (^)(UserModel *user))success
                               Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_SIGN_SENDMESSAGE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        [[SEUserDefaults shareInstance]saveUserModel:user];
        
        success(user);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//发送修改手机号和密码的验证码
+(NSURLSessionDataTask*)send_updateMessage:(NSDictionary *)option
                             Success:(void (^)(NSString *code))success
                             Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_ACCOUNTSENDUPDATEMESSAGE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_stringForKey:@"code"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//修改手机号
+(NSURLSessionDataTask*)changePhone:(NSDictionary *)option
                                   Success:(void (^)(UserModel *user))success
                                   Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_CHANGEPHONE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        [[SEUserDefaults shareInstance]saveUserModel:user];
        
        success(user);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//修改密码
+(NSURLSessionDataTask*)changePassword:(NSDictionary *)option
                            Success:(void (^)(UserModel *user))success
                            Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_ACCOUNTCHANGEPASSWORD parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        [[SEUserDefaults shareInstance]saveUserModel:user];
        
        success(user);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//修改红绿信息
+(NSURLSessionDataTask*)changeMarkColor:(NSDictionary *)option
                               Success:(void (^)(UserModel *user))success
                               Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_ACCOUNTCHANGEMARKCOLOR parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        [[SEUserDefaults shareInstance]saveUserModel:user];
        
        success(user);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//上传头像
+(NSURLSessionDataTask*)account_uploadfile:(NSDictionary *)option
                                 image:(UIImage *)image
                                Success:(void (^)(UserModel *user))success
                                Failure:(void (^)(NSError *error))failue{
    return [APIManager uploadImagePOST:URI_ACCOUNTUPLOADFILE image:image parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        [[SEUserDefaults shareInstance]saveUserModel:user];

        success(user);

    } failure:^(NSURLResponse *respone, id error) {
        failue(error);
    }];
}

//退出登录
+(NSURLSessionDataTask*)sign_destory:(NSDictionary *)option
                                Success:(void (^)(UserModel *user))success
                                Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_SIGN_DESTORY parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        [[SEUserDefaults shareInstance]saveUserModel:user];
        
        success(user);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)alerts_style:(NSDictionary *)option
                             Success:(void (^)(UserModel *user))success
                             Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_ALERTS_STYLE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        [[SEUserDefaults shareInstance]saveUserModel:user];
        
        success(user);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)account_initcontent:(NSDictionary *)option
                             Success:(void (^)(NSDictionary *item))success
                             Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_ACCOUNT_INITCONTENT parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_dictionaryForKey:@"data"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
