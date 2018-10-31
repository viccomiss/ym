//
//  PasswordLoginViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "PasswordLoginViewController.h"
#import "LoginView.h"
#import "FindPasswordViewController.h"

@interface PasswordLoginViewController ()<loginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation PasswordLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [SENotificationCenter addObserver:self selector:@selector(loginSuccess) name:LOGINSUCCESS object:nil];
}

#pragma mark - login delegate
- (void)loginSuccess{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loginViewLeftTouch{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginViewRightTouch{
    FindPasswordViewController *findVC = [[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
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
        _loginView = [[LoginView alloc] initWithLoginType:LoginPasswordType];
        _loginView.delegate = self;
    }
    return _loginView;
}

- (void)dealloc{
    [SENotificationCenter removeObserver:self];
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
