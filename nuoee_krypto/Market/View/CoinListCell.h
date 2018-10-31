//
//  CoinListCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/26.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Currency.h"
#import "SearchModel.h"

/**
 币列表cell
 */
@interface CoinListCell : BaseTableViewCell

/* model */
@property (nonatomic, strong) Currency *model;
/* search */
@property (nonatomic, strong) SearchModel *search;


+ (instancetype)coinListCell:(UITableView *)tableView;

@end
