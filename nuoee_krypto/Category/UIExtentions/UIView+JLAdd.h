//
//  UIView+JLAdd.h
//  wxer_manager
//
//  Created by JackyLiang on 2017/7/25.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (JLAdd)

- (instancetype)cornerAllCornersWithCornerRadius:(CGFloat)cornerRadius;

/**
 生成截图

 @param frame frame
 @param cutout 是否需要剪裁
 @return image
 */
- (UIImage *)screenshotWithFrame:(CGRect)frame isCutout:(BOOL)cutout;


/**
 截取view指定区域

 @param theView view
 @param r frame
 @return image
 */
- (UIImage *)cutoutImageWithFrame:(CGRect)theFrame image:(UIImage *)screenshot;

//按指定比例缩放
-(CGRect)imageCompressForWidth:(UIView *)view targetWidth:(CGFloat)defineWidth;

@end
