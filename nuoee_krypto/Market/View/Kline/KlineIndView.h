//
//  KlineIndView.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 指标view
 */
@interface KlineIndView : UIView

/* block */
@property (nonatomic, copy) BaseIdBlock changeIndBlock;

- (instancetype)initWithType:(KMenuStateType)type;

- (void)adjustSubviews:(UIInterfaceOrientation)orientation;

//清空所有选中状态
- (void)reloadClear;

@end
