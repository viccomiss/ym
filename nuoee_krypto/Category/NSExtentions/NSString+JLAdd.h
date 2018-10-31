//
//  NSString+JLAdd.h
//  HealthCloud
//
//  Created by jack on 16/2/26.
//  Copyright © 2016年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import <UIKit/UIKit.h>

@interface NSString (JLAdd)

//完整的人民币
+ (NSString *)numberFormatterToAllRMB:(CGFloat)price;

//大于万以万结尾 大于亿以亿结尾  RMB
+ (NSString *)numberFormatterToRMB:(CGFloat)price;

//数值
+ (NSString *)numberFormatterToNum:(CGFloat)num;

//百分比
+ (NSString *)numberFormatterToPercent:(CGFloat)num;

//html 转富文本
- (NSAttributedString *)attributedByHtmlStr;

//指定字符串截到最后
- (NSString *)subStringFrom:(NSString *)fromStr;

- (CGSize)sizeWithFont:(UIFont *)font maxH:(CGFloat)maxH;
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

//大数据做单位处理
+ (NSString *)changeAsset:(NSString *)amountStr;

/**
 Returns a new UUID NSString
 */
+ (NSString *)stringWithUUID;

/**
 *  Returns a new IP Address
 */
+ (NSString *)stringWithIPAddress;

/**
 判断是否为空字符串

 @param string string
 @return bool
 */
+ (BOOL)isBlankString:(NSString *)string;
/**
 Trim blank characters (space and newline) in head and tail.
 @return the trimmed string.
 */
- (NSString *)stringByTrim;

#pragma mark - Hash

/**
 Returns a lowercase NSString for md2 hash.
 */
- (NSString *)md2String;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (NSString *)md4String;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)md5String;

// 3DES加解密
- (NSString*)desEncryptOrDecrypt:(CCOperation)encryptOrDecrypt deskey:(NSString *)deskey;

// des解密
- (NSString *)decryptUseDESkey:(NSString*)desKey;

// base64解码
- (NSString *)baseDecodeString;

// sha256加密
- (NSString *)getSha256;
/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)sha1String;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)sha224String;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)sha256String;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)sha384String;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)sha512String;

#pragma mark - Encode and decode
///=============================================================================
/// @name Encode and decode
///=============================================================================

/**
 Returns an NSString for base64 encoded.
 */
- (NSString *)base64EncodedString;

/**
 Returns an NSString from base64 encoded string.
 @param base64EncodedString The encoded string.
 */
+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 URL encode a string in utf-8.
 @return the encoded string.
 */
- (NSString *)stringByURLEncode;

/**
 URL decode a string in utf-8.
 @return the decoded string.
 */
- (NSString *)stringByURLDecode;

/**
 Escape common HTML to Entity.
 Example: "a<b" will be escape to "a&lt;b".
 */
- (NSString *)stringByEscapingHTML;
#pragma mark format 格式处理
+ (NSString *) convertRMBDisplayString:(NSInteger)rmbCents;

+ (NSString *) convertDiscountDisplayString:(NSInteger)discount;
#pragma mark - Other

/**
 *  返回JSON字符串
 */
+ (NSString*)dictionaryToJson:(id)dic;

/**
 *  返回JSON字符串
 */
+(NSString *)arrayToJson:(NSArray *)arr;

/*
 * @return 返回字典
 */
-(NSDictionary *)jsonToDictionary;

/**
 *  干掉null
 *
 *  @return @""
 */
- (NSString *)notNullString;

-(BOOL)notEmptyOrNull;

- (BOOL)equalIgnoreCase:(NSString *)cmpString;
//判断是否全是空格
- (BOOL)isEmpty:(NSString *) str;
#pragma mark - size
/**
 *  根据label宽度，字体 返回高度
 *
 *  @param size lable size
 *  @param font 字体大小
 *
 *  @return 高度
 */
- (CGFloat)autoHeightLabelSize:(CGSize)size font:(CGFloat)font;

/* 根据label宽度，字体, 行间距 返回高度*/
-(CGFloat)getSpaceLabelHeightWithFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace;

/**
 *  根据label宽度，字体, 行间距 返回高度
 *
 *  @param size lable size
 *  @param font 字体大小
 *  @param lineSpace 行间距大小
 *
 *  @return 高度
 */
- (CGFloat)autoHeightLabelSize:(CGSize)size font:(CGFloat)font lineSpacing:(CGFloat)lineSpace;

/**
 计算富文本高度

 @param lineSpeace 行间距
 @param font       字号
 @param width      最大宽度

 @return height
 */
-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width;


/**
 行间距富文本

 @param lineSpace 行间距
 @param font 字号
 @return 富文本
 */
- (NSAttributedString *)getAttributedStrWithLineSpace:(CGFloat)lineSpace font:(UIFont *)font;

/**
 *  返回字符串在fontSize下的长度(默认一行显示)
 *
 *  @param fontSize 字体大小
 *
 *  @return 长度
 */
- (CGFloat)widthOfFontSize:(CGFloat)fontSize;

/**
 *  返回字符串在fontSize下的高度(默认一行显示)
 *
 *  @param fontSize 字体大小
 *
 *  @return 高度
 */
- (CGFloat)heightOfFontSize:(CGFloat)fontSize;

/**
 *  限制string的长度
 *
 *  @param string string
 *  @param length length
 *
 *  @return 限制后的string
 */
+ (NSString *)limitString:(NSString *)string length:(NSInteger)length;

/**
 *  把字符串字符变成星号（*）
 *
 *  @param left  左边剩余位数
 *  @param right 右边剩余位数
 *
 *  @return 变成星号之后的字符串
 */
- (NSString *)asteriskExceptLeft:(NSInteger)left right:(NSInteger)right;


/**
 *  对URL做UTF8解码
 *
 *  @return UTF8解码之后的URL字符串
 */
- (NSString *)URLDecode;
//手机号加****
-(NSString *)stringMasked;

/**
 从指定字符串截取到指定字符串
 
 @param startString 开始截取的字符
 @param endString   结束截取的字符
 
 @return 截取后的字符串
 */
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;

#pragma mark =========html字符串处理=========
/**
 标准Html
 
 @return 返回标签数组
 */
-(NSArray *)htmlWebStrToElements;
/**
 @return 返回标签数组
 */
-(NSArray *)htmlStrToElementArr;
/**
 @return 返回model数组
 */
-(NSMutableArray *)htmlStrToModelArr;

/**
 对比两个html字符串
 @param subStr 元素少的字符 相同的free置为yes
 @return 相同的部分的model数组
 */
-(NSMutableArray *)htmlStrContainSubstrToModelArr:(NSString *)subStr;

//判断是否有表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
