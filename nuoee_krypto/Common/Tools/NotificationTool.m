//
//  NotificationTool.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "NotificationTool.h"
#import "NSDictionary+JKSafeAccess.h"
#import "CurrencyMarket.h"
#import "KlineDetailViewController.h"
#import "CommonUtils.h"
#import "WXRWebViewController.h"
#import "DeviceInfo.h"
#import "SEUserDefaults.h"
#import "UserModel.h"

static NSString *ALERT = @"alert";
static NSString *HOTINFO = @"hotInfo";
static NSString *MESSAGECENTER = @"messageCenter";

@implementation NotificationTool

+(NotificationTool*)shareInstance{
    static NotificationTool *info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[NotificationTool alloc]init];
    });
    
    return info;
}

- (void)reviceNotification:(NSDictionary *)dic enterBackground:(BOOL)backgound{
    
    if (!backgound) {
        return;
    }
    
    NSString *jsonStr = [dic jk_stringForKey:@"custom"];
    NSDictionary *custom = [jsonStr mj_JSONObject];
    
    NSString *type = [custom jk_stringForKey:@"type"];
    if ([type isEqualToString:ALERT]) {
        //预警
        NSDictionary *d = [[custom jk_stringForKey:@"alert"] mj_JSONObject];
        CurrencyMarket *c = [[CurrencyMarket alloc] init];
        c.exchange_code = [d jk_stringForKey:@"exchange"];
        c.ticker = [d jk_stringForKey:@"symbol"];
        c.currency_code = [d jk_stringForKey:@"currency_code"];
        c.currency_name = [[d jk_stringForKey:@"currency_code"] uppercaseString];
        KlineDetailViewController *kVC = [[KlineDetailViewController alloc] init];
        kVC.currencyMarket = c;
        [[CommonUtils currentViewController].navigationController pushViewController:kVC animated:YES];
        
    }else if ([type isEqualToString:HOTINFO]){
        NSDictionary *d = [[custom jk_stringForKey:@"hotInfo"] mj_JSONObject];
        NSString *url = [d jk_stringForKey:@"url"];
        WXRWebViewController *webVC = [[WXRWebViewController alloc] init];
        webVC.dataFrom = WXRWebViewControllerDataFromFlashDetail;
        webVC.url = [NSString stringWithFormat:@"%@?deviceId=%@",url,[DeviceInfo getUUID]];
        [[CommonUtils currentViewController].navigationController pushViewController:webVC animated:YES];
        
    }else if ([type isEqualToString:MESSAGECENTER]){
        UserModel *user= [[SEUserDefaults shareInstance] getUserModel];
        
        NSDictionary *d = [[custom jk_stringForKey:@"messageCenter"] mj_JSONObject];
        NSString *url = [d jk_stringForKey:@"url"];
        WXRWebViewController *webVC = [[WXRWebViewController alloc] init];
        webVC.dataFrom = WXRWebViewControllerDataFromMessage;
        NSString *str;
        if (user.accountId.length == 0) {
            str = url;
        }else{
            str = [NSString stringWithFormat:@"%@?accountId=%@",url,user.accountId];
        }
        webVC.url = str;
        [[CommonUtils currentViewController].navigationController pushViewController:webVC animated:YES];
    }
}

@end
