//
//  APIManager.m
//  UNIS-LEASE
//
//  Created by runlin on 2016/11/4.
//  Copyright © 2016年 unis. All rights reserved.
//


#import "APIManager.h"
#import "AFSecurityPolicy.h"
#import "AFNetworkActivityIndicatorManager.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#import "JKAlert.h"
#import "Constant.h"

#import "SEUserDefaults.h"
#import "CommonUtils.h"
#import "BaseNavigationController.h"
#import "SEHUD.h"
#import "NSString+JLAdd.h"
#import "EncryptionTool.h"
#import "DateManager.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"

static dispatch_once_t onceToken;
static APIManager *_sharedManager = nil;

NetWorkState state;

@implementation APIManager

+ (instancetype)sharedManager {
    
    dispatch_once(&onceToken, ^{
        //设置服务器根地址
        _sharedManager = [[APIManager alloc] initWithBaseURL:[NSURL URLWithString:URI_BASE_SERVER]];
        //        [_sharedManager setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
        
        AFSecurityPolicy * securityPolicy = [AFSecurityPolicy  defaultPolicy];
        //        securityPolicy.allowInvalidCertificates = YES;
        
        //        securityPolicy.validatesDomainName = NO;
        
        [_sharedManager setSecurityPolicy:securityPolicy];
        
        [_sharedManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"3G网络已连接");
                    state = NetWorkConnected;
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"WiFi网络已连接");
                    state = NetWorkConnected;
                    [SENotificationCenter postNotificationName:RECONNECTIONSUCCESS object:nil];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"网络连接失败");
                    [SENotificationCenter postNotificationName:NETBREAK object:nil];
                    state = NetWorkUnknow;
                    break;
                    
                default:
                    break;
            }
        }];
        [_sharedManager.reachabilityManager startMonitoring];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

        //发送http数据
        _sharedManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //响应json数据
        _sharedManager.responseSerializer  = [AFJSONResponseSerializer serializer];

        _sharedManager.responseSerializer.acceptableContentTypes =  [_sharedManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",@"image/jpg",nil]];
          //设置 x-client
        [_sharedManager.requestSerializer setValue:[self generateUserAgent]?:@"" forHTTPHeaderField:@"x-client"];
    });
   
    return _sharedManager;
}

+ (NetWorkState)currentNetWorkState{
    return state;
}

+ (NSString *)generateUserAgent{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    return [NSString stringWithFormat:@"ios(%@;%@)", [UIDevice currentDevice].systemVersion,
            platform];
}

+ (NSURLSessionDataTask *)uploadImagePOST:(NSString *)URLString
                         image:(UIImage *)image
                        parameters:(id)parameters
                           success:(void (^)(NSURLResponse *respone, id responseObject))success
                           failure:(void (^)(NSURLResponse *respone, id error))failure{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:parameters];
    
    NSString *token = [self getToken];
    if (token) {
        [dic setObject:token forKey:@"token"];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    return [manager POST:[NSString stringWithFormat:@"%@%@",URI_BASE_SERVER,URLString] parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = UIImageJPEGRepresentation(image,0.2);//这个就是上面图片转唯了data类型的
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%@.jpeg",[DateManager currentTime]] mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [EasyLoadingView hidenLoading];
//        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = responseObject;
        if (dic) {
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"10000"]) {
                success(task.response,dic);
            }else{
                
                [SEHUD showAlertInWindowWithText:[dic objectForKey:@"message"]];
                NSLog(@"error === %@",dic);
                failure(task.response,dic);
            }
            
        }else{
            [self reset];
            success(task.response,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [EasyLoadingView hidenLoading];
        NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData) {
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
            if (errorDict) {
                [SEHUD showAlertWithText:errorDict[@"error"][@"msg"]];
            }
        }else{
            [SEHUD showAlertWithText:@"请检查网络状态"];
            
        }
        //todo
        failure(task.response,error);
    }];
}

+ (NSURLSessionDataTask *)SafePOST:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(NSURLResponse *respone, id responseObject))success
                           failure:(void (^)(NSURLResponse *respone, id error))failure{
    APIManager *manager = [self setHttpHeader];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:parameters];
    
    NSString *token = [self getToken];
    if (token) {
        [dic setObject:token forKey:@"token"];
    }
    
    NSLog(@"HTTP:\n%@%@",manager.baseURL,URLString);
    
    NSLog(@"Header:\n%@",manager.requestSerializer.HTTPRequestHeaders);

//    NSLog(@"POST JSON:\n%@",[NSString dictionaryToJson:dic?:@{}]);
    
    
    //加密
//    NSDictionary *secretDic = [EncryptionTool encryptionWithParameterDictionary:parameters];
//    NSString *secretStr = [NSString dictionaryToJson:secretDic];
    
    return [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        NSLog(@"client request HTTP interface:\n%@%@",manager.baseURL,URLString);
        NSLog(@"client request POST JSON:\n%@",[NSString dictionaryToJson:parameters?:@{}]);
        
        [EasyLoadingView hidenLoading];
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [string mj_JSONObject];
        if (dic) {
            NSString *code = [dic objectForKey:@"code"];
            if ([code isEqualToString:@"10000"]) {
                success(task.response,dic);
            }else if ([code isEqualToString:@"10002"]){
                [SEHUD showAlertInWindowWithText:@"登录失效,请重新登录"];
                [APIManager loginFailure:NO];
            }else{
                NSString *errorStr = [dic objectForKey:@"message"];
                if (errorStr.length != 0) {
                    [SEHUD showAlertInWindowWithText:errorStr];
                }
                NSLog(@"error === %@",dic);
                failure(task.response,dic);
            }
            
        }else{
            [self reset];
            success(task.response,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task,  NSError * _Nonnull error) {
        [EasyLoadingView hidenLoading];
        NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData) {
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
            if (errorDict) {
                NSString *errorStr = errorDict[@"error"][@"msg"];
                if (errorStr.length != 0) {
                    [SEHUD showAlertWithText:errorStr];
                }
            }
        }else{
            [SEHUD showAlertWithText:@"请检查网络状态"];
            
        }
        //todo
        failure(task.response,error);
    }];
}

+ (NSURLSessionDataTask *)SafeGET:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(NSURLResponse *respone, id responseObject))success
                          failure:(void (^)(NSURLResponse *respone, id error))failure{
    APIManager *manager = [self setHttpHeader];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"client request HTTP interface:\n%@%@",manager.baseURL,URLString);
//    NSString *url = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:parameters];
    
    NSString *token = [self getToken];
    if (token) {
        [dic setObject:token forKey:@"token"];
    }
    
    NSLog(@"client request POST JSON:\n%@",[NSString dictionaryToJson:dic?:@{}]);
    
    //加密
//    NSDictionary *secretDic = [EncryptionTool encryptionWithParameterDictionary:parameters];
//    NSString *secretStr = [NSString dictionaryToJson:secretDic];
    
    return [manager GET:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        [EasyLoadingView hidenLoading];
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [string mj_JSONObject];
        if (dic) {
            
            NSString *code = [dic objectForKey:@"code"];
            if ([code isEqualToString:@"10000"]) {
                success(task.response,dic);
            }else if ([code isEqualToString:@"10002"]){
                [SEHUD showAlertInWindowWithText:@"登录失效,请重新登录"];
                [APIManager loginFailure:NO];
            }else{
                NSString *errorStr = [dic objectForKey:@"message"];
                if (errorStr.length != 0) {
                    [SEHUD showAlertInWindowWithText:errorStr];
                }
                NSLog(@"error === %@",dic);
                failure(task.response,dic);
            }
            
        }else{
            [self reset];
            success(task.response,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task,  NSError * _Nonnull error) {
        [EasyLoadingView hidenLoading];
        NSData *errorData = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData) {
            NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingAllowFragments error:nil];
            if (errorDict) {
                NSString *errorStr = errorDict[@"error"][@"msg"];
                if (errorStr.length != 0) {
                    [SEHUD showAlertWithText:errorStr];
                }
            }
        }else{
            [SEHUD showAlertWithText:@"请检查网络状态"];
            
        }
        //todo
        failure(task.response,error);
    }];
}

//配置header
+(APIManager *)setHttpHeader{
    APIManager *manager = [APIManager sharedManager];
//    for (NSString *key in [self headerDic]) {
//        [manager.requestSerializer setValue:[[self headerDic] objectForKey:key]?:@"" forHTTPHeaderField:key];
//    }
    return manager;

}

+ (NSString *)getToken{
    UserModel *user = [[SEUserDefaults shareInstance] getUserModel];
    return user.token;
}

//header
//+ (NSDictionary *)headerDic{
//    return @{@"x-api-version":API_VERSION,_sessionType == SessionNormalType ? @"x-mdi-sess" : @"x-usr-sess":@"9d9b49ee8ee84050b303e9e50d0204f9N67zEKJioB9ZyjYVaZQ1JR8LmaFqanXn",@"x-client":[self generateUserAgent]};
//    if ([[SEUserDefaults shareInstance] userIsLogin]) {
//        UserModel *user = [SEUserDefaults shareInstance].getUserModel;
//        return @{@"x-api-version":API_VERSION, @"x-mdi-sess": user.session.ID,@"x-client":[self generateUserAgent]};
//    }else{
//        return @{@"x-api-version":API_VERSION, @"x-mdi-sess":@"",@"x-client":[self generateUserAgent]};
//    }
//    return nil;
//}

////设置ip要重置单例 生效
+ (void)reset {
    _sharedManager = nil;
    onceToken = 0;
}

//登录失效
+ (void)loginFailure:(BOOL)logout{
    
    if (logout) {
//        [UserModel sign_destory:@{} Success:^(UserModel *user) {
        
            [[SEUserDefaults shareInstance] userLogout];
            UIViewController *vc = [CommonUtils currentViewController];
            [vc.navigationController popViewControllerAnimated:YES];
            [SENotificationCenter postNotificationName:LOGOUTSUCCESS object:nil];
            
//        } Failure:^(NSError *error) {
//
//        }];
    }else{
        [[SEUserDefaults shareInstance] userLogout];
        UIViewController *vc = [CommonUtils currentViewController];
        LoginViewController *login = [[LoginViewController alloc] init];
        BaseNavigationController *loginNav = [[BaseNavigationController alloc] initWithRootViewController:login];
        [vc presentViewController:loginNav animated:YES completion:nil];
    }
}



@end
