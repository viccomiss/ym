//
//  RiseAndFallViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/21.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "RiseAndFallViewController.h"
#import "UserModel.h"
#import "SEUserDefaults.h"

@interface RiseAndFallViewController()

/* topview */
@property (nonatomic, strong) UIView *topView;
/* bottom */
@property (nonatomic, strong) UIView *bottomView;
/* topRight */
@property (nonatomic, strong) BaseImageView *topRightView;
/* bottomRi */
@property (nonatomic, strong) BaseImageView *bottomRightView;


@end

@implementation RiseAndFallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"涨跌颜色";
    
    [self createUI];
    
    UserModel *user = [[SEUserDefaults shareInstance] getUserModel];
    self.topRightView.hidden = user.markColor;
    self.bottomRightView.hidden = !user.markColor;
}

#pragma mark - action
- (void)topTap{
    if (self.topRightView.hidden == NO) {
        return;
    }
    self.topRightView.hidden = NO;
    self.bottomRightView.hidden = YES;
    [self changeMarkColor:@"false"];
}

- (void)bottomTap{
    if (self.bottomRightView.hidden == NO) {
        return;
    }
    self.topRightView.hidden = YES;
    self.bottomRightView.hidden = NO;
    [self changeMarkColor:@"true"];
}

- (void)changeMarkColor:(NSString *)mark{
    
    [UserModel changeMarkColor:@{@"markColor": mark} Success:^(UserModel *user) {
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH + AdaptY(20));
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(AdaptY(50)));
    }];
    
    [self.topView addSubview:self.topRightView];
    [self.topRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.topView);
        make.right.mas_equalTo(self.topView.mas_right).offset(-AdaptX(20));
        make.size.mas_equalTo(CGSizeMake(13, 10.5));
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.height.mas_equalTo(self.topView);
    }];
    
    [self.bottomView addSubview:self.bottomRightView];
    [self.bottomRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView);
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-AdaptX(20));
        make.size.mas_equalTo(CGSizeMake(13, 10.5));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = MarginLineColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view.mas_left).offset(AdaptX(20));
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark - init
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = MainDarkColor;
        
        BaseLabel *label = [SEFactory labelWithText:@"绿涨红跌" frame:CGRectMake(AdaptX(20), 0, AdaptX(120), AdaptY(50)) textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
        [_topView addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTap)];
        tap.numberOfTapsRequired = 1;
        [_topView addGestureRecognizer:tap];
    }
    return _topView;
}

- (BaseImageView *)topRightView{
    if (!_topRightView) {
        _topRightView = [[BaseImageView alloc] initWithImage:ImageName(@"check_mark")];
    }
    return _topRightView;
}

- (BaseImageView *)bottomRightView{
    if (!_bottomRightView) {
        _bottomRightView = [[BaseImageView alloc] initWithImage:ImageName(@"check_mark")];
        _bottomRightView.hidden = YES;
    }
    return _bottomRightView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = MainDarkColor;
        
        BaseLabel *label = [SEFactory labelWithText:@"红涨绿跌" frame:CGRectMake(AdaptX(20), 0, AdaptX(120), AdaptY(50)) textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
        [_bottomView addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomTap)];
        tap.numberOfTapsRequired = 1;
        [_bottomView addGestureRecognizer:tap];
    }
    return _bottomView;
}

@end
