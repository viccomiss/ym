//
//  WarnRemindCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/16.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "WarnRemindCell.h"

static NSString *CellId = @"WarnRemindCellId";

@interface WarnRemindCell()

/* icon */
@property (nonatomic, strong) BaseImageView *iconView;
/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* content */
@property (nonatomic, strong) BaseLabel *contentLabel;
/* del */
@property (nonatomic, strong) BaseButton *delBtn;

@end

@implementation WarnRemindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.separatorLine = NO;
        [self createUI];
    }
    return self;
}

- (instancetype)initWarnRemindCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!self) {
        self = [[WarnRemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)warnRemindCell:(UITableView *)tableView{
    return [[WarnRemindCell alloc] initWarnRemindCell:tableView];
}

- (void)setModel:(Warn *)model{
    _model = model;
    
    if ([model.chgType isEqualToString:INCREASE]) {
        self.iconView.image = ImageName(@"warn_up");
        self.tagLabel.text = @"上涨至：";
    }else{
        self.iconView.image = ImageName(@"warn_down");
        self.tagLabel.text = @"下跌至：";
    }
    
    NSString *numStr = [NSString stringWithFormat:@"￥%.2f 时提醒",model.price];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:numStr];
    if (attributeStr.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:WhiteTextColor
                             range:NSMakeRange(0, attributeStr.length - 3)];
    }
    self.contentLabel.attributedText = attributeStr;
}

#pragma mark - action
- (void)delTouch{
    if (self.delBlock) {
        self.delBlock();
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(2 * MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(14), AdaptX(14)));
    }];
    
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(MidPadding);
        make.centerY.mas_equalTo(self.contentView);
        make.width.equalTo(@(AdaptX(60)));
    }];
    
    [self.contentView addSubview:self.delBtn];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(- 2 * MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(30), AdaptX(30)));
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagLabel.mas_right);
        make.right.mas_equalTo(self.delBtn.mas_left).offset(- 2 * MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];

}

#pragma mark - init
- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] init];
    }
    return _iconView;
}

- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:TextDarkLightGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _tagLabel;
}

- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:TextDarkLightGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _contentLabel;
}

- (BaseButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [SEFactory buttonWithImage:ImageName(@"del_red")];
        [_delBtn addTarget:self action:@selector(delTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
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
