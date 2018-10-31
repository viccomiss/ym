//
//  WarnSettingHeader.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/15.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "WarnSettingHeader.h"
#import "NSString+JLAdd.h"

@interface WarnSettingHeader()

/* title */
@property (nonatomic, strong) BaseLabel *titleLabel;
/* vol */
@property (nonatomic, strong) BaseLabel *volLabel;
/* dollar */
@property (nonatomic, strong) BaseLabel *dollarLabel;


@end

@implementation WarnSettingHeader

- (instancetype)init{
    if (self == [super init]) {
        
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(100));
        self.backgroundColor = MainDarkColor;
        [self createUI];
    }
    return self;
}

- (void)setMarket:(CurrencyMarket *)market{
    _market = market;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@-%@",market.exchange_code,[[market.ticker subStringFrom:@":"] stringByReplacingOccurrencesOfString:market.currency_name withString:[NSString stringWithFormat:@"%@/",market.currency_name]]];
}

- (void)setKline:(KlineModel *)kline{
    _kline = kline;
    self.volLabel.text = [NSString stringWithFormat:@"￥%.2f",kline.closePrice];
    self.dollarLabel.text = [NSString stringWithFormat:@"$%.2f",kline.usdPrice];
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    [self addSubview:self.volLabel];
    [self.volLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];
    
    [self addSubview:self.dollarLabel];
    [self.dollarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.volLabel.mas_top);
        make.right.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];
    
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = LightDarkColor;
    [self addSubview:hLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@(1));
    }];
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = LightDarkColor;
    [self addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hLine.mas_bottom).offset(MidPadding);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(1, AdaptY(30)));
    }];
}

#pragma mark - init
- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [SEFactory labelWithText:@"Huobi－BTC/USDT" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (BaseLabel *)volLabel{
    if (!_volLabel) {
        _volLabel = [SEFactory labelWithText:@"￥49258.00" frame:CGRectZero textFont:Font(16) textColor:MainRedColor textAlignment:NSTextAlignmentCenter];
    }
    return _volLabel;
}

- (BaseLabel *)dollarLabel{
    if (!_dollarLabel) {
        _dollarLabel = [SEFactory labelWithText:@"$7706.00" frame:CGRectZero textFont:Font(16) textColor:TextDarkLightGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _dollarLabel;
}

@end
