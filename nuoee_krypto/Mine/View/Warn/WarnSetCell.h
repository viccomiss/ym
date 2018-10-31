//
//  WarnSetCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/16.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTableViewCell.h"

/**
 设置警告
 */
@interface WarnSetCell : BaseTableViewCell

+ (instancetype)warnSetCell:(UITableView *)tableView type:(RoseOrFallType)type;
/* prefix */
@property (nonatomic, assign) BOOL prefix;
/* 中间值 */
@property (nonatomic, assign) CGFloat middlePrice;
/* block */
@property (nonatomic, copy) BaseFloatBlock priceBlock;


@end

