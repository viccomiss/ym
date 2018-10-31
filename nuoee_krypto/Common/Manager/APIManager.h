//
//  APIManager.h
//  UNIS-LEASE
//
//  Created by runlin on 2016/11/4.
//  Copyright © 2016年 unis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enumeration.h"
#import "AFHTTPSessionManager.h"
@interface APIManager : AFHTTPSessionManager

/**当前网络状态*/
+ (NetWorkState)currentNetWorkState;

+ (instancetype)sharedManager;

//手机型号
+ (NSString *)generateUserAgent;

+ (NSURLSessionDataTask *)SafePOST:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(NSURLResponse *respone, id responseObject))success
                           failure:(void (^)(NSURLResponse *respone, id error))failure;

+ (NSURLSessionDataTask *)SafeGET:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(NSURLResponse *respone, id responseObject))success
                          failure:(void (^)(NSURLResponse *respone, id error))failure;

//上传图片
+ (NSURLSessionDataTask *)uploadImagePOST:(NSString *)URLString
                                image:(UIImage *)image
                               parameters:(id)parameters
                                  success:(void (^)(NSURLResponse *respone, id responseObject))success
                                  failure:(void (^)(NSURLResponse *respone, id error))failure;

/**
 登录失效
 */
+ (void)loginFailure:(BOOL)logout;

@end
