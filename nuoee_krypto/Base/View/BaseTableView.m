//
//  BaseTableView.m
//  SuperEducation
//
//  Created by 123 on 2017/2/28.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "BaseTableView.h"

@interface BaseTableView ()<UITableViewDelegate>

@end

@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self == [super initWithFrame:frame style:style]) {
        [self updateFit];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self updateFit];
    }
    return self;
}

- (instancetype)init{
    if (self == [super init]) {
        [self updateFit];
    }
    return self;
}

- (void)updateFit{
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
}

@end
