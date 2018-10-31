//
//  Exchange.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

/**
 交易所
 */
@interface Exchange : BaseModel

/* exchange */
@property (nonatomic, copy) NSString *exchange;
/* exchangeName */
@property (nonatomic, copy) NSString *exchangeName;
/* index */
@property (nonatomic, assign) NSInteger index;
/* logo */
@property (nonatomic, copy) NSString *logo;
/* vol */
@property (nonatomic, copy) NSString *vol;
/* area */
@property (nonatomic, copy) NSString *area;
/* tradeType */
@property (nonatomic, copy) NSString *tradeType;

//交易所基本信息
+(NSURLSessionDataTask*)exchange:(NSDictionary *)option
                         Success:(void (^)(Exchange *model))success
                         Failure:(void (^)(NSError *error))failue;

@end
