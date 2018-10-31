//
//  CurrencyRank.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

@interface CurrencyRank : BaseModel

/* index */
@property (nonatomic, assign) NSInteger index;
/* change */
@property (nonatomic, assign) CGFloat change;
/* currency */
@property (nonatomic, copy) NSString *currency;
/* describe */
@property (nonatomic, copy) NSString *describe;
/* iconUrl */
@property (nonatomic, copy) NSString *iconUrl;
/* marketCap */
@property (nonatomic, assign) CGFloat marketCap;
/* maxSupply */
@property (nonatomic, assign) CGFloat maxSupply;
/* name */
@property (nonatomic, copy) NSString *name;
/* price */
@property (nonatomic, assign) CGFloat price;
/* supply */
@property (nonatomic, assign) CGFloat supply;
/* updateTime */
@property (nonatomic, assign) NSInteger updateTime;
/* vol */
@property (nonatomic, assign) CGFloat vol;

@end
