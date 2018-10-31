//
//  TitleAndFieldCell.m
//  wxer_manager
//
//  Created by levin on 2017/7/7.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "TitleAndFieldCell.h"
#import "NSString+JLAdd.h"

@interface TitleAndFieldCell ()<UITextFieldDelegate>

@property (nonatomic, strong) BaseLabel *titleLabel;
/** * */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* 限制提示 */
@property (nonatomic, strong) BaseLabel *limitLabel;
@property (nonatomic, strong) BaseLabel *unitsLabel;
@end

@implementation TitleAndFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initTitleAndFieldCell:(UITableView *)tableView cellID:(NSString *)cellid{
    self = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!self) {
        
        self = [[TitleAndFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return self;
}

+ (instancetype)titleAndFieldCell:(UITableView *)tableView cellID:(NSString *)cellid{
    return [[TitleAndFieldCell alloc] initTitleAndFieldCell:tableView cellID:cellid];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.filed.textColor = textColor;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.filed.placeholder = placeholder;
}

- (void)setIsLimit:(BOOL)isLimit{
    _isLimit = isLimit;
    if (isLimit) {
        self.limitLabel.hidden = NO;
        [self.limitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-CELLMARGIN);
        }];
        
        [self.filed mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(CELLMINMARGIN + CELLMARGIN + CELLTITLEWIDTH);
            make.top.bottom.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.limitLabel.mas_left).offset(-CELLMINMARGIN);
        }];
    }
}

- (void)setHaveNum:(NSInteger)haveNum{
    _haveNum = haveNum;
    
}

- (void)setLimitNum:(NSInteger)limitNum{
    _limitNum = limitNum;
    self.limitLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.haveNum,limitNum];
}

- (void)setIsMust:(BOOL)isMust{
    _isMust = isMust;
    if (isMust) {
        self.tagLabel.hidden = NO;
    }else{
        self.tagLabel.hidden = YES;
    }
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType = keyboardType;
    self.filed.keyboardType = keyboardType;
    if (keyboardType == UIKeyboardTypeDecimalPad ||keyboardType == UIKeyboardTypeNumberPad ) {
        ViewBorderRadius(_filed, 5, 1, LightLineColor);
        [self.filed mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(CELLMINMARGIN + CELLMARGIN + CELLTITLEWIDTH);
            make.size.mas_equalTo(CGSizeMake(AdaptX(130), AdaptX(35)));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
}

- (void)createUI{
    
    self.titleLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:CELLTITLEFONT textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(CELLMARGIN);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    self.tagLabel = [SEFactory labelWithText:@"*" frame:CGRectZero textFont:Font(11 * SCALE_WIDTH) textColor:MainRedColor textAlignment:NSTextAlignmentCenter];
    self.tagLabel.hidden = YES;
    [self.titleLabel addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.titleLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(8 * SCALE_WIDTH, 8 * SCALE_WIDTH));
    }];
    
    self.filed = [SEFactory textFieldWithPlaceholder:@"" frame:CGRectZero font:CELLCONTECTFONT];
    self.filed.delegate = self;
    self.filed.font = CELLTITLEFONT;
    self.filed.textAlignment = NSTextAlignmentRight;
    [self.filed addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.filed.textColor = MainTextColor;
    [self.contentView addSubview:self.filed];
    [self.filed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(2 * MidPadding);
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2 * MidPadding);
    }];
    
    self.limitLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:DecribeTextColor textAlignment:NSTextAlignmentRight];
    self.limitLabel.hidden = YES;
    [self.contentView addSubview:self.limitLabel];
    
    self.unitsLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:CELLTITLEFONT textColor:MainTextColor];
    [self.contentView addSubview:self.unitsLabel];
    [self.unitsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.filed.mas_right).offset(AdaptX(10));;
    }];
}

-(void)textFieldDidChange:(UITextField *)textField{
    
    if (self.disableEmoji) {
        if (self.filed.textLocation == -1) {
            NSLog(@"输入不含emoji表情");
        }else {
            NSLog(@"输入含emoji表情");
            [SEHUD showAlertWithText:@"不能输入emoji表情"];
            //截取emoji表情前
            textField.text = [textField.text substringToIndex:self.filed.textLocation];
        }
    }
    
//    if (_pubModel) {
//        _pubModel.name = textField.text;
//    }
    
    if (self.isLimit || self.limitNum!=0 ) {
        NSString *toBeString = textField.text;
        
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > self.limitNum)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.limitNum];
                if (rangeIndex.length == 1)
                {
                    [SEHUD showAlertWithText:[NSString stringWithFormat:@"不能超过%ld个字符",self.limitNum]];
                    textField.text = [toBeString substringToIndex:self.limitNum];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limitNum)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        self.limitLabel.text = [NSString stringWithFormat:@"%ld/%ld",textField.text.length,self.limitNum];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.disableEmoji) {
//        NSLog(@"location-->>%lu",(unsigned long)range.location);
//        NSLog(@"replacementString-->>%@",string);
        //禁止输入emoji表情
        if ([NSString stringContainsEmoji:string]) {  //[self.filed stringContainsEmoji:string]
            self.filed.textLocation = range.location;
        }else {
            self.filed.textLocation = -1;
        }
    }
    return YES;
}

@end
