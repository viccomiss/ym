//
//  SearchModel.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/26.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

+(NSURLSessionDataTask*)search:(NSDictionary *)option
                              Success:(void (^)(NSArray *list))success
                              Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_SEARCH parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *arr = [responseObject jk_arrayForKey:@"data"];
        for (NSDictionary *dic in arr) {
            SearchModel *s = [SearchModel mj_objectWithKeyValues:dic];
            [arrM addObject:s];
        }
        
        success(arrM);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)hot_coin:(NSDictionary *)option
                       Success:(void (^)(NSArray *list))success
                       Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_HOTCOIN parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSArray *arr = [responseObject jk_arrayForKey:@"data"];
        
        success(arr);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
