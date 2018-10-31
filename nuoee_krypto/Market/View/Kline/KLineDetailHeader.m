//
//  KLineDetailHeader.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "KLineDetailHeader.h"
#import "KlineIndView.h"
#import "SEUserDefaults.h"

@interface KLineDetailHeader()

/* close */
@property (nonatomic, strong) BaseLabel *closeLabel;
/* dollar */
@property (nonatomic, strong) BaseLabel *dollarLabel;
/* degree */
@property (nonatomic, strong) BaseLabel *degreeLabel;
/* high */
@property (nonatomic, strong) BaseLabel *highLabel;
/* low */
@property (nonatomic, strong) BaseLabel *lowLabel;
/* vol */
@property (nonatomic, strong) BaseLabel *volLabel;
/* lastPrice */
@property (nonatomic, assign) CGFloat lastPrice;

@end

@implementation KLineDetailHeader

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = MainDarkColor;
        [self createUI];
    }
    return self;
}

- (void)setModel:(KlineModel *)model{
    _model = model;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;

    //涨跌颜色
    if (self.lastPrice < model.closePrice) {
        self.closeLabel.textColor = [[SEUserDefaults shareInstance] getRiseOrFallColor:RoseType];
    }else{
        self.closeLabel.textColor = [[SEUserDefaults shareInstance] getRiseOrFallColor:FallType];
    }
    self.degreeLabel.textColor = self.closeLabel.textColor;
    self.lastPrice = model.closePrice;
    self.closeLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:model.closePrice]];
    self.dollarLabel.text = [NSString stringWithFormat:@"≈$%.2f",model.usdPrice];;
    if (model.degree > 0) {
        self.degreeLabel.text = [NSString stringWithFormat:@"+%.2f%%",model.degree];
    }else{
        self.degreeLabel.text = [NSString stringWithFormat:@"%.2f%%",model.degree];
    }
    
    self.highLabel.text = [NSString stringWithFormat:@"%.2f",model.highestPrice];
    self.lowLabel.text = [NSString stringWithFormat:@"%.2f",model.lowestPrice];
    self.volLabel.text = [NSString stringWithFormat:@"%.2f万",[model.volumn doubleValue] / 10000];
}

- (void)adjustLayout{
    
    [self.closeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(3 * MidPadding);
        make.top.mas_equalTo(self.mas_top).offset(MidPadding);
    }];
    
    [self.degreeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.closeLabel.mas_right).offset(MidPadding);
        make.bottom.mas_equalTo(self.closeLabel.mas_bottom).offset(-AdaptY(5));
    }];
    
    [self.dollarLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.closeLabel.mas_left);
        make.top.mas_equalTo(self.closeLabel.mas_bottom).offset(MidPadding);
    }];
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.closeLabel];
    [self.closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(3 * MidPadding);
        make.top.mas_equalTo(self.mas_top).offset(MidPadding);
    }];
    
    [self addSubview:self.degreeLabel];
    [self.degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.closeLabel.mas_right).offset(MidPadding);
        make.bottom.mas_equalTo(self.closeLabel.mas_bottom).offset(-AdaptY(5));
    }];
    
    [self addSubview:self.dollarLabel];
    [self.dollarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.closeLabel.mas_left);
        make.top.mas_equalTo(self.closeLabel.mas_bottom).offset(MidPadding);
    }];
    
    [self setContent:0];
    [self setContent:1];
    [self setContent:2];
}

- (void)setContent:(NSInteger)tag{
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(tag * (MAINSCREEN_WIDTH / 3));
        make.bottom.mas_equalTo(self.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(MAINSCREEN_WIDTH / 3, AdaptY(64)));
    }];
    
    NSArray *titleArr = @[@"最高",@"最低",@"24h成交量"];
    BaseLabel *top = [SEFactory labelWithText:titleArr[tag] frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    [contentView addSubview:top];
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).offset(3 * MidPadding);
        make.bottom.mas_equalTo(contentView.mas_centerY).offset(-AdaptY(5));
    }];
    
    BaseLabel *bottom = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    [contentView addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_centerY);
        make.left.mas_equalTo(top.mas_left);
//        make.right.mas_equalTo(contentView.mas_right).offset(- 3 * MidPadding);
    }];
    
    switch (tag) {
        case 0:
            self.highLabel = bottom;
            break;
        case 1:
            self.lowLabel = bottom;
            break;
        case 2:
            self.volLabel = bottom;
            break;
    }
}

#pragma mark - init
- (BaseLabel *)closeLabel{
    if (!_closeLabel) {
        _closeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(32) textColor:DarkRedColor textAlignment:NSTextAlignmentLeft];
    }
    return _closeLabel;
}

- (BaseLabel *)degreeLabel{
    if (!_degreeLabel) {
        _degreeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(17) textColor:DarkRedColor textAlignment:NSTextAlignmentLeft];
    }
    return _degreeLabel;
}

- (BaseLabel *)dollarLabel{
    if (!_dollarLabel) {
        _dollarLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _dollarLabel;
}



@end
