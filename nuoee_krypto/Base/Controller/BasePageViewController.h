//
//  BasePageViewController.h
//  SuperEducation
//
//  Created by JackyLiang on 2017/9/27.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <WMPageController/WMPageController.h>
#import "BaseNavigationControllerKit.h"

/**
 所有的分屏显示内容使用此控制器
 */
@interface BasePageViewController : WMPageController

- (void)backTouch;

//添加logo nav
- (void)addLogoNavView;

@end
