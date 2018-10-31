//
//  ShareCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/20.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ShareCell.h"

@interface ShareCell()

/* icon */
@property (nonatomic, strong) BaseImageView *iconView;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;

@end

@implementation ShareCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}

- (void)setModel:(ShareModel *)model{
    _model = model;
    self.iconView.image = ImageName(model.icon);
    self.nameLabel.text = model.name;
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-AdaptY(5));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AdaptX(48), AdaptX(48)));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(AdaptY(5));
        make.left.right.mas_equalTo(self.contentView);
    }];
}

#pragma mark - init
- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] init];
    }
    return _iconView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _nameLabel;
}

@end
