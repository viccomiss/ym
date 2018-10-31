//
//  Define.h
//  SuperEducation
//
//  Created by yangming on 2017/2/21.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#ifndef Skin_h
#define Skin_h

//Skin
#define NAVBARCOLOR [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1]

#define ColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//例如 0x000000
#define ColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define MainYellowColor ColorFromHex(0xFDC20C)
#define LightYellowColor ColorFromHex(0xCB9A62)
#define DarkYellowColor ColorFromHex(0xFCAD0D)
#define LightDarkColor ColorFromHex(0x1a1a1a)
#define MainDarkColor ColorFromHex(0x121212)
#define MarginLineColor ColorFromHex(0x383838)
#define MainBlackColor ColorFromHex(0x000000)
#define TextDarkGrayColor ColorFromHex(0x5b5b5b)
#define TextDarkLightGrayColor ColorFromHex(0x8E8E8E)
#define TextTagGrayColor ColorFromHex(0x8f8e94)
#define WhiteTextColor [UIColor whiteColor]
#define MainGreenColor ColorFromHex(0x139829)
#define MainRedColor ColorFromHex(0xe23737)
#define DarkRedColor ColorFromHex(0xF84F44)
#define LightGreenColor ColorFromHex(0xc9fed2)
#define LightRedColor ColorFromHex(0xffc6c6)


#define LightLineColor ColorFromHex(0xDFDFDF)
#define LineColor ColorRGBA(235, 235, 235, 1)
#define FailureTextColor ColorRGBA(154, 154, 154, 1)
#define DecribeTextColor ColorFromHex(0x9a9a9a)
#define LightTextColor ColorFromHex(0xcccccc)
#define MainTextColor ColorFromHex(0x4a4a4a)
#define TranslucentColor ColorRGBA(118, 118, 118, 0.5)//半透明颜色
#define BlackTranslucentColor [[UIColor blackColor] colorWithAlphaComponent:0.3]
#define BackGroundColor  ColorRGBA(247, 247, 247, 1)
#define RandColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
#define CyanColor ColorRGBA(80, 227, 194, 1)


//Font
#define Font(F) [UIFont systemFontOfSize:(F)]
#define BoldFont(F) [UIFont boldSystemFontOfSize:(F)]//加粗字体
#define AdaptFont(F) Font(AdaptX(F))
#define ImageName(N) [UIImage imageNamed:N]

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref) (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))


//检测是否是第一次进入APP
#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"

/******************************** typedef ********************************/

typedef void (^BaseBlock)(void);
typedef void (^BaseIntBlock )(NSInteger tag);
typedef void (^BaseFloatBlock )(CGFloat value);
typedef void (^BaseIdBlock )(id parameter);
typedef void (^BaseBoolBlock )(BOOL tag);
typedef void (^BaseDoubleBlock)(id parameter1,id parameter2);
typedef void (^BaseThreeBlock)(id parameter1,id parameter2,id parameter3);

#endif


