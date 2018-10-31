//
//  EncryptionTool.h
//  SosUserApp
//
//  Created by Sonia on 15/11/19.
//  Copyright © 2015年 xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionTool : NSObject

+ (NSDictionary *)encryptionWithParameterDictionary:(NSDictionary *)para;
+ (NSString *)returnWithTimeIntervalSinceNow:(NSString *)time;
+ (NSString *)getTimeStamp;
+ (NSString *)qCloudTimeStamp;
+ (NSNumber *)randomNSUInteger;
+ (NSString *)makeSignatureWithDic:(NSDictionary *)params withApi:(NSString *)api withMethod:(NSString *)method;
+ (NSArray *)sortedArrayWithArray:(NSArray *)arr;

@end
