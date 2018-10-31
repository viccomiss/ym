//
//  UIImage+JLAdd.m
//  HealthCloud
//
//  Created by jack on 16/3/2.
//  Copyright © 2016年 jack. All rights reserved.
//

#import "UIImage+JLAdd.h"
#import <objc/runtime.h>

#define ORIGINAL_MAX_WIDTH 640 * SCALE_WIDTH

@implementation UIImage (JLAdd)

+(UIImage *)captureScreenScrollView:(UIScrollView *)scrollView {
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    
    scrollView.frame = CGRectMake(0, scrollView.frame.origin.y, scrollView.contentSize.width, scrollView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, 0.0); //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)getSubImage:(UIImage *)image centerBool:(BOOL)centerBool WHRatio:(CGFloat)ratio{
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    float imgWidth = image.size.width;
    float imgHeight = image.size.height;
    float viewWidth = MIN(image.size.width, image.size.height);
    float viewHidth = MIN(image.size.width, image.size.height) / ratio;
    CGRect rect;
    if(centerBool){
        rect = CGRectMake((imgWidth-viewWidth)/2,(imgHeight-viewHidth)/2,viewWidth,viewHidth);
    }else{
        if(viewHidth < viewWidth){
            if(imgWidth <= imgHeight){
                rect = CGRectMake(0, 0, imgWidth, imgWidth*imgHeight/viewWidth);
            }else{
                float width = viewWidth*imgHeight/viewHidth;
                float x = (imgWidth - width)/2;
                if(x > 0){
                    rect = CGRectMake(x, 0, width, imgHeight);
                }else{
                    rect = CGRectMake(0, 0, imgWidth, imgWidth*viewHidth/viewWidth);
                }
            }
        }else{
            if(imgWidth <= imgHeight){
                float height = viewHidth*imgWidth/viewWidth;
                if(height < imgHeight){
                    rect = CGRectMake(0,0, imgWidth, height);
                }else{
                    rect = CGRectMake(0,0, viewWidth*imgHeight/viewHidth,imgHeight);
                }
            }else{
                float width = viewWidth * imgHeight / viewHidth;
                if(width < imgWidth){
                    float x = (imgWidth - width)/2;
                    rect = CGRectMake(x,0,width, imgHeight);
                }else{
                    rect = CGRectMake(0,0,imgWidth, imgHeight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0,0,CGImageGetWidth(subImageRef),CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}

/**
 *  根据颜色返回图片
 *
 *  @param color 传入的颜色
 *
 *  @return 返回的image
 */
+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//缩放图片
- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGRect rect = CGRectIntegral(CGRectMake(0,0,aWidth,aHeight));
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)launchImage{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    NSString *viewOrientation = nil;
    if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown) || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)) {
        viewOrientation = @"Portrait";
    } else {
        viewOrientation = @"Landscape";
    }
    
    
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    return [UIImage imageNamed:launchImage];
}
//缩略图
- (UIImage *)getThumbImage
{
    CGSize size= self.size;
    double max = size.width > size.height ? size.width : size.height;
    UIImage *thumbImage = self;
    if (max > 300){
        double scale = 300 / max;
        thumbImage = [self scaledImageWithWidth:size.width * scale andHeight:size.height * scale];
    }
    return thumbImage;
}
//图片分辨率限制在给定宽高内
- (UIImage *)scaledImageBasedIPhoneSizeWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGSize size = [self size];
    double scaleHeight = self.size.height > aHeight ? aHeight / self.size.height : 1;
    double scaleWidth = self.size.width> aWidth? aWidth/self.size.width:1;
    double scale=scaleHeight>scaleWidth?scaleHeight:scaleWidth;
    UIImage *image1 = self;
    if (scale < 1) {
        image1 = [self scaledImageWithWidth:size.width * scale andHeight:size.height * scale];
    }
    return image1;
}

//指定宽度缩小图片
- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) ==NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

//给定宽高内完整显示图片的frame坐标，不改变原图数据
- (CGRect)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGFloat rate = aWidth / aHeight;
    //UIImage *image = nil;
    CGFloat w;
    CGFloat h;
    CGRect frame;
    if ((CGFloat)self.size.width / self.size.height >= rate){
        CGFloat scale = (CGFloat)self.size.width / aWidth;
        w = aWidth;
        h = (CGFloat)self.size.height / scale;
        frame = CGRectMake(0, (aHeight - h)/2, w, h);
    }
    else {
        CGFloat scale = (CGFloat)self.size.height / aHeight;
        w = (CGFloat)self.size.width / scale;
        h = aHeight;
        frame = CGRectMake((aWidth - w)/2, 0, w, h);
    }
    //self = [self scaledImageWithWidth:w andHeight:h];
    return frame;
}
//给定宽高内完整显示图片的frame坐标，可能会有黑色背景填充
- (UIImage *)scaledFillImageWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGFloat rate = aWidth / aHeight;
    CGFloat w;
    CGFloat h;
    CGRect frame;
    BOOL needBackground;
    CGRect backRect = CGRectMake(0, 0, aWidth, aHeight);
    if ((CGFloat)self.size.width / self.size.height > rate){
        CGFloat scale = (CGFloat)self.size.width / aWidth;
        w = aWidth;
        h = (CGFloat)self.size.height / scale;
        frame = CGRectMake(0, (aHeight - h)/2, w, h);
        needBackground = YES;
    }
    else if ((CGFloat)self.size.width / self.size.height < rate){
        CGFloat scale = (CGFloat)self.size.height / aHeight;
        w = (CGFloat)self.size.width / scale;
        h = aHeight;
        frame = CGRectMake((aWidth - w)/2, 0, w, h);
        needBackground = YES;
    }
    else{
        frame = backRect;
        needBackground = NO;
    }
    
    UIGraphicsBeginImageContext(backRect.size);
    if (needBackground){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextAddRect(context, backRect);
        CGContextDrawPath(context, kCGPathFill);
    }
    [self drawInRect:frame];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
//全屏下完整显示图片
- (UIImage *)scaledImageToFullScreen
{
    return [self scaledFillImageWidth:[UIScreen mainScreen].bounds.size.width*2 andHeight:[UIScreen  mainScreen].bounds.size.height*2];
}
- (UIImage *)scaledImageToFullScreenWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    return [self scaledFillImageWidth:aWidth*2 andHeight:aHeight*2];
}
// 给定图片质量压缩jpg图片
- (NSData *)compressImage:(CGFloat)aQuality
{
    NSData *rest = nil;
    if (aQuality > 1 || aQuality < 0.3)
    {
        aQuality = 0.65;
    }
    UIImage *image = self;
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSInteger i = 1;
    if ([data length] < 1024*100){
        rest = data;
    }
    else{
        CGFloat rate = 0.8;
        //CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGSize imageSize = image.size;
        //判断原图分辨率
        if (image.size.width > 640  || image.size.height > 640 ){
            CGRect frame = [image scaledHeadImageWithWidth:640  andHeight:640];
            imageSize = frame.size;
            image = [image scaledImageWithWidth:imageSize.width andHeight:imageSize.height];
        }
        //第一次只压缩质量
        NSData *data = UIImageJPEGRepresentation(image, aQuality);
        
        while([data length]> 1024*100){
            //第二次开始压缩分辨率和质量
            image = [image scaledImageWithWidth:imageSize.width * rate andHeight:imageSize.height * rate];
            data = UIImageJPEGRepresentation(image, aQuality);
            rate *= 0.8;
            i++;
        }
        rest = data;
    }
    return rest;
}
//将图片缩放后切成targetSize大小的图片
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage =  self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
    }
    CGPoint thumbnailPoint = CGPointMake((targetWidth-scaledWidth)/2,(targetHeight-scaledHeight)/2);
    UIGraphicsBeginImageContext(targetSize);
    // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil){
        NSLog(@"处理失败");
    }
    return  newImage;
}

/**
 * 圆形图片
 */
- (UIImage *)circleImageWithSize:(CGSize)size
{
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 将图片画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 * 圆形图片
 */
+ (instancetype)circleImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor size:(CGSize)size
{
    // 2.开启上下文
    CGFloat imageW = size.width + 2 * borderWidth;
    CGFloat imageH = size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [image drawInRect:CGRectMake(borderWidth, borderWidth, size.width, size.height)];
    
    // 7.取图
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)compressWithImageData:(UIImage *)image toKb:(NSInteger)kb
{
    if (!image) {
        return image;
    }
    if (kb < 1) {
        return image;
    }
    UIImage *compressImage = [UIImage imageWithData:[self compressOriginalImage:image toMaxDataSizeKBytes:kb]];
    return compressImage;
}

+(NSData *)compressWithImage:(UIImage *)image toKb:(NSInteger)kb
{
    kb *= 1024;
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return imageData;
}

+ (NSData *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    maxLength *= 1024;
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

- (UIImage *)imageCorrectOrientation {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

- (CGRect)getImageRect:(UIImage *)tempImage
{
    CGRect rect;
    if (tempImage.size.width > tempImage.size.height) {
        rect = CGRectMake((tempImage.size.width-tempImage.size.height)/2, 0, tempImage.size.height, tempImage.size.height);
    } else if (tempImage.size.width < tempImage.size.height) {
        rect = CGRectMake(0, (tempImage.size.height-tempImage.size.width)/2, tempImage.size.width, tempImage.size.width);
    } else {
        rect = CGRectMake(0, 0, tempImage.size.width, tempImage.size.width);
    }
    return rect;
}

- (UIImage *)getCropImage:(UIImage *)image
{
    CGRect rect = [self getImageRect:image];
    rect = CGRectMake(ceilf(rect.origin.x), ceilf(rect.origin.y), ceilf(rect.size.width), ceilf(rect.size.height));
    UIGraphicsBeginImageContext(rect.size);
    [image drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    UIImage *cropImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cropImage;
}


//截图比较清楚
+ (UIImage *)getImage:(UIView *)shareView size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width,size.height ), NO, 0.0); //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
    return viewImage;
}


+ (UIImage *)imageWithIconName:(NSString *)icon borderImage:(NSString *)borderImage border:(int)border{
    //头像图片
    UIImage * image = [UIImage imageNamed:icon];
    //边框图片
    UIImage * borderImg = [UIImage imageNamed:borderImage];
    //
    CGSize size = CGSizeMake(image.size.width + border, image.size.height + border);
    
    //创建图片上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    //绘制边框的圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    
    //剪切可视范围
    CGContextClip(context);
    
    //绘制边框图片
    [borderImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //设置头像frame
    CGFloat iconX = border / 2;
    CGFloat iconY = border / 2;
    CGFloat iconW = image.size.width;
    CGFloat iconH = image.size.height;
    
    //绘制圆形头像范围
    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
    
    //剪切可视范围
    CGContextClip(context);
    
    //绘制头像
    [image drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    
    //取出整个图片上下文的图片
    UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return iconImage;
}

- (UIImage *)resizableImageWithInsets:(UIEdgeInsets)insets {
    
    // 指定为拉伸模式，伸缩后重新赋值
    //    self.imageViewBar.alpha = 0;
    return  [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}

//图片旋转
- (UIImage *)imageRotationOrientation:(UIImageOrientation)orientation{
    return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:orientation];
}

//图片旋转源数据改变
- (UIImage *)imageInfoRotationOrientation:(UIImageOrientation)orientation
{
    CGImageRef imgRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    
    switch(orientation)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    
    UIGraphicsBeginImageContext(bounds.size);
    /****
     出现模糊使用该方法代替上述方法 可能出现性能问题
     2 根据几倍图设置 防止重绘后变模糊
     ****/
    //UIGraphicsBeginImageContextWithOptions(bounds.size, false, 2);//
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft) {
        //平移坐标系 	UIKit － y轴向下   OpenGL ES － y轴向上
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    //做CTM变换
    CGContextConcatCTM(context, transform);
    //绘制图片
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *drawImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *newImage = [UIImage imageWithCGImage:drawImage.CGImage scale:self.scale orientation:self.imageOrientation];
    return newImage;
}


//压缩图片
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize{
    if (self.size.width < ORIGINAL_MAX_WIDTH) return self;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (self.size.width > self.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = self.size.width * (ORIGINAL_MAX_WIDTH / self.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = self.size.height * (ORIGINAL_MAX_WIDTH / self.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:self targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)antiAlias
{
    CGFloat border = 1.0f;
    CGRect rect = CGRectMake(border, border, self.size.width-2*border, self.size.height-2*border);
    UIImage *img = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width,rect.size.height));
    [self drawInRect:CGRectMake(-1, -1, self.size.width, self.size.height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.size);
    [img drawInRect:rect];
    UIImage* antiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return antiImage;
}

@end
