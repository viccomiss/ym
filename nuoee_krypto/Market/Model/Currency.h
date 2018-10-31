//
//  Currency.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

/**
 币种model
 */
@interface Currency : BaseModel

/* slug */
@property (nonatomic, assign) NSInteger slug;
/* currency_name */
@property (nonatomic, copy) NSString *currency_name;
/* currency_type */
@property (nonatomic, copy) NSString *currency_type;
/* sort */
@property (nonatomic, assign) NSInteger sort;
/* type */
@property (nonatomic, assign) NSInteger type;

+(NSURLSessionDataTask*)currency_list:(NSDictionary *)option
                              Success:(void (^)(NSArray *list))success
                              Failure:(void (^)(NSError *error))failue;

@end
