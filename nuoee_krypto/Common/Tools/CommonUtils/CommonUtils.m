//
//  Common.m
//  HealthCloud
//
//  Created by jack on 16/5/13.
//  Copyright © 2016年 luoqi. All rights reserved.
//

#import "CommonUtils.h"
#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "BaseTabBarControllerConfig.h"

@implementation CommonUtils

+ (id)filterReturnData:(NSValue *)data forType:(NetReturnDataType)type {
    switch (type) {
        case NetReturnDataTypeNumber: {
            if ([data isKindOfClass:[NSNull class]]) {
                return [NSNumber numberWithInteger:0];
            }
            if ([data isKindOfClass:[NSNumber class]]) {
                return data;
            }
            if ([data isKindOfClass:[NSString class]]) {
                return [NSNumber numberWithInteger:((NSString *) data).integerValue];
            }
            if ([data isKindOfClass:[NSDictionary class]]) {
                return [NSNumber numberWithInteger:10086];
            }
            if ([data isKindOfClass:[NSArray class]]) {
                return [NSNumber numberWithInteger:10086];
            }
        }

        case NetReturnDataTypeString: {
            if ([data isKindOfClass:[NSNull class]]) {
                return @"";
            }
            if ([data isKindOfClass:[NSNumber class]]) {
                return [NSString stringWithFormat:@"%@", data];
            }
            if ([data isKindOfClass:[NSString class]]) {
                return data;
            }
            if ([data isKindOfClass:[NSDictionary class]]) {
                return @"";
            }
            if ([data isKindOfClass:[NSArray class]]) {
                return @"";
            }
        }

        case NetReturnDataTypeArray: {
            if ([data isKindOfClass:[NSNull class]]) {
                return [NSMutableArray array];
            }
            if ([data isKindOfClass:[NSNumber class]]) {
                return [NSMutableArray array];
            }
            if ([data isKindOfClass:[NSString class]]) {
                return [NSMutableArray array];
            }
            if ([data isKindOfClass:[NSArray class]]) {
                return [NSMutableArray arrayWithArray:(NSArray *) data];
            }
            if ([data isKindOfClass:[NSDictionary class]]) {
                return [NSMutableArray array];
            }
        }
        case NetReturnDataTypeDict: {
            if ([data isKindOfClass:[NSNull class]]) {
                return [NSMutableDictionary dictionary];
            }
            if ([data isKindOfClass:[NSNumber class]]) {
                return [NSMutableDictionary dictionary];
            }
            if ([data isKindOfClass:[NSString class]]) {
                return [NSMutableDictionary dictionary];
            }
            if ([data isKindOfClass:[NSDictionary class]]) {
                return [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *) data];
            }
            if ([data isKindOfClass:[NSArray class]]) {
                return [NSMutableDictionary dictionary];
            }
        }
        default:
            return @"";
    }
}

+ (BOOL)isValidAuthCode:(NSString *)str {
    if (!NotNilAndNull(self)) {
        return NO;
    }
    
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (temp.length == 6) {
        return YES;
    }
    
    return NO;
    
}

+ (BOOL)isValidPhoneNumber:(NSString *)str{
    
    NSString *string = [self replaceWhitespaceCharacter:str];
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:string];
}


+ (NSString *)replaceWhitespaceCharacter:(NSString *)str {
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}


+ (BOOL)validatePassword:(NSString *)passwordStr{
    
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:passwordStr];
}

+ (BOOL)validateIdentityCard:(NSString *)cardStr{
    
    NSString *identityCard = [self replaceWhitespaceCharacter:cardStr];
    
    //判断位数
    if ([identityCard length] != 15 && [identityCard length] != 18) {
        return NO;
    }
    NSString *carid = identityCard;
    long lSumQT =0;
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:identityCard];
    if ([identityCard length] == 15) {
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![self areaCode:sProvince]) {
        return NO;
    }
    //判断年月日是否有效
    //年份
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    //日
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil) {
        return NO;
    }
    
    const char *PaperId  = [carid UTF8String];
    //检验长度
    if( 18 != strlen(PaperId)) return -1;
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (PaperId[17] != 'x')
    {
        if (sChecker[lSumQT%11] != PaperId[17]) {
            return NO;
        }
    }
    else {
        if (sChecker[lSumQT%11] != 'X') {
            return NO;
        }
    }
    
    return YES;
}


/**
 * 功能:判断是否在地区码内
 * 参数:地区码
 */
+ (BOOL)areaCode:(NSString *)code {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

/**
 * 功能:获取指定范围的字符串
 * 参数:字符串的开始小标
 * 参数:字符串的结束下标
 */
+ (NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger )value1 Value2:(NSInteger )value2{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}


+ (BOOL)isValidBankCardNumber:(NSString *)bankStr {
    
    NSString *bankNumber = @"^\\d{19}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", bankNumber];
    
    return [regextestmobile evaluateWithObject:bankStr];
}

+ (BOOL)isValidUrl:(NSString *)urlString {
    
    NSURL *candidateURL = [NSURL URLWithString:urlString];
    // WARNING > "test" is an URL according to RFCs, being just a path
    // so you still should check scheme and all other NSURL attributes you need
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNullOrBlankString:(NSString *)str {
    if (!NotNilAndNull(str)) {
        return NO;
    }
    
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (temp.length == 0) {
        return NO;
    }
    
    return YES;
    
}

+ (BOOL)validateNumber:(NSString *)str {
    BOOL res = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < str.length) {
        NSString *string = [str substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

/**
 *  判断对象是否为空
 *
 *  @param obj obj
 *
 *  @return 是否为空
 */
+ (BOOL)checkEmptyObj:(id)obj {
    if ([obj isEqual:[NSNull null]] || !obj) {
        return YES;
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)obj;
        return [self isEmpty:str];
    }
    
    return NO;
}

/**
 *  检查字符串是否为空
 *
 *  @return 是否为空
 */
+ (BOOL)isEmpty:(NSString *)str{
    if (!str || str == nil) {
        return YES;
    }
    
    return ([[self replaceWhitespaceCharacter:str] length] == 0);
}

/**
 *  获取应用当前的显示的视图控制器
 *
 *  @return viewController
 */
+ (UIViewController *)currentViewController{
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if([rootController isKindOfClass:[CYLTabBarController class]]){
        CYLTabBarController *tabBarController = (CYLTabBarController *)rootController;
        BaseNavigationController *selectController = tabBarController.selectedViewController;
        BaseViewController *viewController = (BaseViewController *)selectController.visibleViewController;
        while (viewController.presentedViewController) {
            viewController = (BaseViewController *)viewController.presentedViewController;
        }
        
        return viewController;
    }else if (rootController.presentedViewController) {
        if ([rootController.presentedViewController isKindOfClass:[BaseNavigationController class]]) {
            BaseNavigationController *nav = (BaseNavigationController *)rootController.presentedViewController;
            return nav.viewControllers.lastObject;
        }
        return rootController.presentedViewController;
        
    } else if ([rootController isKindOfClass:[BaseNavigationController class ]]) {
        BaseNavigationController *nav = (BaseNavigationController *)rootController;;
        BaseViewController *viewController = (BaseViewController *)nav.viewControllers.lastObject;
        return viewController;
    }
    else{
        return nil;
    }
}

////获取当前屏幕显示的viewcontroller
//+ (UIViewController *)currentViewController
//{
//    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    
//    UIViewController *currentVC = [CommonUtils getCurrentVCFrom:rootViewController];
//    
//    return currentVC;
//}
//
//+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
//{
//    UIViewController *currentVC;
//    
//    if ([rootVC presentedViewController]) {
//        // 视图是被presented出来的
//        
//        rootVC = [rootVC presentedViewController];
//    }
//    
//    if ([rootVC isKindOfClass:[UITabBarController class]]) {
//        // 根视图为UITabBarController
//        
//        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
//        
//    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
//        // 根视图为UINavigationController
//        
//        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
//        
//    } else {
//        // 根视图为非导航类
//        
//        currentVC = rootVC;
//    }
//    
//    return currentVC;
//}

/**
 *  获取截屏
 *
 *  @return 截图
 */
+ (UIImage *)getScreenShot{
    
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  在字符串的某些位置加上空格
 *
 *  @param string    string
 *  @param locations 加空格的位置（@[3，5，8]）
 *
 *  @return 加上空格的字符串
 */
+ (NSString *)stringAddedWhiteCharter:(NSString *)string atLocation:(NSArray <NSNumber *> *)locations {
    NSMutableString *newString = [NSMutableString stringWithString:string];
    for (NSInteger i = 0; i < [locations count]; i ++) {
        NSInteger location = [[locations objectAtIndex:i] integerValue];
        if (string.length > location) {
            [newString insertString:@" " atIndex:location + i];
        }
    }
    
    return newString;
}

/**
 *  计算高度
 *
 *  @param textStr  文本
 *  @param width    宽度
 *  @param fontSize 字体
 *
 *  @return 高度
 */
+ (CGFloat)hc_heightFromString:(NSString *)textStr width:(CGFloat)width fontSize:(UIFont *)fontSize {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSDictionary *dict = @{
                               NSFontAttributeName : fontSize
                               };
        CGRect frame = [textStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
        return frame.size.height;
    } else {
        //iOS7 之前的写法
        CGSize size = [textStr sizeWithFont:fontSize constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        return size.height;
    }
}
/**
 *  计算宽度
 *
 *  @param textStr  文本
 *  @param height   高度
 *  @param fontSize 字体
 *
 *  @return 宽度
 */
+ (CGFloat)hc_widthFromString:(NSString *)textStr height:(CGFloat)height fontSize:(UIFont *)fontSize {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSDictionary *dict = @{
                               NSFontAttributeName : fontSize
                               };
        CGRect frame = [textStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
        return frame.size.width;
    } else {
        //iOS7 之前的写法
        CGSize size = [textStr sizeWithFont:fontSize constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByCharWrapping];
        return size.width;
    }
}

@end
