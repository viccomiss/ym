//
//  TitleAndSwitchCell.m
//  wxer_manager
//
//  Created by levin on 2017/7/8.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "TitleAndSwitchCell.h"

@interface TitleAndSwitchCell ()

@property (nonatomic, strong) BaseLabel *titleLabel;
@property (nonatomic, strong) UISwitch *mySwitch;
@property (nonatomic, strong) BaseLabel *tagLabel;
@end

@implementation TitleAndSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initTitleAndSwitchCell:(UITableView *)tableView cellID:(NSString *)cellid{
    self = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!self) {
        
        self = [[TitleAndSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return self;
}

+ (instancetype)titleAndSwitchCell:(UITableView *)tableView cellID:(NSString *)cellid{
    return [[TitleAndSwitchCell alloc] initTitleAndSwitchCell:tableView cellID:cellid];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIsOn:(BOOL)isOn{
    _isOn = isOn;
    [self.mySwitch setOn:isOn animated:YES];
}

- (void)setIsMust:(BOOL)isMust{
    _isMust = isMust;
    if (isMust) {
        self.tagLabel.hidden = NO;
    }else{
        self.tagLabel.hidden = YES;
    }
}
- (void)createUI{
    
    self.titleLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(CELLMARGIN);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(CELLTITLEWIDTH));
    }];
    
    self.tagLabel = [SEFactory labelWithText:@"*" frame:CGRectZero textFont:Font(11 * SCALE_WIDTH) textColor:MainRedColor textAlignment:NSTextAlignmentCenter];
    self.tagLabel.hidden = YES;
    [self.titleLabel addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.titleLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(8 * SCALE_WIDTH, 8 * SCALE_WIDTH));
    }];
    
    self.mySwitch = [[UISwitch alloc] init];
    self.mySwitch.onTintColor = MainYellowColor;
    [self.mySwitch setTintColor:TextDarkGrayColor];
    [self.mySwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.mySwitch];
    [self.mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-CELLMARGIN);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)switchIsChanged:(UISwitch *)sender{
    if (self.switchBlock) {
        self.switchBlock(sender.isOn);
    }
}

@end
