//
//  ExchangeRanksModel.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ExchangeRanksModel.h"

@implementation ExchangeRanksModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"data": [Exchange class]};
}

+(NSURLSessionDataTask*)exchangeRanks:(NSDictionary *)option
                      Success:(void (^)(ExchangeRanksModel *model))success
                      Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_EXCHANGERANKS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        ExchangeRanksModel *model = [ExchangeRanksModel mj_objectWithKeyValues:responseObject];
        
        success(model);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
