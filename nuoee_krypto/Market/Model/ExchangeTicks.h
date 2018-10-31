//
//  ExchangeTicks.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/12.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

/**
 交易所币对行情列表
 */
@interface ExchangeTicks : BaseModel

/* base */
@property (nonatomic, copy) NSString *base;
/* changeValue */
@property (nonatomic, assign) CGFloat changeValue;
/* close */
@property (nonatomic, assign) CGFloat close;
/* currency */
@property (nonatomic, copy) NSString *currency;
/* dateTime */
@property (nonatomic, assign) NSInteger dateTime;
/* degree */
@property (nonatomic, assign) CGFloat degree;
/* exchangeName */
@property (nonatomic, copy) NSString *exchangeName;
/* high */
@property (nonatomic, assign) CGFloat high;
/* low */
@property (nonatomic, assign) CGFloat low;
/* open */
@property (nonatomic, assign) CGFloat open;
/* symbol */
@property (nonatomic, copy) NSString *symbol;
/* ticker */
@property (nonatomic, copy) NSString *ticker;
/* vol */
@property (nonatomic, assign) CGFloat vol;
/* index */
@property (nonatomic, assign) NSInteger index;
/* usdPrice */
@property (nonatomic, copy) NSString *usdPrice;


+(NSURLSessionDataTask*)exchange_ticks:(NSDictionary *)option
                               Success:(void (^)(NSArray *item))success
                               Failure:(void (^)(NSError *error))failue;

@end
