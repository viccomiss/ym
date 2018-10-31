//
//  animationView.m
//  animation
//
//  Created by lee on 2016/10/18.
//  Copyright © 2016年 lee. All rights reserved.
//

#import "animationView.h"

static UIView *coverView;

@implementation animationView
{
    BOOL isend;
}
-(void)drawRect:(CGRect)rect
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius = rect.size.width / 2 - 19;
    CGFloat start = - M_PI_2 + self.timeFlag * 1.1*M_PI;
    CGFloat end = -M_PI_2 + 0.45 * 2 * M_PI  + self.timeFlag * 1.1 *M_PI-1.3333;
    
//    if (isend)
//    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:0 clockwise:YES];

//    else
    [path addArcWithCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    
    if (!self.color1) {
        self.color1 = [UIColor colorWithRed:253/255.0 green:125.0/255.0 blue:7.0/255.0 alpha:1];
    }
    [self.color1 setStroke];
    
    path.lineWidth = 3;
    
    [path stroke];

    UIBezierPath* path1 = [UIBezierPath bezierPath];
    
    CGPoint center1 = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius1 = rect.size.width / 2 - 12;
    CGFloat start1 = - M_PI_2 + self.timeFlag * 0.8*M_PI;
    CGFloat end1 = -M_PI_2 + 0.45 * 2 * M_PI  + self.timeFlag * 0.8 *M_PI-1.3333;
  //  if (isend)
  //      [path1 addArcWithCenter:center1 radius:radius1 startAngle:0 endAngle:0 clockwise:YES];
  //  else

    [path1 addArcWithCenter:center1 radius:radius1 startAngle:start1 endAngle:end1 clockwise:YES];
    if (!self.color2) {
        self.color2 = [UIColor colorWithRed:28/255.0 green:181.0/255.0 blue:224.0/255.0 alpha:1];
    }
    [self.color2 setStroke];

    path1.lineWidth = 3;
    
    [path1 stroke];
    UIBezierPath* path2 = [UIBezierPath bezierPath];
    
    
    CGPoint center2 = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius2 = rect.size.width / 2 - 5;
    CGFloat start2 = - M_PI_2 + self.timeFlag * 0.5*M_PI;
    CGFloat end2 = -M_PI_2 + 0.45 * 2 * M_PI  + self.timeFlag * 0.5 *M_PI-1.3333;
    //if (isend)
    //    [path2 addArcWithCenter:center2 radius:radius2 startAngle:0 endAngle:0 clockwise:YES];
    //else
    [path2 addArcWithCenter:center2 radius:radius2 startAngle:start2 endAngle:end2 clockwise:YES];
    if (!self.color3) {
        self.color3 = [UIColor colorWithRed:39/255.0 green:165.0/255.0 blue:97.0/255.0 alpha:1] ;
    }
    [self.color3 setStroke];
    path2.lineWidth = 3;
    
    [path2 stroke];
    
}
static animationView* tmpview ;
+(void)showInView:(UIView *)view
{
    if (tmpview) {
        [tmpview stopAnimation];
        [tmpview removeFromSuperview];
        tmpview = nil;

    }
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    animationView* aview = [[animationView  alloc]initWithFrame:CGRectMake(0, 0, 130, 130)];
    aview.center = view.center;
    aview.backgroundColor = [UIColor clearColor];
    aview.timeFlag = 0;
    aview.center = view.center;
    [view addSubview:coverView];
    [view addSubview:aview];
    [aview startAnimation];
    tmpview = aview;
}
+(void)dismiss
{
    [tmpview stopAnimation];
    [tmpview removeFromSuperview];
    tmpview = nil;
    [coverView removeFromSuperview];
    coverView = nil;
}
-(void)stopAnimation
{
    isend = YES;
    [self.timer invalidate];
    self.timer = nil;
    [self setNeedsDisplay];
}
-(void)startAnimation{
    
    isend = NO;
    [self.timer invalidate];
    self.timer = nil;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(continueAnimation) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer: self.timer forMode:NSRunLoopCommonModes];
    
    
    [self.timer fire];
    
}
#define speed 0.04f     //数值越小越慢
-(void)continueAnimation{
    self.timeFlag += speed;
    
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
