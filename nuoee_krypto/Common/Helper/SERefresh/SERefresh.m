//
//  SERefresh.m
//  SuperEducation
//
//  Created by yangming on 2017/3/20.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "SERefresh.h"
#import <UIImage+GIF.h>
#import "NSData+JLAdd.h"

@interface SERefresh () {
    NSMutableArray *idleImages;
    NSMutableArray *pullingImages;
    NSMutableArray *refreshingImages;
    UIScrollView *scrollView;
}

//下拉时候触发的block
@property (nonatomic, copy) void(^DropDownRefreshBlock)(void);
//上拉时候触发的block
@property (nonatomic, copy) void(^UpDropRefreshBlock)(void);

@end

@implementation SERefresh

+ (instancetype)sharedSERefresh{
    return [[SERefresh alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        //此gif为逐帧动画由多张图片组成(Image(@"Image")写法和[UIImage imageNamed:@"Image"])
        //闲置状态下的gif(就是拖动的时候变化的gif)
        NSMutableArray *idle = [NSMutableArray array];
        for (int i = 0; i < 61; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"frame-%d",i]];
            [idle addObject:image];
        }
        
        NSMutableArray *refreshing = [NSMutableArray array];
        for (int i = 0; i <= 3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_frame-%d",i]];
            [refreshing addObject:image];
        }
//
        idleImages = [NSMutableArray arrayWithArray:idle];
//        //已经到达偏移量的gif(就是已经到达偏移量的时候的gif)
        pullingImages = [NSMutableArray arrayWithArray:refreshing];
//        //正在刷新的时候的gif
        refreshingImages = [NSMutableArray arrayWithArray:refreshing];
        
//        NSMutableArray *idle = [NSMutableArray array];
//        for (NSUInteger i = 1; i<=60; i++) {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
//            [idle addObject:image];
//        }
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//        NSMutableArray *refreshing = [NSMutableArray array];
//        for (NSUInteger i = 1; i<=3; i++) {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
//            [refreshing addObject:image];
//        }
        
//        NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"refreshing" ofType:@"gif"]];
//        refreshingImages = [gifData praseGIFDataToImageArray];
    }
    return self;
}

//正常模式下拉上拉刷新(firstRefresh第一次进入的时候是否要刷新,这个值只对下拉刷新有影响)(refreshType设置为只支持上拉或者下拉的时候,将另外一个block置为nil)
- (void)normalModelRefresh:(UIScrollView *)tableView refreshType:(RefreshType)refreshType firstRefresh:(BOOL)firstRefresh timeLabHidden:(BOOL)timeLabHidden stateLabHidden:(BOOL)stateLabHidden dropDownBlock:(void(^)(void))dropDownBlock upDropBlock:(void(^)(void))upDropBlock {
    scrollView = tableView;
    if (refreshType == RefreshTypeDropDown) {
        //只支持下拉
        //将block传入
        self.DropDownRefreshBlock = dropDownBlock;
        //初始化
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self dropDownBlockAction];
//        }];
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [self dropDownBlockAction];
        }];
        [header setImages:idleImages forState:MJRefreshStateIdle];
        [header setImages:pullingImages forState:MJRefreshStatePulling];
        [header setImages:refreshingImages forState:MJRefreshStateRefreshing];        //是否隐藏上次更新的时间
        header.lastUpdatedTimeLabel.hidden = timeLabHidden;
        //是否隐藏刷新状态label
        header.stateLabel.hidden = stateLabHidden;
        //tableView.mj_header接收header
        tableView.mj_header = header;
        //首次进来是否需要刷新
        if (firstRefresh) {
            [tableView.mj_header beginRefreshing];
        }
        //透明度渐变
        tableView.mj_header.automaticallyChangeAlpha = YES;
    }else if (refreshType == RefreshTypeUpDrop) {
        //只支持上拉
        //传入block
        self.UpDropRefreshBlock = upDropBlock;
        //初始化并指定方法
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self dropDownBlockAction];
//        }];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            if (scrollView.mj_header.refreshing) {
//                return;
//            }
            [self upDropBlockAction];
        }];
        footer.refreshingTitleHidden = YES;
        footer.stateLabel.textColor = DecribeTextColor;
        tableView.mj_footer = footer;
        
        if (firstRefresh) {
            [tableView.mj_footer beginRefreshing];
        }
        
    }else if (refreshType == RefreshTypeDouble) {
        //上拉和下拉都持支持
        //下拉
        //将block传入
        self.DropDownRefreshBlock = dropDownBlock;
        //初始化
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//                    [self dropDownBlockAction];
//                }];
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [self dropDownBlockAction];
        }];
        [header setImages:idleImages forState:MJRefreshStateIdle];
        [header setImages:pullingImages forState:MJRefreshStatePulling];
        [header setImages:refreshingImages forState:MJRefreshStateRefreshing];        //是否隐藏上次更新的时间
        
        //是否隐藏上次更新的时间
        header.lastUpdatedTimeLabel.hidden = timeLabHidden;
        //是否隐藏刷新状态label
        header.stateLabel.hidden = stateLabHidden;
        //tableView.mj_header接收header
        tableView.mj_header = header;
        //首次进来是否需要刷新
        if (firstRefresh) {
            [tableView.mj_header beginRefreshing];
        }
        //透明度渐变
        tableView.mj_header.automaticallyChangeAlpha = YES;
        //上拉
        //将block传入
        self.UpDropRefreshBlock = upDropBlock;
        //初始化并指定方法
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            if (scrollView.mj_header.refreshing) {
//                return;
//            }
            [self upDropBlockAction];
        }];
        footer.refreshingTitleHidden = NO;
        footer.stateLabel.textColor = TextDarkGrayColor;
        tableView.mj_footer = footer;
    }
}

//gifRefresh
- (void)gifModelRefresh:(UITableView *)tableView refreshType:(RefreshType)refreshType firstRefresh:(BOOL)firstRefresh timeLabHidden:(BOOL)timeLabHidden stateLabHidden:(BOOL)stateLabHidden dropDownBlock:(void(^)(void))dropDownBlock upDropBlock:(void(^)(void))upDropBlock {
    
    if (refreshType == RefreshTypeDropDown) {
        //只支持下拉
        self.DropDownRefreshBlock = dropDownBlock;
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [self dropDownBlockAction];
        }];
        [header setImages:idleImages forState:MJRefreshStateIdle];
        [header setImages:pullingImages forState:MJRefreshStatePulling];
        [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.lastUpdatedTimeLabel.hidden = timeLabHidden;
        header.stateLabel.hidden = stateLabHidden;
        tableView.mj_header = header;
        if (firstRefresh) {
            [tableView.mj_header beginRefreshing];
        }
    }else if (refreshType == RefreshTypeUpDrop) {
        //只支持上拉
        self.UpDropRefreshBlock = upDropBlock;
        //初始化并指定方法
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self upDropBlockAction];
        }];
    }else if (refreshType == RefreshTypeDouble) {
        //支持上拉和下拉加载
        self.DropDownRefreshBlock = dropDownBlock;
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [self dropDownBlockAction];
        }];
        [header setImages:idleImages forState:MJRefreshStateIdle];
        [header setImages:pullingImages forState:MJRefreshStatePulling];
        [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.lastUpdatedTimeLabel.hidden = timeLabHidden;
        header.stateLabel.hidden = stateLabHidden;
        tableView.mj_header = header;
        if (firstRefresh) {
            [tableView.mj_header beginRefreshing];
        }
        self.UpDropRefreshBlock = upDropBlock;
        //初始化并指定方法
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self upDropBlockAction];
        }];
    }
}

//下拉时候触发的block
- (void)dropDownBlockAction {
    if (_DropDownRefreshBlock) {
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        [scrollView.mj_footer resetNoMoreData];
        _DropDownRefreshBlock();
    }
}

//上拉时候触发的block
- (void)upDropBlockAction {
    if (_UpDropRefreshBlock) {
        [scrollView.mj_header endRefreshing];
        _UpDropRefreshBlock();
    }
}
@end
