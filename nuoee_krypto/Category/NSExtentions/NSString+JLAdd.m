//
//  NSString+JLAdd.m
//  HealthCloud
//
//  Created by jack on 16/2/26.
//  Copyright © 2016年 jack. All rights reserved.
//

#import "GTMBase64.h"
#import "NSData+JLAdd.h"
#import "NSString+JLAdd.h"
#import <arpa/inet.h>
#import <ifaddrs.h>
#import "UIView+EasyFrame.h"
//#import "SDVersion.h"

@implementation NSString (JLAdd)

+ (NSString *)numberFormatterToAllRMB:(CGFloat)price{
    
    price = floor(price * 100) / 100;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    return [formatter stringFromNumber:[NSNumber numberWithFloat:price]];
}

+ (NSString *)numberFormatterToRMB:(CGFloat)price{
    
    price = floor(price * 100) / 100;

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    
    if (price >= 100000000) {
        return [NSString stringWithFormat:@"%@亿",[formatter stringFromNumber:[NSNumber numberWithFloat:price / 100000000]]];
    }else if(price > 10000){
        formatter.multiplier = @0.0001;
        formatter.positiveSuffix = @"万";
        return [formatter stringFromNumber:[NSNumber numberWithFloat:price]];
    }
    return [formatter stringFromNumber:[NSNumber numberWithFloat:price]];
}

+ (NSString *)numberFormatterToNum:(CGFloat)num{
    
    num = floor(num * 100) / 100;

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    
    if (num >= 100000000) {
        return [NSString stringWithFormat:@"%@亿",[formatter stringFromNumber:[NSNumber numberWithInteger:num / 100000000]]];
    }else if(num > 10000){
        formatter.multiplier = @0.0001;
        formatter.positiveSuffix = @"万";
        return [formatter stringFromNumber:[NSNumber numberWithInteger:num]];
    }
    return [formatter stringFromNumber:[NSNumber numberWithInteger:num]];
}

+ (NSString *)numberFormatterToPercent:(CGFloat)num{
    
    num = floor(num * 100) / 100;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterPercentStyle;
    
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}

- (NSAttributedString *)attributedByHtmlStr{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

//指定字符串截到最后
- (NSString *)subStringFrom:(NSString *)fromStr{
    
    NSRange startRange = [self rangeOfString:fromStr];
    return [self substringFromIndex:startRange.location + 1];
}

- (CGSize)sizeWithFont:(UIFont *)font maxH:(CGFloat)maxH
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, maxH);
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}


- (NSString *)czh_interceptFrontPartWithtRangeString:(NSString *)rangeString {
    
    if ([self containsString:rangeString]) {
        NSRange range = [self rangeOfString:rangeString];
        NSUInteger location = range.location;
        
        if (location != NSNotFound) {
            return [self substringToIndex:location];
        } else {
            return self;
        }
    } else {
        return self;
    }
}
//大数据做单位处理
+ (NSString *)changeAsset:(NSString *)amountStr
{
    if (amountStr && ![amountStr isEqualToString:@""])
    {
        NSInteger num = [amountStr integerValue];
        if (num<10000)
        {
            return amountStr;
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"%f",num/10000.0];
            NSRange range = [str rangeOfString:@"."];
            str = [str substringToIndex:range.location+2];
            if ([str hasSuffix:@".0"])
            {
                return [NSString stringWithFormat:@"%@万",[str substringToIndex:str.length-2]];
            }
            else
                return [NSString stringWithFormat:@"%@万",str];
        }
    }
    else
        return @"0";
}

+ (NSString *)stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *) string;
}

+ (NSString *)stringWithIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

//判断是否是空字符串
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark - Hash

- (NSString *)md2String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md2String];
}

- (NSString *)md4String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md4String];
}

- (NSString *)md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5String];
}

#pragma mark - ljy 3DES 加密
#define kSecrectKeyLength 24

//3DES
- (NSString *)desEncryptOrDecrypt:(CCOperation)encryptOrDecrypt deskey:(NSString *)deskey {

    const void *vplainText;
    size_t plainTextBufferSize;

    if (encryptOrDecrypt == kCCDecrypt) {
        NSData *EncryptData = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    } else {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *) [data bytes];
    }

    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;

    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *) bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));

    //    NSString *key = @"123456789012345678901234";
    NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [deskey UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];

    //    CCOptions i = encryptOrDecrypt == kCCDecrypt ? kCCOptionECBMode :kCCOptionPKCS7Padding;

    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode | kCCOptionPKCS7Padding, //kCCOptionPKCS7Padding,        //健康云用的ECB模式
                       vkey,                                     //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec,   //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *) bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */

    NSString *result;

    if (encryptOrDecrypt == kCCDecrypt) {
        NSData *data = [NSData dataWithBytes:(const void *) bufferPtr
                                      length:(NSUInteger) movedBytes];
        result = [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
    } else {
        NSData *myData = [NSData dataWithBytes:(const void *) bufferPtr length:(NSUInteger) movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }

    return result;
}

//DES解密
- (NSString *)decryptUseDESkey:(NSString *)desKey {
    NSData *cipherData = [GTMBase64 decodeString:self];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1, 2, 3, 4, 5, 6, 7, 8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [desKey UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString *plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger) numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

- (NSString *)getSha256 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];

    uint8_t digest[CC_SHA256_DIGEST_LENGTH];

    CC_SHA1(data.bytes, data.length, digest);

    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

- (NSString *)baseDecodeString {
    NSData *nsdataFromBase64String = [[NSData alloc]
        initWithBase64EncodedString:self
                            options:NSDataBase64DecodingIgnoreUnknownCharacters];

    return [[NSString alloc] initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
}

- (NSString *)sha1String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1String];
}

- (NSString *)sha224String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha224String];
}

- (NSString *)sha256String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256String];
}

- (NSString *)sha384String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha384String];
}

- (NSString *)sha512String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha512String];
}

#pragma mark - Encode and decode

- (NSString *)base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)stringByURLEncode {
//    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
//        /**
//         AFNetworking/AFURLRequestSerialization.m
//
//         Returns a percent-escaped string following RFC 3986 for a query string key or value.
//         RFC 3986 states that the following characters are "reserved" characters.
//         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
//         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
//         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
//         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
//         should be percent-escaped in the query string.
//         - parameter string: The string to be percent-escaped.
//         - returns: The percent-escaped string.
//         */
//        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
//        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
//
//        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
//        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
//        static NSUInteger const batchSize = 50;
//
//        NSUInteger index = 0;
//        NSMutableString *escaped = @"".mutableCopy;
//
//        while (index < self.length) {
//            NSUInteger length = MIN(self.length - index, batchSize);
//            NSRange range = NSMakeRange(index, length);
//            // To avoid breaking up character sequences such as 👴🏻👮🏽
//            range = [self rangeOfComposedCharacterSequencesForRange:range];
//            NSString *substring = [self substringWithRange:range];
//            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
//            [escaped appendString:encoded];
//
//            index += range.length;
//        }
//        return escaped;
//    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
    NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
            kCFAllocatorDefault,
            (__bridge CFStringRef) self,
            NULL,
            CFSTR("!#$&'()*+,/:;=?@[]"),
            cfEncoding);
    return encoded;
#pragma clang diagnostic pop
    //    }
}

- (NSString *)stringByURLDecode {
//    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
//        return [self stringByRemovingPercentEncoding];
//    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
    NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                        withString:@" "];
    decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
            NULL,
            (__bridge CFStringRef) decoded,
            CFSTR(""),
            en);
    return decoded;
#pragma clang diagnostic pop
    //    }
}

- (NSString *)stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;

    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return nil;
    [self getCharacters:buf range:NSMakeRange(0, len)];

    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34:
                esc = @"&quot;";
                break;
            case 38:
                esc = @"&amp;";
                break;
            case 39:
                esc = @"&apos;";
                break;
            case 60:
                esc = @"&lt;";
                break;
            case 62:
                esc = @"&gt;";
                break;
            default:
                break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef) result, &c, 1);
        }
    }
    free(buf);
    return result;
}
#pragma mark format 格式处理
+ (NSString *) convertRMBDisplayString:(NSInteger)rmbCents
{
    if(rmbCents == 0) return @"0";
    if(rmbCents < 0) {
#ifdef SEDebug
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"转换金额出错"
                                                        message:@"金额不能为负数。这个提示只是在开发环境提示，给你带来的困扰，敬请谅解！" delegate:nil
                                              cancelButtonTitle:@"没关系" otherButtonTitles:nil] ;
        [alert show] ;
        ;
#endif
        return @"";
    }
    NSDecimalNumber *priceNumber = nil;
    if(rmbCents % 100 == 0){
        priceNumber = [[NSDecimalNumber alloc] initWithInteger:rmbCents/100];
    }else{
        priceNumber = [[NSDecimalNumber alloc] initWithMantissa:rmbCents exponent:-2 isNegative:NO];
    }
    return [priceNumber stringValue];
}
+ (NSString *) convertDiscountDisplayString:(NSInteger)discount{
 if(discount == 0) return @"0";
    NSDecimalNumber *discountNumber = nil;
    if(discount % 10 == 0){
        discountNumber = [[NSDecimalNumber alloc] initWithInteger:discount/10];
    }else{
        discountNumber= [[NSDecimalNumber alloc] initWithMantissa:discount exponent:-1 isNegative:NO];
    }
    return [discountNumber stringValue];
}
#pragma mark - Other

/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */

-(NSDictionary *)jsonToDictionary{
    NSError *error = nil;
    NSData *data  =[self dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

+ (NSString *)dictionaryToJson:(id)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *resultJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    resultJson = [resultJson stringByReplacingOccurrencesOfString:@" " withString:@""];
    resultJson = [resultJson stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return resultJson;
}
/**
 *  @brief NSArray转换成JSON字符串
 *
 *  @return  JSON字符串
 */
+(NSString *)arrayToJson:(NSArray *)arr{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData == nil) {
#ifdef DEBUG
        NSLog(@"fail to get JSON from dictionary: %@, error: %@", self, error);
#endif
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSString *)notNullString {
    return self ? self : @"";
}
-(BOOL)notEmptyOrNull{
    if (self && ![self isEqualToString:@""] && ![self isEqualToString:@" "]) {
        return YES;
    }
    return NO;
}
- (BOOL)equalIgnoreCase:(NSString *)cmpString {
    return [[self lowercaseString] isEqualToString:[cmpString lowercaseString]];
}

//判断是否全是空格
- (BOOL) isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (CGFloat)autoHeightLabelSize:(CGSize)size font:(CGFloat)font {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, MAXFLOAT)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:font];
    label.text = self;
    [label sizeToFit];

    return label.easy_height;
}

- (NSAttributedString *)getAttributedStrWithLineSpace:(CGFloat)lineSpace font:(UIFont *)font{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self attributes:dic];
    return attributeStr;
}

-(CGFloat)getSpaceLabelHeightWithFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
//    paraStyle.maximumLineHeight = 12;
//    paraStyle.minimumLineHeight = 10;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                   attributes:dic context:nil].size;
    return size.height;
}

//带行间距的自动行高
- (CGFloat)autoHeightLabelSize:(CGSize)size font:(CGFloat)font lineSpacing:(CGFloat)lineSpace {

    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:font];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lineSpace];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [self length])];
    [detailLabel setAttributedText:attributedString1];
    [detailLabel sizeToFit];
    return detailLabel.frame.size.height;
}

//计算富文本高度
-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

/**
 *  返回字符串在fontSize下的长度(默认一行显示)
 *
 *  @param fontSize 字体大小
 *
 *  @return 长度
 */
- (CGFloat)widthOfFontSize:(CGFloat)fontSize {
    NSDictionary *attrDic = @{NSFontAttributeName : Font(fontSize)};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:options attributes:attrDic context:nil];
    return ceilf(rect.size.width);
}

/**
 从指定字符串截取到指定字符串

 @param startString 开始截取的字符
 @param endString   结束截取的字符

 @return 截取后的字符串
 */
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString{
    
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
}

/**
 *  返回字符串在fontSize下的高度(默认一行显示)
 *
 *  @param fontSize 字体大小
 *
 *  @return 高度
 */
- (CGFloat)heightOfFontSize:(CGFloat)fontSize {
    NSDictionary *attrDic = @{NSFontAttributeName : Font(fontSize)};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:options attributes:attrDic context:nil];
    return ceilf(rect.size.height);
}

/**
 *  限制string的长度
 *
 *  @param string string
 *  @param length length
 *
 *  @return 限制后的string
 */
+ (NSString *)limitString:(NSString *)string length:(NSInteger)length {
    if (string.length > length) {
        return [string substringToIndex:length];
    }

    return string;
}

/**
 *  判断是否为纯字母
 *
 *  @return 是否纯字母
 */
- (BOOL)hc_isPureLetter{
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    if(string.length > 0){
        return NO;
    }
    return YES;
}


/**
 *  把字符串字符变成星号（*）
 *
 *  @param left  左边剩余位数
 *  @param right 右边剩余位数
 *
 *  @return 变成星号之后的字符串
 */
- (NSString *)asteriskExceptLeft:(NSInteger)left right:(NSInteger)right {
    NSAssert((left >=0 && right >= 0), @"NSString + JLAdd : left anf right must not be less than zero ！");
    NSAssert((self.length >= left + right), @"NSString + JLAdd : the string's length must not be less than (right + left) !");
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:self.length - left - right];
    for (NSInteger i = 0; i < self.length - left - right; i ++) {
        [string appendString:@"*"];
    }
    
    return [self stringByReplacingCharactersInRange:NSMakeRange(left, self.length - left - right) withString:string];
}

/**
 *  去掉字符串中的空格
 *
 *  @return 去掉空格的字符串
 */
- (NSString *)replaceWhitespaceCharacter {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/**
 *  对URL做UTF8解码
 *
 *  @return UTF8解码之后的URL字符串
 */
- (NSString *)URLDecode {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
/*  对手机号加****处理
*
*  @return UTF8解码之后的URL字符串
*/
-(NSString *)stringMasked{
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

#pragma mark =========html字符串处理=========

/**
 标准Html

 @return 返回标签数组
 */
-(NSArray *)htmlWebStrToElements{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self componentsSeparatedByString:@"<"]];
    [arr removeObject:@""];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *str in arr) {
        if ([str hasPrefix:@"p"]) {
            NSString  *handelStr = str;
//            if ([handelStr containsString:@"data-src"]) {
//                handelStr = [handelStr stringByReplacingOccurrencesOfString:@"data-src" withString:@"src"];
//            }
            
            NSMutableString *result = [[NSMutableString alloc]initWithString:handelStr];
//            [result insertString:@" font-size = 30px;" atIndex:1];
            
            NSString *pStr = [NSString stringWithFormat:@"<%@</p>",result];
             [arrM addObject:pStr];
        }
        
        if ([str hasPrefix:@"span"]) {
            NSString *handelStr = str;
            NSMutableString *result = [[NSMutableString alloc]initWithString:handelStr];
            NSString *pStr = [NSString stringWithFormat:@"<%@</p>",result];
            [arrM addObject:pStr];
        }
        
        if ([str hasPrefix:@"img"]) {
            NSString  *handelStr = str;
            if ([handelStr containsString:@"data-src"]) {
                handelStr = [handelStr stringByReplacingOccurrencesOfString:@"data-src" withString:@"src"];
            }
          
            NSMutableString *result = [[NSMutableString alloc]initWithString:handelStr];
            [result insertString:[NSString stringWithFormat:@" width = %f",MAINSCREEN_WIDTH - 40 ] atIndex:3];
            
            NSString *imgStr = [NSString stringWithFormat:@"<%@",result];
            [arrM addObject:imgStr];
        }
    }
    return arrM;
}
/**
 @return 返回标签数组
 */
-(NSArray *)htmlStrToElementArr{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self componentsSeparatedByString:@"<"]];
    [arr removeObject:@"/p>"];
    [arr removeObject:@""];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *str in arr) {
        if ([str hasPrefix:@"p>"]) {
            [arrM addObject:[str substringFromIndex:2]];
        }
        if ([str hasPrefix:@"img"]) {
            NSRange startRange = [str rangeOfString:@"\""];
            NSRange endRange = [str rangeOfString:@"\"/"];
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            NSString *result = [str substringWithRange:range];
            [arrM addObject:str];
        }
    }
    return arrM;
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (len < 3) { // 大于2个字符需要验证Emoji(有些Emoji仅三个字符)
        return NO;
    }
    
    // 仅考虑字节长度为3的字符,大于此范围的全部做Emoji处理
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    Byte *bts = (Byte *)[data bytes];
    Byte bt;
    short v;
    for (NSUInteger i = 0; i < len; i++) {
        bt = bts[i];
        
        if ((bt | 0x7F) == 0x7F) { // 0xxxxxxx ASIIC编码
            continue;
        }
        if ((bt | 0x1F) == 0xDF) { // 110xxxxx 两个字节的字符
            i += 1;
            continue;
        }
        if ((bt | 0x0F) == 0xEF) { // 1110xxxx 三个字节的字符(重点过滤项目)
            // 计算Unicode下标
            v = bt & 0x0F;
            v = v << 6;
            v |= bts[i + 1] & 0x3F;
            v = v << 6;
            v |= bts[i + 2] & 0x3F;
            
            // NSLog(@"%02X%02X", (Byte)(v >> 8), (Byte)(v & 0xFF));
            
            if ([NSString emojiInSoftBankUnicode:v] || [NSString emojiInUnicode:v]) {
                return YES;
            }
            
            i += 2;
            continue;
        }
        if ((bt | 0x3F) == 0xBF) { // 10xxxxxx 10开头,为数据字节,直接过滤
            continue;
        }
        
        return YES; // 不是以上情况的字符全部超过三个字节,做Emoji处理
    }
    return NO;
}

+ (BOOL)emojiInSoftBankUnicode:(short)code
{
    return ((code >> 8) >= 0xE0 && (code >> 8) <= 0xE5 && (Byte)(code & 0xFF) < 0x60);
}

+ (BOOL)emojiInUnicode:(short)code
{
    if (code == 0x0023
        || code == 0x002A
        || (code >= 0x0030 && code <= 0x0039)
        || code == 0x00A9
        || code == 0x00AE
        || code == 0x203C
        || code == 0x2049
        || code == 0x2122
        || code == 0x2139
        || (code >= 0x2194 && code <= 0x2199)
        || code == 0x21A9 || code == 0x21AA
        || code == 0x231A || code == 0x231B
        || code == 0x2328
        || code == 0x23CF
        || (code >= 0x23E9 && code <= 0x23F3)
        || (code >= 0x23F8 && code <= 0x23FA)
        || code == 0x24C2
        || code == 0x25AA || code == 0x25AB
        || code == 0x25B6
        || code == 0x25C0
        || (code >= 0x25FB && code <= 0x25FE)
        || (code >= 0x2600 && code <= 0x2604)
        || code == 0x260E
        || code == 0x2611
        || code == 0x2614 || code == 0x2615
        || code == 0x2618
        || code == 0x261D
        || code == 0x2620
        || code == 0x2622 || code == 0x2623
        || code == 0x2626
        || code == 0x262A
        || code == 0x262E || code == 0x262F
        || (code >= 0x2638 && code <= 0x263A)
        || (code >= 0x2648 && code <= 0x2653)
        || code == 0x2660
        || code == 0x2663
        || code == 0x2665 || code == 0x2666 || code == 0x2668
        || code == 0x267B
        || code == 0x267F
        || (code >= 0x2692 && code <= 0x2694)
        || code == 0x2696 || code == 0x2697
        || code == 0x2699
        || code == 0x269B || code == 0x269C
        || code == 0x26A0 || code == 0x26A1
        || code == 0x26AA || code == 0x26AB
        || code == 0x26B0 || code == 0x26B1
        || code == 0x26BD || code == 0x26BE
        || code == 0x26C4 || code == 0x26C5
        || code == 0x26C8
        || code == 0x26CE
        || code == 0x26CF
        || code == 0x26D1
        || code == 0x26D3 || code == 0x26D4
        || code == 0x26E9 || code == 0x26EA
        || (code >= 0x26F0 && code <= 0x26F5)
        || (code >= 0x26F7 && code <= 0x26FA)
        || code == 0x26FD
        || code == 0x2702
        || code == 0x2705
        || (code >= 0x2708 && code <= 0x270D)
        || code == 0x270F
        || code == 0x2712
        || code == 0x2714
        || code == 0x2716
        || code == 0x271D
        || code == 0x2721
        || code == 0x2728
        || code == 0x2733 || code == 0x2734
        || code == 0x2744
        || code == 0x2747
        || code == 0x274C
        || code == 0x274E
        || (code >= 0x2753 && code <= 0x2755)
        || code == 0x2757
        || code == 0x2763 || code == 0x2764
        || (code >= 0x2795 && code <= 0x2797)
        || code == 0x27A1
        || code == 0x27B0
        || code == 0x27BF
        || code == 0x2934 || code == 0x2935
        || (code >= 0x2B05 && code <= 0x2B07)
        || code == 0x2B1B || code == 0x2B1C
        || code == 0x2B50
        || code == 0x2B55
        || code == 0x3030
        || code == 0x303D
        || code == 0x3297
        || code == 0x3299
        // 第二段
        || code == 0x23F0) {
        return YES;
    }
    return NO;
}


@end
