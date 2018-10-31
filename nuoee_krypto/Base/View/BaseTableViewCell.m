//
//  BaseCell.m
//  SuperEducation
//
//  Created by 123 on 2017/3/2.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()
@property (nonatomic, strong) UIView *separatorLineView;

@end
@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = MainDarkColor;
        [self baseViewConfig];
        [self.contentView addSubview:self.separatorLineView];
        [self setBaseContraints];
    }
    return self;
}

-(void)setSeparatorLine:(BOOL)separatorLine{
    _separatorLine = separatorLine;
    _separatorLineView.hidden = _separatorLine;
}

-(void)setBaseContraints{
    [_separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        MakeConstraints(nil, 0, self.contentView.mas_left, 0, self.contentView.mas_bottom, 0, self.contentView.mas_right, 0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.separatorLineView.backgroundColor = lineColor;
}

-(UIView *)separatorLineView{
    if (!_separatorLineView) {
        _separatorLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _separatorLineView.backgroundColor = LightDarkColor;
        _separatorLineView.hidden = YES;
    }
    return _separatorLineView;
}

- (void)baseViewConfig {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
