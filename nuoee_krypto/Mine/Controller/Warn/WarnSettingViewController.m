//
//  WarnSettingViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/15.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "WarnSettingViewController.h"
#import "WarnSettingHeader.h"
#import "LeftRightChooseCell.h"
#import "WarnSetCell.h"
#import "WarnRemindCell.h"
#import "Warn.h"
#import "NSString+JLAdd.h"

@interface WarnSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* header */
@property (nonatomic, strong) WarnSettingHeader *headerView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* prefix no-￥ yes-$ */
@property (nonatomic, assign) BOOL prefix;


@end

@implementation WarnSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"预警设置";
    [self createUI];
    [self setRefresh];
}

#pragma mark - request
- (void)addWarnWithPrice:(CGFloat)price chgType:(NSString *)chgType{
    
    [EasyLoadingView showLoading];
    [Warn alerts_new:@{@"convertCoin": [self.market.currency_code uppercaseString], @"exchangeName" : self.market.exchange_code, @"price": [NSNumber numberWithFloat:price], @"traderCoin" : [[self.market.ticker subStringFrom:@":"] uppercaseString], @"currency" : @"CNY", @"alertStatus" : @"UN_TRIGGER", @"chgType" : chgType} Success:^(Warn *item) {
        
        [self.dataArray insertObject:item atIndex:0];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
    } Failure:^(NSError *error) {
        
    }];
}

- (void)delWarnWithId:(NSString *)Id index:(NSInteger)index{
    
    [EasyLoadingView showLoading];
    [Warn alerts_delsingle:@{@"id": Id} Success:^(NSString *item) {
        
        if ([item isEqualToString:@"10000"]) {
            [SEHUD showAlertWithText:@"删除成功"];
            [self.dataArray removeObjectAtIndex:index];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

-(void)setRefresh{
    [[SERefresh sharedSERefresh] normalModelRefresh:self.tableView refreshType:RefreshTypeDropDown firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self loadDataWithLoadMore:NO];
    } upDropBlock:nil];
}

-(void)loadDataWithLoadMore:(BOOL)isMore{
    [Warn alerts_exchange_show:@{@"convertCoin": self.market.currency_code, @"exchangeName" : self.market.exchange_code, @"traderCoin" : [[self.market.ticker subStringFrom:@":"] uppercaseString]} Success:^(NSArray *item) {
        
        [self.tableView.mj_header endRefreshing];
        self.dataArray = [NSMutableArray arrayWithArray:item];
        
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self);
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    LeftRightChooseCell *cell = [LeftRightChooseCell typeChooseCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row] leftStr:@"人民币(￥)" rightStr:@"美元($)"];
                    cell.title = @"单位：";
                    cell.buttonTouch = ^(NSInteger tag){
                        weakself.prefix = tag == 1 ? NO : YES;
                        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0], [NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    return cell;
                }
                    break;
                case 1:
                {
                    WarnSetCell *cell = [WarnSetCell warnSetCell:tableView type:RoseType];
                    cell.prefix = self.prefix;
                    cell.middlePrice = !self.prefix ? self.kline.closePrice : self.kline.usdPrice;
                    cell.priceBlock = ^(CGFloat value) {
                        [weakself addWarnWithPrice:value chgType:@"INCREASE"];
                    };
                    return cell;
                }
                    break;
                case 2:
                {
                    WarnSetCell *cell = [WarnSetCell warnSetCell:tableView type:FallType];
                    cell.prefix = self.prefix;
                    cell.middlePrice = !self.prefix ? self.kline.closePrice : self.kline.usdPrice;
                    cell.priceBlock = ^(CGFloat value) {
                        [weakself addWarnWithPrice:value chgType:@"FALL"];
                    };
                    return cell;
                }
                    break;
            }
        }
            break;
        case 1:
        {
            WarnRemindCell *cell = [WarnRemindCell warnRemindCell:tableView];
            Warn *w = self.dataArray[indexPath.row];
            cell.model = w;
            cell.delBlock = ^(){
                [weakself delWarnWithId:w.ID index:indexPath.row];
            };
            return cell;
        }
            break;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(20))];
    view.backgroundColor = MainBlackColor;
    return view;
}

#pragma mark - tableView delagate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    return AdaptY(72);
                    break;
                case 1: case 2:
                    return AdaptY(64);
                    break;
            }
        }
            break;
    }
    return AdaptY(56);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(20);
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
    }];
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.market = self.market;
    self.headerView.kline = self.kline;
}

#pragma mark - init
- (WarnSettingHeader *)headerView{
    if (!_headerView) {
        _headerView = [[WarnSettingHeader alloc] init];
    }
    return _headerView;
}

- (BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = MainBlackColor;
    }
    return _tableView;
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
