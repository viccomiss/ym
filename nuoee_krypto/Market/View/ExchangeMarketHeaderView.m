//
//  ExchangeMarketHeaderView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/1.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ExchangeMarketHeaderView.h"

@interface ExchangeMarketHeaderView()

@property (nonatomic, strong) BaseLabel *exchangeLabel;
@property (nonatomic, strong) BaseLabel *tradeLabel;
@property (nonatomic, strong) BaseLabel *numLabel;


@end

@implementation ExchangeMarketHeaderView

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = MainBlackColor;
        [self createUI];
    }
    return self;
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(MidPadding);
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.2);
    }];
    
    [self addSubview:self.exchangeLabel];
    [self.exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numLabel.mas_right);
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.4);
    }];
    
    [self addSubview:self.tradeLabel];
    [self.tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(MidPadding);
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(-MidPadding);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = MainDarkColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark - init
- (BaseLabel *)exchangeLabel{
    if (!_exchangeLabel) {
        _exchangeLabel = [SEFactory labelWithText:@"交易所" frame:CGRectZero textFont:Font(15) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _exchangeLabel;
}

- (BaseLabel *)tradeLabel{
    if (!_tradeLabel) {
        _tradeLabel = [SEFactory labelWithText:@"交易量(24h)" frame:CGRectZero textFont:Font(15) textColor:WhiteTextColor textAlignment:NSTextAlignmentRight];
    }
    return _tradeLabel;
}

- (BaseLabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [SEFactory labelWithText:@"排行" frame:CGRectZero textFont:Font(15) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _numLabel;
}

@end
