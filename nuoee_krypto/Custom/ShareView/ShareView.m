//
//  ShareView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/20.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ShareView.h"
#import "ShareModel.h"
#import "ShareCell.h"

static NSString *CellId = @"ShareCellId";

@interface ShareView()<UICollectionViewDelegate,UICollectionViewDataSource>

/* collection */
@property (nonatomic, strong) UICollectionView *collectionView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
     
        self.backgroundColor = MainDarkColor;
        [self setData];
        [self createUI];
    }
    return self;
}

- (void)setData{
    
    ShareModel *s1 = [[ShareModel alloc] init];
    s1.icon = @"share_wechat";
    s1.type = SSDKPlatformSubTypeWechatSession;
    s1.name = @"微信";
    
    ShareModel *s2 = [[ShareModel alloc] init];
    s2.icon = @"share_friends";
    s2.type = SSDKPlatformSubTypeWechatTimeline;
    s2.name = @"朋友圈";
    
    ShareModel *s3 = [[ShareModel alloc] init];
    s3.icon = @"share_qq";
    s3.type = SSDKPlatformSubTypeQQFriend;
    s3.name = @"QQ";

    ShareModel *s4 = [[ShareModel alloc] init];
    s4.icon = @"share_weibo";
    s4.type = SSDKPlatformTypeSinaWeibo;
    s4.name = @"新浪微博";

    ShareModel *s5 = [[ShareModel alloc] init];
    s5.icon = @"share_more";
    s5.type = SSDKPlatformTypeMail;
    s5.name = @"更多";
    
    [self.dataArray addObject:s1];
    [self.dataArray addObject:s2];
    [self.dataArray addObject:s3];
    [self.dataArray addObject:s4];
    [self.dataArray addObject:s5];
}

#pragma mark - action
- (void)cancelTouch{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

#pragma mark - collection datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    ShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

#pragma mark - collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareModel *model = self.dataArray[indexPath.item];
    if (self.shareBlock) {
        self.shareBlock(model.type);
    }
}

#pragma mark - UI
- (void)createUI{
    
    BaseLabel *tag = [SEFactory labelWithText:@"分享到" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentCenter];
    [self addSubview:tag];
    [tag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.equalTo(@(AdaptY(40)));
    }];
    
    BaseButton *cancel = [SEFactory buttonWithTitle:@"取消" frame:CGRectZero font:Font(16) fontColor:TextDarkGrayColor];
    [cancel addTarget:self action:@selector(cancelTouch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.equalTo(@(AdaptY(50)));
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
        make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
        make.top.mas_equalTo(tag.mas_bottom);
        make.bottom.mas_equalTo(cancel.mas_top);
    }];
}

#pragma mark - init
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake((MAINSCREEN_WIDTH - 6 * AdaptX(20)) / 5, AdaptY(99));
        layout.minimumLineSpacing = AdaptX(20);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ShareCell class] forCellWithReuseIdentifier:CellId];
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
