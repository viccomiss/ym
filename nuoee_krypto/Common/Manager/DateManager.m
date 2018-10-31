//
//  DateManager.m
//
//
//  Created by Jakey on 15/7/13.
//  Copyright © 2015年 . All rights reserved.
//
#define FORMATER_YYMMDD
#import "DateManager.h"
@interface DateManager ()
@property (nonatomic, strong) NSDateFormatter *dateForrmatter;
@end
@implementation DateManager
+ (DateManager *) sharedManager
{
    static DateManager *dateManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateManager = [[self alloc] init];
    });
    return dateManager;
}
- (id)init{
    self = [super init];
    if (self) {
        _dateForrmatter = [[NSDateFormatter alloc] init];
        [_dateForrmatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
    return self;
}
#pragma mark--
/**
 *  NSDate 转换 NSString
 *
 *  @param date   待转换NSDate
 *  @param format 待转换NSDate格式 比如yyyy-MM-dd
 *
 *  @return 转换 后的NSString
 */
- (NSString *)stringConvertFromDate:(NSDate *)date format:(NSString *)format
{
    [_dateForrmatter setDateFormat:format];
    NSString *dateString = [_dateForrmatter stringFromDate:date];
    return dateString;
}
/**
 *默认时区 美国时区
 */
- (NSString *)stringConvertFromDateByDefaultZone:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
/**
 *  NSDate 转换 NSString
 *
 *  @param date   待转换NSDate
 *
 *  @return 转换 后的yyyy-MM-dd NSString
 */
+ (NSString *)stringConvert_YMD_FromDate:(NSDate *)date{
    return [[DateManager sharedManager] stringConvertFromDate:date format:@"yyyy-MM-dd"];
}
/**
 *  NSDate 转换 NSString
 *
 *  @param date   待转换NSDate
 *
 *  @return 转换 后的yyyy-MM-dd HH:mm NSString
 */
+ (NSString *)stringConvert_YMDHM_FromDate:(NSDate *)date{
    return [[DateManager sharedManager] stringConvertFromDate:date format:@"yyyy-MM-dd HH:mm"];
    
}
/**
 *  NSDate 转换 NSString
 *
 *  @param date   待转换NSDate
 *
 *  @return 转换 后的yyyy-MM-dd HH:mm:ss NSString
 */
+ (NSString *)stringConvert_YMDHMS_FromDate:(NSDate *)date{
    return [[DateManager sharedManager] stringConvertFromDate:date format:@"yyyy-MM-dd HH:mm:ss"];
    
}

/**
 *  NSDate 转换 NSString
 *
 *  @param date   待转换NSDate
 *
 *  @return 转换 后的 HH:mm NSString
 */
+ (NSString *)stringConvert_HM_FromDate:(NSDate *)date{
    return [[DateManager sharedManager] stringConvertFromDate:date format:@"HH:mm"];
    
}
+ (NSString *)timeInterval:(NSTimeInterval)lastTime days:(NSInteger)beforeDays isMDHS:(BOOL)isMDHS{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentTime=[dat timeIntervalSince1970];
//    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 时间差
    NSTimeInterval time = currentTime - lastTime / 1000;
    
    NSInteger second = time / 1;
    if (second <= 0) {
        return @"刚刚";
    }
    if (second < 60) {
        return [NSString stringWithFormat:@"%ld秒前",second];
    }
    
    //秒转分钟
    NSInteger minutes = time/60;
    if (minutes<60) {
        return [NSString stringWithFormat:@"%ld分钟前",minutes];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < beforeDays) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
//    //秒转月
//    NSInteger months = time/3600/24/30;
//    if (months < 12) {
//        return [NSString stringWithFormat:@"%ld月前",months];
//    }
//    //秒转年
//    NSInteger years = time/3600/24/30/12;
//    return [NSString stringWithFormat:@"%ld年前",years];
    NSString *date = [DateManager date_YMDHM_WithTimeIntervalSince1970:lastTime];
    if (isMDHS) {
        return [date substringFromIndex:5];
    }
    return [date substringWithRange:NSMakeRange(5, 5)];
}

+ (NSString *)timeIntervalWithString:(NSString *)timeStr days:(NSInteger)beforeDays isMDHS:(BOOL)isMDHS{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval time = [DateManager timeIntervalToCurrentDateWithTimeStr:timeStr];
    
    NSInteger second = time / 1;
    if (second <= 0) {
        return @"刚刚";
    }
    
    if (second < 60) {
        return [NSString stringWithFormat:@"%ld秒前",second];
    }
    
    //秒转分钟
    NSInteger minutes = time/60;
    if (minutes<60) {
        return [NSString stringWithFormat:@"%ld分钟前",minutes];
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 3) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //    //秒转月
    //    NSInteger months = time/3600/24/30;
    //    if (months < 12) {
    //        return [NSString stringWithFormat:@"%ld月前",months];
    //    }
    //    //秒转年
    //    NSInteger years = time/3600/24/30/12;
    //    return [NSString stringWithFormat:@"%ld年前",years];
    NSString *date = [DateManager timeStrConvertFormatStr:timeStr toFormat:@"yyyy-MM-dd HH:ss"];
    if (isMDHS) {
        return [date substringFromIndex:5]; //MM-dd
    }
    return [date substringWithRange:NSMakeRange(5, 5)]; //MM-dd HH:mm

}

#pragma mark-- string to formater data

/**
 *  NSString 转换 NSDate
 *
 *  @param string 待转换NSString
 *  @param format 待转换NSDate格式 比如yyyy-MM-dd
 *
 *  @return 转换 后的NSDate
 */
- (NSDate *)dateConvertFromString:(NSString *)string format:(NSString *)format
{
    [_dateForrmatter setDateFormat:format];
    NSDate *date = [_dateForrmatter dateFromString:string];
    return date;
}
/**
 *默认时区 美国时区
 */
- (NSDate *)dateConvertFromStringByDefaultZone:(NSString *)string format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    return date;
}
/**
 *  NSString 转换 NSDate
 *
 *  @param string 待转换yyyy-MM-dd NSString
 *
 *  @return 转换 后的NSDate
 */
+ (NSDate *)dateConvertFrom_YMD_String:(NSString *)string{
    return [[DateManager sharedManager] dateConvertFromString:string format:@"yyyy-MM-dd"];
}
/**
 *  NSString 转换 NSDate
 *
 *  @param string 待转换yyyy-MM-dd HH:mm NSString
 *
 *  @return 转换 后的NSDate
 */
+ (NSDate *)dateConvertFrom_YMDHM_String:(NSString *)string{
    return [[DateManager sharedManager] dateConvertFromString:string format:@"yyyy-MM-dd HH:mm"];
}
/**
 *  NSString 转换 NSDate
 *
 *  @param string 待转换yyyy-MM-dd HH:mm:ss NSString
 *
 *  @return 转换 后的NSDate
 */
+ (NSDate *)dateConvertFrom_YMDHMS_String:(NSString *)string{
    return [[DateManager sharedManager] dateConvertFromString:string format:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark-- timeStamp to string date
/**
 *  时间戳根据格式转字符串
 *
 *  @param secs   秒数
 *  @param format 格式
 *
 *  @return 格式后时间字符串
 */
+ (NSString *)dateWithTimeIntervalSince1970:(NSTimeInterval)secs format:(NSString *)format
{
    if (secs==0) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs/1000];
    return [[DateManager sharedManager] stringConvertFromDate:date format:format];
}
/**
 *  时间戳根据格式转字符串
 *
 *  @param secs   秒数
 *
 *  @return 格式后时间yyyy-MM-dd字符串
 */
+ (NSString *)date_YMD_WithTimeIntervalSince1970:(NSTimeInterval)secs{
    return [DateManager dateWithTimeIntervalSince1970:secs format:@"yyyy-MM-dd"];
}
/**
 *  时间戳根据格式转字符串
 *
 *  @param secs   秒数
 *
 *  @return 格式后时间HH:mm:ss字符串
 */
+ (NSString *)date_HMS_WithTimeIntervalSince1970:(NSTimeInterval)secs{
    return [DateManager dateWithTimeIntervalSince1970:secs format:@"HH:mm:ss"];
}
/**
 *  时间戳根据格式转字符串
 *
 *  @param secsString   秒数字符串
 *
 *  @return 格式后时间yyyy-MM-dd字符串
 */
+ (NSString *)date_YMD_WithTimeIntervalStringSince1970:(NSString*)secsString{
    return [DateManager dateWithTimeIntervalSince1970:[secsString longLongValue] format:@"yyyy-MM-dd"];
}
+ (NSString *)date_YMD2_WithTimeIntervalStringSince1970:(NSString*)secsString{
    return [DateManager dateWithTimeIntervalSince1970:[secsString longLongValue] format:@"yyyy.MM.dd"];
}
+ (NSString *)date_YMD3_WithTimeIntervalStringSince1970:(NSString*)secsString{
    return [DateManager dateWithTimeIntervalSince1970:[secsString longLongValue] format:@"yyyy-MM-dd HH:mm:ss"];
}
/**
 *  时间戳根据格式转字符串
 *
 *  @param secs   秒数
 *
 *  @return 格式后时间yyyy-MM-dd HH:mm字符串
 */
+ (NSString *)date_YMDHM_WithTimeIntervalSince1970:(NSTimeInterval)secs{
    return [DateManager dateWithTimeIntervalSince1970:secs format:@"yyyy-MM-dd HH:mm"];
}
/**
 *  时间戳根据格式转字符串
 *
 *  @param secs   秒数
 *
 *  @return 格式后时间yyyy-MM-dd HH:mm:ss字符串
 */
+ (NSString *)date_YMDHMS_WithTimeIntervalSince1970:(NSTimeInterval)secs{
    return [DateManager dateWithTimeIntervalSince1970:secs format:@"yyyy-MM-dd HH:mm:ss"];
}


#pragma mark-- timeStamp
/**
 *  时间转时间戳long long
 *
 *  @param date NSDate 时间
 *
 *  @return 时间戳long long
 */
+(long long)timeIntervalWithDate:(NSDate*)date
{
    long long interval = 0;
    if (date == nil)
    {
        return interval;
    }
    
    NSTimeInterval tmp = [date timeIntervalSince1970];
    interval = [[NSNumber numberWithDouble:tmp] longLongValue];
    
    //changge to million second
    return interval * 1000;
}
/**
 *  时间戳转NSDate
 *
 *  @param interval 时间戳
 *
 *  @return 时间NSDate
 */
+ (NSDate*)dateWithTimeStamp:(long long)interval
{
    if (interval != 0) {
        return [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)interval/1000];
    } else {
        return 0;
    }
}
/**
 *  时间转时间戳long long
 *
 *  @param date NSDate 时间
 *
 *  @return 时间戳long long
 */
+(NSString *)timeStampStringWithDate:(NSDate*)date{
    long long  tmp = [self timeIntervalWithDate:date];
    return [[NSNumber numberWithLongLong:tmp] stringValue];
}
/**
 *  当前时间时间戳字符串
 *
 *  @return 当前时间时间戳字符串
 */
+(NSString *)nowTimeStampString{
    return  [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] stringValue];
}
/**
 *  当前时间时间YMD字符串
 *
 *  @return 当前时间ymd字符串
 */
+(NSString*)nowYMDString{
    return [[DateManager sharedManager] stringConvertFromDate:[NSDate date] format:@"yyyy-MM-dd"];
}
+(NSString*)nowYMDDefaultZoneString{
    return [[DateManager sharedManager] stringConvertFromDateByDefaultZone:[NSDate date] format:@"yyyy-MM-dd"];
}
/**
 *  当前时间时间YMDHmS字符串
 *
 *  @return 当前时间YMDHmS字符串
 */
+(NSString*)nowYMDHMSString{
    return [[DateManager sharedManager] stringConvertFromDate:[NSDate date] format:@"yyyyMMddHHmmss"];
}

#pragma mark--
/**
 *  @author Jakey, 15-10-10 16:10:40
 *
 *  @brief  一周第一天
 *
 *  @return 一周第一天
 */
+(long long)weakFirstDay{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff;
    __unused long lastDiff;
    if (weekDay == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    return [DateManager timeIntervalWithDate:firstDayOfWeek];
}
/**
 *  @author Jakey, 15-10-10 16:10:52
 *
 *  @brief  一月第一天
 *
 *  @return 一月第一天
 */
+(long long)monthFirstDay{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSCalendarUnitYear | NSCalendarUnitMonth
                               fromDate:now];
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    return [DateManager timeIntervalWithDate:firstDay];
}
/**

 *  @brief  格式化秒成 天 时 分 秒
 *
 *  @param seconds 秒时间段
 *
 *  @return 天 时 分 秒
 */
+(NSString*)formaterTimeRangeToDHMS:(NSTimeInterval)seconds{
    NSInteger day = seconds/86400;
    NSInteger hour = (seconds-(day*86400))/3600;
    NSInteger minus = (seconds-(day*86400)-(hour*3600))/60;
    NSInteger second = (seconds-(day*86400)-(hour*3600)-minus*60);
    
    return [NSString stringWithFormat:@"%zd天%zd时%zd分%zd秒", day,hour,minus,second];
}
+(NSString*)formaterTimeRangeToHMS:(NSTimeInterval)seconds{
    if (seconds<0) {
        seconds = 0;
    }
    NSInteger s = (int)seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;
    return [NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld", (long)h,(long)m,(long)s];
}
+ (NSString *)formaterTimeRangeToMS:(NSTimeInterval)seconds
{
    if (seconds<0) {
        seconds = 0;
    }
    NSInteger s = (int)seconds;
    NSInteger m = s / 60;
    // 返回计算后的数值
    return [NSString stringWithFormat:@"%02zd:%02zd",m,s];
}

+ (NSString *)formaterTimeRangeToMSs:(NSTimeInterval)seconds
{
    NSInteger time2 = seconds * 100;
    NSInteger timeMin = time2 / 6000;
    NSInteger timeSe = time2 % 6000;
    
    NSString *timeString;
    NSString *seconseStr;
    
    CGFloat seconse = timeSe / 100.00;
    if (seconse < 10) {
        seconseStr = [NSString stringWithFormat:@"0%.2lf",seconse];
    }else{
        seconseStr = [NSString stringWithFormat:@"%.2lf",seconse];
    }
    if (timeMin == 0) {
        timeString = [NSString stringWithFormat:@"00:%@",seconseStr];
    }else{
        timeString = [NSString stringWithFormat:@"%.2ld:%@",timeMin,seconseStr];
    }
    return timeString;
}
+(NSString*)formaterTimeRangeToHM:(NSTimeInterval)minus{
    if (minus<=0) {
        return @"0:0";
    }
    NSInteger hour = minus/60;
    NSInteger minusLeft = (minus-(hour*60));
    return [NSString stringWithFormat:@"%zd:%zd", hour,minusLeft];
}


+(NSString*)formaterTimeRangeToTime:(NSTimeInterval)seconds{
    NSInteger day = seconds/86400;
    NSInteger hour = (seconds-(day*86400))/3600;
    NSInteger minus = (seconds-(day*86400)-(hour*3600))/60;
    NSInteger second = (seconds-(day*86400)-(hour*3600)-minus*60);
    if (day == 0) {
        if (hour == 0) {
            if (minus == 0) {
                return [NSString stringWithFormat:@"%zd秒",second];
            }
            return [NSString stringWithFormat:@"%zd分",minus];
        }
        return [NSString stringWithFormat:@"%zd时",hour];
    }
    return [NSString stringWithFormat:@"%zd天",day];
}

#pragma mark 日期比较
+ (BOOL)isSameMonth:(NSDate *)date1 date2:(NSDate *)date2{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag =  NSCalendarUnitMonth;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 month] == [comp2 month]));
}
+ (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

#pragma mark 字符串格式的日期转为所需字符串格式

+(NSString *)timeStrConvertFormatStr:(NSString *)str toFormat:(NSString *)format{
    return [self timeStrConvertFormatStr:str fromFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" toFormat:format defaultZone:NO];
}

+(NSString *)timeStrConvertFormatStr:(NSString *)str fromFormat:(NSString *)format defaultZone:(BOOL)defaultZone{
    return [self timeStrConvertFormatStr:str fromFormat:format toFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" defaultZone:defaultZone];
}

+(NSString *)timeStrConvertFormatStr:(NSString *)str fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat defaultZone:(BOOL)defaultZone{
    if (defaultZone) {
        NSDate *date = [[DateManager sharedManager]dateConvertFromStringByDefaultZone:str format:fromFormat];
        return [[DateManager sharedManager]stringConvertFromDateByDefaultZone:date format:toFormat];
    }
    NSDate *date = [[DateManager sharedManager]dateConvertFromString:str format:fromFormat];
    return [[DateManager sharedManager] stringConvertFromDate:date format:toFormat];
}

/*
 和当前日期差
 */
+(NSString *)timeIntervalToCurrentTime:(NSString *)timeStr{
    return  [self timeIntervalToCurrentTime:timeStr format:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
}

+(NSString *)timeIntervalToCurrentTime:(NSString *)timeStr format:(NSString *)format{
    NSTimeInterval interval =  [self timeIntervalToCurrentDateWithTimeStr:timeStr format:format];
    if (interval/(24*60*60) >= 1) {//几天前
        return [NSString stringWithFormat:@"%d天前",(int)interval/(24*60*60)];
    }else if(interval/(60*60) >= 1){//几小时
        return  [NSString stringWithFormat:@"%d小时前",(int)interval/(60*60)];
    }else if (interval/(60) >= 1){//几分钟前
        return  [NSString stringWithFormat:@"%d分钟前",(int)interval/(60)];
    }else{
        return @"刚刚";
    }
}

+ (NSString*)weekdayFromTimeStr:(NSString *)timeStr{
    NSDate *date = [[DateManager sharedManager] dateConvertFromString:timeStr format:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    return [self weekdayStringFromDate:date];
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六",nil];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitWeekday fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+(NSTimeInterval )timeIntervalToCurrentDateWithTimeStr:(NSString *)timeStr{
    return [self timeIntervalToCurrentDateWithTimeStr:timeStr format:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
}

+(NSTimeInterval )timeIntervalToCurrentDateWithTimeStr:(NSString *)timeStr format:(NSString *)format{
    NSString *currentTime = [self nowYMDHMSString];
    NSDate *current = [[DateManager sharedManager]dateConvertFromString:currentTime format:@"yyyyMMddHHmmss"];
    NSDate *expire = [[DateManager sharedManager]dateConvertFromString:timeStr format:format];
    //有效时间和当前时间差
    NSTimeInterval inteval = [current timeIntervalSinceDate:expire];
    return inteval;
}

+ (int)calcDaysFromBegin:(NSString *)beginString
{
    //创建日期格式化对象
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time= [DateManager timeIntervalToCurrentDateWithTimeStr:beginString];
    
    int days=((int)time)/(3600*24);
    //int hours=((int)time)%(3600*24)/3600;
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return days;
}

+ (NSTimeInterval)getTimeIntervalWithFormatTime:(NSString *)format
{
    // 分解分钟和秒数
    NSArray *minAsec = [format componentsSeparatedByString:@":"];
    // 获取分钟
    NSString *min = [minAsec firstObject];
    // 获取秒数
    NSString *sec = [minAsec lastObject];
    
    // 计算, 并返回值
    return min.intValue * 60 + sec.floatValue;
}
+ (NSString *)convertStringWithCurrenTime:(float)currenTime duration:(float)duration {
    float time = duration - currenTime;
    int min = time / 60.0;
    int sec = time - min * 60;
    //    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    //    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = min==0?[NSString stringWithFormat:@"%d\"",sec]:[NSString stringWithFormat:@"%d\'%d\"",min,sec];
    return timeStr;
}
+ (NSString *)getTimeToYearMonthDay:(NSString *)str{
    
    NSString *year = [str substringToIndex:4];
    NSString *month;
    NSString *day;
    if ([[str substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"0"]) {
        month = [str substringWithRange:NSMakeRange(6, 1)];
    }else{
        month = [str substringWithRange:NSMakeRange(5, 2)];
    }
    if ([[str substringWithRange:NSMakeRange(8, 1)] isEqualToString:@"0"]) {
        day = [str substringWithRange:NSMakeRange(9, 1)];
    }else{
        day = [str substringWithRange:NSMakeRange(8, 2)];
    }
    
    return [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
}

/** 获取当前时间 */
+ (NSString *)currentTime
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *time = [formate stringFromDate:currentDate];
    return time;
}

@end
