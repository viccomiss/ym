//
//  NBSSearchShopHistoryView.h
//  LLSearchViewController
//
//  Created by 李龙 on 2017/7/14.
//
//

#import <UIKit/UIKit.h>
#import "LLSearchVCConst.h"


@class HistorySearchHistroyViewP;

typedef void (^historyTagonClickBlock)(UILabel *tagLabel);

@interface NBSSearchShopHistoryView : UIView

+ (instancetype)searchShopCategoryViewWithPresenter:(HistorySearchHistroyViewP *)presenter WithFrame:(CGRect)rect seachType:(NaviBarSearchType)searchType;

/**
 刷新数据
 */
- (void)reloadData;


/**
 历史标签被点击

 @param clickBlock <#clickBlock description#>
 */
- (void)historyTagonClick:(historyTagonClickBlock)clickBlock;


/**
 消除所有按钮被点击
 */
@property (nonatomic,copy) void(^clearHistoryBtnOnClick)();

//刷新高度
@property (nonatomic,copy) void(^modifyFrameBlock)(CGRect rect);

/**
 热门
 */
@property (nonatomic, strong) NSArray *hotArray;


@end
