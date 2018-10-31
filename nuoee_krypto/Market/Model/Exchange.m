//
//  Exchange.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "Exchange.h"

@implementation Exchange

+(NSURLSessionDataTask*)exchange:(NSDictionary *)option
                              Success:(void (^)(Exchange *model))success
                              Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_EXCHANGE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        Exchange *model = [Exchange mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        
        success(model);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
