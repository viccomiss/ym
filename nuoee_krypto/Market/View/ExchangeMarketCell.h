//
//  ExchangeMarketCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/1.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Exchange.h"

/**
 交易所行情cell
 */
@interface ExchangeMarketCell : BaseTableViewCell

+ (instancetype)exchangeMarketCell:(UITableView *)tableView;

/* model */
@property (nonatomic, strong) Exchange *model;


@end
