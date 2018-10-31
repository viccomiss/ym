//
//  CoinListViewController.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/26.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseHiddenNavViewController.h"

/**
 币 列表
 */
@interface CoinListViewController : BaseViewController

/* array */
@property (nonatomic, strong) NSArray *listArray;
/* touchBlock */
@property (nonatomic, copy) BaseIdBlock coinBlock;


@end
