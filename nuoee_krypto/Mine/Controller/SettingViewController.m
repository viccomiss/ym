//
//  SettingViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "SettingViewController.h"
#import "TitleAndArrowCell.h"
#import "EditPhoneViewController.h"
#import "EditPasswordViewController.h"
#import "SEUserDefaults.h"
#import "UserModel.h"
#import "ProgressTableViewCell.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* user */
@property (nonatomic, strong) UserModel *user;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"设置";
    [self createUI];
    [self getCacheSize];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    [self.tableView reloadData];
}

#pragma mark - request
- (void)logout{
    
    JKAlert *alert= [JKAlert alertWithTitle:@"是否退出登录？" andMessage:@""];
    [alert addCancleButtonWithTitle:@"取消" handler:^(JKAlertItem *item) {
    }];
    [alert addCommonButtonWithTitle:@"确认" handler:^(JKAlertItem *item) {
        
        [APIManager loginFailure:YES];
    }];
    [alert show];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            TitleAndArrowCell *cell = [TitleAndArrowCell titleAndArrowCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            cell.title = @"修改手机号";
            cell.showField = NO;
            return cell;
        }
            break;
        case 1:
        {
            TitleAndArrowCell *cell = [TitleAndArrowCell titleAndArrowCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            cell.title = self.user.hasPassword ? @"修改密码" : @"设置密码";
            cell.showField = NO;
            return cell;
        }
            break;
        case 2:
        {
//            TitleAndArrowCell *cell = [TitleAndArrowCell titleAndArrowCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
//            cell.title = @"清除缓存";
//            cell.placeholder = @"0.00M";
//            cell.disableField = YES;
//            return cell;
            
            ProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            if (!cell) {
                cell = [[ProgressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            }
            cell.title = @"清除缓存";
            return cell;
        }
            break;
        case 3:
        {
            BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginOutCellId"];
            if (!cell) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loginOutCellId"];
            }
            BaseLabel *loginOutLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:MainYellowColor textAlignment:NSTextAlignmentCenter];
            loginOutLabel.text = @"退出登录";
            [cell.contentView addSubview:loginOutLabel];
            [loginOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell.contentView);
            }];
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

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            EditPhoneViewController *editPhoneVC = [[EditPhoneViewController alloc] init];
            [self.navigationController pushViewController:editPhoneVC animated:YES];
        }
            break;
        case 1:
        {
            EditPasswordViewController *editPWVC = [[EditPasswordViewController alloc] init];
            [self.navigationController pushViewController:editPWVC animated:YES];
        }
            break;
        case 2:
        {
            ProgressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.clearDone = NO;
            [self clearCache];
        }
            break;
        case 3:
        {
            [self logout];
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

//获取缓存
-(void)getCacheSize{
    dispatch_queue_t queue = dispatch_queue_create("getCache", DISPATCH_QUEUE_SERIAL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(queue, ^{
            float tmpSize = [[SDImageCache sharedImageCache]getSize];
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue, ^{
                ProgressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                cell.cacheSize = [NSString stringWithFormat:@"%.2fM",tmpSize/1000.0/1000];
            });
        });
        
    });
}
//清理缓存
-(void)clearCache{
    dispatch_queue_t queue = dispatch_queue_create("clearCache", DISPATCH_QUEUE_SERIAL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //图片缓存
        dispatch_async(queue, ^{
            
            [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    ProgressTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                    cell.cacheSize = [NSString stringWithFormat:@"%.2fM",(unsigned long)[[SDImageCache sharedImageCache]getSize]/1000.0/1000];
                    cell.clearDone = YES;
                });
                
            }];
        });
        
        //浏览器缓存
        dispatch_async(queue, ^{
            //清除cookies
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies]){
                [storage deleteCookie:cookie];
            }
            //清除UIWebView的缓存
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            NSURLCache * cache = [NSURLCache sharedURLCache];
            [cache removeAllCachedResponses];
            [cache setDiskCapacity:0];
            [cache setMemoryCapacity:0];
            
        });
    });
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
