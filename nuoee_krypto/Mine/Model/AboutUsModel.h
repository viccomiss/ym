//
//  AboutUsModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/7/2.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

@interface AboutUsModel : BaseModel

/* address */
@property (nonatomic, copy) NSString *address;
/* email */
@property (nonatomic, copy) NSString *email;
/* facebook */
@property (nonatomic, copy) NSString *facebook;
/* id */
@property (nonatomic, copy) NSString *ID;
/* qqGroup */
@property (nonatomic, copy) NSString *qqGroup;
/* telegram */
@property (nonatomic, copy) NSString *telegram;
/* twitter */
@property (nonatomic, copy) NSString *twitter;
/* version */
@property (nonatomic, copy) NSString *version;
/* weibo */
@property (nonatomic, copy) NSString *weibo;

+(NSURLSessionDataTask*)aboutUs:(NSDictionary *)option
                        Success:(void (^)(AboutUsModel *item))success
                        Failure:(void (^)(NSError *error))failue;

@end
