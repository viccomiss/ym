//
//  ExchangeMarketViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ExchangeMarketViewController.h"
#import "ExchangeMarketCell.h"
#import "ExchangeMarketHeaderView.h"
#import "ExchangeRanksModel.h"
#import "ExchangeInfoViewController.h"

static NSString *headerCellId = @"headerCellId";

@interface ExchangeMarketViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/* model */
@property (nonatomic, strong) ExchangeRanksModel *model;
/* header */
@property (nonatomic, strong) ExchangeMarketHeaderView *headerView;


@end

@implementation ExchangeMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self setRefresh];
}

#pragma mark - request
-(void)setRefresh{
    [[SERefresh sharedSERefresh] normalModelRefresh:self.tableView refreshType:RefreshTypeDropDown firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer endRefreshing];
        [self loadDataWithLoadMore:NO];
    } upDropBlock:nil];
}

-(void)loadDataWithLoadMore:(BOOL)isMore{
    [ExchangeRanksModel exchangeRanks:@{} Success:^(ExchangeRanksModel *model) {
        self.model = model;
        
        [self.tableView.mj_header endRefreshing];
        self.dataArray = [NSMutableArray arrayWithArray:self.model.data];
        
        if (self.dataArray.count == 0) {
            [self.noDataView showNoDataView:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-NavbarH) type:NoTextType tagStr:@"" needReload:NO reloadBlock:nil];
            [self.tableView addSubview:self.noDataView];
        }else{
            self.noDataView.hidden = YES;
        }
                     
        [self.tableView reloadData];
        
         } Failure:^(NSError *error) {
             
         }];
}


#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExchangeMarketCell *cell = [ExchangeMarketCell exchangeMarketCell:tableView];
    Exchange *model = self.dataArray[indexPath.row];
    model.index = indexPath.row;
    cell.model = model;
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExchangeInfoViewController *infoVC = [[ExchangeInfoViewController alloc] init];
    Exchange *model = self.dataArray[indexPath.row];
    infoVC.exchange = model;
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(47);
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(AdaptY(47)));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - init
- (ExchangeMarketHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ExchangeMarketHeaderView alloc] init];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
