//
//  TitleAndImageCell.m
//  wxer_manager
//
//  Created by levin on 2017/8/4.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "TitleAndImageCell.h"

@interface TitleAndImageCell ()

@property (nonatomic, strong) BaseLabel *titleLabel;
@property (nonatomic, strong) BaseButton *arrowBtn;
/** * */
@property (nonatomic, strong) BaseLabel *tagLabel;
/** imge */
@end

@implementation TitleAndImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initTitleAndImageCell:(UITableView *)tableView cellID:(NSString *)cellid {
    
    self = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!self) {
        
        self = [[TitleAndImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return self;
}

+ (instancetype)titleAndImageCellCell:(UITableView *)tableView cellID:(NSString *)cellid{
    return [[TitleAndImageCell alloc] initTitleAndImageCell:tableView cellID:cellid];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIsMust:(BOOL)isMust{
    _isMust = isMust;
    if (isMust) {
        self.tagLabel.hidden = NO;
    }else{
        self.tagLabel.hidden = YES;
    }
}

- (void)setPlaceHolderImg:(UIImage *)placeHolderImg{
    _placeHolderImg = placeHolderImg;
    self.imgView.image = placeHolderImg;
}

- (void)setImgSize:(CGSize)imgSize{
    _imgSize = imgSize;
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowBtn.mas_left).offset(-CELLMINMARGIN);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(imgSize.width, imgSize.height));
    }];
}

- (void)createUI{
        
    self.titleLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(CELLMARGIN);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    self.tagLabel = [SEFactory labelWithText:@"*" frame:CGRectZero textFont:Font(11 * SCALE_WIDTH) textColor:MainRedColor textAlignment:NSTextAlignmentCenter];
    self.tagLabel.hidden = YES;
    [self.titleLabel addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.titleLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(8 * SCALE_WIDTH, 8 * SCALE_WIDTH));
    }];
    
    self.arrowBtn = [SEFactory buttonWithTitle:nil image:ImageName(@"arrow_right") frame:CGRectZero font:CELLCONTECTFONT fontColor:MainTextColor];
    [self.contentView addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-CELLMINMARGIN);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(25), AdaptX(25)));
    }];
    
    self.imgView = [[BaseImageView alloc] init];
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowBtn.mas_left).offset(-CELLMINMARGIN);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptY(35), AdaptY(35)));
    }];
}


@end
