//
//  NoDataView.h
//  SuperEducation
//
//  Created by yangming on 2017/5/31.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 无数据view
 */
@interface NoDataView : UIView

- (void)showNoDataView:(CGRect)frame type:(NoDataType)type tagStr:(NSString *)tagStr needReload:(BOOL)needReload reloadBlock:(void(^)(void))reloadBlock;

@end
