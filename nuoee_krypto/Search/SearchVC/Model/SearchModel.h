//
//  SearchModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/26.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

@interface SearchModel : BaseModel

/* iconUrl */
@property (nonatomic, copy) NSString *iconUrl;
/* id */
@property (nonatomic, copy) NSString *ID;
/* name */
@property (nonatomic, copy) NSString *name;
/* type */
@property (nonatomic, copy) NSString *type;

//开始搜索
+(NSURLSessionDataTask*)search:(NSDictionary *)option
                       Success:(void (^)(NSArray *list))success
                       Failure:(void (^)(NSError *error))failue;

//热门币种
+(NSURLSessionDataTask*)hot_coin:(NSDictionary *)option
                         Success:(void (^)(NSArray *list))success
                         Failure:(void (^)(NSError *error))failue;

@end
