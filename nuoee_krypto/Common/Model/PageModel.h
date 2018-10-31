//
//  PageModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/7.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

/**
 分页model
 */
@interface PageModel : BaseModel

/* pageNo */
@property (nonatomic, assign) NSInteger pageNo;
/* pageSize */
@property (nonatomic, assign) NSInteger pageSize;
/* totalCount */
@property (nonatomic, assign) NSInteger totalCount;
/* totalPage */
@property (nonatomic, assign) NSInteger totalPage;

@end
