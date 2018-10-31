//
//  TopCollectionViewCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/5/31.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGPoint offset;

@end
