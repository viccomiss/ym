
//
//  EncryptionTool.m
//  SosUserApp
//
//  Created by Sonia on 15/11/19.
//  Copyright © 2015年 xie. All rights reserved.
//

#import "EncryptionTool.h"
#import "NSData+AES256.h"
#import "GTMBase64.h"
//#import "HeaderHelp.h"

@implementation EncryptionTool

+ (NSDictionary *)encryptionWithParameterDictionary:(NSDictionary *)para {
    
    NSArray *keys = para.allKeys;
    NSMutableString *valueBefore = [NSMutableString new];
    NSMutableString *signBefore = [NSMutableString new];
    NSString *timestamp = [EncryptionTool getTimeStamp];
    for (NSString *key in keys) {
        @try {
            [signBefore appendString:para[key]];
            [valueBefore appendFormat:@"%@=%@&", key, para[key]];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception.reason);
        }
        @finally {
            
        }
        
    }
    //时间戳
    [signBefore appendFormat:@"%@%@", timestamp, timestamp];
    [valueBefore appendFormat:@"timestamp=%@", timestamp];

    
    NSString *value = [EncryptionTool AES128Encryption:valueBefore];
    
    NSString *sign = [EncryptionTool MD5Encryption:signBefore];
    
    if (value && sign) {
        return @{@"value": value, @"sign": sign};
    }

    NSLog(@"加密失败");
    return nil;
}


+ (NSString *)getTimeStamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [[NSString stringWithFormat:@"%f", a] componentsSeparatedByString:@"."].firstObject;
    return timeString;
}

+ (NSString *)qCloudTimeStamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [[NSString stringWithFormat:@"%f", a] componentsSeparatedByString:@"."].firstObject;
    return timeString;
}

+ (NSString *)returnWithTimeIntervalSinceNow:(NSString *)time
{
    //时间戳转换成
    long long time1=[time  longLongValue];
    NSDate *date =[[NSDate alloc]initWithTimeIntervalSinceNow:time1/1000.0];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH点mm分"];
    NSString*  dateTime = [formatter stringFromDate:date];
    return dateTime;
}

+ (NSString *)AES128Encryption:(NSString *)str {
    NSString *value = [NSData AES128EncryptWithPlainText:str];
    return value;
}

+ (NSString *)MD5Encryption:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

+ (NSNumber *)randomNSUInteger {
    return [NSNumber numberWithUnsignedInteger:rand()];
}

+ (NSString *)makeSignatureWithDic:(NSDictionary *)params withApi:(NSString *)api withMethod:(NSString *)method {
    NSMutableDictionary *dic = params.mutableCopy;
    NSMutableArray *keys = dic.allKeys.mutableCopy;
    NSArray *resultArray = [EncryptionTool sortedArrayWithArray:keys];
    
    NSMutableString *res = [NSMutableString new];
    for (NSString *key in resultArray) {
        [res appendFormat:@"%@=%@&", key, [params objectForKey:key]];
    }
    [res deleteCharactersInRange:NSMakeRange(res.length-1, 1)];
    [res insertString:[NSString stringWithFormat:@"%@%@?", [method uppercaseString], api] atIndex:0];
    NSString *sha1 = [NSData HMAC_SHA1_Text:res];
    
    return sha1;
}

+ (NSArray *)sortedArrayWithArray:(NSArray *)arr {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *resultArray = [arr sortedArrayUsingDescriptors:descriptors];
    return  resultArray;
}

@end
