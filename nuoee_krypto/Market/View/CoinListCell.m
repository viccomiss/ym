//
//  CoinListCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/26.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "CoinListCell.h"

static NSString *cellId = @"coinListCellId";

@interface CoinListCell()

/* icon */
@property (nonatomic, strong) BaseImageView *iconView;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;

@end

@implementation CoinListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = MainBlackColor;
        [self createUI];
    }
    return self;
}

- (instancetype)initCoinListCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!self) {
        self = [[CoinListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)coinListCell:(UITableView *)tableView{
    return [[CoinListCell alloc] initCoinListCell:tableView];
}

- (void)setModel:(Currency *)model{
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png",IMAGE_SERVICE,model.currency_name]] placeholderImage:ImageName(@"coin_place")];
    self.nameLabel.text = model.currency_name;
}

- (void)setSearch:(SearchModel *)search{
    _search = search;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:search.iconUrl] placeholderImage:ImageName(@"coin_place")];
    self.nameLabel.text = search.name;
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(19), AdaptX(19)));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(MidPadding);
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = MainDarkColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(MidPadding);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-AdaptX(24));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark - init
- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] init];
        ViewRadius(_iconView, AdaptX(19/2));
    }
    return _iconView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
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
