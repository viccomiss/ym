//
//  WarnViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/13.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "WarnViewController.h"
#import "TitleAndArrowCell.h"
#import "TitleAndSwitchCell.h"
#import "WarnListViewController.h"
#import "WarnSettingViewController.h"
#import "WarnModeViewController.h"
#import "SEUserDefaults.h"
#import "UserModel.h"

@interface WarnViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* user */
@property (nonatomic, strong) UserModel *user;


@end

@implementation WarnViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"预警中心";
    
    [self createUI];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 1) {
//        return 2;
//    }
//    else if (section == 2){
//        return 2;
//    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
//        case 0:
//        {
//            TitleAndArrowCell *cell = [TitleAndArrowCell titleAndArrowCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
//            cell.title = @"预警模式";
//            if (self.user.ring && self.user.vibrate) {
//                cell.placeholder = @"声音+震动";
//            }else if (self.user.ring && !self.user.vibrate){
//                cell.placeholder = @"声音";
//            }else if (!self.user.ring && self.user.vibrate){
//                cell.placeholder = @"震动";
//            }else if (!self.user.ring && !self.user.vibrate){
//                cell.placeholder = @"";
//            }
//            cell.disableField = YES;
//            return cell;
//        }
//            break;
//        case 1:
//        {
//            switch (indexPath.row) {
//                case 0:
//                {
//                    TitleAndSwitchCell *cell = [TitleAndSwitchCell titleAndSwitchCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
//                    cell.title = @"APP推送";
//                    return cell;
//                }
//                    break;
//                case 1:
//                {
//                    TitleAndSwitchCell *cell = [TitleAndSwitchCell titleAndSwitchCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
//                    cell.title = @"电话推送";
//                    return cell;
//                }
//                    break;
//                case 2:
//                {
//                    TitleAndSwitchCell *cell = [TitleAndSwitchCell titleAndSwitchCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
//                    cell.title = @"短信推送";
//                    return cell;
//                }
//                    break;
//            }
//        }
//            break;
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    TitleAndArrowCell *cell = [TitleAndArrowCell titleAndArrowCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
                    cell.title = @"未触发预警";
//                    cell.placeholder = @"2条";
                    cell.disableField = YES;
                    return cell;
                }
                    break;
                case 1:
                {
                    TitleAndArrowCell *cell = [TitleAndArrowCell titleAndArrowCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
                    cell.title = @"历史预警";
//                    cell.placeholder = @"3条";
                    cell.disableField = YES;
                    return cell;
                }
                    break;
            }
        }
            break;
    }
    return nil;
}

#pragma mark - tableview delagte
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
//        case 0:
//        {
//            WarnModeViewController *modeVC = [[WarnModeViewController alloc] init];
//            [self.navigationController pushViewController:modeVC animated:YES];
//        }
//            break;
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    WarnListViewController *warnVC = [[WarnListViewController alloc] init];
                    warnVC.type = WarnUnTriggerType;
                    [self.navigationController pushViewController:warnVC animated:YES];
                }
                    break;
               case 1:
                {
                    WarnListViewController *warnVC = [[WarnListViewController alloc] init];
                    warnVC.type = WarnTriggerType;
                    [self.navigationController pushViewController:warnVC animated:YES];
                }
                    break;
            }
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(50);
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
