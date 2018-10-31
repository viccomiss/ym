//
//  CoinMarketViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ParentCoinMarketViewController.h"
#import "SPPageMenu.h"
#import "CoinRankViewController.h"
#import "CoinViewController.h"
#import "Currency.h"
#import "CoinListViewController.h"

#define pageMenuH AdaptY(47)
#define scrollViewHeight (MAINSCREEN_HEIGHT - NavbarH - pageMenuH * 2 - TabbarH)

@interface ParentCoinMarketViewController ()<UIScrollViewDelegate,SPPageMenuDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
/* allData */
@property (nonatomic, strong) NSArray *allDataArray;


@end

@implementation ParentCoinMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRequest];
}

- (void)setRequest{
    
    [EasyLoadingView showLoading];
    [Currency currency_list:@{} Success:^(NSArray *list) {
        
        self.allDataArray = list;
        [self.dataArr addObject:@"排行"];
        for (Currency *c in list) {
            [self.dataArr addObject:c.currency_name];
        }
        
        [self createUI];
        
    } Failure:^(NSError *error) {
        
    }];
}

- (void)createUI{
    
    NSArray *controllerClassNames = [NSArray arrayWithObjects:@"CoinRankViewController",@"CoinViewController",@"CoinViewController",@"CoinViewController",@"CoinViewController",@"CoinViewController",@"CoinViewController",@"CoinViewController",@"CoinViewController", nil];
    for (int i = 0; i < self.dataArr.count; i++) {
        BaseViewController *baseVc;

        if (i == 0) {
            baseVc = [[NSClassFromString(@"CoinRankViewController") alloc] init];
        }else{
            baseVc = [[NSClassFromString(@"CoinViewController") alloc] init];
        }
        
        baseVc.closeNav = YES;
        [self addChildViewController:baseVc];
        if (i > 0) {
            Currency *c = self.allDataArray[i - 1];
            CoinViewController *coinVC = (CoinViewController *)baseVc;
            coinVC.currency = c.currency_type;
        }
        
        // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
        [self.myChildViewControllers addObject:baseVc];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, pageMenuH, MAINSCREEN_WIDTH, scrollViewHeight)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
    self.pageMenu.bridgeScrollView = self.scrollView;
    
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        BaseViewController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(MAINSCREEN_WIDTH*self.pageMenu.selectedItemIndex, 0, MAINSCREEN_WIDTH, scrollViewHeight);
        scrollView.contentOffset = CGPointMake(MAINSCREEN_WIDTH*self.pageMenu.selectedItemIndex, 0);
        scrollView.contentSize = CGSizeMake(self.dataArr.count*MAINSCREEN_WIDTH, 0);
    }
}

#pragma mark - page delegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(MAINSCREEN_WIDTH * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(MAINSCREEN_WIDTH * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(MAINSCREEN_WIDTH * toIndex, 0, MAINSCREEN_WIDTH, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
}

- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {
    
    WeakSelf(self);
    CoinListViewController *coinListVC = [[CoinListViewController alloc] init];
    coinListVC.listArray = self.allDataArray;
    [self.navigationController pushViewController:coinListVC animated:YES];
    coinListVC.coinBlock = ^(NSString *coin){
        for (int i = 0; i < weakself.dataArr.count; i++) {
            NSString *name = weakself.dataArr[i];
            if ([name isEqualToString:coin]) {
                [weakself.pageMenu setItems:weakself.dataArr selectedItemIndex:i];
            }
        }
    };
}

- (SPPageMenu *)pageMenu{
    if (!_pageMenu && self) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLine];
        // 传递数组，默认选中第2个
        _pageMenu.showFuntionButton = YES;
        [_pageMenu setItems:self.dataArr selectedItemIndex:0];
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:AdaptX(15)];
        _pageMenu.selectedItemTitleColor = MainYellowColor;
        _pageMenu.unSelectedItemTitleColor = WhiteTextColor;
        _pageMenu.backgroundColor = MainBlackColor;
        _pageMenu.tracker.backgroundColor = MainYellowColor;
        _pageMenu.dividingLine.hidden = YES;
        // 设置代理
        _pageMenu.delegate = self;
        [self.view addSubview:_pageMenu];
    }
    return _pageMenu;
}

- (NSMutableArray *)myChildViewControllers {
    
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    return _myChildViewControllers;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
