//
//  ShareFlashViewController.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/8.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseHiddenNavViewController.h"
#import "FlashModel.h"

@interface ShareFlashViewController : BaseHiddenNavViewController

/* flash */
@property (nonatomic, strong) Flash *flash;
/* id */
@property (nonatomic, copy) NSString *ID;


@end
