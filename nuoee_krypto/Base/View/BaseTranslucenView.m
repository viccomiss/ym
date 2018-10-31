//
//  BaseTranslucenView;.m
//  SuperEducation
//
//  Created by 123 on 2017/3/7.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "BaseTranslucenView.h"

@implementation BaseTranslucenView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, MAINSCREEN_HEIGHT, MAINSCREEN_HEIGHT);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        [[UIApplication sharedApplication].delegate.window addSubview:self];
    }
    return self;
}

@end
