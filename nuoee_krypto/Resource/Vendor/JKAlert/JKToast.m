//
//  JKToast.m
//  JKToast
//
//  Created by Jakey on 14-10-27.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "JKToast.h"
#import <QuartzCore/QuartzCore.h>
@implementation JKToast


- (id)initWithText:(NSString *)text{
    if (self = [super init]) {
        
        _text = [text copy];
        
        UIFont *font = [UIFont boldSystemFontOfSize:14];
         CGSize textSize = [_text boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
        
      
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 12, textSize.height + 12)];
        
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = _text;
        textLabel.numberOfLines = 0;
        
        _contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.layer.borderWidth = 1.0f;
        _contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        _contentView.backgroundColor = [UIColor colorWithRed:0.2f
                                                      green:0.2f
                                                       blue:0.2f
                                                      alpha:0.75f];
        [_contentView addSubview:textLabel];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_contentView addTarget:self
                        action:@selector(toastTaped:)
              forControlEvents:UIControlEventTouchDown];
        _contentView.alpha = 0.0f;
        
        _duration = DEFAULT_DISPLAY_DURATION;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(deviceOrientationDidChanged:)
//                                                     name:UIDeviceOrientationDidChangeNotification
//                                                   object:[UIDevice currentDevice]];
    }
    return self;
}

- (void)deviceOrientationDidChanged:(NSNotification *)notify{
    UIDevice* device = [notify valueForKey:@"object"];
    NSLog(@"%zd",device.orientation);
    //[self hideAnimation];
}

-(void)dismissToast{
    [_contentView removeFromSuperview];
}

-(void)toastTaped:(UIButton *)sender{
    [self hideAnimation];
}

- (void)setDuration:(CGFloat) duration{
    _duration = duration;
}

-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    _contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

-(void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    _contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = window.center;
    [window  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}

- (void)showFromTopOffset:(CGFloat)top{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = CGPointMake(window.center.x, top + _contentView.frame.size.height/2);
    [window  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}

- (void)showFromBottomOffset:(CGFloat) bottom{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = CGPointMake(window.center.x, window.frame.size.height-(bottom + _contentView.frame.size.height/2));
    [window  addSubview:_contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:_duration];
}


+ (void)toastWithText:(NSString *)text{
    [JKToast toastWithText:text  bottomOffset:80 duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)toastWithText:(NSString *)text
            duration:(CGFloat)duration{
    JKToast *toast = [[JKToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast show];
}

+ (void)toastWithText:(NSString *)text
           topOffset:(CGFloat)topOffset{
    [JKToast toastWithText:text  topOffset:topOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)toastWithText:(NSString *)text
           topOffset:(CGFloat)topOffset
            duration:(CGFloat)duration{
    JKToast *toast = [[JKToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showFromTopOffset:topOffset];
}

+ (void)toastWithText:(NSString *)text
        bottomOffset:(CGFloat)bottomOffset{
    [JKToast toastWithText:text  bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)toastWithText:(NSString *)text
        bottomOffset:(CGFloat)bottomOffset
            duration:(CGFloat)duration{
    JKToast *toast = [[JKToast alloc] initWithText:text] ;
    [toast setDuration:duration];
    [toast showFromBottomOffset:bottomOffset];
}

@end
