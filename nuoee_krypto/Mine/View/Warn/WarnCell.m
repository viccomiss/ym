//
//  WarnCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/13.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "WarnCell.h"
#import "DateManager.h"

static NSString *CellId = @"WarnCellId";

@interface WarnCell()

/* title */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* close */
@property (nonatomic, strong) BaseButton *closeBtn;
/* ticks */
@property (nonatomic, strong) BaseLabel *ticksLabel;
/* vol */
@property (nonatomic, strong) BaseLabel *volLabel;
/* settime */
@property (nonatomic, strong) BaseLabel *setTagLabel;
/* set */
@property (nonatomic, strong) BaseLabel *setTimeLabel;
/* trigger */
@property (nonatomic, strong) BaseLabel *triggerTagLabel;
/* trigger */
@property (nonatomic, strong) BaseLabel *triggerTimeLabel;

@end

@implementation WarnCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initWarnCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!self) {
        self = [[WarnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)warnCell:(UITableView *)tableView{
    return [[WarnCell alloc] initWarnCell:tableView];
}

- (void)setModel:(Warn *)model{
    _model = model;
    
    if (model.warnType == WarnUnTriggerType) {
        self.triggerTagLabel.hidden = YES;
        self.triggerTimeLabel.hidden = YES;
    }else{
        self.triggerTagLabel.hidden = NO;
        self.triggerTimeLabel.hidden = NO;
        self.triggerTimeLabel.text = [DateManager dateWithTimeIntervalSince1970:model.updateTime format:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    self.setTimeLabel.text = [DateManager dateWithTimeIntervalSince1970:model.createTime format:@"yyyy-MM-dd HH:mm:ss"];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@-%@",model.exchangeName,model.convertCoin];
    self.ticksLabel.text = model.traderCoin;
    
    if ([model.chgType isEqualToString:INCREASE]) {
        self.volLabel.textColor = MainRedColor;
        self.volLabel.text = [NSString stringWithFormat:@"上涨至：%.2f",model.price];
    }else{
        self.volLabel.textColor = MainGreenColor;
        self.volLabel.text = [NSString stringWithFormat:@"下跌至：%.2f",model.price];
    }
}

#pragma mark - action
- (void)closeTouch{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left).offset(2 * MidPadding);
        make.right.mas_equalTo(self.contentView.mas_right).offset(AdaptX(20) + 2 * MidPadding);
        make.height.equalTo(@(AdaptY(49)));
    }];

    [self.contentView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MidPadding);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(30), AdaptX(30)));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LightDarkColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.equalTo(@(0.5));
    }];
    
    [self.contentView addSubview:self.ticksLabel];
    [self.ticksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(line.mas_bottom).offset(AdaptY(15));
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.3);
    }];
    
    [self.contentView addSubview:self.volLabel];
    [self.volLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2 * MidPadding);
        make.centerY.mas_equalTo(self.ticksLabel.mas_centerY);
        make.left.mas_equalTo(self.ticksLabel.mas_right).offset(4 * MidPadding);
    }];
    
    [self.contentView addSubview:self.setTagLabel];
    [self.setTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-MidPadding);
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.width.equalTo(@(AdaptX(120)));
    }];
    
    [self.contentView addSubview:self.setTimeLabel];
    [self.setTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2 * MidPadding);
        make.bottom.mas_equalTo(self.setTagLabel);
        make.left.mas_equalTo(self.setTagLabel.mas_right).offset(4 * MidPadding);
    }];
    
    [self.contentView addSubview:self.triggerTagLabel];
    [self.triggerTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.setTagLabel);
        make.bottom.mas_equalTo(self.setTagLabel.mas_top).offset(-MinPadding);
    }];
    
    [self.contentView addSubview:self.triggerTimeLabel];
    [self.triggerTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.setTimeLabel);
        make.bottom.mas_equalTo(self.triggerTagLabel);
    }];
    
}

#pragma mark - init
- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"火币Pro-BTC" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [SEFactory buttonWithImage:ImageName(@"close_gray")];
        [_closeBtn addTarget:self action:@selector(closeTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (BaseLabel *)ticksLabel{
    if (!_ticksLabel) {
        _ticksLabel = [SEFactory labelWithText:@"BTC/USDT" frame:CGRectZero textFont:Font(16) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _ticksLabel;
}
- (BaseLabel *)volLabel{
    if (!_volLabel) {
        _volLabel = [SEFactory labelWithText:@"上涨至：￥7600.3058" frame:CGRectZero textFont:Font(16) textColor:MainRedColor textAlignment:NSTextAlignmentRight];
    }
    return _volLabel;
}

- (BaseLabel *)triggerTagLabel{
    if (!_triggerTagLabel) {
        _triggerTagLabel = [SEFactory labelWithText:@"触发时间" frame:CGRectZero textFont:Font(16) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _triggerTagLabel;
}

- (BaseLabel *)triggerTimeLabel{
    if (!_triggerTimeLabel) {
        _triggerTimeLabel = [SEFactory labelWithText:@"2018-06-05 13:23:23" frame:CGRectZero textFont:Font(14) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentRight];
    }
    return _triggerTimeLabel;
}

- (BaseLabel *)setTagLabel{
    if (!_setTagLabel) {
        _setTagLabel = [SEFactory labelWithText:@"设置时间" frame:CGRectZero textFont:Font(16) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _setTagLabel;
}

- (BaseLabel *)setTimeLabel{
    if (!_setTimeLabel) {
        _setTimeLabel = [SEFactory labelWithText:@"2018-06-05 13:23:23" frame:CGRectZero textFont:Font(14) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentRight];
    }
    return _setTimeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
