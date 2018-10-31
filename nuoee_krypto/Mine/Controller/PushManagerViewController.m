//
//  PushManagerViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "PushManagerViewController.h"
#import "AppInfo.h"

@interface PushManagerViewController ()

/* view */
@property (nonatomic, strong) UIView *topView;
/* label */
@property (nonatomic, strong) BaseLabel *titleLabel;
/* switch */
@property (nonatomic, strong) UISwitch *pushSwitch;
/* detail */
@property (nonatomic, strong) BaseLabel *summaryLabel;


@end

@implementation PushManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"推送管理";
    [self createUI];
    [SENotificationCenter addObserver:self selector:@selector(viewAppear) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewAppear{
    [self.pushSwitch setOn:[AppInfo isUserNotificationEnable] animated:YES];
}

#pragma mark - action
- (void)switchIsChanged:(UISwitch *)sender{
    [AppInfo goToAppSystemSetting];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH + AdaptY(20));
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(AdaptY(50)));
    }];
    
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView.mas_left).offset(AdaptX(20));
        make.top.bottom.mas_equalTo(self.topView);
    }];
    
    [self.topView addSubview:self.pushSwitch];
    [self.pushSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView.mas_right).offset(-AdaptX(20));
        make.centerY.mas_equalTo(self.topView.mas_centerY);
    }];
    
    [self.view addSubview:self.summaryLabel];
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(MidPadding);
        make.left.mas_equalTo(self.view.mas_left).offset(AdaptX(20));
        make.right.mas_equalTo(self.view.mas_right).offset(-AdaptX(20));
    }];
}

#pragma mark - init
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = MainDarkColor;
    }
    return _topView;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [SEFactory labelWithText:@"接收新消息通知" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UISwitch *)pushSwitch{
    if (!_pushSwitch) {
        _pushSwitch = [[UISwitch alloc] init];
        _pushSwitch.onTintColor = MainYellowColor;
        [_pushSwitch setTintColor:TextDarkGrayColor];
        [_pushSwitch setOn:[AppInfo isUserNotificationEnable] animated:YES];
        [_pushSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pushSwitch;
}

- (BaseLabel *)summaryLabel{
    if (!_summaryLabel) {
        _summaryLabel = [SEFactory labelWithText:@"请在iPhone的“设置”－“通知”－“快比特”中进行设置是否接收新消息通知。" frame:CGRectZero textFont:Font(14) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
        _summaryLabel.numberOfLines = 0;
    }
    return _summaryLabel;
}

- (void)dealloc{
    [SENotificationCenter removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
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
