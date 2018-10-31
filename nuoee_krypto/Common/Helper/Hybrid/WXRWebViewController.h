//
//  WXRWebViewController.h
//  wxer_manager
//
//  Created by levin on 2017/8/11.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "BaseViewController.h"
#import "CurrencyRank.h"

//进入方式
typedef NS_ENUM(NSUInteger, WXRWebViewControllerModelType) {
    WXRWebViewControllerModelTypePush,
    WXRWebViewControllerModelTypePresent
};

//数据获取方向
typedef NS_ENUM(NSUInteger, WXRWebViewControllerDataFrom) {
    WXRWebViewControllerDataFromAgreenment, //用户协议
    WXRWebViewControllerDataFromCurrencyInfo, //币种详情
    WXRWebViewControllerDataFromFlash, //快讯原文
    WXRWebViewControllerDataFromFlashDetail, //快讯详情
    WXRWebViewControllerDataFromMessage //消息
};

/**
 店铺界面
 */
@interface WXRWebViewController : BaseViewController
@property (nonatomic, assign) WXRWebViewControllerModelType modelType;
@property (nonatomic, assign) WXRWebViewControllerDataFrom dataFrom;//数据获取方向

#pragma mark - 单品跳转

/* id */
@property (nonatomic, copy) NSString *skuId;
/* url */
@property (nonatomic, copy) NSString *url;
/* 币种信息 */
@property (nonatomic, strong) CurrencyRank *currencyRank;


@end
