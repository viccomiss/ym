//
//  AboutUsModel.m
//  nuoee_krypto
//
//  Created by Mac on 2018/7/2.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "AboutUsModel.h"

@implementation AboutUsModel

+(NSURLSessionDataTask*)aboutUs:(NSDictionary *)option
                           Success:(void (^)(AboutUsModel *item))success
                           Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_ABOUT_US parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        AboutUsModel *item = [AboutUsModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        
        success(item);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
