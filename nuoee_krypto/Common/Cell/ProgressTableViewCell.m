//
//  ProgressTableViewCell.m
//  SuperEducation
//
//  Created by 123 on 2017/4/22.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "ProgressTableViewCell.h"
#import <UIImage+GIF.h>
@interface ProgressTableViewCell ()
@property (nonatomic, strong) BaseLabel *leftLabel;
@property (nonatomic, strong) BaseLabel *cache;
@property (nonatomic, strong) BaseImageView *progress;
@end
@implementation ProgressTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorLine = YES;
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.cache];
        [self.contentView addSubview:self.progress];
        [self setContraints];
    }
    return self;
}
-(void)setClearDone:(BOOL)clearDone{
    _progress.hidden = clearDone?YES:NO;
}
-(void)setCacheSize:(NSString *)cacheSize{
    _cache.text = cacheSize;
}
-(void)setContraints{
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        MakeConstraints(nil, 0, self.contentView.mas_left, AdaptX(18), nil,0 , nil, 0);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(13);
    }];
    [_cache mas_makeConstraints:^(MASConstraintMaker *make) {
        MakeConstraints(nil, 0, nil, 0, nil,0 , self.contentView.mas_right,-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(13);
    }];
    
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cache.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _leftLabel.text = title;
}


-(BaseLabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [SEFactory labelWithFrame:CGRectZero textFont:Font(16) textColor:WhiteTextColor];
    }
    return _leftLabel;
}
-(BaseLabel *)cache{
    if (!_cache) {
        _cache = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:WhiteTextColor];
        _cache.textAlignment = NSTextAlignmentRight;
    }
    return _cache;
}

-(BaseImageView *)progress{
    if (!_progress) {
        _progress = [SEFactory imageViewWithImage: [UIImage sd_animatedGIFNamed:@"clearCache@3x"] frame:CGRectZero];
        _progress.hidden = YES;
    }
    return _progress;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
