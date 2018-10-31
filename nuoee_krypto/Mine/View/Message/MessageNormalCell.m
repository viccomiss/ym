//
//  MessageNormalCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/12.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MessageNormalCell.h"
#import "DateManager.h"
#import "NSString+JLAdd.h"

static NSString *CellId = @"messageNormalCellId";

@interface MessageNormalCell()

/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* time */
@property (nonatomic, strong) BaseLabel *timeLabel;
/* content */
@property (nonatomic, strong) BaseLabel *contentLabel;
/* read */
@property (nonatomic, strong) UIView *readView;

@end

@implementation MessageNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = MainDarkColor;
        [self createUI];
    }
    return self;
}

- (instancetype)initMessageNormalCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!self) {
        self = [[MessageNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)messageNormalCell:(UITableView *)tableView{
    return [[MessageNormalCell alloc] initMessageNormalCell:tableView];
}

- (void)setModel:(Message *)model{
    _model = model;
    
    self.tagLabel.text = model.title;
    self.timeLabel.text = [DateManager dateWithTimeIntervalSince1970:model.createDate format:@"MM-dd HH:mm"];
    self.readView.hidden = model.read;
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithAttributedString:[model.context attributedByHtmlStr]];
    if (attributeStr.length > 0) {
        
        [attributeStr addAttribute:NSForegroundColorAttributeName
         
                             value:TextDarkLightGrayColor
         
                             range:NSMakeRange(0, attributeStr.length)];
        
        [attributeStr addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(0, attributeStr.length)];
    }
    
    self.contentLabel.attributedText = attributeStr;
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).offset(2 * MidPadding);
        make.height.equalTo(@(AdaptY(20)));
    }];
    
    [self.contentView addSubview:self.readView];
    [self.readView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tagLabel.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(AdaptX(8));
        make.size.mas_equalTo(CGSizeMake(AdaptX(7), AdaptX(7)));
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.tagLabel.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2 * MidPadding);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(MinPadding);
        make.left.mas_equalTo(self.tagLabel);
        make.right.bottom.mas_equalTo(self.contentView).offset(-2 * MidPadding);
    }];
}

#pragma mark - init
- (UIView *)readView{
    if (!_readView) {
        _readView = [[UIView alloc] init];
        _readView.backgroundColor = MainRedColor;
        ViewRadius(_readView, AdaptX(3.5));
    }
    return _readView;
}

- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _tagLabel;
}

- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentRight];
    }
    return _timeLabel;
}

- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
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
