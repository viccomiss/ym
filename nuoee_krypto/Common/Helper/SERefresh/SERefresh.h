//
//  SERefresh.h
//  SuperEducation
//
//  Created by yangming on 2017/3/20.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshTypeDropDown = 0,  //只支持下拉
    RefreshTypeUpDrop = 1,    //只支持上拉
    RefreshTypeDouble = 2,    //支持上拉和下拉
};


@interface SERefresh : NSObject

//初始化
+ (instancetype)sharedSERefresh;

//正常模式上拉下拉刷新
- (void)normalModelRefresh:(UIScrollView *)tableView refreshType:(RefreshType)refreshType firstRefresh:(BOOL)firstRefresh timeLabHidden:(BOOL)timeLabHidden stateLabHidden:(BOOL)stateLabHidden dropDownBlock:(void(^)(void))dropDownBlock upDropBlock:(void(^)(void))upDropBlock;

//gifRefresh
- (void)gifModelRefresh:(UITableView *)tableView refreshType:(RefreshType)refreshType firstRefresh:(BOOL)firstRefresh timeLabHidden:(BOOL)timeLabHidden stateLabHidden:(BOOL)stateLabHidden dropDownBlock:(void(^)(void))dropDownBlock upDropBlock:(void(^)(void))upDropBlock;

//后期如果有需要还要对diy的模式进行封装
@end
