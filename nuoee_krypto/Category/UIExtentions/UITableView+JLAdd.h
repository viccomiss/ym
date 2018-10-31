//
//  UITableView+JLAdd.h
//  HCMedical
//
//  Created by jack on 16/6/27.
//  Copyright © 2016年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (JLAdd)

/**
 *  除去 UITableView 中多余的分割线
 *
 *  @param tableView 传入的UITableView
 */
+ (void)setExtraCellLineHidden:(UITableView *)tableView;

@end
