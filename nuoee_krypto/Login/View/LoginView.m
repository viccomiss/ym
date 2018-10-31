//
//  LoginView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "LoginView.h"
#import "UnderLineTextField.h"
#import "AreaPhoneHeaderView.h"
#import "UserModel.h"
#import "WXRWebViewController.h"
#import "CommonUtils.h"
#import "SEUserDefaults.h"

#define LINEHEIGHT AdaptY(46)

@interface LoginView()

@property (nonatomic, strong) BaseImageView *bgView;
@property (nonatomic, strong) BaseLabel *topTagLabel;
@property (nonatomic, strong) BaseLabel *detailLabel;
@property (nonatomic, strong) UnderLineTextField *phoneField;
@property (nonatomic, strong) UnderLineTextField *passwordField;
@property (nonatomic, strong) UnderLineTextField *codeField;
@property (nonatomic, strong) BaseButton *loginBtn;
@property (nonatomic, strong) BaseButton *leftBtn;
@property (nonatomic, strong) BaseButton *rightBtn;
@property (nonatomic, strong) BaseButton *clauseBtn;
@property (nonatomic, assign) LoginType type;
@property (nonatomic, strong) BaseButton *timeBtn;

//修改手机号
/* 当前绑定 */
@property (nonatomic, strong) BaseLabel *phoneTag;
/* phone */
@property (nonatomic, strong) BaseLabel *currentPhone;

//修改密码
@property (nonatomic, strong) UnderLineTextField *inputPWField;
@property (nonatomic, strong) UnderLineTextField *confirmNewField;
/* user */
@property (nonatomic, strong) UserModel *user;

@end

@implementation LoginView

- (instancetype)initWithLoginType:(LoginType)type{
    if (self == [super init]) {
        
        self.type = type;
        self.backgroundColor = MainBlackColor;
        [self createUI];
    }
    return self;
}

#pragma mark - action
- (void)loginTouch:(BaseButton *)sender{
    
    if (self.type != LoginEditPasswordType && self.type != LoginSetPasswordType) {
        if (![self checkPhone]) return;
    }
    
    switch (self.type) {
        case LoginCodeType:
        {
            if (![self checkCode]) return;
            
            [EasyLoadingView showLoading];
            [UserModel login:@{@"phone": self.phoneField.text, @"captcha" : self.codeField.text, @"deviceToken" : [[SEUserDefaults shareInstance] getDeviceToken], @"pusherType" : @"IOS"} Success:^(UserModel *responeObject) {
                
                [SENotificationCenter postNotificationName:LOGINSUCCESS object:nil];
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        case LoginPasswordType:
        {
            if (![self checkPassword]) return;
            
            [EasyLoadingView showLoading];
            [UserModel login:@{@"phone": self.phoneField.text, @"password" : self.passwordField.text, @"deviceToken" : [[SEUserDefaults shareInstance] getDeviceToken], @"pusherType" : @"IOS"} Success:^(UserModel *responeObject) {
                
                [SENotificationCenter postNotificationName:LOGINSUCCESS object:nil];
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        case LoginFindPasswordType:
        {
            if (![self checkPassword]) return;

            if (![self checkCode]) return;

            [EasyLoadingView showLoading];
            [UserModel retrievePassword:@{@"phone": self.phoneField.text, @"password" : self.passwordField.text, @"captcha": self.codeField.text} Success:^(UserModel *responeObject) {
                
                [SEHUD showAlertWithText:@"修改成功,请重新登录"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(dismiss)]) {
                        [self.delegate dismiss];
                    }
                });
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        case LoginEditPhoneType:
        {
            if (![self checkCode]) return;
            
            [EasyLoadingView showLoading];
            [UserModel changePhone:@{@"phone" : self.phoneField.text, @"captcha" : self.codeField.text} Success:^(UserModel *user) {
                
                [SEHUD showAlertWithText:@"修改成功"];
                self.user = user;
                self.currentPhone.text = self.user.cell;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(dismiss)]) {
                        [self.delegate dismiss];
                    }
                });
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        case LoginEditPasswordType:
        {
            if (![self checkCode]) return;

            if (![self checkNewPassword]) return;

            if (![self checkConfirmPassword]) return;

            if (![self.inputPWField.text isEqualToString:self.confirmNewField.text]) {
                [SEHUD showAlertWithText:@"两次输入密码不一致"];
                return;
            }
            
            [EasyLoadingView showLoading];
            [UserModel changePassword:@{@"phone": self.user.cell, @"captcha" : self.codeField.text, @"password": self.inputPWField.text, @"repassword": self.confirmNewField.text} Success:^(UserModel *user) {
                
                [SEHUD showAlertWithText:@"修改成功"];
                self.user = user;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(dismiss)]) {
                        [self.delegate dismiss];
                    }
                });
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        case LoginSetPasswordType:
        {
            if (![self checkNewPassword]) return;
            
            if (![self checkConfirmPassword]) return;
            
            if (![self.inputPWField.text isEqualToString:self.confirmNewField.text]) {
                [SEHUD showAlertWithText:@"两次输入密码不一致"];
                return;
            }
            
            [EasyLoadingView showLoading];
            [UserModel changePassword:@{@"password": self.inputPWField.text, @"repassword": self.confirmNewField.text} Success:^(UserModel *user) {
                
                [SEHUD showAlertWithText:@"设置成功"];
                self.user = user;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(dismiss)]) {
                        [self.delegate dismiss];
                    }
                });
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - check
- (BOOL)checkPhone{
    if (self.phoneField.text.length == 0) {
        [SEHUD showAlertWithText:@"手机号码不能为空"];
        return NO;
    }
    
    if (self.phoneField.text.length != 11) {
        [SEHUD showAlertWithText:@"请填写正确的手机号"];
        return NO;
    }
    return YES;
}

- (BOOL)checkCode{
    if (self.codeField.text.length == 0) {
        [SEHUD showAlertWithText:@"验证码不能为空"];
        return NO;
    }
    if (self.codeField.text.length != 6) {
        [SEHUD showAlertWithText:@"请填写正确的验证码"];
        return NO;
    }
    return YES;
}

- (BOOL)checkPassword{
    if (self.passwordField.text.length == 0) {
        [SEHUD showAlertWithText:@"密码不能为空"];
        return NO;
    }
    if (self.passwordField.text.length < 6 || self.passwordField.text.length > 25) {
        if (self.type == LoginPasswordType) {
            [SEHUD showAlertWithText:@"密码错误"];
        }else{
            [SEHUD showAlertWithText:@"密码长度为6-25之间"];
        }
        return NO;
    }
    return YES;
}

- (BOOL)checkNewPassword{
    if (self.inputPWField.text.length == 0) {
        [SEHUD showAlertWithText:@"密码不能为空"];
        return NO;
    }
    if (self.inputPWField.text.length < 6 || self.passwordField.text.length > 25) {
        [SEHUD showAlertWithText:@"密码长度为6-25之间"];
        return NO;
    }
    return YES;
}

- (BOOL)checkConfirmPassword{
    if (self.confirmNewField.text.length == 0) {
        [SEHUD showAlertWithText:@"密码不能为空"];
        return NO;
    }
    if (self.confirmNewField.text.length < 6 || self.passwordField.text.length > 25) {
        [SEHUD showAlertWithText:@"密码长度为6-25之间"];
        return NO;
    }
    return YES;
}

#pragma mark - action
- (void)leftTouch:(BaseButton *)sender{
    if ([self.delegate respondsToSelector:@selector(loginViewLeftTouch)]) {
        [self.delegate loginViewLeftTouch];
    }
}

- (void)rightTouch:(BaseButton *)sender{
    if ([self.delegate respondsToSelector:@selector(loginViewRightTouch)]) {
        [self.delegate loginViewRightTouch];
    }
}

- (void)clauseTouch{
    WXRWebViewController *webVC = [[WXRWebViewController alloc] init];
    webVC.dataFrom = WXRWebViewControllerDataFromAgreenment;
    [[CommonUtils currentViewController].navigationController pushViewController:webVC animated:YES];
}

- (void)closeTouch{
    if ([self.delegate respondsToSelector:@selector(dismiss)]) {
        [self.delegate dismiss];
    }
}

- (void)seePassword:(BaseButton *)sender{
    sender.selected = !sender.selected;
    self.passwordField.secureTextEntry = !sender.selected;
}

- (void)timeTouch:(BaseButton *)sender{
    
    if (self.type == LoginEditPhoneType || self.type == LoginEditPasswordType) {
        
        if (self.type == LoginEditPhoneType) {
            if (![self checkPhone]) return;
        }
        
        //修改
        [UserModel send_updateMessage:@{@"businessType" : self.type == LoginEditPhoneType ? @"UPDATECELL" : @"UPDATEPW", @"phone": self.type == LoginEditPhoneType ? self.phoneField.text : self.user.cell} Success:^(NSString *code) {
            
            if ([code isEqualToString:@"10000"]) {
                [SEHUD showAlertWithText:@"发送验证码成功"];
            }
            
        } Failure:^(NSError *error) {
            
        }];
        
    }else{
        
        if (![self checkPhone]) return;
        
        //发送验证码
        [UserModel send_message:@{@"phone": self.phoneField.text, @"businessType": self.type == LoginCodeType ? @"LOGIN" : @"FORGETPW"} Success:^(UserModel *user) {
            
            
            
        } Failure:^(NSError *error) {
            
        }];
    }
    
    __block int timeout = 119; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                [self.timeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                //设置不可点击
                self.timeBtn.userInteractionEnabled = YES;
                [self.timeBtn setTitleColor:MainYellowColor forState:UIControlStateNormal];
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [self.timeBtn setTitle:[NSString stringWithFormat:@"%@s后重试",strTime] forState:UIControlStateNormal];
                self.timeBtn.userInteractionEnabled = NO;
                [self.timeBtn setTitleColor:TextDarkGrayColor forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - UI
- (void)createUI{
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    
    switch (self.type) {
        case LoginCodeType:
        {
            [self addLoginLayer];
            
            BaseButton *close = [SEFactory buttonWithImage:ImageName(@"close_white")];
            [close addTarget:self action:@selector(closeTouch) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:close];
            [close mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_top).offset(ISIPHONE_X_S ? NavbarH - StatusBarH : StatusBarH + MinPadding);
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
                make.size.mas_equalTo(CGSizeMake(AdaptX(44), AdaptX(44)));
            }];
            
            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.detailLabel);
                make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(AdaptY(30));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.codeField];
            [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.codeField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(AdaptY(46)));
            }];
            
            [self addSubview:self.leftBtn];
            [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.loginBtn.mas_left);
                make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(MidPadding);
            }];
            
            [self addSubview:self.clauseBtn];
            [self.clauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mas_bottom).offset(-AdaptY(30));
                make.left.right.mas_equalTo(self);
            }];
            
            self.topTagLabel.text = @"登录快比特";
            self.detailLabel.text = @"验证码登录，未注册用户账号将自动创建";
            [self.leftBtn setTitle:@"密码登录" forState:UIControlStateNormal];
        }
            break;
        case LoginPasswordType:
        {
            [self addLoginLayer];

            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.detailLabel);
                make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(AdaptY(30));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            
            [self addSubview:self.passwordField];
            [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.passwordField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(AdaptY(46)));
            }];
            
            [self addSubview:self.leftBtn];
            [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.loginBtn.mas_left);
                make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(MidPadding);
            }];
            
            [self addSubview:self.rightBtn];
            [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.loginBtn.mas_right);
                make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(MidPadding);
            }];
            
            [self addSubview:self.clauseBtn];
            [self.clauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mas_bottom).offset(-AdaptY(30));
                make.left.right.mas_equalTo(self);
            }];

            
            self.passwordField.placeholder = @"请输入密码";
            self.topTagLabel.text = @"登录快比特";
            self.detailLabel.text = @"请使用密码登录账户";
            [self.leftBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        }
            break;
        case LoginFindPasswordType:
        {
            [self addLoginLayer];

            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.detailLabel);
                make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(AdaptY(30));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.passwordField];
            [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.codeField];
            [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.passwordField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.codeField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            self.phoneField.text = self.user.cell.length != 0 ? self.user.cell : @"";
            self.passwordField.placeholder = @"新密码（6-25位数字字母）";
            self.topTagLabel.text = @"找回密码";
            self.detailLabel.text = @"请输入新密码并验证手机号";
            [self.loginBtn setTitle:@"重置密码" forState:UIControlStateNormal];
        }
            break;
            case LoginEditPhoneType:
        {
            [self addEditLayer];
            
            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(40));
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(40));
                make.top.mas_equalTo(self.currentPhone.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.codeField];
            [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.codeField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(AdaptY(46)));
            }];
            
            self.phoneField.placeholder = @"请输入新手机号";
            [self.loginBtn setTitle:@"确认修改" forState:UIControlStateNormal];
            self.currentPhone.text = self.user.cell;

        }
            break;
            case LoginEditPasswordType:
        {
            [self addEditLayer];
            
            [self addSubview:self.codeField];
            [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(40));
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(40));
                make.top.mas_equalTo(self.currentPhone.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.inputPWField];
            [self.inputPWField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.codeField);
                make.top.mas_equalTo(self.codeField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.confirmNewField];
            [self.confirmNewField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.codeField);
                make.top.mas_equalTo(self.inputPWField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.codeField);
                make.top.mas_equalTo(self.confirmNewField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(AdaptY(46)));
            }];
            
            [self.loginBtn setTitle:@"修改密码" forState:UIControlStateNormal];
            self.currentPhone.text = self.user.cell;
        }
            break;
        case LoginSetPasswordType:
        {
            [self addSubview:self.inputPWField];
            [self.inputPWField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(40));
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(40));
                make.height.equalTo(@(LINEHEIGHT));
                make.top.mas_equalTo(self.mas_top).offset(NavbarH + AdaptY(60));
            }];
            
            [self addSubview:self.confirmNewField];
            [self.confirmNewField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.inputPWField);
                make.top.mas_equalTo(self.inputPWField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.inputPWField);
                make.top.mas_equalTo(self.confirmNewField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(AdaptY(46)));
            }];
            
            [self.loginBtn setTitle:@"完成" forState:UIControlStateNormal];
            self.inputPWField.placeholder = @"请输入您的密码(6-25位数字字母)";
        }
            break;
        default:
            break;
    }
    
}

- (void)addLoginLayer{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.6);
    }];
    
    [self addSubview:self.topTagLabel];
    [self.topTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(NavbarH + AdaptY(20));
        make.left.mas_equalTo(self.mas_left).offset(AdaptX(40));
    }];
    
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topTagLabel.mas_bottom).offset(MidPadding);
        make.left.mas_equalTo(self.topTagLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-AdaptX(40));
    }];
}

- (void)addEditLayer{
    [self addSubview:self.phoneTag];
    [self.phoneTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(NavbarH + 3 * MidPadding);
        make.left.right.mas_equalTo(self);
    }];
    
    [self addSubview:self.currentPhone];
    [self.currentPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneTag.mas_bottom).offset(MidPadding);
        make.left.right.mas_equalTo(self);
    }];
}

#pragma mark - init
- (BaseImageView *)bgView{
    if (!_bgView) {
        _bgView = [[BaseImageView alloc] initWithImage:ImageName(@"login_bg")];
    }
    return _bgView;
}

- (BaseLabel *)topTagLabel{
    if (!_topTagLabel) {
        _topTagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:30] textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _topTagLabel;
}

- (BaseLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(AdaptX(14)) textColor:TextDarkLightGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _detailLabel;
}

- (BaseButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [SEFactory buttonWithTitle:@"登录" image:nil frame:CGRectMake(0, 0, MAINSCREEN_WIDTH - AdaptX(80), LINEHEIGHT) font:Font(18) fontColor:WhiteTextColor];
        ViewRadius(_loginBtn, AdaptX(4));
        [_loginBtn.layer insertSublayer:[UIColor setGradualChangingColor:_loginBtn fromColor:MainYellowColor toColor:DarkYellowColor] below:_loginBtn.imageView.layer];
        [_loginBtn addTarget:self action:@selector(loginTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (BaseButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [SEFactory buttonWithTitle:@"" image:nil frame:CGRectZero font:Font(14) fontColor:WhiteTextColor];
        [_leftBtn addTarget:self action:@selector(leftTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (BaseButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [SEFactory buttonWithTitle:@"忘记密码" image:nil frame:CGRectZero font:Font(14) fontColor:WhiteTextColor];
        [_rightBtn addTarget:self action:@selector(rightTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (BaseButton *)clauseBtn{
    if (!_clauseBtn) {
        NSString *str = @"登录即表示同意《快比特服务条款》";
        _clauseBtn = [SEFactory buttonWithTitle:str image:nil frame:CGRectZero font:Font(12) fontColor:TextDarkLightGrayColor];
        [_clauseBtn addTarget:self action:@selector(clauseTouch) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:MainYellowColor
                             range:NSMakeRange(7, 9)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:TextDarkLightGrayColor range:NSMakeRange(0, 7)];
        [attributeStr addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange(0, str.length)];
        _clauseBtn.titleLabel.attributedText = attributeStr;
    }
    return _clauseBtn;
}

- (UnderLineTextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[UnderLineTextField alloc] initWithFrame:CGRectZero];
        _phoneField.placeholder = @"请输入手机号";
        _phoneField.lineColor = [WhiteTextColor colorWithAlphaComponent:0.5];
        _phoneField.textColor = WhiteTextColor;
        _phoneField.font = Font(14);
        _phoneField.cursorColor = WhiteTextColor;
        _phoneField.placeholderColor = TextDarkGrayColor;
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.limitNum = 11;
        AreaPhoneHeaderView *areaView = [AreaPhoneHeaderView areaPhoneHeaderViewWithFrame:CGRectMake(3, 0, AdaptX(55), LINEHEIGHT) headStrBlock:^(id parameter) {
            
        }];
        _phoneField.leftView = areaView;
        _phoneField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneField;
}

- (UnderLineTextField *)codeField{
    if (!_codeField) {
        _codeField = [[UnderLineTextField alloc] initWithFrame:CGRectZero];
        _codeField.placeholder = @"请输入手机验证码";
        _codeField.lineColor = [WhiteTextColor colorWithAlphaComponent:0.5];
        _codeField.textColor = WhiteTextColor;
        _codeField.font = Font(14);
        _codeField.cursorColor = WhiteTextColor;
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.rightView = self.timeBtn;
        _codeField.rightViewMode = UITextFieldViewModeAlways;
        _codeField.placeholderColor = TextDarkGrayColor;
        _codeField.limitNum = 6;
    }
    return _codeField;
}

- (BaseButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [SEFactory buttonWithTitle:@"发送验证码" frame:CGRectMake(0, 0, AdaptX(120), LINEHEIGHT) font:Font(15) fontColor:MainYellowColor];
        _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_timeBtn addTarget:self action:@selector(timeTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}

- (UnderLineTextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[UnderLineTextField alloc] initWithFrame:CGRectZero];
        _passwordField.placeholder = @"请输入密码";
        _passwordField.lineColor = [WhiteTextColor colorWithAlphaComponent:0.5];
        _passwordField.textColor = WhiteTextColor;
        _passwordField.font = Font(14);
        _passwordField.cursorColor = WhiteTextColor;
        _passwordField.secureTextEntry = YES;
        
        BaseButton *seeBtn = [SEFactory buttonWithImage:ImageName(@"password_open") frame:CGRectMake(0, 0, LINEHEIGHT, LINEHEIGHT)];
        seeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [seeBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
        [seeBtn setImage:ImageName(@"password_close") forState:UIControlStateSelected];
        [seeBtn addTarget:self action:@selector(seePassword:) forControlEvents:UIControlEventTouchUpInside];
        
        _passwordField.rightView = seeBtn;
        _passwordField.rightViewMode = UITextFieldViewModeAlways;
        _passwordField.placeholderColor = TextDarkGrayColor;
    }
    return _passwordField;
}

- (UnderLineTextField *)inputPWField{
    if (!_inputPWField) {
        _inputPWField = [[UnderLineTextField alloc] initWithFrame:CGRectZero];
        _inputPWField.placeholder = @"请输入新密码(6-25位数字字母)";
        _inputPWField.lineColor = [WhiteTextColor colorWithAlphaComponent:0.5];
        _inputPWField.textColor = WhiteTextColor;
        _inputPWField.font = Font(14);
        _inputPWField.cursorColor = WhiteTextColor;
        _inputPWField.placeholderColor = TextDarkGrayColor;
        _inputPWField.secureTextEntry = YES;
    }
    return _inputPWField;
}

- (UnderLineTextField *)confirmNewField{
    if (!_confirmNewField) {
        _confirmNewField = [[UnderLineTextField alloc] initWithFrame:CGRectZero];
        _confirmNewField.placeholder = @"请再次确认新密码";
        _confirmNewField.lineColor = [WhiteTextColor colorWithAlphaComponent:0.5];
        _confirmNewField.textColor = WhiteTextColor;
        _confirmNewField.font = Font(14);
        _confirmNewField.cursorColor = WhiteTextColor;
        _confirmNewField.placeholderColor = TextDarkGrayColor;
        _confirmNewField.secureTextEntry = YES;
    }
    return _confirmNewField;
}

- (BaseLabel *)phoneTag{
    if (!_phoneTag) {
        _phoneTag = [SEFactory labelWithText:@"当前绑定手机号" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _phoneTag;
}

- (BaseLabel *)currentPhone{
    if (!_currentPhone) {
        _currentPhone = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(18) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
    }
    return _currentPhone;
}

@end
