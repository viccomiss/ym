//
//  ProgressTableViewCell.h
//  SuperEducation
//
//  Created by 123 on 2017/4/22.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProgressTableViewCell : BaseTableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cacheSize;
@property (nonatomic, assign) BOOL clearDone;
@end
