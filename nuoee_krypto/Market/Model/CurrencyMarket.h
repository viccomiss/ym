//
//  CurrencyMarket.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/12.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

/**
 币行情
 */
@interface CurrencyMarket : BaseModel

/* index */
@property (nonatomic, assign) NSInteger index;

/* datetimes */
@property (nonatomic, assign) NSInteger datetimes;
/* line */
@property (nonatomic, strong) NSArray *line;
/* coin_url */
@property (nonatomic, copy) NSString *coin_url;
/* currency_code */
@property (nonatomic, copy) NSString *currency_code;
/* currency_name */
@property (nonatomic, copy) NSString *currency_name;
/* degree */
@property (nonatomic, copy) NSString *degree;
/* domain */
@property (nonatomic, copy) NSString *domain;
/* exchange_code */
@property (nonatomic, copy) NSString *exchange_code;
/* exchange_name */
@property (nonatomic, copy) NSString *exchange_name;
/* high */
@property (nonatomic, copy) NSString *high;
/* klines_url */
@property (nonatomic, copy) NSString *klines_url;
/* last */
@property (nonatomic, copy) NSString *last;
/* logo */
@property (nonatomic, copy) NSString *logo;
/* low */
@property (nonatomic, copy) NSString *low;
/* sort */
@property (nonatomic, assign) NSInteger sort;
/* ticker */
@property (nonatomic, copy) NSString *ticker;
/* vol */
@property (nonatomic, copy) NSString *vol;
/* usdPrice */
@property (nonatomic, copy) NSString *usdPrice;

+(NSURLSessionDataTask*)currency_market:(NSDictionary *)option
                                Success:(void (^)(NSArray *item))success
                                Failure:(void (^)(NSError *error))failue;

@end
