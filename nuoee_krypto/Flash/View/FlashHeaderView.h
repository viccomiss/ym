//
//  FlashHeaderView.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashModel.h"

@interface FlashHeaderView : UITableViewHeaderFooterView

+ (instancetype)flashHeader:(UITableView *)tableView;

/* model */
@property (nonatomic, strong) FlashGroupModel *model;


@end
