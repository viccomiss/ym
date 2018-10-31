//
//  Common.h
//  HealthCloud
//
//  Created by jack on 16/5/13.
//  Copyright © 2016年 luoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum _RETURNDATA_TYPE {
    NetReturnDataTypeString = 1 << 1,
    NetReturnDataTypeNumber = 1 << 2,
    NetReturnDataTypeArray = 1 << 3,
    NetReturnDataTypeDict = 1 << 4,
} NetReturnDataType;

@interface CommonUtils : NSObject

/**
 *  返回所需类型数据
 *
 *  @param data 数据
 *  @param type 返回类型
 *
 *  @return 对象
 */
+ (id)filterReturnData:(NSValue *)data forType:(NetReturnDataType)type;

/**
 *  验证 验证码否是空或者空格
 *
 *  @param str 字符串
 *
 *  @return 是否是合格的验证码
 */
+ (BOOL)isValidAuthCode:(NSString *)str;

/**
 *  是否是有效的手机号码
 *
 *  @return
 */
+ (BOOL)isValidPhoneNumber:(NSString *)str;

/**
 *  去掉字符串中的空格
 *
 *  @return 去掉空格的字符串
 */
+ (NSString *)replaceWhitespaceCharacter:(NSString *)str;

/**
 *  校验密码
 *
 *  @return
 */
+ (BOOL)validatePassword:(NSString *)passwordStr;


/**
 *  校验身份证号码
 *
 *  @return 返回是否为真实身份证号码
 */
+ (BOOL)validateIdentityCard:(NSString *)cardStr;

/**
 *  校验银行卡号
 *
 *  @return
 */
+ (BOOL)isValidBankCardNumber:(NSString *)bankStr;

/**
 *  检验是否是有效的URL
 *
 *  @param urlString
 *
 *  @return
 */
+(BOOL)isValidUrl:(NSString *)urlString;

/**
 *  验证是否是空或者空格
 *
 *  @return
 */
+ (BOOL)isNullOrBlankString:(NSString *)str;

/**
 *  是否是数字
 */
+ (BOOL)validateNumber:(NSString *)str;

/**
 *  判断对象是否为空
 *
 *  @param obj obj
 *
 *  @return 是否为空
 */
+ (BOOL)checkEmptyObj:(id)obj;

/**
 *  检查字符串是否为空
 *
 *  @return 是否为空
 */
+ (BOOL)isEmpty:(NSString *)str;

/**
 *  获取应用当前的显示的视图控制器
 *
 *  @return viewController
 */
+ (UIViewController *)currentViewController;

/**
 *  获取截屏
 *
 *  @return 截图
 */
+ (UIImage *)getScreenShot;

/**
 *  在字符串的某些位置加上空格
 *
 *  @param string    string
 *  @param locations 加空格的位置（@[3，5，8]）
 *
 *  @return 加上空格的字符串
 */
+ (NSString *)stringAddedWhiteCharter:(NSString *)string atLocation:(NSArray <NSNumber *> *)locations;

/**
 *  计算高度
 *
 *  @param textStr  文本
 *  @param width    宽度
 *  @param fontSize 字体
 *
 *  @return 高度
 */
+ (CGFloat)hc_heightFromString:(NSString *)textStr width:(CGFloat)width fontSize:(UIFont *)fontSize;

/**
 *  计算宽度
 *
 *  @param textStr  文本
 *  @param height   高度
 *  @param fontSize 字体
 *
 *  @return 宽度
 */
+ (CGFloat)hc_widthFromString:(NSString *)textStr height:(CGFloat)height fontSize:(UIFont *)fontSize;

@end
