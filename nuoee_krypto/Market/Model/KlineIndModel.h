//
//  KlineIndModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

@interface KlineIndModel : BaseModel

/* str */
@property (nonatomic, copy) NSString *ind;
/* code */
@property (nonatomic, copy) NSString *code;
/* sel */
@property (nonatomic, assign) BOOL sel;
/* type */
@property (nonatomic, assign) KMenuType type;
/* fixed or dynamic */
@property (nonatomic, assign) KMenuStateType stateType;

/* quota */
@property (nonatomic, copy) NSString *quota;


@end
