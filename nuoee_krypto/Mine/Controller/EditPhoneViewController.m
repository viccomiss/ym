//
//  EditPhoneViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/9.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "EditPhoneViewController.h"
#import "LoginView.h"

@interface EditPhoneViewController ()<loginViewDelegate>

/* loginView */
@property (nonatomic, strong) LoginView *loginView;

@end

@implementation EditPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"修改手机号";
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
        _loginView = [[LoginView alloc] initWithLoginType:LoginEditPhoneType];
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
