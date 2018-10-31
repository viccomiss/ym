//
//  ExchangeMarketCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/1.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ExchangeMarketCell.h"
#import "NSString+JLAdd.h"

static NSString *CellId = @"exchangeMarketCellId";

@interface ExchangeMarketCell()

@property (nonatomic, strong) BaseImageView *iconView;
@property (nonatomic, strong) BaseLabel *nameLabel;
@property (nonatomic, strong) BaseLabel *tradeLabel;
@property (nonatomic, strong) BaseLabel *numLabel;

@end

@implementation ExchangeMarketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initExchangeMarkCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!self) {
        self = [[ExchangeMarketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)exchangeMarketCell:(UITableView *)tableView{
    return [[ExchangeMarketCell alloc] initExchangeMarkCell:tableView];
}

- (void)setModel:(Exchange *)model{
    _model = model;
    
    if (model.index % 2 == 0) {
        self.contentView.backgroundColor = MainDarkColor;
    }else{
        self.contentView.backgroundColor = MainBlackColor;
    }
    
    self.numLabel.text = [NSString stringWithFormat:@"%ld",model.index + 1];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:ImageName(@"")];
    self.nameLabel.text = model.exchangeName;
    
    CGFloat vol = floor([model.vol floatValue] * 100) / 100;
    
    self.tradeLabel.text = [NSString numberFormatterToRMB:vol];
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(MidPadding);
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.2);
    }];
    
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numLabel.mas_right);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SmallIcon, SmallIcon));
    }];
    
    [self.contentView addSubview:self.tradeLabel];
    [self.tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.36);
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MidPadding);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(MinPadding);
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.tradeLabel.mas_left).offset(-2 * MidPadding);
    }];
    
    
}

#pragma mark - init
- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] init];
        ViewRadius(_iconView, SmallIcon/2);
    }
    return _iconView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseLabel *)tradeLabel{
    if (!_tradeLabel) {
        _tradeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:MainYellowColor textAlignment:NSTextAlignmentRight];
    }
    return _tradeLabel;
}

- (BaseLabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _numLabel;
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
