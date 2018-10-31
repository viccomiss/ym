//
//  WarnCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/13.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Warn.h"

@interface WarnCell : BaseTableViewCell

+ (instancetype)warnCell:(UITableView *)tableView;

/* model */
@property (nonatomic, strong) Warn *model;
/* closeBlock */
@property (nonatomic, copy) BaseBlock closeBlock;


@end
