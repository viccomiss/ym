//
//  MineHeaderView.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/8.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

/**
 个人中心header
 */
@interface MineHeaderView : UIView

/* arrowBlock */
@property (nonatomic, copy) BaseBlock userInfoBlock;
/* loginBlock */
@property (nonatomic, copy) BaseBlock loginBlock;
/* settingBlock */
@property (nonatomic, copy) BaseBlock settingBlock;
/* user */
@property (nonatomic, strong) UserModel *user;


@end
