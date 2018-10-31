//
//  FlashModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/7.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"
#import "PageModel.h"

/**
 快讯model
 */
@interface Flash: BaseModel

/* open */
@property (nonatomic, assign) BOOL open;

/* id */
@property (nonatomic, copy) NSString *ID;
/* source */
@property (nonatomic, copy) NSString *source;
/* weight */
@property (nonatomic, assign) CGFloat weight;
/* title */
@property (nonatomic, copy) NSString *title;
/* content */
@property (nonatomic, copy) NSString *content;
/* contentAttr 解析html */
@property (nonatomic, copy) NSMutableAttributedString *contentStr;
/* title height */
@property (nonatomic, assign) CGFloat titleHeight;
/* content height */
@property (nonatomic, assign) CGFloat contentHeight;

/* rise */
@property (nonatomic, assign) NSInteger rise;
/* fall */
@property (nonatomic, assign) NSInteger fall;
/* createTime */
@property (nonatomic, assign) NSInteger createTime;
/* updateTime */
@property (nonatomic, assign) NSInteger updateTime;
/* urlSource */
@property (nonatomic, copy) NSString *urlSource;
/* showHeader */
@property (nonatomic, assign) BOOL hideHeader;
/* riseOrFall */
@property (nonatomic, assign) RiseOrFallType riseOrFall;


+(NSURLSessionDataTask*)hot_info_rise:(NSDictionary *)option
                              Success:(void (^)(Flash *flash))success
                              Failure:(void (^)(NSError *error))failue;

+(NSURLSessionDataTask*)hot_info_fall:(NSDictionary *)option
                              Success:(void (^)(Flash *flash))success
                              Failure:(void (^)(NSError *error))failue;

//快讯详情
+(NSURLSessionDataTask*)hot_info_details:(NSDictionary *)option
                                 Success:(void (^)(Flash *flash))success
                                 Failure:(void (^)(NSError *error))failue;

//获得最新快讯条数
+(NSURLSessionDataTask*)hot_info_get_newInfoNum:(NSDictionary *)option
                                        Success:(void (^)(NSInteger num))success
                                        Failure:(void (^)(NSError *error))failue;

@end

@interface FlashGroupModel : BaseModel

/* date */
@property (nonatomic, copy) NSString *time;
/* array */
@property (nonatomic, strong) NSArray *flashArray;
/* news */
@property (nonatomic, assign) NSInteger news;


@end

@interface FlashModel : BaseModel

/* page */
@property (nonatomic, strong) PageModel *page;
/* results */
@property (nonatomic, strong) NSArray *results;

+(NSURLSessionDataTask*)hot_info:(NSDictionary *)option
                         Success:(void (^)(FlashModel *user))success
                         Failure:(void (^)(NSError *error))failue;


@end
