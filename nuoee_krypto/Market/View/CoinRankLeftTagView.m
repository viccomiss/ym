//
//  CoinRankLeftTagView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/31.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "CoinRankLeftTagView.h"

@interface CoinRankLeftTagView()

@property (nonatomic, strong) BaseLabel *rankLabel;
@property (nonatomic, strong) BaseLabel *nameLabel;

@end

@implementation CoinRankLeftTagView

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = LightDarkColor;
        [self createUI];
    }
    return self;
}

- (void)setType:(CoinRankOrExchangeType)type{
    _type = type;
    if (type == CoinRankType) {
        [self.rankLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(MinPadding);
            make.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.2);
        }];
        self.rankLabel.text = @"排行";
        self.nameLabel.hidden = NO;
    }else{
        self.rankLabel.text = type == ExchangeType ? @"交易所" : @"币对";
        [self.rankLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(MidPadding);
            make.top.bottom.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width);
        }];
        self.nameLabel.hidden = YES;
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.rankLabel];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(MinPadding);
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.2);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rankLabel.mas_right);
        make.right.mas_equalTo(self.mas_right);
        make.top.bottom.mas_equalTo(self);
    }];
}

#pragma mark - init
- (BaseLabel *)rankLabel{
    if (!_rankLabel) {
        _rankLabel = [SEFactory labelWithText:@"排行" frame:CGRectZero textFont:Font(AdaptX(14)) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _rankLabel;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"名称" frame:CGRectZero textFont:Font(AdaptX(14)) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _nameLabel;
}

@end
