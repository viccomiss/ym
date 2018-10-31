//
//  FlashModel.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/7.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "FlashModel.h"
#import "DateManager.h"

@implementation Flash

+(NSURLSessionDataTask*)hot_info_get_newInfoNum:(NSDictionary *)option
                                        Success:(void (^)(NSInteger num))success
                                        Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_HOTINFO_GET_NEWHOTINFONUM parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_integerForKey:@"data"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)hot_info_rise:(NSDictionary *)option
                              Success:(void (^)(Flash *flash))success
                              Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_HOTINFO_RISE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        Flash *f = [Flash mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        
        success(f);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)hot_info_fall:(NSDictionary *)option
                              Success:(void (^)(Flash *flash))success
                              Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_HOTINFO_FALL parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        Flash *f = [Flash mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        
        success(f);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)hot_info_details:(NSDictionary *)option
                              Success:(void (^)(Flash *flash))success
                              Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_HOTINFO_DETAILS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        Flash *f = [Flash mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        
        success(f);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end

@implementation FlashGroupModel

- (instancetype)init{
    if (self == [super init]) {

    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"flashArray" : [Flash class]};
}

@end

@implementation FlashModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"results" : [Flash class]};
}

+(NSURLSessionDataTask*)hot_info:(NSDictionary *)option
                      Success:(void (^)(FlashModel *user))success
                      Failure:(void (^)(NSError *error))failue{
    return [APIManager SafeGET:URI_HOTINFO parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        FlashModel *model = [FlashModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"data"]];
        
        success(model);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
