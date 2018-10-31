//
//  WarnModeViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/20.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "WarnModeViewController.h"
#import "TitleAndSwitchCell.h"
#import "UserModel.h"
#import "SEUserDefaults.h"

@interface WarnModeViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* ring */
@property (nonatomic, copy) NSString *ring;
/* vibrate */
@property (nonatomic, copy) NSString *vibrate;
/* user */
@property (nonatomic, strong) UserModel *user;


@end

@implementation WarnModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"预警模式";
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    self.ring = self.user.ring ? @"1" : @"0";
    self.vibrate = self.user.vibrate ? @"1" : @"0";
    
    [self createUI];
}

#pragma mark - action
- (void)doneTouch{

    [UserModel alerts_style:@{@"ring" : self.ring, @"vibrate": self.vibrate} Success:^(UserModel *item) {
        
        self.user = item;
        [SEHUD showAlertWithText:@"保存成功"];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self);
    switch (indexPath.row) {
        case 0:
        {
            TitleAndSwitchCell *cell = [TitleAndSwitchCell titleAndSwitchCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            cell.title = @"声音";
            cell.isOn = self.user.ring;
            cell.switchBlock = ^(BOOL tag) {
                weakself.ring = tag ? @"1" : @"0";
            };
            return cell;
        }
            break;
        case 1:
        {
            TitleAndSwitchCell *cell = [TitleAndSwitchCell titleAndSwitchCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            cell.title = @"震动";
            cell.isOn = self.user.vibrate;
            cell.switchBlock = ^(BOOL tag) {
                weakself.vibrate = tag ? @"1" : @"0";
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
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(doneTouch)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
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
