
/*~!
 | @FUNC  正则表达式
 | @AUTH  Nobility
 | @DATE  2016-10-17
 | @BRIF  <#brif#>
 */

#import <Foundation/Foundation.h>

@interface NSString (Regular)

//0.1 正则验证(通用) regex 正则表达式 返回值：验证结果
- (BOOL)regular:(NSString *)regex;

//1.1 验证电话号码
- (BOOL)checkTelephoneNumber;

//1.2 验证身份证
- (BOOL)checkIDCard;
//1.2.1 验证身份证 - 全验证
- (BOOL)checkIDCardNumber;
//1.2.1 验证身份证 - 全验证 - 后补
- (BOOL)judgeIdentityStringValid:(NSString *)identityString;
//1.3 验证邮箱
- (BOOL)checkEmail;

//1.4 验证纯数字
- (BOOL)checkJustNumber;

//1.5 验证URL
- (BOOL)checkURL;

//1.6 验证只是汉字
- (BOOL)checkJustChinese;

//1.7 验证只是字母
- (BOOL)checkJustLetter;

//1.8 验证只是小写字母
- (BOOL)checkJustLowercase;

//1.9 验证只是大写字母
- (BOOL)checkCapitalLetter;

//1.10 验证包含特殊字符
- (BOOL)checkContainSpecialCharacter;




@end
