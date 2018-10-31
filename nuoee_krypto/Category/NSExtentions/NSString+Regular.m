

#import "NSString+Regular.h"

@implementation NSString (Regular)

//1.0 正则验证(通用) regex 正则表达式 返回值：验证结果
- (BOOL)regular:(NSString *)regex {
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}

//1.1 验证电话号码
- (BOOL)checkTelephoneNumber {
    NSString *regex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}

//1.2 验证身份证
- (BOOL)checkIDCard {
    NSString *regex = @"\\d{15}(\\d\\d[0-9xX])?";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}
- (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)checkIDCardNumber
{
        NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         if ([str length] != 18) {
                 return NO;
             }
         NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
         NSString *leapMmdd = @"0229";
         NSString *year = @"(19|20)[0-9]{2}";
         NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
         NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
         NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
         NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
         NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
         NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
         NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (![regexTest evaluateWithObject:self]) {
                 return NO;
             }
         int summary = ([self substringWithRange:NSMakeRange(0,1)].intValue + [self substringWithRange:NSMakeRange(10,1)].intValue) *7
                 + ([self substringWithRange:NSMakeRange(1,1)].intValue + [self substringWithRange:NSMakeRange(11,1)].intValue) *9
                 + ([self substringWithRange:NSMakeRange(2,1)].intValue + [self substringWithRange:NSMakeRange(12,1)].intValue) *10
                 + ([self substringWithRange:NSMakeRange(3,1)].intValue + [self substringWithRange:NSMakeRange(13,1)].intValue) *5
                 + ([self substringWithRange:NSMakeRange(4,1)].intValue + [self substringWithRange:NSMakeRange(14,1)].intValue) *8
                 + ([self substringWithRange:NSMakeRange(5,1)].intValue + [self substringWithRange:NSMakeRange(15,1)].intValue) *4
                 + ([self substringWithRange:NSMakeRange(6,1)].intValue + [self substringWithRange:NSMakeRange(16,1)].intValue) *2
                 + [self substringWithRange:NSMakeRange(7,1)].intValue *1 + [self substringWithRange:NSMakeRange(8,1)].intValue *6
                 + [self substringWithRange:NSMakeRange(9,1)].intValue *3;
         NSInteger remainder = summary % 11;
         NSString *checkBit = @"";
         NSString *checkString = @"10X98765432";
         checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
        return [checkBit isEqualToString:[[self substringWithRange:NSMakeRange(17,1)] uppercaseString]];
 }

//1.3 验证邮箱
- (BOOL)checkEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}

//1.4 验证纯数字
- (BOOL)checkJustNumber {
    NSString *regex = @"^[0-9]+$";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}

//1.5 验证URL
- (BOOL)checkURL {
    NSString *regex = @"^http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}

//1.6 验证只是汉字
- (BOOL)checkJustChinese {
    NSString *regex = @"^[\u4e00-\u9fa5]+$";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}

//1.7 验证只是字母
- (BOOL)checkJustLetter {
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}

//1.8 验证只是小写字母
- (BOOL)checkJustLowercase {
    NSString *regex = @"^[a-z]+$";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}

//1.9 验证只是大写字母
- (BOOL)checkCapitalLetter {
    NSString *regex = @"^[A-Z]+$";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}

//1.10 验证包含特殊字符
- (BOOL)checkContainSpecialCharacter {
    NSString *regex = @"[~`!@#$%^&*':;\"\?=/<>,\\.\\{\\}\\[\\]\\(\\)]+";
    NSPredicate *predicateRe = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    return [predicateRe evaluateWithObject:self];
}




@end
