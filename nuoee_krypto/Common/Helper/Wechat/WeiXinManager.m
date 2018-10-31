//
//  WeiXinManager.m
//  Super-Learning
//
//  Created by runlin on 2016/12/23.
//  Copyright © 2016年 SiNetWork. All rights reserved.
//


#define WM_WX_ACCESS_TOKEN @"access_token"
#define WM_WX_OPEN_ID @"openid"
#define WM_WX_REFRESH_TOKEN @"refresh_token"
#define WM_WX_UNION_ID @"unionid"
#define WM_WX_BASE_URL @"https://api.weixin.qq.com/sns"


#import "WeiXinManager.h"
#import "NSDictionary+JKSafeAccess.h"

#include "Constant.h"
@implementation WeiXinManager
+(WeiXinManager*)sharedManager {
    static dispatch_once_t onceToken;
    static WeiXinManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WeiXinManager alloc] init];
    });
    return instance;
}

+ (BOOL)isWXAppInstalled{
   return [WXApi isWXAppInstalled];
}

+ (BOOL)handleOpenURL:(NSURL *)url;
{
    return [WXApi handleOpenURL:url delegate:[WeiXinManager sharedManager]];
}

+ (void)registWeChat:(NSString *)appkey
{
    [WXApi registerApp:appkey];
}

+ (void)sendAuthRequest:(UIViewController*)viewController codeHandler:(WMCodeHandler)WMCodeHandler
{
    [self sharedManager]->_WMCodeHandler = [WMCodeHandler copy];
    
    if ([WXApi isWXAppInstalled]) {
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        req.openID = @"0c806938e2413ce73eef92cc3" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        //    [WXApi sendReq:req];
        [WXApi sendAuthReq:req
            viewController:viewController
                  delegate:[WeiXinManager sharedManager]];
    }
    else {
        NSLog(@"App Not Installed");
    }

}
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{

}



/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void)onResp:(SendAuthResp*)resp{
    if (resp.errCode == WXSuccess) {
        if (_WMCodeHandler) {
            _WMCodeHandler(resp.code);
        }
     }
}

//分享
//+ (void)shareWithType:(ShareType)type shareUrl:(NSString *)shareUrl Id:(NSString *)Id sessionType:(SessionType)sessionType isCopy:(BOOL)isCopy copyUrlBlock:(BaseIdBlock)copyUrlBlock{
//
//    [APIManager SafePOST:shareUrl parameters:@{@"liveId" : Id} sessionType:sessionType success:^(NSURLResponse *respone, id responseObject) {
//
//        NSDictionary *result = [responseObject jk_dictionaryForKey:@"result"];
//
//        NSString *url = [result jk_stringForKey:@"url"];
//        NSString *img = [result jk_stringForKey:@"img"];
//        NSString *desc = [result jk_stringForKey:@"desc"];
//        NSString *title = [result jk_stringForKey:@"title"];
//
//        if (copyUrlBlock) {
//            copyUrlBlock(url);
//        }
//
//        if (isCopy) {
//            return;
//        }
//
//        //创建分享消息对象
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img]];
//        UIImage *image = [UIImage imageWithData:data];
//        NSData *compressData = nil;
//        compressData = UIImageJPEGRepresentation(image, 0.1);
//        UIImage *nowImage = [UIImage imageWithData:compressData];
//
//        WXMediaMessage *message = [WXMediaMessage message];
//        message.title = title;
//        message.description = desc;
//        [message setThumbImage:nowImage];
//
//        WXWebpageObject *webpageObject = [WXWebpageObject object];
//        webpageObject.webpageUrl = url;
//        message.mediaObject = webpageObject;
//
//        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//        req.bText = NO;
//        req.message = message;
//        req.scene = type;
//
//        [WXApi sendReq:req];
//
//    } failure:^(NSURLResponse *respone, NSError *error) {
//
//    }];
//}





//-(NSDictionary*)fetchAutInfo:(NSString*)code refresh:(BOOL)isRefresh{
//    NSURL *url =  [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",KEY_WEIXIN_SSO_ID,KEY_WEIXIN_SECRET,code]];
//    NSError *error = nil;
//    NSURLResponse *response = nil;
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
////    [request setHTTPBody:jsonData];
//    [request setTimeoutInterval:10.0];
//    NSData *data =  [[self class] sendSynchronousDataTaskWithRequest:request returningResponse:&response error:&error];
//    NSDictionary *accessDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    NSLog(@"请求access的response = %@", accessDict);
//    NSString *accessToken = [accessDict objectForKey:WM_WX_ACCESS_TOKEN];
//    NSString *openID = [accessDict objectForKey:WM_WX_OPEN_ID];
//    NSString *refreshToken = [accessDict objectForKey:WM_WX_REFRESH_TOKEN];
//    
//    return accessDict;
//}
//access_token是调用授权关系接口的调用凭证，由于access_token有效期（目前为2个小时）较短，当access_token超时后，可以使用refresh_token进行刷新，access_token刷新结果有两种：
//1. 若access_token已超时，那么进行refresh_token会获取一个新的access_token，新的超时时间；

//2. 若access_token未超时，那么进行refresh_token不会改变access_token，但超时时间会刷新，相当于续期access_token。
-(NSDictionary*)refreshAutInfo:(NSString*)refreshToken{
    NSURL *url =  [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",WEIXIN_SSO_ID,refreshToken]];
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    //    [request setHTTPBody:jsonData];
    [request setTimeoutInterval:10.0];
    NSData *data =  [[self class] sendSynchronousDataTaskWithRequest:request returningResponse:&response error:&error];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return responseObject;
}

+ (NSData *)sendSynchronousDataTaskWithRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSData *data = nil;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *taskResponse, NSError *taskError) {
        data = taskData;
        if (response) {
            *response = taskResponse;
        }
        if (error) {
            *error = taskError;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return data;
}
//+ (void)sendAsynchronousDataTaskWithRequest:(NSURLRequest *)request
//                                    success:(void (^)(NSDictionary *responeObject))completion
//                                    failed:(void (^)(NSError *error))failed{
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *taskResponse, NSError *taskError) {
//        if (!taskError) {
//            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:taskData options:kNilOptions error:nil];
//            completion(responseObject);
//        }else{
//            failed(taskError);
//        }
//    }] resume];
//}
@end
