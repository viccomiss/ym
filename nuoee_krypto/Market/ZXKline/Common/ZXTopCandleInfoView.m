//
//  ZXTopCandleInfoView.m
//  GJB
//
//  Created by 郑旭 on 2017/9/30.
//  Copyright © 2017年 汇金集团SR. All rights reserved.
//

#import "ZXTopCandleInfoView.h"
#import "ZXHeader.h"
#import <Masonry.h>
#import "SEUserDefaults.h"

@interface ZXTopCandleInfoView()
@property (nonatomic,strong) NSMutableArray *labelArray;
@end
@implementation ZXTopCandleInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self creatUI];
        [self setUI];
    }
    return self;
}
- (void)setUI
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}
- (void)creatUI
{
    
    self.labelArray = [NSMutableArray array];
    UIView *previousView = self;
//    CGFloat width = ([UIScreen mainScreen].bounds.size.width-ZXLeftMargin-ZXRightMargin)/4.0;
    for (int i = 0; i<4; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:10];
        label.text = @"";
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.left.mas_equalTo(previousView).offset(ZXLeftMargin);
            }else{
                make.left.mas_equalTo(previousView.mas_right).offset(ZXLeftMargin * 2);
            }
//            make.width.mas_equalTo(width);
            make.top.bottom.mas_equalTo(self)
            ;
        }];
        [self.labelArray addObject:label];
        previousView = label;
    }
}
- (void)updateInfoWithModel:(KlineModel *)model precision:(int)precision
{
    
    if (model.isPlaceHolder) {
        
        [self setLabelTextWithOpen:0 close:0 high:0 low:0 precision:0];
        
    }else{
        [self setLabelTextWithOpen:model.openPrice close:model.closePrice high:model.highestPrice low:model.lowestPrice precision:precision];
    }
    
}

- (void)setLabelTextWithOpen:(double)open close:(double)close high:(double)high low:(double)low precision:(int)precision
{
    NSString *openString = [NSString stringWithFormat:@"开:%.2f",open];
    NSAttributedString *openAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:[self setupAttributeString:openString color:[[SEUserDefaults shareInstance] getRiseOrFallColor:FallType]]];
    NSString *closeString = [NSString stringWithFormat:@"收:%.2f",close];
    NSAttributedString *closeAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:[self setupAttributeString:closeString color:[[SEUserDefaults shareInstance] getRiseOrFallColor:RoseType]]];
    NSString *highString = [NSString stringWithFormat:@"高:%.2f",high];
    NSAttributedString *highAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:[self setupAttributeString:highString color:[[SEUserDefaults shareInstance] getRiseOrFallColor:FallType]]];
    NSString *lowString = [NSString stringWithFormat:@"低:%.2f",low];
    NSAttributedString *lowAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:[self setupAttributeString:lowString color:[[SEUserDefaults shareInstance] getRiseOrFallColor:RoseType]]];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:openAttributed,closeAttributed,highAttributed,lowAttributed,nil];
    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *label = self.labelArray[idx];
        label.attributedText = (NSAttributedString *)obj;
    }];
}

- (NSAttributedString *)setupAttributeString:(NSString *)text color:(UIColor *)attributedColor
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:TextDarkLightGrayColor range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:TextDarkLightGrayColor range:NSMakeRange(1, text.length-1)];
    return [attributedString copy];
}

@end
