//
//  WarnSetCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/16.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "WarnSetCell.h"

@interface WarnSetCell()

/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* field */
@property (nonatomic, strong) BaseTextField *textField;
/* add */
@property (nonatomic, strong) BaseButton *addBtn;
/* prefix */
@property (nonatomic, strong) BaseLabel *prefixLabel;
/* type */
@property (nonatomic, assign) RoseOrFallType type;

@end

@implementation WarnSetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(RoseOrFallType)type{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = MainDarkColor;
        [self createUI];
        self.type = type;
        self.tagLabel.text = type == RoseType ? @"上涨至：" : @"下跌至：";
    }
    return self;
}

- (instancetype)initWarnSetCell:(UITableView *)tableView type:(RoseOrFallType)type{
    self = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"warnCell%ld",type]];
    if (!self) {
        self = [[WarnSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"warnCell%ld",type] type:type];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)warnSetCell:(UITableView *)tableView type:(RoseOrFallType)type{
    return [[WarnSetCell alloc] initWarnSetCell:tableView type:type];
}

- (void)setPrefix:(BOOL)prefix{
    _prefix = prefix;
    self.prefixLabel.text = prefix ? @"$" : @"￥";
}

- (void)setMiddlePrice:(CGFloat)middlePrice{
    _middlePrice = middlePrice;
    
    
}

#pragma mark - action
- (void)addTouch:(BaseButton *)sender{
    if (sender.selected) {
        //添加
        if (self.type == RoseType) {
            if ([self.textField.text floatValue] <= self.middlePrice) {
                [SEHUD showAlertWithText:@"上涨价格必须高于当前价格"];
                return;
            }

        }else{
            if ([self.textField.text floatValue] >= self.middlePrice) {
                [SEHUD showAlertWithText:@"下跌价格必须低于当前价格"];
                return;
            }
        }
        
        if (self.priceBlock) {
            self.priceBlock([self.textField.text floatValue]);
        }
        self.textField.text = @"";
        [self.textField resignFirstResponder];
        self.addBtn.selected = NO;
        self.prefixLabel.textColor = TextDarkGrayColor;
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(2 * MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(@(AdaptX(70)));
    }];
    
    [self.contentView addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(- 2 * MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(30), AdaptX(30)));
    }];
    
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagLabel.mas_right).offset(AdaptX(3));
        make.right.mas_equalTo(self.addBtn.mas_left).offset(- 2 * MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@(AdaptY(44)));
    }];
    
}

-(void)textFieldDidChange:(UITextField *)textField{
    
    BaseLabel *label = (BaseLabel *)textField.leftView;
    
    if (textField.text.length != 0) {
        self.addBtn.selected = YES;
        label.textColor = WhiteTextColor;
    }else{
        self.addBtn.selected = NO;
        label.textColor = TextDarkGrayColor;
    }
}

#pragma mark - init
- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:TextDarkLightGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _tagLabel;
}

- (BaseTextField *)textField{
    if (!_textField) {
        _textField = [SEFactory textFieldWithPlaceholder:@"价格" frame:CGRectZero font:Font(16)];
        _textField.textColor = WhiteTextColor;
        _textField.backgroundColor = LightDarkColor;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        _prefixLabel = [SEFactory labelWithText:@"￥" frame:CGRectMake(8, 0, 18, AdaptY(44)) textFont:Font(16) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentRight];
        _textField.leftView = _prefixLabel;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (BaseButton *)addBtn{
    if(!_addBtn){
        _addBtn = [SEFactory buttonWithImage:ImageName(@"add_black")];
        [_addBtn setImage:ImageName(@"add_yellow") forState:UIControlStateSelected];
        [_addBtn addTarget:self action:@selector(addTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
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
