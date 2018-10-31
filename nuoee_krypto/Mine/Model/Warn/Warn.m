//
//  Warn.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/25.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "Warn.h"

@implementation Warn

+(NSURLSessionDataTask*)alerts_historyWithType:(WarnType)type param:(NSDictionary *)option
                                     Success:(void (^)(NSArray *item))success
                                     Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:type == WarnTriggerType ? URI_ALERTS_HISTROY_TRIGGER : URI_ALERTS_HISTROY_UN_TRIGGER parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *arr = [responseObject jk_arrayForKey:@"data"];
        for (NSDictionary *dic in arr) {
            Warn *model = [Warn mj_objectWithKeyValues:dic];
            [arrM addObject:model];
        }
        
        success(arrM);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)alerts_exchange_show:(NSDictionary *)option
                                     Success:(void (^)(NSArray *item))success
                                     Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_ALERTS_EXCHANGE_SHOW parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *arr = [responseObject jk_arrayForKey:@"data"];
        for (NSDictionary *dic in arr) {
            Warn *model = [Warn mj_objectWithKeyValues:dic];
            [arrM addObject:model];
        }
        
        success(arrM);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)alerts_new:(NSDictionary *)option
                           Success:(void (^)(Warn *item))success
                           Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_ALERTS_NEW parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        Warn *warn = [Warn mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        success(warn);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)alerts_delsingle:(NSDictionary *)option
                           Success:(void (^)(NSString *item))success
                           Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_ALERTS_DELSINGLE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([[responseObject jk_dictionaryForKey:@"data"] jk_stringForKey:@"code"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)alerts_delAll_history:(NSDictionary *)option
                                 Success:(void (^)(NSString *item))success
                                 Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:[NSString stringWithFormat:@"%@/UN_DELETE",URI_ALERTS_DELALL_HISTORY] parameters:option success:^(NSURLResponse *respone, id responseObject)
            {
        success([[responseObject jk_dictionaryForKey:@"data"] jk_stringForKey:@"code"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}



@end
