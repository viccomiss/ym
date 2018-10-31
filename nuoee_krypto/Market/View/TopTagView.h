//
//  TopTagView.h
//  nuoee_krypto
//
//  Created by Mac on 2018/5/31.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 顶部tag
 */
@protocol TopTagDelegate<NSObject>

- (void)topTagCurrentOffset:(CGPoint)offset;

@end

@interface TopTagView : UIView

- (instancetype)initWithType:(CoinRankOrExchangeType)type;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<TopTagDelegate> delegate;


@end
