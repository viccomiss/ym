//
//  KlineIndView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "KlineIndView.h"
#import "KlineIndCell.h"
#import "KlineIndModel.h"

static NSString *CellId = @"KlineCellId";

@interface KlineIndView()<UICollectionViewDelegate,UICollectionViewDataSource>

/* collection */
@property (nonatomic, strong) UICollectionView *collectionView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* type */
@property (nonatomic, assign) KMenuStateType type;

@end

@implementation KlineIndView

- (instancetype)initWithType:(KMenuStateType)type{
    if (self == [super init]) {
        
        self.type = type;
        self.backgroundColor = type == KMenuFixedType ? MainBlackColor : MainDarkColor;
        [self createUI];
        [self setData];
    }
    return self;
}

- (void)setData{
    
    if (self.type == KMenuFixedType) {
        KlineIndModel *m1 = [[KlineIndModel alloc] init];
        m1.ind = @"分时";
        m1.code = @"M1";
        m1.type = KMenuNormalType;
        
        KlineIndModel *m15 = [[KlineIndModel alloc] init];
        m15.ind = @"15分";
        m15.code = @"M15";
        m15.type = KMenuNormalType;
//
//        KlineIndModel *h1 = [[KlineIndModel alloc] init];
//        h1.ind = @"1小时";
//        h1.code = @"H1";
//        h1.type = KMenuNormalType;
        
        KlineIndModel *h4 = [[KlineIndModel alloc] init];
        h4.ind = @"4小时";
        h4.code = @"H4";
        h4.sel = YES;
        h4.type = KMenuNormalType;
        
        KlineIndModel *d = [[KlineIndModel alloc] init];
        d.ind = @"日线";
        d.code = @"D1";
        d.type = KMenuNormalType;
        
        KlineIndModel *more = [[KlineIndModel alloc] init];
        more.ind = @"更多";
        more.type = KMenuMoreType;
        
        KlineIndModel *ind = [[KlineIndModel alloc] init];
        ind.ind = @"指标";
        ind.type = KMenuIndType;
        
        KlineIndModel *rotate = [[KlineIndModel alloc] init];
        rotate.type = KMenuRotatType;
        
        [self.dataArray addObject:m1];
        [self.dataArray addObject:m15];
//        [self.dataArray addObject:h1];
        [self.dataArray addObject:h4];
        [self.dataArray addObject:d];
        [self.dataArray addObject:more];
        [self.dataArray addObject:ind];
        [self.dataArray addObject:rotate];
        [self.collectionView reloadData];
    }
    
    if (self.type == KMenuDynamicType) {
        KlineIndModel *m5 = [[KlineIndModel alloc] init];
        m5.ind = @"5分";
        m5.code = @"M5";
        m5.type = KMenuNormalType;
        
        KlineIndModel *m30 = [[KlineIndModel alloc] init];
        m30.ind = @"30分";
        m30.code = @"M30";
        m30.type = KMenuNormalType;
        
        KlineIndModel *h1 = [[KlineIndModel alloc] init];
        h1.ind = @"1小时";
        h1.code = @"H1";
        h1.type = KMenuNormalType;
        
        KlineIndModel *w1 = [[KlineIndModel alloc] init];
        w1.ind = @"1星期";
        w1.code = @"W1";
        w1.type = KMenuNormalType;
        
        KlineIndModel *mon1 = [[KlineIndModel alloc] init];
        mon1.ind = @"1月";
        mon1.code = @"MONTH";
        mon1.type = KMenuNormalType;
        
        [self.dataArray addObject:m5];
        [self.dataArray addObject:m30];
        [self.dataArray addObject:h1];
        [self.dataArray addObject:w1];
        [self.dataArray addObject:mon1];
        [self.collectionView reloadData];
    }
    
    if (self.type == KMenuQuataType) {
        KlineIndModel *place = [[KlineIndModel alloc] init];
        place.ind = @"";
        place.type = KMenuNormalType;
        
        KlineIndModel *macd = [[KlineIndModel alloc] init];
        macd.ind = @"MACD";
        macd.type = KMenuNormalType;
        
        KlineIndModel *kdj = [[KlineIndModel alloc] init];
        kdj.ind = @"KDJ";
        kdj.type = KMenuNormalType;
        
        KlineIndModel *boll = [[KlineIndModel alloc] init];
        boll.ind = @"BOLL";
        boll.type = KMenuNormalType;
        
        KlineIndModel *rsi = [[KlineIndModel alloc] init];
        rsi.ind = @"RSI";
        rsi.type = KMenuNormalType;
        
        KlineIndModel *vol = [[KlineIndModel alloc] init];
        vol.ind = @"VOL";
        vol.type = KMenuNormalType;
        
        [self.dataArray addObject:place];
        [self.dataArray addObject:macd];
        [self.dataArray addObject:kdj];
        [self.dataArray addObject:boll];
        [self.dataArray addObject:rsi];
        [self.dataArray addObject:vol];
        [self.collectionView reloadData];
    }
}

#pragma mark - collection datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    KlineIndCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    KlineIndModel *model = self.dataArray[indexPath.item];
    model.stateType = self.type;
    cell.model = model;
    return cell;
}

#pragma mark - collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KlineIndModel *model = self.dataArray[indexPath.item];
    
    if (model.type != KMenuMoreType && model.type != KMenuQuataType) {
        for (KlineIndModel *m in self.dataArray) {
            if ([model.ind isEqualToString:m.ind]) {
                m.sel = YES;
            }else{
                m.sel = NO;
            }
        }
    }
    
    if (self.changeIndBlock) {
        self.changeIndBlock(model);
    }
    [self.collectionView reloadData];
}

- (void)reloadClear{
    for (KlineIndModel *m in self.dataArray) {
        m.sel = NO;
    }
    [self.collectionView reloadData];
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)adjustSubviews:(UIInterfaceOrientation)orientation{

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - init
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(MAINSCREEN_WIDTH / 7, AdaptY(36));
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[KlineIndCell class] forCellWithReuseIdentifier:CellId];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
