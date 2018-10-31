//
//  SEJSApiBase.h
//  wxer_manager
//
//  Created by Jacky on 2017/10/28.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridgeBase.h"
#import "NSString+JLAdd.h"
#import "NSDictionary+JKSafeAccess.h"


@interface SEJSApiBase : NSObject
+(instancetype)shareJSApiBase;
//响应JS事件不回调
-(void)responsejsCallWithData:(id)data;
//响应JS事件后回调
-(void)responsejsCallWithData:(id)data callBack:(WVJBResponseCallback)responseCallback;
//结束正在响应的事件
-(void)disconnectResponsejsCall;
@end
