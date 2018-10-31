//
//  WXRImagePicker.h
//  wxer_manager
//
//  Created by JackyLiang on 2017/8/16.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PickImagePath){
    PickImagePathPhotoAndCamera = 0,
    PickImagePathPhoto ,
    PickImagePathCamera,
    PickImagePathLocalVideo
};


typedef void (^pickImageBlock)(UIImage *editedImage,NSDictionary *info);

@interface WXRImagePicker : NSObject

+(instancetype)shareImagePicker;
/**
 图片选择
 @param cropable 是否需要裁剪
 @param cropFrame 裁剪框的frame 默认为屏宽的正方形
 @param backBlock 返回选择的image  
 path = PickImagePathLocalVideo 没有editedImage 只有info
 */
-(void)showImagePickerWithCropable:(BOOL)cropable cropFrame:(CGRect)cropFrame  pickPath:(PickImagePath)pickPath block:(pickImageBlock )backBlock;
@end
