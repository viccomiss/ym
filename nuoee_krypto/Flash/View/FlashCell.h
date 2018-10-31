//
//  FlashCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FlashModel.h"


@interface FlashCell : BaseTableViewCell

+ (instancetype)flashCell:(UITableView *)tableView;

/* model */
@property (nonatomic, strong) Flash *model;

/* riseBlock */
@property (nonatomic, copy) BaseBoolBlock riseBlock;
/* fallBlock */
@property (nonatomic, copy) BaseBoolBlock fallBlock;
/* shareBlock */
@property (nonatomic, copy) BaseBlock shareBlock;
/* originalBlock */
@property (nonatomic, copy) BaseBlock originalBlock;


- (void)upSuccess;

- (void)downSuccess;

@end
