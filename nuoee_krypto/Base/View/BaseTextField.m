//
//  BaseTextField.m
//  SuperEducation
//
//  Created by 123 on 2017/2/28.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

// 控制placeHolder的位置，左右缩20，但是光标位置不变

//-(CGRect)placeholderRectForBounds:(CGRect)bounds
// {
// CGRect inset = CGRectMake(bounds.origin.x+100, bounds.origin.y, bounds.size.width -10, bounds.size.height);
// return inset;
//}

//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds
{
    self.keyboardAppearance = UIKeyboardAppearanceDark;
    [self setValue:TextDarkGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    return CGRectMake(self.leftView.bounds.size.width +10, bounds.origin.y, bounds.size.width-25 - self.leftView.bounds.size.width, bounds.size.height);
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(self.leftView.bounds.size.width +10, bounds.origin.y, bounds.size.width-25 - self.leftView.bounds.size.width, bounds.size.height);
    return inset;
}


//表情符号的判断
- (BOOL)stringContainsEmoji:(NSString *)string{

    __block BOOL returnValue = NO;

    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];

    return returnValue;
}

@end
