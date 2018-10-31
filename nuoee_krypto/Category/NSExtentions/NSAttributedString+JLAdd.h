//
//  NSAttributedString+JLAdd.h
//  SuperEducation_Host
//
//  Created by 123 on 2017/4/14.
//  Copyright © 2017年 shanghailuoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (JLAdd)

//富文本高度
-(CGFloat)getHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width;

-(CGFloat)getHeightWithWidth:(CGFloat)width;
/**
 生成html

 @return html 字符串
 */
- (NSString *)attributeStrToHtml;

/**
 只有正文内容（带标签）

 @return p
 */
- (NSString *)attributeStrTobodyHtml;

/**
 HTML字符串生成属性字符串 解决不显示删除线
 @param htmlStr 含有标签的字符串
 */
+(instancetype)htmlStrToAttributeStr:(NSString *)htmlStr;

/**
 使用YYLabel  YYTextView加载
 HTML字符串生成YYAttributeStr 解决不显示删除线
 @param htmlStr 含有标签的字符串
 */
+(instancetype)htmlStrToYYAttributeStr:(NSString *)htmlStr;

/**
 属性字符串返回模型数组

 @return ArticleModel 数组
 */
-(NSArray *)attributeStrToModelArr;
@end
