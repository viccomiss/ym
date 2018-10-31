//
//  WarnSettingViewController.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/15.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseViewController.h"
#import "CurrencyMarket.h"
#import "KlineModel.h"

/**
 预警设置
 */
@interface WarnSettingViewController : BaseViewController

/* model */
@property (nonatomic, strong) CurrencyMarket *market;
/* kline */
@property (nonatomic, strong) KlineModel *kline;


@end
