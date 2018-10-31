//
//  WarnRemindCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/16.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Warn.h"

/**
 提醒cell
 */
@interface WarnRemindCell : BaseTableViewCell

+ (instancetype)warnRemindCell:(UITableView *)tableView;
/* warn */
@property (nonatomic, strong) Warn *model;
/* del */
@property (nonatomic, copy) BaseBlock delBlock;


@end
