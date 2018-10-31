//
//  NumberAndTypeModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/12.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

//存储数值 加 对应type值
@interface NumberAndTypeModel : BaseModel

/* number */
@property (nonatomic, assign) CGFloat number;
/* usd */
@property (nonatomic, assign) CGFloat usdPrice;
/* type */
@property (nonatomic, assign) NumberType type;
/* index */
@property (nonatomic, assign) NSInteger index;
/* type */
@property (nonatomic, assign) CoinRankOrExchangeType rankOrExchangeType;


@end
