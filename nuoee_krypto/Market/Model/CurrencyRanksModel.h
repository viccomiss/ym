//
//  CurrencyRanksModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"
#import "CurrencyRank.h"

@interface CurrencyRanksModel : BaseModel

/* code */
@property (nonatomic, copy) NSString *code;
/* data */
@property (nonatomic, strong) NSArray *data;
/* message */
@property (nonatomic, copy) NSString *message;

+(NSURLSessionDataTask*)currency_ranks:(NSDictionary *)option
                               Success:(void (^)(CurrencyRanksModel *model))success
                               Failure:(void (^)(NSError *error))failue;

@end
