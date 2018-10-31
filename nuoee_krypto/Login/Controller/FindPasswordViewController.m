//
//  FindPasswordViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "LoginView.h"

@interface FindPasswordViewController ()<loginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [SENotificationCenter addObserver:self selector:@selector(findSuccess) name:FINDPASSWORDSUCCESS object:nil];
}

- (void)findSuccess{
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
        _loginView = [[LoginView alloc] initWithLoginType:LoginFindPasswordType];
        _loginView.delegate = self;
    }
    return _loginView;
}

- (void)dealloc{
    [SENotificationCenter removeObserver:FINDPASSWORDSUCCESS];
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
