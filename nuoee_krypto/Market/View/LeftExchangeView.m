//
//  LeftExchangeView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/1.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "LeftExchangeView.h"
#import "NSString+JLAdd.h"

@interface LeftExchangeView()

@property (nonatomic, strong) BaseImageView *iconView;
@property (nonatomic, strong) BaseLabel *exchangeLabel;
@property (nonatomic, strong) BaseLabel *coinLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LeftExchangeView

- (instancetype)init{
    if (self == [super init]) {
        
        [self createUI];
    }
    return self;
}

- (void)setMarket:(CurrencyMarket *)market{
    _market = market;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:market.logo] placeholderImage:ImageName(@"coin_place")];
    self.exchangeLabel.text = market.exchange_name;
    
    self.coinLabel.text = [[market.ticker subStringFrom:@":"] stringByReplacingOccurrencesOfString:market.currency_name withString:[NSString stringWithFormat:@"%@/",market.currency_name]];
}

- (void)setExchange:(ExchangeTicks *)exchange{
    _exchange = exchange;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",IMAGE_SERVICE,exchange.base]] placeholderImage:ImageName(@"coin_place")];
    self.exchangeLabel.text = exchange.base;
    self.coinLabel.text = [[exchange.ticker subStringFrom:@":"] stringByReplacingOccurrencesOfString:exchange.base withString:[NSString stringWithFormat:@"%@/",exchange.base]];
    ;
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(MidPadding);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SmallIcon, SmallIcon));
    }];
    
    [self addSubview:self.exchangeLabel];
    [self.exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(MidPadding);
        make.bottom.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-MidPadding);
    }];
    
    [self addSubview:self.coinLabel];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.exchangeLabel);
        make.top.mas_equalTo(self.mas_centerY).offset(AdaptY(4));
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
- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] init];
        ViewRadius(_iconView, SmallIcon/2);
    }
    return _iconView;
}

- (BaseLabel *)exchangeLabel{
    if (!_exchangeLabel) {
        _exchangeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(AdaptX(14)) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _exchangeLabel;
}

- (BaseLabel *)coinLabel{
    if (!_coinLabel) {
        _coinLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(AdaptX(12)) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _coinLabel;
}

@end
