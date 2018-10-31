//
//  NoteRefreshNormalHeader.m
//  SuperEducation
//
//  Created by wangcl on 2017/6/9.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "NoteRefreshNormalHeader.h"

@implementation NoteRefreshNormalHeader
- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = MJRefreshLabelLeftInset;
    // 初始化文字
    self.stateLabel.textColor = MainYellowColor;
    self.lastUpdatedTimeLabel.textColor = MainYellowColor;
    self.lastUpdatedTimeLabel.font = Font(12);
    [self setTitle: @"下拉即可同步" forState:MJRefreshStateIdle];
    [self setTitle: @"松开立即同步到云端" forState:MJRefreshStatePulling];    
}
-(void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    // 如果label隐藏了，就不用再处理
    if (self.lastUpdatedTimeLabel.hidden) return;
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    // 如果有block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }

    if (lastUpdatedTime) {
        // 2.格式化日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        // 3.显示日期
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@",@"上次同步的时间：",time];
    }
}

@end
