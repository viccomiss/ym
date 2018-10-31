//
//  SEJSBridgeEngine.m
//  wxer_manager
//
//  Created by Jacky on 2017/10/30.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "SEJSBridgeEngine.h"
#import "SEJSApiPay.h"
#import "SEJSApiShare.h"

#import "NSString+JLAdd.h"

static NSString *SHARE = @"nuoee.share";
static NSString *PAY = @"pay";

static NSString *RECORDESTART = @"startAudio";
static NSString *RECORDESTOP = @"stopAudio";
static NSString *RECORDEUPLOAD = @"uploadAudio";

static NSString *PHOTOBROESER = @"photoBrowser";

static NSString *PHOTOSAVE = @"savePicture";
static NSString *PHOTOSENDFRIEND = @"sentFriends";
static NSString *PHOTOSENDTIMELINE = @"sentTimeLine";

static NSString *VIDEOPLAY = @"playVideo";
static NSString *FAVORITE = @"favorite";


@implementation SEJSBridgeEngine

-(void)registerNativeService{
    
    //分享
    [self registerHandler:SHARE handler:^(NSString * data, WVJBResponseCallback responseCallback) {
        NSDictionary *shareDict = [data jsonToDictionary];
        [[SEJSApiShare shareJSApiBase] responsejsCallWithData:shareDict[@"data"]];
    }];
        
    //支付
//    [self registerHandler:PAY handler:^(NSString * data, WVJBResponseCallback responseCallback) {
//        [[SEJSApiPay shareJSApiBase] responsejsCallWithData:data callBack:responseCallback];
//    }];
}
//移除响应事件
-(void)removeResponsingNativeService{
    [[SEJSApiPay shareJSApiBase] disconnectResponsejsCall];
}
@end
