//
//  ExchangeInfoViewController.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/12.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTransparentNavViewController.h"
#import "Exchange.h"

/**
 交易所信息
 */
@interface ExchangeInfoViewController : BaseTransparentNavViewController

/* exchange */
@property (nonatomic, strong) Exchange *exchange;
/* query */
@property (nonatomic, copy) NSString *query;

@end
