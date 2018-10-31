//
//  MessageCenterViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/12.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageNormalCell.h"
#import "MessageModel.h"
#import "WXRWebViewController.h"
#import "UserModel.h"
#import "SEUserDefaults.h"

@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* user */
@property (nonatomic, strong) UserModel *user;

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"消息中心";
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    [self createUI];
    [self setRefresh];
}

#pragma mark - action
- (void)deletTouch{
    
    WeakSelf(self);
    JKAlert *alert= [JKAlert alertWithTitle:@"提示信息" andMessage:@"您确定全部清除吗?"];
    [alert addCommonButtonWithTitle:@"确定" handler:^(JKAlertItem *item) {
        
        [EasyLoadingView showLoading];
        [MessageModel mes_center_delete_all:@{} Success:^(NSString *item) {
            
            if ([item isEqualToString:@"10000"]) {
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

#pragma mark - request
-(void)setRefresh{
    [[SERefresh sharedSERefresh] normalModelRefresh:self.tableView refreshType:RefreshTypeDropDown firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self loadDataWithLoadMore:NO];
    } upDropBlock:nil];
}

-(void)loadDataWithLoadMore:(BOOL)isMore{
    [MessageModel mes_center:@{} Success:^(MessageModel *item) {
        
        [self.tableView.mj_header endRefreshing];
        self.dataArray = [NSMutableArray arrayWithArray:item.mesCenters];
        
        if (self.dataArray.count == 0) {
            [self.noDataView showNoDataView:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-NavbarH) type:NoMessageType tagStr:@"" needReload:NO reloadBlock:nil];
            [self.tableView addSubview:self.noDataView];
        }else{
            self.noDataView.hidden = YES;
        }
        
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageNormalCell *cell = [MessageNormalCell messageNormalCell:tableView];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}

#pragma mark - tableview delagte
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Message *m = self.dataArray[indexPath.section];
    m.read = YES;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    WXRWebViewController *webVC = [[WXRWebViewController alloc] init];
    webVC.url = [NSString stringWithFormat:@"%@%@?accountId=%@",H5_MES_CENTER,m.ID,self.user.accountId];;
    webVC.dataFrom = WXRWebViewControllerDataFromMessage;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //实现删除操作
    Message *model = self.dataArray[indexPath.section];
    
    //删除数据，和删除动画
    [EasyLoadingView showLoading];
    [Message mes_center_delete_id:@{@"mesCenterId" : model.ID} Success:^(id item) {
        
        if ([[item jk_stringForKey:@"code"] isEqualToString:@"10000"]) {
            [self.dataArray removeObject:model];
            [self.tableView reloadData];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  AdaptY(126);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(20);
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
    
    UIBarButtonItem *delItem = [[UIBarButtonItem alloc] initWithTitle:@"全部删除" style:UIBarButtonItemStylePlain target:self action:@selector(deletTouch)];
    self.navigationItem.rightBarButtonItem = delItem;
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
