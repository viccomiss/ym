//
//  BaseViewController.h
//  UNIS-LEASE
//
//  Created by runlin on 2016/10/24.
//  Copyright © 2016年 unis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAlert.h"
#import "JKToast.h"
#import "NSDictionary+JKSafeAccess.h"
#import "NSArray+JKSafeAccess.h"
#import "SERefresh.h"
#import "NoDataView.h"
#import "BaseNavigationControllerKit.h"

@interface BaseViewController : UIViewController

/**
 初始化UI
 */
- (void)setUpUI;


/**
 返回按钮点击
 */
- (void)backTouch;

/**
 子类在点击返回按钮进行操作，使用该方法
 */
- (void)backOtherOperation;

@property (nonatomic, strong) NoDataView *noDataView;
@property (nonatomic, assign) BOOL isFirstEnter;
/* 是否开启nav设置 涉及嵌套controller 需要取消设置 */
@property (nonatomic, assign) BOOL closeNav;


/* 开启横屏 */
@property (nonatomic, assign) BOOL openLandScape;


/**
 横竖屏

 @param isLandscape no - 竖屏
 */
- (void)playPortrait:(BOOL)isLandscape;

//添加logo nav
- (void)addLogoNavView;

@end
