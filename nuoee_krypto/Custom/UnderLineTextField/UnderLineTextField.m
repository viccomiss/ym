//
//  UnderLineTextField.m
//  Super-Learning
//
//  Created by runlin on 2016/12/26.
//  Copyright © 2016年 SiNetWork. All rights reserved.
//

#import "UnderLineTextField.h"

@implementation UnderLineTextField
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self applyIndent];
        [self applyUnderline];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
//    [self applyIndent];
}
-(void)applyUnderline{
    _underline  =[CALayer layer];
    _underline.borderColor = self.lineColor?self.lineColor.CGColor:[UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:179/255.0].CGColor;
    _underline.frame = CGRectMake(0, self.frame.size.height-0.8, self.frame.size.width, 0.8);
    _underline.borderWidth = 0.8;
    
    [self.layer addSublayer:_underline];
    self.layer.masksToBounds = true;

    if (self.placeholderColor) {
        [self setValue:self.placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    [self setValue:self.font forKeyPath:@"_placeholderLabel.font"];
    
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}



- (void)setCursorColor:(UIColor *)cursorColor{
    _cursorColor = cursorColor;
    //光标颜色
    self.tintColor = cursorColor;
}

- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    if (self.placeholderColor) {
        [self setValue:self.placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return [super becomeFirstResponder];
}
- (void)deleteBackward {
    //！！！这里要调用super方法，要不然删不了东西
    [super deleteBackward];
    if ([self.UnderLineDelegate respondsToSelector:@selector(UnderLineTextFieldDeleteBackward:)]) {
        [self.UnderLineDelegate UnderLineTextFieldDeleteBackward:self];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self relayOut];
}
-(void)relayOut{
    if(_underline){
        [_underline removeFromSuperlayer];
    }
    [self applyUnderline];
}

-(void)applyIndent{
    if (_name) {
        UILabel *paddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _leftPadding, self.frame.size.height)];
        paddingView.font = [UIFont systemFontOfSize:15];
        paddingView.textColor = [UIColor whiteColor];
        paddingView.text = _name;
        paddingView.font = self.font;
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }else{
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _leftPadding, self.frame.size.height)];
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    if (_rightPadding>0) {
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _rightPadding, self.frame.size.height)];
        self.rightView = paddingView;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
}
-(void)prepareForInterfaceBuilder{
    [self applyIndent];
}
-(void)setLeftPadding:(CGFloat)leftPadding{
    _leftPadding =  leftPadding;
    [self applyIndent];
}
-(void)setRightPadding:(CGFloat)rightPadding{
    _rightPadding = rightPadding;
    [self applyIndent];
}
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    [self relayOut];
}
-(void)setName:(NSString *)name{
    _name = name;
    [self applyIndent];
}
- (void)setLimitNum:(NSInteger)limitNum{
    _limitNum = limitNum;

}

-(void)textFieldDidChange:(UITextField *)textField{
    
    if (self.limitNum!=0) {
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > self.limitNum)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.limitNum];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:self.limitNum];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limitNum)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}

@end
