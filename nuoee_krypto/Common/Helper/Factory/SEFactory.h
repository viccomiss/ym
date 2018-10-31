//
//  BaseTabBarController.m
//  SuperEducation
//
//  Created by 123 on 2017/2/20.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseLabel.h"
#import "BaseButton.h"
#import "BaseTextView.h"
#import "BaseImageView.h"
#import "BaseTextField.h"
#import "BaseTableView.h"
#import "BaseView.h"
@interface SEFactory : NSObject

/*---- UIButton -----*/
+ (BaseButton *)buttonWithImage:(UIImage *)image;
+ (BaseButton *)buttonWithTitle:(NSString *)title;

+ (BaseButton *)buttonWithImage:(UIImage *)image frame:(CGRect)frame;
+ (BaseButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame;

+ (BaseButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image frame:(CGRect)frame;

+ (BaseButton *)buttonWithImage:(UIImage *)image frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color;
+ (BaseButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color;

+ (BaseButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color;

+ (BaseButton *)MainButtonWithTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action;
/** 自适应大小Button */
+(BaseButton *)buttonAdaptiveWithTitle:(NSString *)title frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color isLeft:(BOOL)left;

/*---- BaseLabel -----*/
//单行
+ (BaseLabel *)labelWithText:(NSString *)text;
+ (BaseLabel *)labelWithText:(NSString *)text textFont:(UIFont *)font;

+ (BaseLabel *)labelWithText:(NSString *)text frame:(CGRect)frame;
+ (BaseLabel *)labelWithText:(NSString *)text frame:(CGRect)frame textFont:(UIFont *)font;
+ (BaseLabel*)labelWithFrame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color;
+ (BaseLabel *)labelWithText:(NSString *)text frame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color;
+ (BaseLabel *)labelWithText:(NSString *)text frame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment;

//加载html文本
+ (BaseLabel *)labelWithHtmlText:(NSString *)text frame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color;

//多行
+ (BaseLabel *)multilineLabelWithText:(NSString *)text frame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color;

/*---- AdaptBaseTextField -----*/
+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text;
+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame;
+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame font:(UIFont *)font;
+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame backgroudImage:(UIImage *)image;
+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color;
+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color backgroudImage:(UIImage *)image;
+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color backgroudImage:(UIImage *)image borderStyle:(UITextBorderStyle)borderStyle;

/*---- BaseTextView -----*/
+ (BaseTextView *)textViewWithText:(NSString *)text frame:(CGRect)frame;
+ (BaseTextView *)textViewWithText:(NSString *)text frame:(CGRect)frame font:(UIFont *)font;
+ (BaseTextView *)textViewWithText:(NSString *)text frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color;

//加载html的textView
+ (BaseTextView *)textViewWithHtmlString:(NSString *)hString frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color;

/*---- BaseTableView -----*/
+ (BaseTableView *)tableViewWithFrame:(CGRect)frame;
+ (BaseTableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style;

/*---- BaseImageView -----*/
+ (BaseImageView *)imageViewWithImage:(UIImage *)image;
+ (BaseImageView *)imageViewWithImage:(UIImage *)image frame:(CGRect)frame;
+ (BaseImageView *)imageViewWithImage:(UIImage *)image frame:(CGRect)frame contentMode:(UIViewContentMode)contentMode;

/*---- other -----*/
+ (BaseLabel *)createLineWithFrame:(CGRect)frame lineColor:(UIColor *)color;
+ (BaseView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;


@end
