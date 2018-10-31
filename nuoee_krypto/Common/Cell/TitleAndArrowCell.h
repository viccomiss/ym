//
//  TitleAndArrowCell.h
//  wxer_manager
//
//  Created by levin on 2017/7/8.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UserModel.h"

/**
 title 和 小箭头
 */
@interface TitleAndArrowCell : BaseTableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showField;
/** 输入框是否可以编辑 */
@property (nonatomic, assign) BOOL disableField;
/* 是否显示箭头 */
@property (nonatomic, assign) BOOL disArrowBtn;
/** 是否显示重新编辑按钮 */
@property (nonatomic, assign) BOOL showReEidt;
@property (nonatomic, copy) NSString *placeholder;
/* placeholderColor */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 是否是必填项 */
@property (nonatomic, assign) BOOL isMust;
/* user */
@property (nonatomic, strong) UserModel *username;
/* gnder */
@property (nonatomic, strong) UserModel *gender;



+ (instancetype)titleAndArrowCellCell:(UITableView *)tableView cellID:(NSString *)cellid;

@end
