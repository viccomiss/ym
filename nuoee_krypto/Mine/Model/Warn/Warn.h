//
//  Warn.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/25.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

@interface Warn : BaseModel

/* ID */
@property (nonatomic, copy) NSString *ID;

/* exchangeName */
@property (nonatomic, copy) NSString *exchangeName;
/* traderCoin */
@property (nonatomic, copy) NSString *traderCoin;
/* convertCoin */
@property (nonatomic, copy) NSString *convertCoin;
/* price */
@property (nonatomic, assign) CGFloat price;
/* chgType */
@property (nonatomic, copy) NSString *chgType;
/* currency */
@property (nonatomic, copy) NSString *currency;
/* createTime */
@property (nonatomic, assign) NSInteger createTime;
/* updateTime */
@property (nonatomic, assign) NSInteger updateTime;
/* alertStatus */
@property (nonatomic, copy) NSString *alertStatus;
/* dispaySwitch */
@property (nonatomic, copy) NSString *dispaySwitch;
/* warnType */
@property (nonatomic, assign) WarnType warnType;


//添加新的预警
+(NSURLSessionDataTask*)alerts_new:(NSDictionary *)option
                           Success:(void (^)(Warn *item))success
                           Failure:(void (^)(NSError *error))failue;

//未触发列表
+(NSURLSessionDataTask*)alerts_exchange_show:(NSDictionary *)option
                                     Success:(void (^)(NSArray *item))success
                                     Failure:(void (^)(NSError *error))failue;

//历史预警
+(NSURLSessionDataTask*)alerts_historyWithType:(WarnType)type param:(NSDictionary *)option
                                       Success:(void (^)(NSArray *item))success
                                       Failure:(void (^)(NSError *error))failue;

//删除单条
+(NSURLSessionDataTask*)alerts_delsingle:(NSDictionary *)option
                                 Success:(void (^)(NSString *item))success
                                 Failure:(void (^)(NSError *error))failue;

//删除全部
+(NSURLSessionDataTask*)alerts_delAll_history:(NSDictionary *)option
                                      Success:(void (^)(NSString *item))success
                                      Failure:(void (^)(NSError *error))failue;

@end
