//
//  TitleAndArrowCell.m
//  wxer_manager
//
//  Created by levin on 2017/7/8.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "TitleAndArrowCell.h"
//#import "DatePickerView.h"
#import "DateManager.h"
#import "NSString+JLAdd.h"

@interface TitleAndArrowCell ()<UITextFieldDelegate>

@property (nonatomic, strong) BaseLabel *titleLabel;
@property (nonatomic, strong) BaseButton *arrowBtn;
@property (nonatomic, strong) BaseButton *reEditBtn;
@property (nonatomic, strong) BaseTextField *field;
@property (nonatomic, strong) UIView *channelView;
/** * */
@property (nonatomic, strong) BaseLabel *tagLabel;

@end

@implementation TitleAndArrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initTitleAndArrowCell:(UITableView *)tableView cellID:(NSString *)cellid {
    
    self = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!self) {
        
        self = [[TitleAndArrowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return self;
}

+ (instancetype)titleAndArrowCellCell:(UITableView *)tableView cellID:(NSString *)cellid{
    return [[TitleAndArrowCell alloc] initTitleAndArrowCell:tableView cellID:cellid];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.field.placeholder = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    [self.field setValue:self.placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setShowField:(BOOL)showField{
    _showField = showField;
    
    if (showField) {
        self.field.hidden = NO;
    }else{
        self.field.hidden = YES;
    }
}
- (void)setDisableField:(BOOL)disableField{
    _disableField = disableField;
    if (disableField) {
        self.field.userInteractionEnabled = NO;
    }else{
        self.field.userInteractionEnabled = YES;
    }
}
-(void)setShowReEidt:(BOOL)showReEidt
{
    _showReEidt = showReEidt;
    if (showReEidt) {
        self.reEditBtn.hidden = NO;
        self.arrowBtn.hidden = YES;
    }else{
        self.reEditBtn.hidden = YES;
        self.arrowBtn.hidden = NO;
    }
}

- (void)setDisArrowBtn:(BOOL)disArrowBtn{
    _disArrowBtn = disArrowBtn;
    if (disArrowBtn) {
        self.arrowBtn.hidden = YES;
        [self.field mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(MAINSCREEN_WIDTH / 2));
            make.top.bottom.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-CELLMINMARGIN);
        }];
    }
}

- (void)setIsMust:(BOOL)isMust{
    _isMust = isMust;
    if (isMust) {
        self.tagLabel.hidden = NO;
    }else{
        self.tagLabel.hidden = YES;
    }
}

- (void)setUsername:(UserModel *)username{
    _username = username;
    self.field.text = username.username;
}

- (void)setGender:(UserModel *)gender{
    _gender = gender;
    if ([gender.gender isEqualToString:@"MAN"]) {
        self.field.text = @"男";
    }
    if ([gender.gender isEqualToString:@"WOMAN"]) {
        self.field.text = @"女";
    }
}

- (void)createUI{
    
    WeakSelf(self);
    
    self.titleLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
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
    
    self.arrowBtn = [SEFactory buttonWithTitle:nil image:ImageName(@"arrow_right") frame:CGRectZero font:CELLCONTECTFONT fontColor:MainTextColor];
    [self.contentView addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-CELLMINMARGIN);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(25), AdaptX(25)));
    }];
    
    self.field = [SEFactory textFieldWithPlaceholder:@"" frame:CGRectZero font:Font(16)];
    self.field.delegate = self;
    self.field.textColor = WhiteTextColor;
    self.field.clearButtonMode = UITextFieldViewModeNever;
    self.field.textAlignment = NSTextAlignmentRight;
//    self.field.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    self.field.inputView = [[DatePickerView alloc] initWithView:self.field withDatePickerMode:UIDatePickerModeDateAndTime withDateFormat:@"yyyy-MM-dd H:mm" limitTime:YES withBlock:^(NSString *str) {
//        weakself.field.text = str;
//    }];
    [self.contentView addSubview:self.field];
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(MAINSCREEN_WIDTH / 2));
        make.top.bottom.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.arrowBtn.mas_left).offset(-AdaptX(5));
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}


@end
