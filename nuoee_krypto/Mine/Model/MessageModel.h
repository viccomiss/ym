//
//  MessageModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/13.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

@interface Message : BaseModel

/* context */
@property (nonatomic, copy) NSString *context;
/* createDate */
@property (nonatomic, assign) NSInteger createDate;
/* id */
@property (nonatomic, copy) NSString *ID;
/* publish */
@property (nonatomic, assign) BOOL publish;
/* read */
@property (nonatomic, assign) BOOL read;
/* title */
@property (nonatomic, copy) NSString *title;
/* updateDate */
@property (nonatomic, assign) NSInteger updateDate;
/* push */
@property (nonatomic, assign) BOOL push;
/* jumpUrl */
@property (nonatomic, copy) NSString *jumpUrl;
/* jumpPage */
@property (nonatomic, assign) BOOL jumpPage;

//删除
+(NSURLSessionDataTask*)mes_center_delete_id:(NSDictionary *)option
                                     Success:(void (^)(id item))success
                                     Failure:(void (^)(NSError *error))failue;

@end


@interface MessageModel : BaseModel

/* mesCenters */
@property (nonatomic, strong) NSArray *mesCenters;
/* notReadCount */
@property (nonatomic, assign) NSInteger notReadCount;
/* isRead */
@property (nonatomic, assign) BOOL isRead;

+(NSURLSessionDataTask*)mes_center:(NSDictionary *)option
                           Success:(void (^)(MessageModel *item))success
                           Failure:(void (^)(NSError *error))failue;

//删除所有
+(NSURLSessionDataTask*)mes_center_delete_all:(NSDictionary *)option
                                      Success:(void (^)(NSString *item))success
                                      Failure:(void (^)(NSError *error))failue;

@end
