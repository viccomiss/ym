//
//  ShareModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/20.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"
#import <ShareSDK/ShareSDK.h>

@interface ShareModel : BaseModel

/* icon */
@property (nonatomic, copy) NSString *icon;
/* name */
@property (nonatomic, copy) NSString *name;
/* SSDKPlatformType */
@property (nonatomic, assign) SSDKPlatformType type;


@end
