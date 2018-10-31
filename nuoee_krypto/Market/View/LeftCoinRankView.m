//
//  LeftCoinCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "LeftCoinRankView.h"

@interface LeftCoinRankView()

@property (nonatomic, strong) BaseLabel *numLabel;
@property (nonatomic, strong) BaseImageView *iconView;
@property (nonatomic, strong) BaseLabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LeftCoinRankView

- (instancetype)init{
    if (self == [super init]) {
        
        [self createUI];
    }
    return self;
}

- (void)setCurrency:(CurrencyRank *)currency{
    _currency = currency;
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld",currency.index + 1];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:currency.iconUrl] placeholderImage:ImageName(@"coin_place")];
    self.nameLabel.text = currency.currency;
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(MidPadding);
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.2);
    }];
    
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numLabel.mas_right).offset(MaxPadding);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SmallIcon, SmallIcon));
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(MinPadding);
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(-MinPadding);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.width.equalTo(@(1));
    }];
}

#pragma mark - init
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LightDarkColor;
    }
    return _lineView;
}

- (BaseLabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(AdaptX(14)) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _numLabel;
}

- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] initWithImage:ImageName(@"account_highlight")];
        ViewRadius(_iconView, SmallIcon/2);
    }
    return _iconView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(AdaptX(14)) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

@end
