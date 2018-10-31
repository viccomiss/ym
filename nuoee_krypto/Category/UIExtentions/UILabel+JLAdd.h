//
//  UILabel+JLAdd.h
//  HCMedical
//
//  Created by jack on 7/21/16.
//  Copyright © 2016 平安科技健康云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel (JLAdd)

/**
 *  获取宽度
 *
 *  @return 宽度
 */
- (CGFloat)getExactlyWidth;

/**
 *  获取高度
 *
 *  @return 高度
 */
- (CGFloat)getExactlyHeight;

/**
 *  在size范围内返回label文字的size
 *
 *  @param size size范围
 *
 *  @return 文字的size
 */
- (CGSize)getSizeInContainerSize:(CGSize)size;

/**
 *  自动适配label的高度
 */
- (void)autoSetLabelHeight;

/**
 *  设置label行间距(需要设置text后调用)
 *
 *  @param lineSpace 行间距
 */
- (void)changeLineSpace:(CGFloat)lineSpace;

/**
 *  设置label行间距和段落间距
 *
 *  @param lineSpace      行间距
 *  @param paragraphSpace 段落间距
 */
- (void)changeLineSpace:(CGFloat)lineSpace paragraphSpacing:(CGFloat)paragraphSpace;


/**
 设置行间距并计算高低

 @param str str
 @param font font
 @param width width
 @param lineSpace 行间距
 @return height
 */
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpace:(CGFloat)lineSpace;


@end
