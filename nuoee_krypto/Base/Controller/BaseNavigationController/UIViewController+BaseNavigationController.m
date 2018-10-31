//
//  UIViewController+BaseNavigationController.m
//  BaseNavigationController
//
//  Created by liusong on 2018/3/30.
//  Copyright © 2018年 liusong. All rights reserved.
//

#import "UIViewController+BaseNavigationController.h"
#import <objc/runtime.h>
#import "UIView+BaseNavigationController.h"
#import "BaseNavigationController.h"
#import "UINavigationBar+BaseNavigationController.h"


@interface UIViewController ()


@property (nonatomic,weak) BaseNavigationController *ls_navigationController;
@property (nonatomic,strong) BaseNavigationItem *ls_navigation_item;

@end

@implementation UIViewController (BaseNavigationController)

+(void)load{

    [UINavigationBar ls_navBar_exchangeInstanceMethod:[self class] originalSel:@selector(viewDidAppear:) newSel:@selector(ls_viewDidAppear:)];
    
    [UINavigationBar ls_navBar_exchangeInstanceMethod:[self class] originalSel:@selector(navigationItem) newSel:@selector(ls_navigationItem)];
    
    [UINavigationBar ls_navBar_exchangeInstanceMethod:[self class] originalSel:@selector(setTitle:) newSel:@selector(ls_setTitle:)];

}

//#pragma mark - 以下为方法替换
-(void)ls_setTitle:(NSString *)title
{
    [self ls_setTitle:title];
    if (self.ls_navigation_item) {
        self.ls_navigation_item.title=title;
    }
}


-(void)ls_viewDidAppear:(BOOL)animated
{
    [self ls_viewDidAppear:animated];
    //只有通过BaseNavigationController push过来的VC才做此设置
    if (self.ls_navigationController) {
        if (self.navigationController.viewControllers.firstObject == self) {
            //在根控制器界面
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }else{
            BaseNavigationController *nav=(BaseNavigationController*)self.navigationController;
            //不在跟控制界面
            if (nav.cancelGesture) {
                self.navigationController.interactivePopGestureRecognizer.enabled=NO;
            }else{
                self.navigationController.interactivePopGestureRecognizer.enabled = !self.cancelGesture;
            }
        }
    }
}

-(UINavigationItem *)ls_navigationItem
{
    if (self.ls_navigation_item) {
        return self.ls_navigation_item;
    }
    return  [self ls_navigationItem];
}

#pragma mark - 以下为私有方法
-(void)bringNavigationBarToFront
{
    [self.view bringSubviewToFront:self.navigationBar];
}

-(void)setDefaultBackItem
{
    //设置返回item
    if (self.navigationController.viewControllers.count>1){
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back_white"] style:(UIBarButtonItemStylePlain) target:self action:@selector(navigationBarClickBack)];
        self.ls_navigation_item.leftBarButtonItem=leftItem;
    }
}

-(void)removeNavigationBar
{
    if (self.navigationBar) {
        [self.navigationBar removeFromSuperview];
        self.ls_navigation_item=nil;
    }
}
-(void)reloadNavigationBar
{
    [self removeNavigationBar];
    CGSize size = [UIApplication sharedApplication].statusBarFrame.size;
    BaseNavigationBar *navigationBar=[[BaseNavigationBar alloc]init];
    [navigationBar setBarTintColor:MainBlackColor];
    navigationBar.translucent = NO;
    navigationBar.tintColor = WhiteTextColor;
    [navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:WhiteTextColor,NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
//    navigationBar.layer.zPosition=10000;
    if (self.edgesForExtendedLayout==UIRectEdgeNone) {
        navigationBar.frame=CGRectMake(0, -44, size.width, 44);
        self.view.clipsToBounds=NO;
        self.view.ls_nav_enlargeTop=YES;
    }else{
        navigationBar.frame=CGRectMake(0, size.height, size.width, 44);
        self.view.ls_nav_enlargeTop=YES;
    }
    
    self.navigationBar=navigationBar;
    
    [self.view addSubview:navigationBar];
    self.ls_navigation_item=[[BaseNavigationItem alloc]init];
    navigationBar.items=@[self.ls_navigation_item];
    
    [self setDefaultBackItem];
}
-(void)navigationBarClickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 以下为增加属性
-(void)setLs_navigation_item:(BaseNavigationItem *)ls_navigation_item
{
     objc_setAssociatedObject(self, @selector(ls_navigation_item), ls_navigation_item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BaseNavigationItem *)ls_navigation_item
{
    return  objc_getAssociatedObject(self, _cmd);
}

-(BaseNavigationController *)ls_navigationController
{
    return  objc_getAssociatedObject(self, _cmd);
}
-(void)setLs_navigationController:(BaseNavigationController *)ls_navigationController
{
     objc_setAssociatedObject(self, @selector(ls_navigationController), ls_navigationController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setNavigationBar:(BaseNavigationBar *)navigationBar
{
    objc_setAssociatedObject(self, @selector(navigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BaseNavigationBar *)navigationBar
{
    return  objc_getAssociatedObject(self, _cmd);
}

-(void)setCancelGesture:(BOOL)cancelGesture
{
     objc_setAssociatedObject(self, @selector(cancelGesture), @(cancelGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!((BaseNavigationController*)self.navigationController).cancelGesture) {
        //导航控制器没有全局取消 直接设置
        self.navigationController.interactivePopGestureRecognizer.enabled=!cancelGesture;
    }
}

-(BOOL)cancelGesture
{
     return  [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setForbidAllGesture:(BOOL)forbidAllGesture
{
    BaseNavigationController *nav=self.ls_navigationController;
    nav.cancelGesture=forbidAllGesture;
}
-(BOOL)forbidAllGesture
{
    return self.navigationController.cancelGesture;
    
}



@end



