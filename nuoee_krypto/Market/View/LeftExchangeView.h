//
//  LeftExchangeView.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/1.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyMarket.h"
#import "ExchangeTicks.h"

/**
 交易所left
 */
@interface LeftExchangeView : UIView

/* market */
@property (nonatomic, strong) CurrencyMarket *market;
/* ExchangeTicks */
@property (nonatomic, strong) ExchangeTicks *exchange;


@end
