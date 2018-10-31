//
//  MessageModel.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/13.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MessageModel.h"

@implementation Message

+(NSURLSessionDataTask*)mes_center_delete_id:(NSDictionary *)option
                           Success:(void (^)(id item))success
                           Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_MES_CENTER_DELETE_ID parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}
@end

@implementation MessageModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"mesCenters" : [Message class]};
}

+(NSURLSessionDataTask*)mes_center:(NSDictionary *)option
                              Success:(void (^)(MessageModel *item))success
                              Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_MES_CENTER parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        MessageModel *item = [MessageModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        
        success(item);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)mes_center_delete_all:(NSDictionary *)option
                           Success:(void (^)(NSString *item))success
                           Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_MES_CENTER_DELETEALL parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([[responseObject jk_dictionaryForKey:@"data"] jk_stringForKey:@"code"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
