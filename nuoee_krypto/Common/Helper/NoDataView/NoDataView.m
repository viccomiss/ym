//
//  NoDataView.m
//  SuperEducation
//
//  Created by yangming on 2017/5/31.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView ()

@property (nonatomic, strong) BaseImageView *coverView;
@property (nonatomic, strong) BaseLabel *tagLabel;
@property (nonatomic, strong) BaseButton *reloadButton;
@property (nonatomic, copy) BaseBlock reloadBlock;
/* tagStr */
@property (nonatomic, copy) NSString *tagStr;


@end

@implementation NoDataView

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = MainBlackColor;
        [self createUI];
    }
    return self;
}

- (void)showNoDataView:(CGRect)frame type:(NoDataType)type tagStr:(NSString *)tagStr needReload:(BOOL)needReload reloadBlock:(void(^)(void))reloadBlock{
    
    self.tagStr = tagStr;
    self.hidden = NO;
    self.frame = frame;
    [self.superview bringSubviewToFront:self];
    self.reloadBlock = reloadBlock;
    self.reloadButton.hidden = !needReload;
    
    [self reloadDataWithType:type];
}

//刷新数据
- (void)reloadDataWithType:(NoDataType)type{
    
    NSString *imageStr = @"";
    NSString *str = @"";
    NSString *btnTitle = @"";
    switch (type) {
        case NoTextType:
        {
            str = @"暂无内容";
            imageStr = @"zwwd";
        }
            break;
        case NoNetworkType:
        {
            str = @"请检查网络";
            imageStr = @"no_network";
        }
            break;
        case NoFlashType:
        {
            str = @"暂无快讯";
            imageStr = @"no_flash";
        }
            break;
        case NoUnWarnType:
        {
            str = @"暂无未触发预警";
            imageStr = @"no_warn";
        }
            break;
        case NoHistoryType:
        {
            str = @"暂无历史预警";
            imageStr = @"no_warn";
        }
            break;
        case NoSearchType:
        {
            str = [NSString stringWithFormat:@"没有找到\"%@\"相关结果",self.tagStr];
            imageStr = @"no_search";
            [self.reloadButton setTitle:@"换个关键词试试?" forState:UIControlStateNormal];
            self.reloadButton.backgroundColor = [UIColor clearColor];
            [self.reloadButton setTitleColor:TextDarkGrayColor forState:UIControlStateNormal];
            [self.reloadButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.mas_centerX);
                make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(MinPadding);
            }];
        }
            break;
        case NoMessageType:{
            str = @"暂无消息";
            imageStr = @"no_message";
        }
            break;
    }
    
    UIImage *image = ImageName(imageStr);
    self.coverView.image = image;
    
    [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.equalTo(@(image.size.width));
        make.height.equalTo(@(image.size.height));
        make.centerY.mas_equalTo(self.mas_centerY).offset(-AdaptY(120));
    }];
    
    self.tagLabel.text = str;
}

#pragma mark - action
- (void)reloadTouch:(BaseButton *)sender{
    
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

#pragma mark - UI
- (void)createUI{
    
    self.coverView = [[BaseImageView alloc] init];
    [self addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(-AdaptY(120));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150 * SCALE_WIDTH, 150 * SCALE_WIDTH));
    }];
    
    self.tagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(15 * SCALE_WIDTH) textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverView.mas_bottom).offset(15 * SCALE_HEIGHT);
        make.left.right.mas_equalTo(self);
        make.height.equalTo(@(20 * SCALE_HEIGHT));
    }];
    
    self.reloadButton = [SEFactory buttonWithTitle:@"重新加载" image:nil frame:CGRectZero font:Font(15 * SCALE_WIDTH) fontColor:WhiteTextColor];
    self.reloadButton.backgroundColor = MainYellowColor;
    ViewRadius(self.reloadButton, 4 * SCALE_WIDTH);
    [self.reloadButton addTarget:self action:@selector(reloadTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reloadButton];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(15 * SCALE_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(120 * SCALE_WIDTH, 42 * SCALE_HEIGHT));
    }];
}

@end
