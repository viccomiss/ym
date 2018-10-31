
//
//  BaseNavigationController.m
//  BaseNavigationController
//
//  Created by liusong on 2018/3/22.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "BaseNavigationController.h"
#import <objc/runtime.h>
#import "BaseNavigationBar.h"
#import "UIViewController+BaseNavigationController.h"
#import <objc/runtime.h>
@interface BaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *panRecognizer;

@end


@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden=YES;
    BaseTopNavigationBar *navbar=[[BaseTopNavigationBar alloc]init] ;
    navbar.hidden=NO;
    [self setValue:navbar forKeyPath:@"_navigationBar"];
    self.interactivePopGestureRecognizer.delegate=self;
    
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController  setValue:self forKeyPath:@"ls_navigationController"];
    if (self.viewControllers.count>=1) {
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:animated];
}
-(void)setCancelGesture:(BOOL)cancelGesture
{
    _cancelGesture=cancelGesture;
    self.interactivePopGestureRecognizer.enabled=!cancelGesture;
}
@end





