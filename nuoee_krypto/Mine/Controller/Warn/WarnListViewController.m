//
//  WarnListViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/13.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "WarnListViewController.h"
#import "WarnCell.h"
#import "Warn.h"

@interface WarnListViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WarnListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.type == WarnTriggerType ? @"历史预警" : @"未触发预警";
    [self createUI];
    [self setRefresh];
}

#pragma mark - request
-(void)setRefresh{
    [[SERefresh sharedSERefresh] normalModelRefresh:self.tableView refreshType:RefreshTypeDropDown firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self loadDataWithLoadMore:NO];
    } upDropBlock:nil];
}

-(void)loadDataWithLoadMore:(BOOL)isMore{
    
    [Warn alerts_historyWithType:self.type param:@{} Success:^(NSArray *item) {
        
        [self.tableView.mj_header endRefreshing];
        self.dataArray = [NSMutableArray arrayWithArray:item];
        
        if (self.dataArray.count == 0) {
            [self.noDataView showNoDataView:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-NavbarH) type:self.type == WarnTriggerType ? NoHistoryType : NoUnWarnType tagStr:@"" needReload:NO reloadBlock:nil];
            [self.tableView addSubview:self.noDataView];
        }else{
            self.noDataView.hidden = YES;
        }
        
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}

- (void)delWarnWithId:(NSString *)Id index:(NSInteger)index{
    
    [EasyLoadingView showLoading];
    [Warn alerts_delsingle:@{@"id": Id} Success:^(NSString *item) {
        
        if ([item isEqualToString:@"10000"]) {
            [SEHUD showAlertWithText:@"删除成功"];
            [self.dataArray removeObjectAtIndex:index];
            [self.tableView reloadData];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

- (void)clearTouch{
    
    WeakSelf(self);
    JKAlert *alert= [JKAlert alertWithTitle:@"提示信息" andMessage:@"您确定全部清除吗?"];
    [alert addCommonButtonWithTitle:@"确定" handler:^(JKAlertItem *item) {
        
        [EasyLoadingView showLoading];
        [Warn alerts_delAll_history:@{} Success:^(NSString *item) {
            
            if ([item isEqualToString:@"10000"]) {
                [SEHUD showAlertWithText:@"删除成功"];
                [weakself.dataArray removeAllObjects];
                [weakself.tableView reloadData];
            }
            
        } Failure:^(NSError *error) {
            
        }];
    }];
    [alert addCancleButtonWithTitle:@"取消" handler:^(JKAlertItem *item) {
    }];
    [alert show];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self);
    WarnCell *cell = [WarnCell warnCell:tableView];
    Warn *model = self.dataArray[indexPath.section];
    model.warnType = self.type;
    cell.model = model;
    cell.closeBlock = ^(){
        [weakself delWarnWithId:model.ID index:indexPath.section];
    };
    return cell;
}

#pragma mark - tableview delagte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.type == WarnUnTriggerType ? AdaptY(132) : AdaptY(157);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(20))];
    return view;
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    if (self.type == WarnTriggerType) {
        UIBarButtonItem *clearAll = [[UIBarButtonItem alloc] initWithTitle:@"全部清除" style:UIBarButtonItemStyleDone target:self action:@selector(clearTouch)];
        self.navigationItem.rightBarButtonItem = clearAll;
    }
}

#pragma mark - init
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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
