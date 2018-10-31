//
//  TitleAndFieldCell.h
//  wxer_manager
//
//  Created by levin on 2017/7/7.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface TitleAndFieldCell : BaseTableViewCell

@property (nonatomic, strong) BaseTextField *filed;
/* textColor */
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;
/** 键盘类型 */
@property (nonatomic, assign) UIKeyboardType keyboardType;
/* 禁止emoji表情 */
@property (nonatomic, assign) BOOL disableEmoji;

/** 是否是必填项 */
@property (nonatomic, assign) BOOL isMust;
/* 限制字数 */
@property (nonatomic, assign) NSInteger limitNum;
/* 已有字数 */
@property (nonatomic, assign) NSInteger haveNum;
/* 是否显示字数限制 */
@property (nonatomic, assign) BOOL isLimit;

+ (instancetype)titleAndFieldCell:(UITableView *)tableView cellID:(NSString *)cellid;

@end
