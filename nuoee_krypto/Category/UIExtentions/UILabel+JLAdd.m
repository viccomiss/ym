//
//  UILabel+JLAdd.m
//  HCMedical
//
//  Created by jack on 7/21/16.
//  Copyright © 2016 jack All rights reserved.
//

#import "UILabel+JLAdd.h"

@implementation UILabel (JLAdd)

/**
 *  获取宽度
 *
 *  @return 宽度
 */
- (CGFloat)getExactlyWidth {
    
    CGSize size = [self getExactlyRect];
    return ceilf(size.width);;
}

/**
 *  获取高度
 *
 *  @return 高度
 */
- (CGFloat)getExactlyHeight {
    
    CGSize size = [self getExactlyRect];
    return ceilf(size.height);;
}

- (CGSize)getExactlyRect {
    return  [self getSizeInContainerSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)];
}

/**
 *  在size范围内返回label文字的size
 *
 *  @param size size范围
 *
 *  @return 文字的size
 */
- (CGSize)getSizeInContainerSize:(CGSize)size {
    
    CGRect rect;
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    if (self.attributedText) {
        rect = [self.attributedText boundingRectWithSize:size options:option context:nil];
    }
    else {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
        rect = [self.text boundingRectWithSize:size
                                  options:option
                               attributes:attributes
                                  context:nil];
    }
    
    return rect.size;
}

/**
 *  自动适配label的高度
 */
- (void)autoSetLabelHeight{
    CGFloat height = [self getExactlyHeight];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
}

/**
 *  设置label行间距(需要设置text后调用)
 *
 *  @param lineSpace 行间距
 */
- (void)changeLineSpace:(CGFloat)lineSpace {
    [self changeLineSpace:lineSpace paragraphSpacing:lineSpace];
}

/**
 *  设置label行间距和段落间距
 *
 *  @param lineSpace      行间距
 *  @param paragraphSpace 段落间距
 */
- (void)changeLineSpace:(CGFloat)lineSpace paragraphSpacing:(CGFloat)paragraphSpace{
    
    NSMutableAttributedString *attributedString = nil;
    if (self.attributedText) {
        attributedString = [self.attributedText mutableCopy];
    }
    else attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    [paragraphStyle setParagraphSpacing:paragraphSpace];//调整段落间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAINSCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
