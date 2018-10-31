//
//  ExchangeRanksModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"
#import "Exchange.h"

/**
 交易所行情列表
 */
@interface ExchangeRanksModel : BaseModel

/* code */
@property (nonatomic, copy) NSString *code;
/* data */
@property (nonatomic, strong) NSArray *data;
/* message */
@property (nonatomic, copy) NSString *message;

+(NSURLSessionDataTask*)exchangeRanks:(NSDictionary *)option
                              Success:(void (^)(ExchangeRanksModel *model))success
                              Failure:(void (^)(NSError *error))failue;

@end
