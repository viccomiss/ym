//
//  MaskVIew.m
//  SuperEducation
//
//  Created by wangcl on 2017/6/9.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "MaskView.h"

@interface MaskView()

/** <#annote#> */
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation MaskView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityView.center = self.center;
        [self addSubview:self.activityView];
    }
    return self;
}
/** 显示遮罩层 */
-(void)showMask
{
    [self.activityView startAnimating];
}
-(void)hiddenMask
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.activityView stopAnimating];
        [self removeFromSuperview];
    }];
}
@end
