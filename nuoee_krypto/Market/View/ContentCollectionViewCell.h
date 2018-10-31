//
//  ContentCollectionViewCell.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/1.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberAndTypeModel.h"

/**
 展示数据内容cell
 */
@interface ContentCollectionViewCell : UICollectionViewCell

/* mdoel */
@property (nonatomic, strong) NumberAndTypeModel *model;


@end
