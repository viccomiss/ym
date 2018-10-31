//
//  MainContentCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/5/31.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CurrencyRank.h"
#import "CurrencyMarket.h"
#import "ExchangeTicks.h"

typedef void(^offsetBlock)(CGPoint offset);

@interface MainContentCell : BaseTableViewCell

+ (instancetype)mainContentCell:(UITableView *)tableView type:(CoinRankOrExchangeType)type;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) offsetBlock offsetBlock;
/* model */
@property (nonatomic, strong) CurrencyRank *model;
/* market */
@property (nonatomic, strong) CurrencyMarket *market;
/* ExchangeTicks */
@property (nonatomic, strong) ExchangeTicks *exchange;

/* collection touch */
@property (nonatomic, copy) BaseBlock contentTouchBlock;


@end
