//
//  ContentCollectionViewCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/1.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ContentCollectionViewCell.h"
#import "SEUserDefaults.h"
#import "NSString+JLAdd.h"

@interface ContentCollectionViewCell()

@property (nonatomic, strong) BaseLabel *contentLabel;
@property (nonatomic, strong) BaseLabel *detailLabel;

@end

@implementation ContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}

- (void)setModel:(NumberAndTypeModel *)model{
    _model = model;
    
    if (model.index == 0 && model.rankOrExchangeType != CoinRankType) {
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(MidPadding);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-MidPadding-MinPadding);
            make.bottom.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(self.contentLabel);
            make.top.mas_equalTo(self.contentView.mas_centerY).offset(AdaptY(4));
        }];
        
        self.detailLabel.text = [NSString stringWithFormat:@"$%.2f",model.usdPrice];
        
    }else{
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(MidPadding);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-MidPadding-MinPadding);
            make.top.bottom.mas_equalTo(self.contentView);
        }];
        
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.mas_equalTo(self.contentLabel);
            make.top.mas_equalTo(self.contentView.mas_centerY).offset(AdaptY(4));
            make.height.equalTo(@(0));
        }];
    }
    
    if (model.type == NumberChangeType) {
        self.contentLabel.textColor = [[SEUserDefaults shareInstance] getRiseOrFallColor: model.number > 0 ? RoseType : FallType];
        self.contentLabel.text = model.number > 0 ? [NSString stringWithFormat:@"+%.2f%%",model.number] : [NSString stringWithFormat:@"%.2f%%",model.number];
    }else if (model.type == NumberVolNumType){
        self.contentLabel.textColor = WhiteTextColor;
        self.contentLabel.text = [NSString stringWithFormat:@"%.2f万",model.number];
    }else if (model.type == NumberVolType){
        self.contentLabel.textColor = WhiteTextColor;
        self.contentLabel.text = [NSString numberFormatterToRMB:model.number];
        
    }else if (model.type == NumberFlowRateType){
        self.contentLabel.textColor = WhiteTextColor;
        self.contentLabel.text = [NSString stringWithFormat:@"%.2f%%",model.number * 100];
    }else if (model.type == NumberSupplyType || model.type == NumberMaxSupplyType || model.type == NumberMarketCapType){
        self.contentLabel.textColor = WhiteTextColor;
        self.contentLabel.text = [NSString numberFormatterToNum:model.number];
    }else if (model.type == NumberPriceType){
        self.contentLabel.textColor = WhiteTextColor;
        self.contentLabel.text = [NSString numberFormatterToAllRMB:model.number];
    }
    else{
        self.contentLabel.textColor = WhiteTextColor;
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(MidPadding);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MidPadding-MinPadding);
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.contentLabel);
        make.top.mas_equalTo(self.contentView.mas_centerY).offset(AdaptY(4));
        make.height.equalTo(@(0));
    }];
}

#pragma mark - init
- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(AdaptX(14)) textColor:WhiteTextColor textAlignment:NSTextAlignmentRight];
    }
    return _contentLabel;
}

- (BaseLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(AdaptX(12)) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentRight];
    }
    return _detailLabel;
}

@end
