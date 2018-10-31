//
//  AdapterMacros.h
//  wxer_manager
//
//  Created by Jacky on 2017/11/8.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#ifndef AdapterMacros_h
#define AdapterMacros_h

/*====================================UI定义============================================*/
#define MAINSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAINSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define StatusBarH  [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavbarH     (StatusBarH > 20 ?88:64)
#define TabbarH     (StatusBarH > 20 ?88:44)
#define TabbarNSH   (StatusBarH > 20 ?34:0)  //tabbar非安全区域高度

//状态栏高于20 是iphoneX 高度缩放比率为1
#define SCALE_WIDTH  MAINSCREEN_WIDTH / 375
#define AdaptX(x)    MAINSCREEN_WIDTH / 375 * x
#define HAdaptY(y)   MAINSCREEN_HEIGHT / 375 * y
#define SCALE_HEIGHT (StatusBarH > 20 ? MAINSCREEN_HEIGHT/812 : MAINSCREEN_HEIGHT/667)
#define HAdaptX(x)   (StatusBarH > 20 ? MAINSCREEN_WIDTH /812 * x : MAINSCREEN_WIDTH / 667 * x)
#define AdaptY(y)    (StatusBarH > 20 ? MAINSCREEN_HEIGHT/812 * y : MAINSCREEN_HEIGHT/ 667 * y)

#define MinPadding AdaptX(8)
#define MidPadding AdaptX(10)
#define MaxPadding AdaptX(20)
#define SmallIcon AdaptX(19)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// View 圆角，边框
#define ViewBorderRadius(View, Radius, Width, Color)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]\

// View 圆角
#define ViewRadius(View, Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//View 自定义切角位置
#define ViewRadiusCustom(View,Conrners,Size)\
UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:View.bounds byRoundingCorners:Conrners cornerRadii:Size];\
CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];\
maskLayer.frame = View.bounds;\
maskLayer.path = maskPath.CGPath;\
View.layer.mask = maskLayer;

//View 阴影切角
#define ViewShadow(View, shadowOffset, shadowColor, shadowOpacity, shadowRadius, cornerRadius)\
[View.layer setShadowColor:[shadowColor CGColor]];\
[View.layer setShadowOffset:(shadowOffset)];\
[View.layer setShadowOpacity:(shadowOpacity)];\
[View.layer setShadowRadius:(shadowRadius)];\
[View.layer setCornerRadius:(cornerRadius)]

//Masonry
#define MakeConstraints(TopView, Topoffset,LeftView, Leftoffset,BottomView, Bottomoffset,RightView,rightOffset)\
if(TopView)\
make.top.equalTo(TopView).offset(Topoffset);\
if(LeftView)\
make.left.equalTo(LeftView).offset(Leftoffset);\
if(BottomView)\
make.bottom.equalTo(BottomView).offset(Bottomoffset);\
if(RightView)\
make.right.equalTo(RightView).offset(rightOffset)

#define WeakSelf(type)  __weak typeof(type) weak##type = type;//使用：直接 WeakSelf(self)
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

#endif /* AdapterMacros_h */
