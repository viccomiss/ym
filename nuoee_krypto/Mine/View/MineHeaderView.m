//
//  MineHeaderView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/8.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView()
/* backViwe */
@property (nonatomic, strong) BaseImageView *backView;
/* icon */
@property (nonatomic, strong) BaseImageView *iconView;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* detail */
@property (nonatomic, strong) BaseLabel *detailLabel;
/* arrow */
@property (nonatomic, strong) BaseButton *arrowBtn;
/* set */
@property (nonatomic, strong) BaseButton *settingBtn;

@end

@implementation MineHeaderView

- (instancetype)init{
    if (self == [super init]) {
        
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, NavbarH + AdaptY(86));
        self.backgroundColor = RGBColor(24, 24, 24);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginTap)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        [self createUI];
    }
    return self;
}

- (void)setUser:(UserModel *)user{
    _user = user;
    
    self.nameLabel.text = user.username == nil ? @"请登录" : user.username;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:ImageName(@"icon_placeholder")];
    self.arrowBtn.hidden = user.token != nil ? NO : YES;
    self.settingBtn.hidden = user.token != nil ? NO : YES;
}

#pragma mark - action
- (void)loginTap{
    if (self.user.token == nil) {
        if (self.loginBlock) {
            self.loginBlock();
        }
    }
}

- (void)settingTouch{
    if (self.settingBlock) {
        self.settingBlock();
    }
}

- (void)arrowTouch{
    if (self.userInfoBlock) {
        self.userInfoBlock();
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.equalTo(@(MAINSCREEN_WIDTH * 300 / 750));
    }];
    
    [self addSubview:self.settingBtn];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-2 * MidPadding);
        make.top.mas_equalTo(self.mas_top).offset(StatusBarH);
        make.size.mas_equalTo(CGSizeMake(NavbarH - StatusBarH, NavbarH - StatusBarH));
    }];
    
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(2 * MidPadding);
        make.size.mas_equalTo(CGSizeMake(AdaptX(70), AdaptX(70)));
        make.top.mas_equalTo(self.mas_top).offset(NavbarH);
    }];
    
    [self addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-MidPadding * 2);
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(25), AdaptX(25)));
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(2 * MidPadding);
        make.centerY.mas_equalTo(self.iconView.mas_centerY).offset(-MinPadding);
        make.right.mas_equalTo(self.arrowBtn.mas_left).offset(-3 * MidPadding);
    }];
    
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(AdaptY(5));
        make.left.right.mas_equalTo(self.nameLabel);
    }];
}

#pragma mark - init
- (BaseImageView *)backView{
    if (!_backView) {
        _backView = [[BaseImageView alloc] initWithImage:ImageName(@"mine_header_bg")];
    }
    return _backView;
}

- (BaseButton *)settingBtn{
    if (!_settingBtn) {
        _settingBtn = [SEFactory buttonWithTitle:@"设置" frame:CGRectZero font:Font(14) fontColor:WhiteTextColor];
        _settingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_settingBtn addTarget:self action:@selector(settingTouch) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.hidden = YES;
    }
    return _settingBtn;
}

- (BaseButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [SEFactory buttonWithImage:ImageName(@"arrow_right")];
        [_arrowBtn addTarget:self action:@selector(arrowTouch) forControlEvents:UIControlEventTouchUpInside];
        _arrowBtn.hidden = YES;
    }
    return _arrowBtn;
}

- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] init];
        ViewRadius(_iconView, AdaptX(35));
    }
    return _iconView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"请登录" frame:CGRectZero textFont:Font(24) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [SEFactory labelWithText:@"欢迎来到比特币" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _detailLabel;
}

@end
