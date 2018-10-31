//
//  NSData+AES256.m
//  AES
//
//  Created by Henry Yu on 2009/06/03.
//  Copyright 2010 Sevensoft Technology Co., Ltd.(http://www.sevenuc.com)
//  All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "NSData+AES256.h"
#import "GTMBase64.h"

const NSUInteger kAlgorithmKeySize = kCCKeySizeAES256;
const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4


//#define gkey			@"16位长度的字符串"
#define gIv             @"0102030405060708"//@"D!Fdfk.#121d1-az"
#define SHA1Key         @"OEYYMGnwINlsIkGJolfYmuhrf7WXOlca"

@implementation NSData (AES256)

+ (NSString *)AES128EncryptWithPlainText:(NSString *)plainText
{
    BOOL isLocation;
    NSArray *arr1 = [plainText componentsSeparatedByString:@"x="];
    NSArray *arr2 = [plainText componentsSeparatedByString:@"y="];
    isLocation = arr1.count == 2 && arr2.count == 2 ? YES : NO;
    
    
    
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    
//    if ( isLocation ) {
//        NSLog(@"请求xy");
//        [lIv getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//        
//        [lIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
//    }
//    else {
    [gIv getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
//    }

    
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    int newSize = 0;
    
    if(diff > 0)
    {
        newSize = (int)(dataLength + diff);
    }
    
    char dataPtr[dataLength];
    @try {
        memcpy(dataPtr, [data bytes], [data length]);
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        
    }
    
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode | ccPKCS7Padding,               //No padding
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          nil,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [GTMBase64 stringByEncodingBytes:[resultData bytes] length:[resultData length]];
    }
    free(buffer);
    return nil;
}

+(NSString *)AES128Decrypt:(NSString *)DecryStr
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [gIv getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    
    NSData *data = [GTMBase64 decodeData:[DecryStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCModeCBC,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          nil,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}

+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text
{
//    NSData *secretData = [SHA1Key dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
//    unsigned char result[20];
//    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
//    char base64Result[32];
//    size_t theResultLength = 32;
//    Base64EncodeData(result, 20, base64Result, &theResultLength,YES);
//    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
//    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
//    return base64EncodedResult;
    const char *cKey  = [SHA1Key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    //NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    return hash;

}

+ (NSString *)HMAC_SHA1_Text:(NSString *)text{
    
    const char *cKey  = [SHA1Key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [HMAC base64Encoding];//base64Encoding函数在NSData+Base64中定义（NSData+Base64网上有很多资源）
    
    return hash;
}

@end
