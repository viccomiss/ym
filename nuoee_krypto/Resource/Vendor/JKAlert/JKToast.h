//
//  JKToast.h
//  JKToast
//
//  Created by Jakey on 14-10-27.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEFAULT_DISPLAY_DURATION 1.0f

@interface JKToast : NSObject {
    NSString *_text;
    UIButton *_contentView;
    CGFloat  _duration;
}

+ (void)toastWithText:(NSString *)text;
+ (void)toastWithText:(NSString *)text
            duration:(CGFloat)duration;

+ (void)toastWithText:(NSString *)text
           topOffset:(CGFloat) topOffset;

+ (void)toastWithText:(NSString *)text
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration;

+ (void)toastWithText:(NSString *) text
        bottomOffset:(CGFloat) bottomOffset;

+ (void)toastWithText:(NSString *) text
        bottomOffset:(CGFloat) bottomOffset
            duration:(CGFloat) duration;

@end
