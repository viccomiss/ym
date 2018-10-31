//
//  TitleAndSwitchCell.h
//  wxer_manager
//
//  Created by levin on 2017/7/8.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "BaseTableViewCell.h"

/**
 title 和 开关
 */
@interface TitleAndSwitchCell : BaseTableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isMust;

@property (nonatomic, copy) BaseBoolBlock switchBlock;
/* on */
@property (nonatomic, assign) BOOL isOn;


+ (instancetype)titleAndSwitchCell:(UITableView *)tableView cellID:(NSString *)cellid;

@end
