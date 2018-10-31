//
//  MineViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationControllerKit.h"
#import "MineHeaderView.h"
#import "MineCell.h"
#import "MineModel.h"
#import "UserInfoViewController.h"
#import "SettingViewController.h"
#import "UserModel.h"
#import "SEUserDefaults.h"
#import "MessageCenterViewController.h"
#import "WarnViewController.h"
#import "ShareFlashViewController.h"
#import "RiseAndFallViewController.h"
#import "PushManagerViewController.h"
#import "AboutUsViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* header */
@property (nonatomic, strong) MineHeaderView *headerView;
/* suer */
@property (nonatomic, strong) UserModel *user;


@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadUser];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self setData];
//    [SENotificationCenter addObserver:self selector:@selector(loginSuccess) name:LOGINSUCCESS object:nil];
//    [SENotificationCenter addObserver:self selector:@selector(logoutSuccess) name:LOGOUTSUCCESS object:nil];
}

- (void)setData{
    NSMutableArray *arr1 = [NSMutableArray array];
    NSArray *iconArr1 = @[@"mine_message",@"mine_warn"];
    NSArray *nameArr1 = @[@"消息中心",@"预警中心"];
    NSArray *type1 = @[[NSNumber numberWithUnsignedInteger:MineMessageTagCellType], [NSNumber numberWithUnsignedInteger:MineNormalCellType]];
    for (int i = 0; i < nameArr1.count; i++) {
        MineModel *model = [[MineModel alloc] init];
        model.icon = iconArr1[i];
        model.name = nameArr1[i];
        model.type = [type1[i] integerValue];
        [arr1 addObject:model];
    }
    
    NSMutableArray *arr2 = [NSMutableArray array];
    NSArray *iconArr2 = @[@"mine_zhangdie",@"mine_push",@"mine_about"]; //@"mine_mode",
    NSArray *nameArr2 = @[@"涨跌颜色",@"推送管理",@"关于我们"]; //@"夜间模式",
    NSArray *type2 = @[[NSNumber numberWithUnsignedInteger:MineSummaryCellType],[NSNumber numberWithUnsignedInteger:MineNormalCellType], [NSNumber numberWithUnsignedInteger:MineNormalCellType]]; //[NSNumber numberWithUnsignedInteger:MineSwitchCellType],
    for (int i = 0; i < nameArr2.count; i++) {
        MineModel *model = [[MineModel alloc] init];
        model.name = nameArr2[i];
        model.icon = iconArr2[i];
        model.type = [type2[i] integerValue];
        [arr2 addObject:model];
    }
    
    [self.dataArray addObject:arr1];
    [self.dataArray addObject:arr2];
    [self.tableView reloadData];
}

- (void)reloadUser{
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    self.headerView.user = self.user;
    
    NSArray *arr = self.dataArray[1];
    MineModel *m = arr[0];
    m.summary = self.user.markColor ? @"红涨绿跌" : @"绿涨红跌";
    [self.tableView reloadData];
    
    if (self.user.token != nil) {
        [self messageNum];
    }
}

//消息红点数
- (void)messageNum{
    
    [UserModel account_initcontent:@{} Success:^(NSDictionary *item) {
        
        NSArray *arr = self.dataArray[0];
        MineModel *m = arr[0];
        m.notReadCount = [item jk_integerForKey:@"notReadCount"];
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCell *cell = [MineCell mineCell:tableView];
    NSArray *arr = self.dataArray[indexPath.section];
    cell.model = arr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(20))];
    view.backgroundColor = MainBlackColor;
    return view;
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(20);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 0)) {
        if (self.user.token == nil) {
            [self login];
            return;
        }
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    MessageCenterViewController *messageCenterVC = [[MessageCenterViewController alloc] init];
                    [self.navigationController pushViewController:messageCenterVC animated:YES];
                }
                    break;
                case 1:
                {
                    WarnViewController *warnVC = [[WarnViewController alloc] init];
                    [self.navigationController pushViewController:warnVC animated:YES];
                }
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    RiseAndFallViewController *riseOrFallVC = [[RiseAndFallViewController alloc] init];
                    [self.navigationController pushViewController:riseOrFallVC animated:YES];
                }
                    break;
                case 1:
                {
                    PushManagerViewController *managerVC = [[PushManagerViewController alloc] init];
                    [self.navigationController pushViewController:managerVC animated:YES];
                }
                    break;
                case 2:
                {
                    AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
                    [self.navigationController pushViewController:aboutUsVC animated:YES];
                }
                    break;
            }
        }
            break;
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    
    WeakSelf(self);
    self.headerView.userInfoBlock = ^(){
        UserInfoViewController *userVC = [[UserInfoViewController alloc] init];
        [weakself.navigationController pushViewController:userVC animated:YES];
    };
    self.headerView.loginBlock = ^(){
        [weakself login];
    };
    self.headerView.settingBlock = ^(){
        SettingViewController *setVC = [[SettingViewController alloc] init];
        [weakself.navigationController pushViewController:setVC animated:YES];
    };
}

- (void)login{
    dispatch_async(dispatch_get_main_queue(), ^{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        BaseNavigationController *loginNav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNav animated:YES completion:nil];
    });
}

#pragma mark - init
- (MineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] init];
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
