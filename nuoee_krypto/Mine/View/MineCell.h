//
//  MineCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/9.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MineModel.h"

@interface MineCell : BaseTableViewCell

/* type */
@property (nonatomic, assign) MineCellType type;

+ (instancetype)mineCell:(UITableView *)tableView;

/* model */
@property (nonatomic, strong) MineModel *model;


@end
