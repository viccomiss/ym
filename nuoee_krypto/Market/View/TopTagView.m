//
//  TopTagView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/31.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "TopTagView.h"
#import "CoinRankLeftTagView.h"
#import "TopCollectionViewCell.h"

static NSString *topCollectionCellId = @"topCollectionCellId";

@interface TopTagView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) CoinRankLeftTagView *leftView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) CGPoint currentOffset;
@property (nonatomic, assign) CoinRankOrExchangeType type;


@end

@implementation TopTagView

- (instancetype)initWithType:(CoinRankOrExchangeType)type{
    if (self == [super init]) {
        
        self.type = type;
        self.dataArray = type == CoinRankType ? @[@"价格",@"24h涨跌幅",@"24h成交额",@"流通市值",@"流通数量",@"流通率",@"发行总量"] : @[@"最新价格",@"涨幅",@"24h成交量",@"24h最高",@"24h最低"];
        [self createUI];
    }
    return self;
}

#pragma mark - init
- (void)createUI{
    
    [self addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.4);
    }];
    self.leftView.type = self.type;
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self.leftView.mas_right);
    }];
}

#pragma mark - collection datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    TopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:topCollectionCellId forIndexPath:indexPath];
    cell.content = self.dataArray[indexPath.item];
    cell.offset = self.currentOffset;
    cell.index = indexPath.item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView addObserver:cell forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView removeObserver:cell forKeyPath:@"contentOffset"];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type != CoinRankType) {
        return CGSizeMake(MAINSCREEN_WIDTH * 0.6 / 2, AdaptY(34));
    }
    if (indexPath.item == 0 || indexPath.item == 1 || indexPath.item == 5) {
        return CGSizeMake(MAINSCREEN_WIDTH * 0.6 / 2, AdaptY(34));
    }
    return CGSizeMake(MAINSCREEN_WIDTH * 0.4, AdaptY(34));
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        if (scrollView.contentOffset.y != 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
            return;
        }
        if (scrollView.contentOffset.x <= 0)
        {
            CGPoint offset = scrollView.contentOffset;
            offset.x = 0;
            scrollView.contentOffset = offset;
        }
        [self.collectionView setValue:[NSValue valueWithCGPoint:scrollView.contentOffset] forKeyPath:@"contentOffset"];
        self.currentOffset = scrollView.contentOffset;
        if ([self.delegate respondsToSelector:@selector(topTagCurrentOffset:)]) {
            [self.delegate topTagCurrentOffset:scrollView.contentOffset];
        }
    }
}

#pragma mark - init
- (CoinRankLeftTagView *)leftView{
    if (!_leftView) {
        _leftView = [[CoinRankLeftTagView alloc] init];
    }
    return _leftView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = MainDarkColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[TopCollectionViewCell class] forCellWithReuseIdentifier:topCollectionCellId];
    }
    return _collectionView;
}


@end
