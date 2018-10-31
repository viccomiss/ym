//
//  NotificationTool.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 推送消息处理类
 */
@interface NotificationTool : NSObject

+(NotificationTool *)shareInstance;

- (void)reviceNotification:(NSDictionary *)dic enterBackground:(BOOL)backgound;

@end
