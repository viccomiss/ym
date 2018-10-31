//
//  CurrencyRanksModel.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "CurrencyRanksModel.h"

@implementation CurrencyRanksModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data": [CurrencyRank class]};
}

+(NSURLSessionDataTask*)currency_ranks:(NSDictionary *)option
                              Success:(void (^)(CurrencyRanksModel *model))success
                              Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_CURRENCYRANKS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        CurrencyRanksModel *model = [CurrencyRanksModel mj_objectWithKeyValues:responseObject];
        
        success(model);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
