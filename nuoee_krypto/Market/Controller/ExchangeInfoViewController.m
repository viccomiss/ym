//
//  ExchangeInfoViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/12.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ExchangeInfoViewController.h"
#import "TopTagView.h"
#import "MainContentView.h"
#import "ExchangeTicks.h"
#import "CurrencyMarket.h"
#import "KlineDetailViewController.h"
#import "NSString+JLAdd.h"

@interface ExchangeInfoViewController ()<MainContentDelegate,TopTagDelegate>

@property (nonatomic, strong) TopTagView *topView;
@property (nonatomic, strong) MainContentView *contentView;
/* header */
@property (nonatomic, strong) UIView *headerView;
/* vol */
@property (nonatomic, strong) BaseLabel *volLabel;
/* voltag */
@property (nonatomic, strong) BaseLabel *volTagLabel;
/* tradeType */
@property (nonatomic, strong) BaseLabel *tradeTypeLabel;
/* area */
@property (nonatomic, strong) BaseLabel *areaLabel;
/* num */
@property (nonatomic, strong) BaseLabel *numLabel;

@end

@implementation ExchangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.exchange.exchangeName;
    [self createUI];
    if (self.exchange == nil && self.query.length != 0) {
        [self setNormalInfo];
    }
    [self setRefresh];
}

- (void)setNormalInfo{
    
    [Exchange exchange:@{@"query" : self.query} Success:^(Exchange *model) {
        
        self.exchange = model;
        self.title = self.exchange.exchangeName;
        [self setData];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - request
-(void)setRefresh{
    [[SERefresh sharedSERefresh] normalModelRefresh:self.contentView refreshType:RefreshTypeDropDown firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self loadDataWithLoadMore:NO];
    } upDropBlock:nil];
}

-(void)loadDataWithLoadMore:(BOOL)isMore{
    [ExchangeTicks exchange_ticks:@{@"exchange": self.exchange.exchange} Success:^(NSArray *list) {
        
        [self.contentView.mj_header endRefreshing];
        self.contentView.dataArray = [NSMutableArray arrayWithArray:list];
        
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

- (void)setData{
    
    CGFloat vol = floor([self.exchange.vol doubleValue] * 100) / 100;
    
    self.volLabel.text = [NSString numberFormatterToRMB:vol];
    
    self.tradeTypeLabel.text = [NSString stringWithFormat:@"类型: %@",self.exchange.tradeType];
    self.areaLabel.text = [NSString stringWithFormat:@"地区: %@",self.exchange.area];
    
    NSString *numStr = [NSString stringWithFormat:@"第 %ld 名",self.exchange.index + 1];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:numStr];
    if (attributeStr.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:MainYellowColor
                             range:NSMakeRange(1, attributeStr.length - 2)];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:AdaptX(30)] range:NSMakeRange(1, attributeStr.length - 2)];
    }
    self.numLabel.attributedText = attributeStr;
}

#pragma mark - main content delegate
- (void)mainContentCurrentOffset:(CGPoint)offset{
    self.topView.collectionView.contentOffset = offset;
}

- (void)didSelectedCoinDetail:(id)object{
    
    ExchangeTicks *e = (ExchangeTicks *)object;
    CurrencyMarket *c = [[CurrencyMarket alloc] init];
    c.exchange_code = e.exchangeName;
    c.ticker = e.ticker;
    c.currency_code = e.currency;
    c.vol = [NSString stringWithFormat:@"%.f",e.vol];
    c.degree = [NSString stringWithFormat:@"%.f",e.degree];
    c.high = [NSString stringWithFormat:@"%.f",e.high];;
    c.low = [NSString stringWithFormat:@"%.f",e.low];;
    c.usdPrice = e.usdPrice;
    c.currency_name = e.base;
    c.last = [NSString stringWithFormat:@"%.f",e.close];
    
    KlineDetailViewController *detailVC = [[KlineDetailViewController alloc] init];
    detailVC.currencyMarket = c;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - top tag delegate
- (void)topTagCurrentOffset:(CGPoint)offset{
    self.contentView.currentOffset = offset;
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(NavbarH + AdaptY(86)));
    }];
    
    [self.headerView addSubview:self.volLabel];
    [self.volLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_top).offset(NavbarH + AdaptY(2));
        make.left.mas_equalTo(self.headerView.mas_left).offset(2 * MidPadding);
    }];
    
    [self.headerView addSubview:self.volTagLabel];
    [self.volTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.volLabel.mas_right).offset(MidPadding);
        make.bottom.mas_equalTo(self.volLabel.mas_bottom);
    }];
    
    [self.headerView addSubview:self.tradeTypeLabel];
    [self.tradeTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.volLabel.mas_bottom).offset(MidPadding);
        make.left.mas_equalTo(self.volLabel.mas_left);
    }];
    
    [self.headerView addSubview:self.areaLabel];
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tradeTypeLabel.mas_bottom).offset(AdaptY(5));
        make.left.mas_equalTo(self.volLabel.mas_left);
    }];
    
    [self.headerView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headerView.mas_right).offset(- 2 * MidPadding);
        make.bottom.mas_equalTo(self.headerView.mas_bottom).offset(- MidPadding);
    }];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.height.equalTo(@(AdaptY(34)));
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
    
    [self setData];
}

#pragma mark - init
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor colorWithPatternImage:StatusBarH > 20 ? ImageName(@"exchange_header_x") : ImageName(@"exchange_header")];
    }
    return _headerView;
}

- (BaseLabel *)volLabel{
    if (!_volLabel) {
        _volLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(18) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _volLabel;
}

- (BaseLabel *)volTagLabel{
    if (!_volTagLabel) {
        _volTagLabel = [SEFactory labelWithText:@"24h全球交易量" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _volTagLabel;
}

- (BaseLabel *)tradeTypeLabel{
    if (!_tradeTypeLabel) {
        _tradeTypeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _tradeTypeLabel;
}

- (BaseLabel *)areaLabel{
    if (!_areaLabel) {
        _areaLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _areaLabel;
}

- (BaseLabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:WhiteTextColor textAlignment:NSTextAlignmentRight];
    }
    return _numLabel;
}

- (TopTagView *)topView{
    if (!_topView) {
        _topView = [[TopTagView alloc] initWithType:ExchangeTicksType];
        _topView.delegate = self;
    }
    return _topView;
}

- (MainContentView *)contentView{
    if (!_contentView) {
        _contentView = [[MainContentView alloc] initWithType:ExchangeTicksType];
        _contentView.mainDelegate = self;
    }
    return _contentView;
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
