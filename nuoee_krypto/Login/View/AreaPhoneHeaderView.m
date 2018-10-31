//
//  AreaPhoneHeaderView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "AreaPhoneHeaderView.h"
#import "PhoneAreaCodeViewController.h"
#import "CommonUtils.h"

@interface AreaPhoneHeaderView()

@property (nonatomic, strong) BaseButton *areaBtn;
@property (nonatomic, copy) BaseIdBlock headStrBlock;


@end

@implementation AreaPhoneHeaderView

+ (instancetype)areaPhoneHeaderViewWithFrame:(CGRect)frame headStrBlock:(BaseIdBlock)headStrBlock{
    return [[AreaPhoneHeaderView alloc] initWithFrame:frame headStrBlock:headStrBlock];
}

- (instancetype)initWithFrame:(CGRect)frame headStrBlock:(BaseIdBlock)headStrBlock{
    if (self == [super initWithFrame:frame]) {
        
        self.headStrBlock = headStrBlock;
        [self createUI];
    }
    return self;
}

#pragma mark - action
- (void)areaTouch{
    PhoneAreaCodeViewController *areaVC = [[PhoneAreaCodeViewController alloc] init];
    [[CommonUtils currentViewController].navigationController pushViewController:areaVC animated:YES];
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.areaBtn];
    [self.areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - init
- (BaseButton *)areaBtn{
    if (!_areaBtn) {
        //ImageName(@"arrow_down_white")
        _areaBtn = [SEFactory buttonWithTitle:@"+86" image:nil frame:CGRectZero font:Font(14) fontColor:WhiteTextColor];
        [_areaBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:8];
//        [_areaBtn addTarget:self action:@selector(areaTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _areaBtn;
}





@end
