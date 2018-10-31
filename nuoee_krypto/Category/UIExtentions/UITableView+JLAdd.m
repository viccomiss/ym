//
//  UITableView+JLAdd.m
//  HCMedical
//
//  Created by jack on 16/6/27.
//  Copyright © 2016年 jack. All rights reserved.
//

#import "UITableView+JLAdd.h"

@implementation UITableView (JLAdd)

//去掉多余的分割线
+ (void)setExtraCellLineHidden:(UITableView *)tableView {
    
    UIView *view =[ [UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
