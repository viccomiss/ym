//
//  BaseCell.h
//  SuperEducation
//
//  Created by 123 on 2017/3/2.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELLTITLEFONT AdaptFont(15)
#define CELLCONTECTFONT AdaptFont(14)
#define CELLTITLEWIDTH 70 * SCALE_WIDTH
#define CELLMARGIN 15 * SCALE_WIDTH
#define CELLMINMARGIN 5 * SCALE_WIDTH

@interface BaseTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL separatorLine;
/* lineColor */
@property (nonatomic, strong) UIColor *lineColor;
@end
