//
//  KlineMoreIndView.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 更多指标
 */
@interface KlineMoreIndView : UIView

/* main cancel block */
@property (nonatomic, copy) BaseBlock mainCancelBlock;
/* vice cancel block */
@property (nonatomic, copy) BaseBlock viceCancelBlock;
/* mainSelectBlock */
@property (nonatomic, copy) BaseIdBlock mainSelectBlock;
/* vice */
@property (nonatomic, copy) BaseIdBlock viceSelectBlock;


@end
