//
//  BaseTabBarController.m
//  SuperEducation
//
//  Created by 123 on 2017/2/20.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "SEFactory.h"
#import "UILabel+JLAdd.h"

@implementation SEFactory

#pragma mark - Button

+ (BaseButton *)buttonWithImage:(UIImage *)image {
    return [self buttonWithImage:image frame:CGRectZero];
}

+ (BaseButton *)buttonWithTitle:(NSString *)title {
    return [self buttonWithTitle:title frame:CGRectZero];
}

+ (BaseButton *)buttonWithImage:(UIImage *)image frame:(CGRect)frame {
    return [self buttonWithTitle:@"" image:image frame:frame];
}

+ (BaseButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame {
    return [self buttonWithTitle:title image:[[UIImage alloc] init] frame:frame];
}

+ (BaseButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image frame:(CGRect)frame {
    return [self buttonWithTitle:title image:image frame:frame font:Font(14) fontColor:[UIColor blackColor]];
}

+ (BaseButton *)buttonWithImage:(UIImage *)image frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color {
    return [self buttonWithTitle:@"" image:image frame:frame font:font fontColor:color];
}

+ (BaseButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color {
    return [self buttonWithTitle:title image:[[UIImage alloc] init] frame:frame font:font fontColor:color];
}

+ (BaseButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color {
    BaseButton *button = [BaseButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = font;
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    return button;
}

+ (BaseButton *)MainButtonWithTitle:(NSString *)title frame:(CGRect)frame target:(id)target action:(SEL)action {
    BaseButton *button = [self buttonWithTitle:title frame:frame font:Font(15) fontColor:[UIColor whiteColor]];
    button.titleLabel.font = Font(14);
    button.backgroundColor = MainYellowColor;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
/** 自适应按钮 */
+(BaseButton *)buttonAdaptiveWithTitle:(NSString *)title frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color isLeft:(BOOL)left
{
    BaseButton *button = [self buttonWithTitle:title frame:frame font:font fontColor:color];
    CGSize size = [button adaptiveWidth:title];
    if (left)
    {
        button.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
    }else
    {
        button.frame = CGRectMake(frame.origin.x - size.width, frame.origin.y, size.width, size.height);
    }
    
    return button;
}

#pragma mark - Label
#pragma mark 单行

+ (BaseLabel *)labelWithText:(NSString *)text {
    return [self labelWithText:text frame:CGRectZero];
}
+ (BaseLabel *)labelWithText:(NSString *)text textFont:(UIFont *)font{
    return [self labelWithText:text frame:CGRectZero textFont:font];
}
+ (BaseLabel *)labelWithText:(NSString *)text frame:(CGRect)frame {
    return [self labelWithText:text frame:frame textFont:Font(14)];
}

+ (BaseLabel *)labelWithText:(NSString *)text frame:(CGRect)frame textFont:(UIFont *)font {
    return [self labelWithText:text frame:frame textFont:font textColor:[UIColor lightTextColor]];
}

+ (BaseLabel *)labelWithFrame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color {
    return [self labelWithText:@"" frame:frame textFont:font textColor:color];
}

+ (BaseLabel *)labelWithText:(NSString *)text frame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color {
    return [self labelWithText:text frame:frame textFont:font textColor:color textAlignment:NSTextAlignmentLeft];
}

+ (BaseLabel *)labelWithText:(NSString *)text frame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment {
    BaseLabel *titleLabel = [[BaseLabel alloc] initWithFrame:frame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = font;
    titleLabel.textColor = color;
    titleLabel.text = text;
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = textAlignment;
    //设置文字过长时的显示格式,截去尾部...
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    return titleLabel;
}

+ (BaseLabel *)labelWithHtmlText:(NSString *)text frame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color {
    BaseLabel *titleLabel = [[BaseLabel alloc] initWithFrame:frame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3*SCALE_HEIGHT];//调整行间距
    [paragraphStyle setParagraphSpacing:6*SCALE_HEIGHT];//调整段落间距
    
    [attributedString addAttributes:@{NSFontAttributeName : font,
                                      NSForegroundColorAttributeName : color,
                                      NSParagraphStyleAttributeName : paragraphStyle
                                      } range:NSMakeRange(0, attributedString.length)];
    
    titleLabel.attributedText = attributedString;
    
    return titleLabel;
}

#pragma mark 多行

+ (BaseLabel *)multilineLabelWithText:(NSString *)text frame:(CGRect)frame textFont:(UIFont *)font textColor:(UIColor *)color {
    BaseLabel *titleLabel = [[BaseLabel alloc] initWithFrame:frame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = font;
    titleLabel.textColor = color;
    titleLabel.text = text;
    titleLabel.numberOfLines = 0;
   // titleLabel.preferredMaxLayoutWidth = frame.size.width - kViewPadding;
    [titleLabel changeLineSpace:SCALE_HEIGHT*3];
    CGRect rect = titleLabel.frame;
    rect.size.height = [titleLabel getExactlyHeight];
    titleLabel.frame = rect;
    
    return titleLabel;
}

#pragma mark - TextField
#pragma mark 默认没有边框

+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text {
    return [self textFieldWithPlaceholder:text frame:CGRectZero];
}

+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame {
    return [self textFieldWithPlaceholder:text frame:frame font:Font(14)];
}

+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame font:(UIFont *)font {
    return [self textFieldWithPlaceholder:text frame:frame font:font fontColor:[UIColor darkTextColor]];
}

+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame backgroudImage:(UIImage *)image {
    return [self textFieldWithPlaceholder:text frame:frame font:Font(14) fontColor:[UIColor darkTextColor] backgroudImage:image];
}

+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color {
    return [self textFieldWithPlaceholder:text frame:frame font:font fontColor:color backgroudImage:nil];
}

+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color backgroudImage:(UIImage *)image {
    return [self textFieldWithPlaceholder:text frame:frame font:font fontColor:color backgroudImage:image borderStyle:UITextBorderStyleNone];
}

+ (BaseTextField *)textFieldWithPlaceholder:(NSString *)text frame:(CGRect)frame font:(UIFont *)font fontColor:(UIColor *)color backgroudImage:(UIImage *)image borderStyle:(UITextBorderStyle)borderStyle {
    BaseTextField *textField = [[BaseTextField alloc] initWithFrame:frame];
    textField.placeholder = text;
    textField.font = font;
    textField.textColor = color;
    [textField setBackground:[image stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    
    textField.backgroundColor = [UIColor clearColor];
    textField.borderStyle = borderStyle;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyNext;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    return textField;
}

#pragma mark - TextView

+ (BaseTextView *)textViewWithText:(NSString *)text frame:(CGRect)frame {
    return [self textViewWithText:text frame:frame font:Font(14)];
}

+ (BaseTextView *)textViewWithText:(NSString *)text frame:(CGRect)frame font:(UIFont *)font {
    return [self textViewWithText:text frame:frame font:font textColor:[UIColor lightTextColor]];
}

+ (BaseTextView *)textViewWithText:(NSString *)text frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color {
    BaseTextView *textView = [[BaseTextView alloc] initWithFrame:frame];
    textView.text = text;
    textView.font = font;
    textView.textColor = color;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.editable = YES;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    
    return textView;
}

+ (BaseTextView *)textViewWithHtmlString:(NSString *)hString frame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color {
    BaseTextView *textView = [[BaseTextView alloc] initWithFrame:frame];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.selectable = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[hString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:SCALE_HEIGHT *3];//调整行间距
    [paragraphStyle setParagraphSpacing:SCALE_HEIGHT *6];//调整段落间距
    
    [attributedString addAttributes:@{NSFontAttributeName : font,
                                      NSForegroundColorAttributeName : color,
                                      NSParagraphStyleAttributeName : paragraphStyle
                                      } range:NSMakeRange(0, attributedString.length)];
    
    textView.attributedText = attributedString;
    
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height <= frame.size.height) {
        textView.scrollEnabled = NO;
    }

    return textView;
}

#pragma mark - TableView

+ (BaseTableView *)tableViewWithFrame:(CGRect)frame {
    return [self tableViewWithFrame:frame style:UITableViewStylePlain];
}

+ (BaseTableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    BaseTableView *tableView = [[BaseTableView alloc] initWithFrame:frame style:style];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexColor = [UIColor clearColor];
    
    return tableView;
}

#pragma mark - UIImageView

+ (BaseImageView *)imageViewWithImage:(UIImage *)image {
    return [self imageViewWithImage:image frame:CGRectZero];
}

+ (BaseImageView *)imageViewWithImage:(UIImage *)image frame:(CGRect)frame {
    return [self imageViewWithImage:image frame:frame contentMode:UIViewContentModeScaleToFill];
}

+ (BaseImageView *)imageViewWithImage:(UIImage *)image frame:(CGRect)frame contentMode:(UIViewContentMode)contentMode {
    BaseImageView *imageView = [[BaseImageView alloc] initWithFrame:frame];
    imageView.image = image;
    imageView.contentMode = contentMode;
    
    return imageView;
}

#pragma mark - line

+ (BaseLabel *)createLineWithFrame:(CGRect)frame lineColor:(UIColor *)color; {
    BaseLabel *tbSep = [self labelWithText:@""];
    tbSep.backgroundColor = color;
    tbSep.frame = frame;
    
    return tbSep;
}

+ (BaseView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color {
    BaseView *view = [[BaseView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    
    return view;
}

@end
