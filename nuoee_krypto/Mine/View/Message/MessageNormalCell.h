//
//  MessageNormalCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/12.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MessageModel.h"

@interface MessageNormalCell : BaseTableViewCell

+ (instancetype)messageNormalCell:(UITableView *)tableView;

/* model */
@property (nonatomic, strong) Message *model;


@end
