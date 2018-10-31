//
//  MarketViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MarketViewController.h"
#import "ParentCoinMarketViewController.h"
#import "ExchangeMarketViewController.h"
#import "SearchViewController.h"
#import "LLSearchVCConst.h"
#import "SearchModel.h"
#import "ExchangeInfoViewController.h"
#import "WXRWebViewController.h"

@interface MarketViewController ()

/* SearchViewController */
@property (nonatomic, strong) SearchViewController *searShopVC;
/* array */
@property (nonatomic, strong) NSArray *resultArray;


@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addLogoNavView];
    [self createUI];
}

- (instancetype)init{
    if (self == [super init]) {
        
        self.scrollEnable = NO;
        self.menuItemWidth = MAINSCREEN_WIDTH / 2;
        self.progressWidth = MAINSCREEN_WIDTH / 2;
        self.automaticallyCalculatesItemWidths = NO;
        self.menuViewContentMargin = 0;
    }
    return self;
}

#pragma mark - request
- (void)startSearch:(NSString *)str{
    
    [SearchModel search:@{@"query" : str} Success:^(NSArray *list) {
        
        NSLog(@"lissst === %@",list);
        self.resultArray = [NSArray arrayWithArray:list];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.searShopVC.resultListArray = self.resultArray;
        });
        
    } Failure:^(NSError *error) {

    }];
}

#pragma mark - action
- (void)searchTouch{
    WeakSelf(self);
    SearchViewController *searShopVC = [[SearchViewController alloc] init];
    self.searShopVC = searShopVC;
    [searShopVC beginSearch:^(NaviBarSearchType searchType,NBSSearchShopCategoryViewCellP *categorytagP,UILabel *historyTagLabel,LLSearchBar *searchBar) {
        //            @LLStrongObj(self);
        
        NSLog(@"historyTagLabel:%@--->searchBar:%@--->categotyTitle:%@--->%@",historyTagLabel.text,searchBar.text,categorytagP.categotyTitle,categorytagP.categotyID);
        //开始搜索
        NSString *str = @"";
        if (historyTagLabel.text.length != 0) {
            str = historyTagLabel.text;
        }
        if (searchBar.text.length != 0) {
            str = searchBar.text;
        }
        [weakself startSearch:str];

    }];
    
    @LLWeakObj(searShopVC);
    [searShopVC searchbarDidChange:^(NaviBarSearchType searchType, LLSearchBar *searchBar, NSString *searchText) {
        @LLStrongObj(searShopVC);
        
        [weakself startSearch:searchText];
    }];
    
    //点击了即时匹配选项
    [searShopVC resultListViewDidSelectedIndex:^(UITableView *tableView, NSInteger index) {
        //            @LLStrongObj(self);
        SearchModel *s = self.resultArray[index];
        if ([s.type isEqualToString:@"exchange"]) {
            //交易所
            ExchangeInfoViewController *exchangeVC = [[ExchangeInfoViewController alloc] init];
            exchangeVC.query = s.ID;
            [weakself.navigationController pushViewController:exchangeVC animated:YES];
            
        }else{
            //币 详情
            WXRWebViewController *webVC = [[WXRWebViewController alloc] init];
            CurrencyRank *rank = [[CurrencyRank alloc] init];
            rank.currency = s.ID;
            webVC.currencyRank = rank;
            webVC.dataFrom = WXRWebViewControllerDataFromCurrencyInfo;
            [weakself.navigationController pushViewController:webVC animated:YES];
        }
        
        NSLog(@"点击了即时搜索内容第%zd行的%@数据",index,self.resultArray[index]);
    }];
    [self.navigationController presentViewController:searShopVC animated:NO completion:nil];
}

#pragma mark - UI
- (void)createUI{
    
    //line
    UIView *midLine = [[UIView alloc] init];
    midLine.backgroundColor = [UIColor colorWithHexString:@"383838"];
    [self.menuView addSubview:midLine];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.menuView);
        make.size.mas_equalTo(CGSizeMake(2, AdaptY(20)));
    }];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:ImageName(@"search_nav") style:UIBarButtonItemStylePlain target:self action:@selector(searchTouch)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

#pragma mark - datasource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 2;
}

- (NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu{
    return 2;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
        {
            ParentCoinMarketViewController *coinVC = [[ParentCoinMarketViewController alloc]init];
            coinVC.closeNav = YES;
            return coinVC;
        }
            break;
        case 1:
        {
            ExchangeMarketViewController *exchangeVC = [[ExchangeMarketViewController alloc]init];
            exchangeVC.closeNav = YES;
            return exchangeVC;
        }
            break;
    }
    
    return nil;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            return @"币行情";
        }
            break;
        case 1:
        {
            return @"交易所行情";
        }
            break;
    }
    
    return nil;
}

//当前所在控制器
- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
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
