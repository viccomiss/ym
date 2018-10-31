//
//  CoinRankViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "CoinRankViewController.h"
#import "MainContentView.h"
#import "TopTagView.h"
#import "WXRWebViewController.h"
#import "CurrencyRanksModel.h"

@interface CoinRankViewController ()<MainContentDelegate, TopTagDelegate>

@property (nonatomic, strong) MainContentView *contentView;
@property (nonatomic, strong) TopTagView *topView;
/* CurrencyRanksModel */
@property (nonatomic, strong) CurrencyRanksModel *model;

@end

@implementation CoinRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self setRefresh];
}

#pragma mark - request
-(void)setRefresh{
    [[SERefresh sharedSERefresh] normalModelRefresh:self.contentView refreshType:RefreshTypeDropDown firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self loadDataWithLoadMore:NO];
    } upDropBlock:nil];
}

-(void)loadDataWithLoadMore:(BOOL)isMore{
    [CurrencyRanksModel currency_ranks:@{} Success:^(CurrencyRanksModel *model) {
        self.model = model;
        
        [self.contentView.mj_header endRefreshing];
        self.contentView.dataArray = [NSMutableArray arrayWithArray:self.model.data];
        
        if (self.contentView.dataArray.count == 0) {
            [self.noDataView showNoDataView:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-NavbarH) type:NoTextType tagStr:@"" needReload:NO reloadBlock:nil];
            [self.contentView addSubview:self.noDataView];
        }else{
            self.noDataView.hidden = YES;
        }
        
        [self.contentView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - main content delegate
- (void)mainContentCurrentOffset:(CGPoint)offset{
    self.topView.collectionView.contentOffset = offset;
}

- (void)didSelectedCoinDetail:(id)object{
    CurrencyRank *c = (CurrencyRank *)object;
    WXRWebViewController *webVC = [[WXRWebViewController alloc] init];
    webVC.currencyRank = c;
    webVC.dataFrom = WXRWebViewControllerDataFromCurrencyInfo;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - top tag delegate
- (void)topTagCurrentOffset:(CGPoint)offset{
    self.contentView.currentOffset = offset;
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.equalTo(@(AdaptY(34)));
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
}

#pragma mark - init
- (TopTagView *)topView{
    if (!_topView) {
        _topView = [[TopTagView alloc] initWithType:CoinRankType];
        _topView.delegate = self;
    }
    return _topView;
}

- (MainContentView *)contentView{
    if (!_contentView) {
        _contentView = [[MainContentView alloc] initWithType:CoinRankType];
        _contentView.mainDelegate = self;
    }
    return _contentView;
}

- (void)dealloc{
    
    
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
