//
//  BaseModel.m
//  UNIS-LEASE
//
//  Created by Jakey on 16/4/13.
//  Copyright © 2016年 UNIS-LEASE. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end
