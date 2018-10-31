//
//  UnderLineTextField.h
//  Super-Learning
//
//  Created by runlin on 2016/12/26.
//  Copyright © 2016年 SiNetWork. All rights reserved.
//

#import "BaseTextField.h"

@class UnderLineTextField;

@protocol UnderLineTextFieldDelegate <NSObject>
- (void)UnderLineTextFieldDeleteBackward:(UnderLineTextField *)textField;
@end

@interface UnderLineTextField : BaseTextField
{
    CALayer *_underline;
}


@property(assign,nonatomic) CGFloat leftPadding;
@property(assign,nonatomic) CGFloat rightPadding;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) UIColor *lineColor;
@property (nonatomic, strong) UIColor *placeholderColor;
/* cursor */
@property (nonatomic, strong) UIColor *cursorColor;
/* 限制字数 */
@property (nonatomic, assign) NSInteger limitNum;
@property (nonatomic, assign) id <UnderLineTextFieldDelegate> UnderLineDelegate;
@end
