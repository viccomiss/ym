//
//  BaseTransparentNavViewController.h
//  SuperEducation
//
//  Created by yangming on 2017/4/20.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "SERefresh.h"
#import "NoDataView.h"
#import "BaseViewController.h"

/**
 透明nav
 */
@interface BaseTransparentNavViewController : BaseViewController

- (void)backOtherOperation;

@property (nonatomic, assign) BOOL isNotShowNav;

@end
