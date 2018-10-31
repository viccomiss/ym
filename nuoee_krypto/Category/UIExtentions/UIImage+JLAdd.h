//
//  UIImage+JLAdd.h
//  HealthCloud
//
//  Created by jack on 16/3/2.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JLAdd)

//截取scrollView 生成图片
+(UIImage *)captureScreenScrollView:(UIScrollView *)scrollView;

//将view生成图片
+ (UIImage *)getImage:(UIView *)shareView size:(CGSize)size;

//截取图片某部分区域
+ (UIImage*)getSubImage:(UIImage *)image centerBool:(BOOL)centerBool WHRatio:(CGFloat)ratio;

//根据指定颜色生成指定大小的图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)launchImage;

//缩放图片
- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

//缩略图
- (UIImage *)getThumbImage;

//图片分辨率限制在给定宽高内
- (UIImage *)scaledImageBasedIPhoneSizeWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

//给定宽高内完整显示图片的frame坐标，不改变原图数据
- (CGRect)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledFillImageWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

//全屏下完整显示图片
- (UIImage *)scaledImageToFullScreen;

//给定宽高内完整显示图片的frame坐标，可能会有黑色背景填充
- (UIImage *)scaledImageToFullScreenWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

//将图片缩放后切成targetSize大小的图片
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

/*** 圆形图片*/
- (UIImage *)circleImageWithSize:(CGSize)size
;
+ (instancetype)circleImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor size:(CGSize)size;

/** 返回一个指定大小的Image */
+(UIImage *)compressWithImageData:(UIImage *)image toKb:(NSInteger)kb;
/** 返回一个指定大小的data */
+(NSData *)compressWithImage:(UIImage *)image toKb:(NSInteger)kb;
// 给定图片质量压缩jpg图片
-(NSData *)compressImage:(CGFloat)aQuality;
// 返回一个指定大小的data */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;
/***  强制图片为竖直方向*/
- (UIImage *)imageCorrectOrientation;

/** 截取图片的中间部分 */
- (UIImage *)getCropImage:(UIImage *)image;



/**
 *  @param icon         头像图片名称
 *  @param borderImage  边框的图片名称
 *  @param border       边框大小
 *
 *  @return 圆形的头像图片
 */
+ (UIImage *)imageWithIconName:(NSString *)icon borderImage:(NSString *)borderImage border:(int)border;

/**
 拉伸图片
 
 @param insets 伸缩边距
 
 @return 拉伸后图片
 */
- (UIImage *)resizableImageWithInsets:(UIEdgeInsets)insets;

/**
 图片旋转 (不改变原始图片数据)
 @param orientation 旋转方向
 
 实现上下翻转 上下镜像
 NSInteger imageOrientation = (imv.image.imageOrientation + 4) % 8;
 imageOrientation += imageOrientation%2==0 ? 1 : -1;
 
 实现左右翻转  水平镜像
 (imv.image.imageOrientation + 4) % 8
 
 顺时针旋转
 up -> right -> down -> left -> up
 
 逆时针旋转
 up -> left -> down -> right -> up
 
 @return 新图片
 */
- (UIImage *)imageRotationOrientation:(UIImageOrientation)orientation;

/**
 图片旋转 (改变原始图片数据)
 @param orientation 旋转方向
 
 方法同上
 
 @return 新图片
 */
- (UIImage *)imageInfoRotationOrientation:(UIImageOrientation)orientation;

/**
 通过url获取第一帧图片
 
 @param videoURL url
 @param time     time
 
 @return image
 */
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 压缩图片
 
 @return 压缩后的图片
 */
- (UIImage *)imageByScalingToMaxSize;

//指定宽高缩小图片
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

//抗锯齿处理
- (UIImage *)antiAlias;

@end
