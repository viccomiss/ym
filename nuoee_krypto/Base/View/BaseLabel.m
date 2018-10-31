//
//  BaseLabel.m
//  SuperEducation
//
//  Created by 123 on 2017/2/28.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "BaseLabel.h"

@implementation BaseLabel

//自适应宽度
- (CGSize)adaptiveWidth:(NSString *)str label:(BaseLabel *)label{
    
    //重要的是下面这部分哦！
    CGSize titleSize = [str sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:label.font.fontName size:label.font.pointSize]}];
    
    titleSize.height = 20 * SCALE_HEIGHT;
    titleSize.width += 15 * SCALE_WIDTH;
    
    return titleSize;
}
//子视图超出之后允许响应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}
@end
