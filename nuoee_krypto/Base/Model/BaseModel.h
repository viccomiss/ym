//
//  BaseModel.h
//  UNIS-LEASE
//
//  Created by Jakey on 16/4/13.
//  Copyright © 2016年 UNIS-LEASE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAMKeychain.h"
#import "APIManager.h"
#import "NSDictionary+JKSafeAccess.h"
#import "NSArray+JKSafeAccess.h"
#import "Constant.h"
@interface BaseModel : NSObject
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL hasMore;
@end
