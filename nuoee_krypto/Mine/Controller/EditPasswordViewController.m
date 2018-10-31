//
//  EditPasswordViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "LoginView.h"
#import "SEUserDefaults.h"
#import "UserModel.h"

@interface EditPasswordViewController ()<loginViewDelegate>

/* loginView */
@property (nonatomic, strong) LoginView *loginView;
/* user */
@property (nonatomic, strong) UserModel *user;

@end

@implementation EditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    self.title = self.user.hasPassword ? @"修改密码" : @"设置密码";

    [self createUI];
}

- (void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - init
- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc] initWithLoginType:self.user.hasPassword ? LoginEditPasswordType : LoginSetPasswordType];
        _loginView.delegate = self;
    }
    return _loginView;
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
