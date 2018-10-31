//
//  FlashCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "FlashCell.h"
#import "XHStarRateView.h"
#import "DateManager.h"
#import "NSString+JLAdd.h"

#define ContentWidth MAINSCREEN_WIDTH - AdaptX(60)

/** 看好看空 */
typedef NS_ENUM(NSUInteger, SeeType){
    SeeUpType,
    SeeDownType,
};

static NSString *CellId = @"flashCellId";

@interface FlashCell()<CAAnimationDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) BaseLabel *timeLabel;
@property (nonatomic, strong) XHStarRateView *starsControl;
@property (nonatomic, strong) BaseButton *originalBtn;

@property (nonatomic, strong) BaseButton *upBtn;
@property (nonatomic, strong) BaseButton *downBtn;
@property (nonatomic, strong) BaseButton *shareBtn;

@property (nonatomic, strong) BaseLabel *upAniLabel;
@property (nonatomic, strong) BaseLabel *downAniLabel;

/* title */
@property (nonatomic, strong) BaseLabel *titleLabel;

/* content */
@property (nonatomic, strong) BaseLabel *contentLabel;

@end

@implementation FlashCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = MainBlackColor;
        [self createUI];
    }
    return self;
}

- (instancetype)initFlashCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!self) {
        self = [[FlashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)flashCell:(UITableView *)tableView{
    return [[FlashCell alloc] initFlashCell:tableView];
}

- (void)setModel:(Flash *)model{
    _model = model;
    
    self.timeLabel.text = [DateManager dateWithTimeIntervalSince1970:model.createTime format:@"HH:mm"];
    self.starsControl.currentScore = model.weight;
    [self.upBtn setTitle:[NSString stringWithFormat:@"利好 %ld",(long)model.rise] forState:UIControlStateNormal];
    [self.downBtn setTitle:[NSString stringWithFormat:@"利空 %ld",(long)model.fall] forState:UIControlStateNormal];
    
    self.titleLabel.attributedText = [model.title getAttributedStrWithLineSpace:3 font:Font(16)];
    self.contentLabel.attributedText = [model.content getAttributedStrWithLineSpace:3 font:Font(14)];
    
    self.titleLabel.frame = CGRectMake(AdaptX(20), 3 * MidPadding + AdaptY(20), MAINSCREEN_WIDTH - AdaptX(60), model.titleHeight);
    self.contentLabel.frame = CGRectMake(AdaptX(20), self.titleLabel.easy_bottom + AdaptY(6), ContentWidth, model.contentHeight);
    
    self.originalBtn.hidden = model.urlSource.length == 0 ? YES : NO;
    
    switch (model.riseOrFall) {
        case UnRiseAndUnFallType:
            self.upBtn.selected = NO;
            self.downBtn.selected = NO;
            break;
        case RiseAndUnFallType:
            self.upBtn.selected = YES;
            self.downBtn.selected = NO;
            break;
        case UnRiseAndFallType:
            self.upBtn.selected = NO;
            self.downBtn.selected = YES;
            break;
    }
    [self reloadState:NO];
    
//    self.titleLabel.backgroundColor = MainGreenColor;
//    self.contentLabel.backgroundColor = MainRedColor;
}

#pragma mark - action
- (void)shareTouch{
    if (self.shareBlock) {
        self.shareBlock();
    }
}

- (void)originalTouch{
    if (self.originalBlock) {
        self.originalBlock();
    }
}

- (void)upTouch:(BaseButton *)sender{

    if (self.riseBlock) {
        self.riseBlock(sender.selected);
    }
}

- (void)upSuccess{
    [self reloadState:YES];
}

- (void)downTouch:(BaseButton *)sender{

    if (self.fallBlock) {
        self.fallBlock(sender.selected);
    }
}

- (void)downSuccess{
    [self reloadState:YES];
}

- (void)reloadState:(BOOL)ani{
    if (self.upBtn.selected) {
        [self.upBtn setBackgroundColor:MainRedColor];
        if (ani) {
            [self startAnimation:SeeUpType];
        }
    }else{
        [self.upBtn setBackgroundColor:LightRedColor];
    }
    
    if (self.downBtn.selected) {
        [self.downBtn setBackgroundColor:MainGreenColor];
        if (ani) {
            [self startAnimation:SeeDownType];
        }
    }else{
        [self.downBtn setBackgroundColor:LightGreenColor];
    }
}

//创建动画label
- (void)startAnimation:(SeeType)type{
    if (type == SeeUpType) {
        [self.upAniLabel removeFromSuperview];
        self.upAniLabel = nil;
    }else{
        [self.downAniLabel removeFromSuperview];
        self.downAniLabel = nil;
    }
    [self fire:type];
}

- (void)fire:(SeeType)type{
    BaseLabel *label = [SEFactory labelWithText:@"+ 1" frame:CGRectMake(type == SeeUpType ? self.upBtn.easy_right + 8 : self.downBtn.easy_right + 8, self.upBtn.easy_centerY, 17, 17) textFont:Font(12) textColor:type == SeeUpType ? MainRedColor : MainGreenColor textAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:label];
    
    CGPoint point = CGPointMake(label.easy_centerX, self.upBtn.easy_top - 8);
    
    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"position"];
    ani.toValue = [NSValue valueWithCGPoint:point];
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.delegate = self;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [label.layer addAnimation:ani forKey:type == SeeUpType ? @"PostionUp" : @"PostionDown"];
    if (type == SeeUpType) {
        self.upAniLabel = label;
    }else{
        self.downAniLabel = label;
    }
}

- (void)removeAni:(BaseLabel *)label{
    __block BaseLabel *l = label;
    [UIView animateWithDuration:0.3 animations:^{
        l.alpha = 0;
    } completion:^(BOOL finished) {
        [l removeFromSuperview];
        l = nil;
    }];
}

#pragma mark - animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([self.upAniLabel.layer animationForKey:@"PostionUp"] == anim) {
        [self removeAni:self.upAniLabel];
    }else{
        [self removeAni:self.downAniLabel];
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(MidPadding);
        make.right.bottom.mas_equalTo(self.contentView).offset(-MidPadding);
        make.top.mas_equalTo(self.contentView);
    }];
    
    [self.backView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(MidPadding);
        make.top.mas_equalTo(self.backView.mas_top).offset(2 * MidPadding);
        make.height.equalTo(@(AdaptY(20)));
    }];
    
    [self.backView addSubview:self.starsControl];
    [self.starsControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(AdaptX(6));
        make.size.mas_equalTo(CGSizeMake(AdaptX(100), AdaptY(17)));
    }];
    
    [self.backView addSubview:self.originalBtn];
    [self.originalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView.mas_right).offset(-2 * MidPadding);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
    }];
    
    [self.backView addSubview:self.upBtn];
    [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(2 * MidPadding);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(- 2 * MidPadding);
        make.height.equalTo(@(AdaptY(24)));
    }];
    
    [self.backView addSubview:self.downBtn];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upBtn.mas_right).offset(2 * MidPadding);
        make.bottom.mas_equalTo(self.upBtn.mas_bottom);
        make.height.equalTo(@(AdaptY(24)));
    }];
    
    [self.backView addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView.mas_right).offset(- 2 * MidPadding);
        make.centerY.height.mas_equalTo(self.upBtn);
    }];
    
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.contentLabel];
}

#pragma mark - init
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = MainDarkColor;
    }
    return _backView;
}

- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:MainYellowColor textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (XHStarRateView *)starsControl{
    if (!_starsControl) {
        
        _starsControl = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, AdaptX(100) , AdaptY(17))];
        _starsControl.isAnimation = NO;
        _starsControl.rateStyle = WholeStar;
    }
    return _starsControl;
}

- (BaseButton *)originalBtn{
    if (!_originalBtn) {
        _originalBtn = [SEFactory buttonWithTitle:@"[阅读原文]" frame:CGRectZero font:Font(14) fontColor:TextDarkLightGrayColor];
        [_originalBtn addTarget:self action:@selector(originalTouch) forControlEvents:UIControlEventTouchUpInside];
        _originalBtn.hidden = YES;
    }
    return _originalBtn;
}

- (BaseButton *)upBtn{
    if (!_upBtn) {
        _upBtn = [SEFactory buttonWithTitle:@"" image:ImageName(@"k_up") frame:CGRectZero font:Font(12) fontColor:WhiteTextColor];
        [_upBtn setImage:ImageName(@"k_up_select") forState:UIControlStateSelected];
        [_upBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        ViewRadius(_upBtn, AdaptY(12));
        [_upBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
        [_upBtn setBackgroundColor:LightRedColor];
        [_upBtn setTitleColor:MainRedColor forState:UIControlStateNormal];
        [_upBtn setTitleColor:WhiteTextColor forState:UIControlStateSelected];
        [_upBtn addTarget:self action:@selector(upTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upBtn;
}

- (BaseButton *)downBtn{
    if (!_downBtn) {
        _downBtn = [SEFactory buttonWithTitle:@"" image:ImageName(@"k_down") frame:CGRectZero font:Font(12) fontColor:WhiteTextColor];
        [_downBtn setImage:ImageName(@"k_down_select") forState:UIControlStateSelected];
        [_downBtn setBackgroundColor:LightGreenColor];
        [_downBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
        [_downBtn setTitleColor:MainGreenColor forState:UIControlStateNormal];
        [_downBtn setTitleColor:WhiteTextColor forState:UIControlStateSelected];
        [_downBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        ViewRadius(_downBtn, AdaptY(12));
        [_downBtn addTarget:self action:@selector(downTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downBtn;
}

- (BaseButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [SEFactory buttonWithTitle:@"分享" image:ImageName(@"share_gray") frame:CGRectZero font:Font(14) fontColor:TextDarkGrayColor];
        [_shareBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [_shareBtn  addTarget:self action:@selector(shareTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:TextDarkLightGrayColor textAlignment:NSTextAlignmentLeft];
        _contentLabel.backgroundColor = [UIColor clearColor];
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
