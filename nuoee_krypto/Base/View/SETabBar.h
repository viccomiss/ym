//
//  SETabBar.h
//  SuperEducation_Host
//
//  Created by yangming on 2017/3/29.
//  Copyright © 2017年 shanghailuoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SETabBar;

@protocol SETabBarDelegate <NSObject>
/**
 *  工具栏按钮被选中, 记录从哪里跳转到哪里. (方便以后做相应特效)
 */
- (void) tabBar:(SETabBar *)tabBar selectedFrom:(NSInteger) from to:(NSInteger)to;

@end

@interface SETabBar : UIView

@property (nonatomic, assign) id<SETabBarDelegate> delegate;
@property (nonatomic, copy) BaseBlock centerBlock;

/**
 *  使用特定图片来创建按钮
 *
 *  @param image         普通状态下的图片
 *  @param selectedImage 选中状态下的图片
 */
-(void)addButtonWithImage:(UIImage *)image selectedImage:(UIImage *) selectedImage;

@end
