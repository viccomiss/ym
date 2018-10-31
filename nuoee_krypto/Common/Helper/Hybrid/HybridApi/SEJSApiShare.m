//
//  SEJSApiShare.m
//  Hybrid
//
//  Created by Jacky on 2017/10/27.
//  Copyright © 2017年 从知科技. All rights reserved.
//

#import "SEJSApiShare.h"
#import "ShareFlashViewController.h"
#import "CommonUtils.h"

@implementation SEJSApiShare

-(void)responsejsCallWithData:(id)data{
    [super responsejsCallWithData:data];
    
    NSLog(@"相应分享 === %@",data);
    ShareFlashViewController *shareVC = [[ShareFlashViewController alloc] init];
    shareVC.ID = data;
    [[CommonUtils currentViewController] presentViewController:shareVC animated:YES completion:nil];
}

-(void)disconnectResponsejsCall{
    
    
    
}
@end
