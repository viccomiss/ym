//
//  UserInfoViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/9.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "UserInfoViewController.h"
#import "TitleAndFieldCell.h"
#import "TitleAndImageCell.h"
#import "TitleAndArrowCell.h"
#import "CZHAlertView.h"
#import "EditNickViewController.h"
#import "SEUserDefaults.h"
#import "WXRImagePicker.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* user */
@property (nonatomic, strong) UserModel *user;

@end

@implementation UserInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人资料";
    [self createUI];
}

#pragma mark - request
- (void)editGender:(NSString *)gender{
    [UserModel account_change:@{@"gender" : gender} Success:^(UserModel *user) {
        
        self.user = user;
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
            TitleAndImageCell *cell = [TitleAndImageCell titleAndImageCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            cell.title = @"头像";
            cell.imgSize = CGSizeMake(AdaptX(49), AdaptX(49));
            ViewRadius(cell.imgView, AdaptX(49) / 2);
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.user.avatarUrl] placeholderImage:ImageName(@"icon_placeholder")];
            return cell;
        }
            break;
        case 1:
        {
            TitleAndArrowCell *cell = [TitleAndArrowCell titleAndArrowCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            cell.title = @"用户名";
            cell.placeholder = @"请输入";
            cell.disableField = YES;
            cell.username = self.user;
            return cell;
        }
            break;
        case 2:
        {
            TitleAndArrowCell *cell = [TitleAndArrowCell titleAndArrowCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            cell.title = @"性别";
            cell.placeholder = @"请选择";
            cell.disableField = YES;
            cell.gender = self.user;
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
    WeakSelf(self);
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CGRect cropperRect =  CGRectMake(0, (MAINSCREEN_HEIGHT - MAINSCREEN_WIDTH) / 2, MAINSCREEN_WIDTH, MAINSCREEN_WIDTH);
                        [[WXRImagePicker shareImagePicker]showImagePickerWithCropable:YES cropFrame:cropperRect pickPath:PickImagePathPhotoAndCamera block:^(UIImage *editedImage,NSDictionary *info) {
                            
                            [UserModel account_uploadfile:@{} image:editedImage Success:^(UserModel *user) {
                                
                                self.user = user;
                                [self.tableView reloadData];
                                
                            } Failure:^(NSError *error) {
                                
                            }];
                        }];
                    });
                    
                }
                    break;
                case 1:
                {
                    EditNickViewController *nickVC = [[EditNickViewController alloc] init];
                    [self.navigationController pushViewController:nickVC animated:YES];
                }
                    break;
                case 2:
                {
                    CZHAlertView *alertView = [CZHAlertView czh_alertViewWithTitle:@"请选择您的性别" message:nil preferredStyle:CZHAlertViewStyleActionSheet animationStyle:CZHAlertViewAnimationStyleSlideFromBottom];
                    
                    CZHAlertItem *cancel = [CZHAlertItem czh_itemWithTitle:@"取消" style:CZHAlertItemStyleCancel handler:^(CZHAlertItem *item) {
                        NSLog(@"---点击了");
                    }];
                    CZHAlertItem *man = [CZHAlertItem czh_itemWithTitle:@"男" titleColor:[self.user.gender isEqualToString:@"MAN"] ? MainYellowColor : WhiteTextColor style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
                        if ([self.user.gender isEqualToString:@"MAN"]) {
                            return;
                        }
                        [weakself editGender:@"MAN"];
                    }];
                    CZHAlertItem *women = [CZHAlertItem czh_itemWithTitle:@"女" titleColor:[self.user.gender isEqualToString:@"MAN"] ? WhiteTextColor : MainYellowColor style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
                        if ([self.user.gender isEqualToString:@"WOMAN"]) {
                            return;
                        }
                        [weakself editGender:@"WOMAN"];
                    }];
                    [alertView czh_addAlertItem:cancel];
                    [alertView czh_addAlertItem:man];
                    [alertView czh_addAlertItem:women];
                    [alertView czh_showView];
                }
                    break;
            }
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return AdaptY(70);
    }
    return AdaptY(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(20);
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
