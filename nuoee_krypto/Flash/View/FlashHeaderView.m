//
//  FlashHeaderView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "FlashHeaderView.h"
#import "DateManager.h"

static NSString *headerCellId = @"headerCellId";

@interface FlashHeaderView()

@property (nonatomic, strong) BaseLabel *timeLabel;
/* news */
@property (nonatomic, strong) BaseLabel *newsLabel;

@end

@implementation FlashHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = MainBlackColor;
        [self createUI];
    }
    return self;
}

- (instancetype)initFlashHeader:(UITableView *)tableView{
    self = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerCellId];
    if (!self) {
        self = [[FlashHeaderView alloc] initWithReuseIdentifier:headerCellId];
    }
    return self;
}

+ (instancetype)flashHeader:(UITableView *)tableView{
    return [[FlashHeaderView alloc] initFlashHeader:tableView];
}

- (void)setModel:(FlashGroupModel *)model{
    _model = model;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", [DateManager timeStrConvertFormatStr:model.time fromFormat:@"yyyy-MM-dd" toFormat:@"MM月dd日" defaultZone:NO],[DateManager weekdayStringFromDate:[DateManager dateConvertFrom_YMD_String:model.time]]];
    
    self.newsLabel.hidden = model.news == 0 ? YES : NO;
    self.newsLabel.text = [NSString stringWithFormat:@"%ld条新快讯",model.news];
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.contentView);
        make.height.equalTo(@(AdaptY(47)));
    }];
    
    [self.contentView addSubview:self.newsLabel];
    [self.newsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.timeLabel);
        make.height.equalTo(@(AdaptY(29)));
        make.top.mas_equalTo(self.timeLabel.mas_bottom);
    }];
}

#pragma mark - init
- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
        _timeLabel.backgroundColor = MainDarkColor;
    }
    return _timeLabel;
}

- (BaseLabel *)newsLabel{
    if (!_newsLabel) {
        _newsLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:MainYellowColor textAlignment:NSTextAlignmentCenter];
        _newsLabel.backgroundColor = ColorFromHex(0x1E1E1E);
    }
    return _newsLabel;
}

@end
