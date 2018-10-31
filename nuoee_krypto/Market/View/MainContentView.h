//
//  MainContentView.h
//  nuoee_krypto
//
//  Created by Mac on 2018/5/31.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseTableView.h"

/**
 主content
 */
@protocol MainContentDelegate<NSObject>

- (void)mainContentCurrentOffset:(CGPoint)offset;

- (void)didSelectedCoinDetail:(id)object;

@end

@interface MainContentView : BaseTableView

- (instancetype)initWithType:(CoinRankOrExchangeType)type;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) id<MainContentDelegate> mainDelegate;
/**
 记录当前偏移量
 */
@property (nonatomic, assign) CGPoint currentOffset;


@end
