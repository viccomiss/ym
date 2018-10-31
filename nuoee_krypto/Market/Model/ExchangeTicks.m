//
//  ExchangeTicks.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/12.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ExchangeTicks.h"

@implementation ExchangeTicks

+(NSURLSessionDataTask*)exchange_ticks:(NSDictionary *)option
                                Success:(void (^)(NSArray *item))success
                                Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_CURRENCYTICKS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *arr = [responseObject jk_arrayForKey:@"data"];
        for (NSDictionary *dic in arr) {
            ExchangeTicks *e = [ExchangeTicks mj_objectWithKeyValues:dic];
            [arrM addObject:e];
        }
        success(arrM);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
