//
//  KlineIndCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "KlineIndCell.h"

@interface KlineIndCell()

/* content */
@property (nonatomic, strong) BaseLabel *contentLabel;
/* line */
@property (nonatomic, strong) UIView *lineView;
/* more */
@property (nonatomic, strong) BaseImageView *moreView;
/* rotat */
@property (nonatomic, strong) BaseImageView *rotatView;


@end

@implementation KlineIndCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}

- (void)setModel:(KlineIndModel *)model{
    _model = model;
    
    self.contentLabel.text = model.ind;
   
    
    if (model.stateType == KMenuDynamicType || model.stateType == KMenuQuataType) {
        //动态隐藏
        self.contentView.backgroundColor = MainDarkColor;
        self.rotatView.hidden = YES;
        self.contentLabel.hidden = NO;
        self.moreView.hidden = YES;
        if (model.sel) {
            self.contentLabel.textColor = MainYellowColor;
            self.lineView.hidden = NO;
        }else{
            self.contentLabel.textColor = TextDarkGrayColor;
            self.lineView.hidden = YES;
        }
        
    }else{
        //固定
        if (model.type == KMenuRotatType) {
            self.rotatView.hidden = NO;
            self.contentLabel.hidden = YES;
            self.lineView.hidden = YES;
            self.moreView.hidden = YES;
            self.contentView.backgroundColor = MainBlackColor;
            
        }else{
            self.contentLabel.hidden = NO;
            self.rotatView.hidden = YES;
            if (model.type != KMenuNormalType) {
                
                self.lineView.hidden = YES;
                if (model.sel) {
                    self.contentLabel.textColor = MainYellowColor;
                    self.contentView.backgroundColor = MainDarkColor;
                }else{
                    self.contentLabel.textColor = TextDarkGrayColor;
                    self.contentView.backgroundColor = MainBlackColor;
                }
                self.moreView.hidden = NO;
                
            }else{
                self.moreView.hidden = YES;
                self.contentView.backgroundColor = MainBlackColor;
                if (model.sel) {
                    self.contentLabel.textColor = MainYellowColor;
                    self.lineView.hidden = NO;
                }else{
                    self.contentLabel.textColor = TextDarkGrayColor;
                    self.lineView.hidden = YES;
                }
            }
        }
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-3);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AdaptX(28), 2));
    }];
    
    [self.contentView addSubview:self.moreView];
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLabel.mas_right).offset(2);
        make.bottom.mas_equalTo(self.contentLabel.mas_bottom).offset(-3);
        make.size.mas_equalTo(CGSizeMake(5, 5));
    }];
    
    [self.contentView addSubview:self.rotatView];
    [self.rotatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(AdaptX(18), AdaptX(16)));
    }];
}

#pragma mark - init
- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _contentLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = MainYellowColor;
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (BaseImageView *)moreView{
    if (!_moreView) {
        _moreView = [[BaseImageView alloc] initWithImage:ImageName(@"arrow_right_bottom")];
        _moreView.hidden = YES;
    }
    return _moreView;
}

- (BaseImageView *)rotatView{
    if (!_rotatView) {
        _rotatView = [[BaseImageView alloc] initWithImage:ImageName(@"k_rotat")];
        _rotatView.hidden = YES;
    }
    return _rotatView;
}

@end
