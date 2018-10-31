//
//  MainContentView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/31.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MainContentView.h"
#import "MainContentCell.h"
#import "CurrencyMarket.h"
#import "ExchangeTicks.h"

@interface MainContentView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CoinRankOrExchangeType type;


@end

@implementation MainContentView

- (instancetype)initWithType:(CoinRankOrExchangeType)type{
    if (self == [super init]) {
        
        self.type = type;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = MainBlackColor;
    }
    return self;
}

- (void)setCurrentOffset:(CGPoint)currentOffset{
    _currentOffset = currentOffset;
    @synchronized(self)
    {
        for (MainContentCell* c in self.visibleCells) {
            c.collectionView.contentOffset = _currentOffset;
        }
    }
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainContentCell *cell = [MainContentCell mainContentCell:tableView type:self.type];
    if (self.type == CoinRankType) {
        CurrencyRank *model = self.dataArray[indexPath.row];
        model.index = indexPath.row;
        cell.model = model;
    }else if(self.type == ExchangeType){
        CurrencyMarket *m = self.dataArray[indexPath.row];
        m.index = indexPath.row;
        cell.market = m;
    }else{
        ExchangeTicks *e = self.dataArray[indexPath.row];
        e.index = indexPath.row;
        cell.exchange = e;
    }
    WeakSelf(self);
    cell.offsetBlock = ^(CGPoint offset){
        @synchronized(weakself)
        {
            weakself.currentOffset = offset;
            if ([weakself.mainDelegate respondsToSelector:@selector(mainContentCurrentOffset:)]) {
                [weakself.mainDelegate mainContentCurrentOffset:offset];
            }
            for (MainContentCell* c in weakself.visibleCells) {
                c.collectionView.contentOffset = weakself.currentOffset;
            }
        }
    };
    cell.contentTouchBlock = ^(){
        [weakself didSelectRow:indexPath tableView:tableView];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //处理cell复用
    MainContentCell *c = (MainContentCell *)cell;
    c.collectionView.contentOffset = self.currentOffset;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(47);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self didSelectRow:indexPath tableView:tableView];
}

- (void)didSelectRow:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    MainContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.contentView.backgroundColor = [cell.contentView.backgroundColor colorWithAlphaComponent:0.5];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            cell.contentView.backgroundColor = [cell.contentView.backgroundColor colorWithAlphaComponent:1];
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    if (self.type == CoinRankType) {
        CurrencyRank *model = self.dataArray[indexPath.row];
        model.index = indexPath.row;
        if ([self.mainDelegate respondsToSelector:@selector(didSelectedCoinDetail:)]) {
            [self.mainDelegate didSelectedCoinDetail:model];
        }
    }else if(self.type == ExchangeType){
        CurrencyMarket *m = self.dataArray[indexPath.row];
        m.index = indexPath.row;
        if ([self.mainDelegate respondsToSelector:@selector(didSelectedCoinDetail:)]) {
            [self.mainDelegate didSelectedCoinDetail:m];
        }
    }else{
        ExchangeTicks *e = self.dataArray[indexPath.row];
        e.index = indexPath.row;
        if ([self.mainDelegate respondsToSelector:@selector(didSelectedCoinDetail:)]) {
            [self.mainDelegate didSelectedCoinDetail:e];
        }
    }
}

@end
