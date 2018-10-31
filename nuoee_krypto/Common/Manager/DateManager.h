//
//  DateManager.h
//
//
//  Created by Jakey on 15/7/13.
//  Copyright © 2015年  . All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef NS_ENUM(NSUInteger, FormatType) {
//    FormatType_YMD,
//    FormatType_YMDHM,
//    FormatType_YMDHMD,
//};
@interface DateManager : NSObject


+ (DateManager *) sharedManager;
#pragma mark-- data to formater string
/**
 *  NSDate 转换 NSString
 *
 *  @param date   待转换NSDate
 *  @param format 待转换NSDate格式 比如yyyy-MM-dd
 *
 *  @return 转换 后的NSString
 */
- (NSString *)stringConvertFromDate:(NSDate *)date format:(NSString *)format;
/**
 *  NSDate 转换 NSString
 *
 *  @param date   待转换NSDate
 *
 *  @return 转换 后的yyyy-MM-dd NSString
 */
+ (NSString *)stringConvert_YMD_FromDate:(NSDate *)date;
/**
 *  NSDate 转换 NSString
 *
 *  @param date   待转换NSDate
 *
 *  @return 转换 后的yyyy-MM-dd HH:mm NSString
 */
+ (NSString *)stringConvert_YMDHM_FromDate:(NSDate *)date;
/**
 *  NSDate 转换 NSString
 *
 *  @param date   待转换NSDate
 *
 *  @return 转换 后的yyyy-MM-dd HH:mm:ss NSString
 */
+ (NSString *)stringConvert_YMDHMS_FromDate:(NSDate *)date;
/**
 *  NSDate 转换 NSString
 *
 *  @param date   待转换NSDate
 *
 *  @return 转换 后的 HH:mm NSString
 */
+ (NSString *)stringConvert_HM_FromDate:(NSDate *)date;

#pragma mark-- string to formater data
/**
 *  NSString 转换 NSDate
 *
 *  @param string 待转换NSString
 *  @param format 待转换NSDate格式 比如yyyy-MM-dd
 *
 *  @return 转换 后的NSDate
 */

- (NSDate *)dateConvertFromString:(NSString *)string format:(NSString *)format;
/**
 *  NSString 转换 NSDate
 *
 *  @param string 待转换yyyy-MM-dd NSString
 *
 *  @return 转换 后的NSDate
 */
+ (NSDate *)dateConvertFrom_YMD_String:(NSString *)string;
/**
 *  NSString 转换 NSDate
 *
 *  @param string 待转换yyyy-MM-dd HH:mm NSString
 *
 *  @return 转换 后的NSDate
 */
+ (NSDate *)dateConvertFrom_YMDHM_String:(NSString *)string;
/**
 *  NSString 转换 NSDate
 *
 *  @param string 待转换yyyy-MM-dd HH:mm:ss NSString
 *
 *  @return 转换 后的NSDate
 */
+ (NSDate *)dateConvertFrom_YMDHMS_String:(NSString *)string;
+ (NSString *)date_YMD2_WithTimeIntervalStringSince1970:(NSString*)secsString;
+ (NSString *)date_YMD3_WithTimeIntervalStringSince1970:(NSString*)secsString;
#pragma mark-- timeStamp to string date
/**
 *  时间戳根据格式转字符串
 *
 *  @param secs   秒数
 *  @param format 格式
 *
 *  @return 格式后时间字符串
 */
+ (NSString *)dateWithTimeIntervalSince1970:(NSTimeInterval)secs format:(NSString *)format;
/**
 *  时间戳根据格式转字符串
 *
 *  @param secs   秒数
 *
 *  @return 格式后时间yyyy-MM-dd字符串
 */
+ (NSString *)date_YMD_WithTimeIntervalSince1970:(NSTimeInterval)secs;
/**
 *  时间戳根据格式转字符串
 *
 *  @param secs   秒数
 *
 *  @return 格式后时间HH:mm:ss字符串
 */
+ (NSString *)date_HMS_WithTimeIntervalSince1970:(NSTimeInterval)secs;
/**
 *  时间戳根据格式转字符串
 *
 *  @param secsString   秒数
 *
 *  @return 格式后时间yyyy-MM-dd字符串
 */
+ (NSString *)date_YMD_WithTimeIntervalStringSince1970:(NSString*)secsString;
/**
 *  时间戳根据格式转字符串
 *
 *  @param secs   秒数
 *
 *  @return 格式后时间yyyy-MM-dd HH:mm字符串
 */
+ (NSString *)date_YMDHM_WithTimeIntervalSince1970:(NSTimeInterval)secs;
/**
 *  时间戳根据格式转字符串
 *
 *  @param secs   秒数
 *
 *  @return 格式后时间yyyy-MM-dd HH:mm:ss字符串
 */
+ (NSString *)date_YMDHMS_WithTimeIntervalSince1970:(NSTimeInterval)secs;

#pragma mark-- timeStamp
/**
 *  时间转时间戳字符串
 *
 *  @param date NSDate 时间
 *
 *  @return 时间戳字符串
 */
+(NSString *)timeStampStringWithDate:(NSDate*)date;
/**
 *  时间戳转NSDate
 *
 *  @param interval 时间戳
 *
 *  @return 时间NSDate
 */
+ (NSDate*)dateWithTimeStamp:(long long)interval;
/**
 *  时间转时间戳long long
 *
 *  @param date NSDate 时间
 *
 *  @return 时间戳long long
 */
+(long long)timeIntervalWithDate:(NSDate*)date;
/**
 *  当前时间时间戳字符串
 *
 *  @return 当前时间时间戳字符串
 */
+(NSString*)nowTimeStampString;
/**
 *  当前时间时间YMD字符串
 *
 *  @return 当前时间ymd字符串
 */
+(NSString*)nowYMDString;
/**
 *  当前时间时间YMDHmS字符串
 *
 *  @return 当前时间YMDHmS字符串
 */
+(NSString*)nowYMDHMSString;
#pragma mark --
/**
 *
 *  @brief  一周第一天
 *
 *  @return 一周第一天
 */
+(long long)weakFirstDay;
/**
 *
 *  @brief  一月第一天
 *
 *  @return 一月第一天
 */
+(long long)monthFirstDay;
/**
 *
 *  @brief  格式化秒成 天 时 分 秒
 *
 *  @param seconds 秒时间段
 *
 *  @return 天 时 分 秒
 */
+(NSString*)formaterTimeRangeToDHMS:(NSTimeInterval)seconds;
+(NSString*)formaterTimeRangeToHMS:(NSTimeInterval)seconds;
+(NSString *)formaterTimeRangeToMS:(NSTimeInterval)seconds;
+ (NSString *)formaterTimeRangeToMSs:(NSTimeInterval)seconds;//包含毫秒
+(NSString*)formaterTimeRangeToHM:(NSTimeInterval)minus;
/**
 *  @brief  格式化分钟成  天或时或分或秒
 *
 *  @param seconds 秒时间段
 *
 *  @return  时 分
 */
+(NSString*)formaterTimeRangeToTime:(NSTimeInterval)seconds;

/**
 *  @brief  录音
 *
 *  @param seconds <#seconds description#>
 *
 *  @return <#return value description#>
 */

/**
 时间戳计算距离当前时间

 @param lastTime 指定的时间戳

 @param beforeDays 几天前
 
 @param isMDHS
 
 @return （几天前，几小时前，几分钟前，几月几日）
 */
+ (NSString *)timeInterval:(NSTimeInterval)lastTime days:(NSInteger)beforeDays isMDHS:(BOOL)isMDHS;

/**
 时间戳计算距离当前时间
 
 @param timeStr 时间字符串
 
 @param beforeDays 几天前
 
 @param isMDHS
 
 @return （几天前，几小时前，几分钟前，几月几日 HH:ss）
 */
+ (NSString *)timeIntervalWithString:(NSString *)timeStr days:(NSInteger)beforeDays isMDHS:(BOOL)isMDHS;
#pragma mark 日期比较
/**
 是否是同一个月
 @return 是 YES
 */
+ (BOOL)isSameMonth:(NSDate *)date1 date2:(NSDate *)date2;

+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2;


#pragma mark 字符串格式的日期转为所需字符串格式 defaultZone = YES 美区时间
/*
 yyyy-MM-dd'T'HH:mm:ss.SSSZ 转为指定的格式
 */
+(NSString *)timeStrConvertFormatStr:(NSString *)str toFormat:(NSString *)format;
+(NSString *)timeStrConvertFormatStr:(NSString *)str fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat defaultZone:(BOOL)defaultZone;
/**
  yyyy-MM-dd'T'HH:mm:ss.SSSZ 计算周几
 */
+ (NSString*)weekdayFromTimeStr:(NSString *)timeStr;
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

/**
 任意格式转 yyyy-MM-dd'T'HH:mm:ss.SSSZ
 */
+(NSString *)timeStrConvertFormatStr:(NSString *)str fromFormat:(NSString *)format defaultZone:(BOOL)defaultZone;

/*
 和当前日期差
 */
+(NSTimeInterval )timeIntervalToCurrentDateWithTimeStr:(NSString *)timeStr;
+(NSTimeInterval )timeIntervalToCurrentDateWithTimeStr:(NSString *)timeStr format:(NSString *)format;
/*
 和当前时间差 返回类似几天前 几小时前
 */
+(NSString *)timeIntervalToCurrentTime:(NSString *)timeStr;
+(NSString *)timeIntervalToCurrentTime:(NSString *)timeStr format:(NSString *)format;

//计算距离当前几天
+ (int)calcDaysFromBegin:(NSString *)beginString;

/**
 @param currenTime 当前进度
 @param duration 总时长
 @return  m's"
 */
+ (NSString *)convertStringWithCurrenTime:(float)currenTime duration:(float)duration;
/**
 *  根据  "分钟:秒数" 的格式 , 例如 "06:02" 转换成为 秒数
 *
 *  @param format 格式化的时间
 *
 *  @return 秒数
 */
+ (NSTimeInterval)getTimeIntervalWithFormatTime:(NSString *)format;

/**
 yyyy-MM-dd 转成yyyy年MM月dd日
 
 @param str yyyy-MM-dd
 
 @return yyyy年MM月dd日
 */
+ (NSString *)getTimeToYearMonthDay:(NSString *)str;
/** 获取当前时间  yyyy-mm-dd HH:mm:ss */
+ (NSString *)currentTime;




@end
