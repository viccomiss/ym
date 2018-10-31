//
//  Currency.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "Currency.h"

@implementation Currency

+(NSURLSessionDataTask*)currency_list:(NSDictionary *)option
                              Success:(void (^)(NSArray *list))success
                              Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_CURRENCYLIST parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *arr = [responseObject jk_arrayForKey:@"data"];
        for (NSDictionary *dic in arr) {
            Currency *c = [Currency mj_objectWithKeyValues:dic];
            [arrM addObject:c];
        }
        
        success(arrM);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
