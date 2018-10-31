//
//  MainContentCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/31.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MainContentCell.h"
#import "LeftCoinRankView.h"
#import "ContentCollectionViewCell.h"
#import "LeftExchangeView.h"
#import "NumberAndTypeModel.h"

static NSString *contentCellId = @"contentCellId";
static NSString *contentCollectionCellId = @"contentCollectionCellId";

@interface MainContentCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) LeftCoinRankView *rankView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CoinRankOrExchangeType type;
@property (nonatomic, strong) LeftExchangeView *exchangeView;

@end

@implementation MainContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(CoinRankOrExchangeType)type{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.type = type;
        [self createUI];
    }
    return self;
}

- (instancetype)initMainContentCell:(UITableView *)tableView type:(CoinRankOrExchangeType)type{
    self = [tableView dequeueReusableCellWithIdentifier:contentCellId];
    if (!self) {
        self = [[MainContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentCellId type:type];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

+ (instancetype)mainContentCell:(UITableView *)tableView type:(CoinRankOrExchangeType)type{
    return [[MainContentCell alloc] initMainContentCell:tableView type:type];
}

- (void)setModel:(CurrencyRank *)model{
    _model = model;
    
    [self bgColor:model.index];
    
    self.rankView.currency = model;
    
    [self.dataArray removeAllObjects];
    
    //添加collection data
    //价格
    NumberAndTypeModel *nt1 = [[NumberAndTypeModel alloc] init];
    nt1.type = NumberPriceType;
    nt1.number = model.price;
    
    //24h涨跌幅
    NumberAndTypeModel *nt2 = [[NumberAndTypeModel alloc] init];
    nt2.type = NumberChangeType;
    nt2.number = model.change;
    
    //24h成交额
    NumberAndTypeModel *nt3 = [[NumberAndTypeModel alloc] init];
    nt3.type = NumberVolType;
    nt3.number = model.vol;

    //流通市值
    NumberAndTypeModel *nt4 = [[NumberAndTypeModel alloc] init];
    nt4.type = NumberVolType;
    nt4.number = model.marketCap;
    
    //流通数量
    NumberAndTypeModel *nt5 = [[NumberAndTypeModel alloc] init];
    nt5.type = NumberSupplyType;
    nt5.number = model.supply;
    
    //流通率
    NumberAndTypeModel *nt6 = [[NumberAndTypeModel alloc] init];
    nt6.type = NumberFlowRateType;
    nt6.number = model.supply / model.maxSupply;
    
    //发行总量
    NumberAndTypeModel *nt7 = [[NumberAndTypeModel alloc] init];
    nt7.type = NumberMaxSupplyType;
    nt7.number = model.maxSupply;
    
    [self.dataArray addObject:nt1];
    [self.dataArray addObject:nt2];
    [self.dataArray addObject:nt3];
    [self.dataArray addObject:nt4];
    [self.dataArray addObject:nt5];
    [self.dataArray addObject:nt6];
    [self.dataArray addObject:nt7];
    [self.collectionView reloadData];
}

- (void)setMarket:(CurrencyMarket *)market{
    _market = market;
    
    [self bgColor:market.index];
    
    self.exchangeView.market = market;
    
    [self.dataArray removeAllObjects];
    
    //添加collection data
    //最新价格
    NumberAndTypeModel *nt1 = [[NumberAndTypeModel alloc] init];
    nt1.type = NumberPriceType;
    nt1.usdPrice = [market.usdPrice floatValue];
    nt1.number = [market.last floatValue];
    
    //涨幅
    NumberAndTypeModel *nt2 = [[NumberAndTypeModel alloc] init];
    nt2.type = NumberChangeType;
    nt2.number = [market.degree floatValue];
    
    //24h成交量
    NumberAndTypeModel *nt3 = [[NumberAndTypeModel alloc] init];
    nt3.type = NumberVolNumType;
    nt3.number = [market.vol floatValue];
    
    //24h最高
    NumberAndTypeModel *nt4 = [[NumberAndTypeModel alloc] init];
    nt4.type = NumberPriceType;
    nt4.number = [market.high floatValue];
    
    //24h最低
    NumberAndTypeModel *nt5 = [[NumberAndTypeModel alloc] init];
    nt5.type = NumberPriceType;
    nt5.number = [market.low floatValue];
    
    [self.dataArray addObject:nt1];
    [self.dataArray addObject:nt2];
    [self.dataArray addObject:nt3];
    [self.dataArray addObject:nt4];
    [self.dataArray addObject:nt5];
    [self.collectionView reloadData];
}

- (void)setExchange:(ExchangeTicks *)exchange{
    _exchange = exchange;
    
    [self bgColor:exchange.index];
    
    self.exchangeView.exchange = exchange;
    
    [self.dataArray removeAllObjects];
    
    //添加collection data
    //最新价格
    NumberAndTypeModel *nt1 = [[NumberAndTypeModel alloc] init];
    nt1.type = NumberPriceType;
    nt1.number = exchange.close;
    nt1.usdPrice = [exchange.usdPrice floatValue];
    
    //涨幅
    NumberAndTypeModel *nt2 = [[NumberAndTypeModel alloc] init];
    nt2.type = NumberChangeType;
    nt2.number = exchange.degree;
    
    //24h成交量
    NumberAndTypeModel *nt3 = [[NumberAndTypeModel alloc] init];
    nt3.type = NumberMarketCapType;
    nt3.number = exchange.vol;
    
    //24h最高
    NumberAndTypeModel *nt4 = [[NumberAndTypeModel alloc] init];
    nt4.type = NumberPriceType;
    nt4.number = exchange.high;
    
    //24h最低
    NumberAndTypeModel *nt5 = [[NumberAndTypeModel alloc] init];
    nt5.type = NumberPriceType;
    nt5.number = exchange.low;
    
    [self.dataArray addObject:nt1];
    [self.dataArray addObject:nt2];
    [self.dataArray addObject:nt3];
    [self.dataArray addObject:nt4];
    [self.dataArray addObject:nt5];
    [self.collectionView reloadData];
}

- (void)bgColor:(NSInteger)index{
    if (index % 2 != 0) {
        self.contentView.backgroundColor = MainDarkColor;
    }else{
        self.contentView.backgroundColor = MainBlackColor;
    }
}

#pragma mark - collection datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    ContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contentCollectionCellId forIndexPath:indexPath];
    NumberAndTypeModel *model = self.dataArray[indexPath.item];
    model.index = indexPath.item;
    model.rankOrExchangeType = self.type;
    cell.model = model;
    return cell;
}

#pragma mark - collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.contentTouchBlock) {
        self.contentTouchBlock();
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type != CoinRankType) {
        return CGSizeMake(MAINSCREEN_WIDTH * 0.6 / 2, AdaptY(47));
    }
    if (indexPath.item == 0 || indexPath.item == 1 || indexPath.item == 5) {
        return CGSizeMake(MAINSCREEN_WIDTH * 0.6 / 2, AdaptY(47));
    }
    return CGSizeMake(MAINSCREEN_WIDTH * 0.4, AdaptY(47));
}


- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        if (scrollView.contentOffset.y != 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
            return;
        }
        if (self.offsetBlock) {
            self.offsetBlock(scrollView.contentOffset);
        }
    }
}

#pragma mark - UI
- (void)createUI{
    
    if (self.type == CoinRankType) {
        [self.contentView addSubview:self.rankView];
        [self.rankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.4);
        }];
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.rankView.mas_right);
        }];
    }else{
        [self.contentView addSubview:self.exchangeView];
        [self.exchangeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self.contentView);
            make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.4);
        }];
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.exchangeView.mas_right);
        }];
    }
}

#pragma mark - init
- (LeftCoinRankView *)rankView{
    if (!_rankView) {
        _rankView = [[LeftCoinRankView alloc] init];
    }
    return _rankView;
}

- (LeftExchangeView *)exchangeView{
    if (!_exchangeView) {
        _exchangeView = [[LeftExchangeView alloc] init];
    }
    return _exchangeView;
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
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:contentCollectionCellId];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
