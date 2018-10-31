//
//  SEJSBridgeEngine.h
//  wxer_manager
//
//  Created by Jacky on 2017/10/30.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "WKWebViewJavascriptBridge.h"
#import "SEJSApiBase.h"

@interface SEJSBridgeEngine : WKWebViewJavascriptBridge

@property (nonatomic, assign) BOOL hasResponsing;
-(void)registerNativeService;
-(void)removeResponsingNativeService;//移除正在响应的事件
@end
