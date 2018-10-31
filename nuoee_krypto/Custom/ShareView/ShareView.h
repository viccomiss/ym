//
//  ShareView.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/20.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

typedef void(^shareBlock)(SSDKPlatformType type);

@interface ShareView : UIView

/* shareBlock */
@property (nonatomic, copy) BaseBlock cancelBlock;

/* shareBlock */
@property (nonatomic, copy) shareBlock shareBlock;


@end
