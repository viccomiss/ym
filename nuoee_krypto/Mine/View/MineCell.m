//
//  MineCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/9.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MineCell.h"

static NSString *CellId = @"MineCellId";

@interface MineCell()

/* icon */
@property (nonatomic, strong) BaseImageView *iconView;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* arrow */
@property (nonatomic, strong) BaseButton *arrowBtn;
/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* summary */
@property (nonatomic, strong) BaseLabel *summaryLabel;
/* switch */
@property (nonatomic, strong) UISwitch *modeSwitch;
/* lineView */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation MineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = MainDarkColor;
        [self createUI];
    }
    return self;
}

- (instancetype)initMineCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (!self) {
        self = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    return self;
}

+ (instancetype)mineCell:(UITableView *)tableView{
    return [[MineCell alloc] initMineCell:tableView];
}

- (void)setModel:(MineModel *)model{
    _model = model;
    
    self.iconView.image = ImageName(model.icon);
    self.nameLabel.text = model.name;
    
    switch (model.type) {
        case MineNormalCellType:
        {
            self.arrowBtn.hidden = NO;
            self.modeSwitch.hidden = YES;
            self.tagLabel.hidden = YES;
            self.summaryLabel.hidden = YES;
        }
            break;
        case MineSummaryCellType:
        {
            self.summaryLabel.hidden = NO;
            self.tagLabel.hidden = YES;
            self.modeSwitch.hidden = YES;
            self.arrowBtn.hidden = NO;
            self.summaryLabel.text = model.summary;
        }
            break;
        case MineMessageTagCellType:
        {
            self.tagLabel.hidden = NO;
            self.summaryLabel.hidden = YES;
            self.modeSwitch.hidden = YES;
            self.arrowBtn.hidden = NO;
            if (model.notReadCount == 0) {
                self.tagLabel.hidden = YES;
            }else{
                self.tagLabel.hidden = NO;
                self.tagLabel.text = [NSString stringWithFormat:@"%ld",model.notReadCount];
            }
        }
            break;
        case MineSwitchCellType:
        {
            self.arrowBtn.hidden = YES;
            self.modeSwitch.hidden = NO;
            self.tagLabel.hidden = YES;
            self.summaryLabel.hidden = YES;
        }
            break;
    }
}

#pragma mark - action
- (void)switchAction:(UISwitch *)sender{
    
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(2 * MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(20), AdaptX(20)));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(2 * MidPadding);
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(- 2 * MidPadding);
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(25), AdaptX(25)));
    }];
    
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowBtn.mas_left).offset(-MinPadding);
        make.centerY.mas_equalTo(self.arrowBtn.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(@(AdaptX(18)));
        make.height.equalTo(@(AdaptX(18)));
    }];
    
    [self.contentView addSubview:self.summaryLabel];
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowBtn.mas_left).offset(-MinPadding);
        make.centerY.mas_equalTo(self.arrowBtn.mas_centerY);
    }];
    
    [self.contentView addSubview:self.modeSwitch];
    [self.modeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2 * MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.bottom.mas_equalTo(self.contentView);
        make.height.equalTo(@(1));
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

- (UISwitch *)modeSwitch{
    if (!_modeSwitch) {
        _modeSwitch = [[UISwitch alloc]init];
        [_modeSwitch setTintColor:TextDarkGrayColor];
        [_modeSwitch setOnTintColor:MainYellowColor];
        [_modeSwitch setThumbTintColor:[UIColor whiteColor]];
        _modeSwitch.layer.cornerRadius = 15.5f;
        _modeSwitch.layer.masksToBounds = YES;
        [_modeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _modeSwitch;
}

- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] init];
    }
    return _iconView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [SEFactory buttonWithImage:ImageName(@"arrow_right")];
        _arrowBtn.userInteractionEnabled = NO;
    }
    return _arrowBtn;
}

- (BaseLabel *)summaryLabel{
    if (!_summaryLabel) {
        _summaryLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:TextDarkLightGrayColor textAlignment:NSTextAlignmentRight];
    }
    return _summaryLabel;
}

- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
        _tagLabel.backgroundColor = MainRedColor;
        ViewRadius(_tagLabel, AdaptX(9));
    }
    return _tagLabel;
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
