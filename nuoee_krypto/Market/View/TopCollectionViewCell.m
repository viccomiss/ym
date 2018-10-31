//
//  TopCollectionViewCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/31.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "TopCollectionViewCell.h"
#import "NSDictionary+JKSafeAccess.h"

@interface TopCollectionViewCell()

@property (nonatomic, strong) BaseLabel *contentLabel;
@property (nonatomic, strong) BaseImageView *tagView;



@end

@implementation TopCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *value = [change objectForKey:@"new"];
        CGPoint point = [value CGPointValue];
        self.offset = point;
        [self reload];
    }
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.contentLabel.text = content;
}

- (void)setOffset:(CGPoint)offset{
    _offset = offset;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    [self reload];
}

- (void)reload{
    if (self.index == 1 && self.offset.x <= 0) {
        [self showTag];
    }else{
        [self hideTag];
    }
}

- (void)showTag{
    
    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-AdaptX(10));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(5), AdaptY(10)));
    }];
}

- (void)hideTag{
    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-AdaptX(10));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-AdaptX(10));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(MidPadding);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MidPadding-MinPadding);
        make.top.bottom.mas_equalTo(self.contentView);
    }];
}

#pragma mark - init
- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(AdaptX(14)) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentRight];
    }
    return _contentLabel;
}

- (BaseImageView *)tagView{
    if (!_tagView) {
        _tagView = [[BaseImageView alloc] initWithImage:ImageName(@"arrow_tag_right")];
    }
    return _tagView;
}

@end


