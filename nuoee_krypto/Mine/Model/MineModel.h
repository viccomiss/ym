//
//  MineModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/9.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

@interface MineModel : BaseModel

/* icon */
@property (nonatomic, copy) NSString *icon;
/* name */
@property (nonatomic, copy) NSString *name;
/* type */
@property (nonatomic, assign) MineCellType type;
/* summary */
@property (nonatomic, copy) NSString *summary;
/* num */
@property (nonatomic, assign) NSInteger notReadCount;


@end
