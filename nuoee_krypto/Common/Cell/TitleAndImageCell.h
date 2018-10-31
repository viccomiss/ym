//
//  TitleAndImageCell.h
//  wxer_manager
//
//  Created by levin on 2017/8/4.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "BaseTableViewCell.h"

/**
 左title 右image+arrow
 */
@interface TitleAndImageCell : BaseTableViewCell

@property (nonatomic, copy) NSString *title;
/** 是否是必填项 */
@property (nonatomic, assign) BOOL isMust;
/** size */
@property (nonatomic, assign) CGSize imgSize;

@property (nonatomic, strong) BaseImageView *imgView;

/** placeImage */
@property (nonatomic, strong) UIImage *placeHolderImg;

+ (instancetype)titleAndImageCellCell:(UITableView *)tableView cellID:(NSString *)cellid;

@end
