//
//  SEJSApiBase.m
//  wxer_manager
//
//  Created by Jacky on 2017/10/28.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "SEJSApiBase.h"
#import <objc/runtime.h>

@implementation SEJSApiBase

+(instancetype)shareJSApiBase{
    id instance = objc_getAssociatedObject(self, @"instance");
    if (!instance){
        instance = [[super allocWithZone:NULL] init];
        objc_setAssociatedObject(self, @"instance", instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return instance;
}

+(id) allocWithZone:(struct _NSZone *)zone {
    return [self shareJSApiBase];
}

-(id) copyWithZone:(struct _NSZone *)zone {
    Class selfClass = [self class];
    return [selfClass shareJSApiBase];
}

-(void)responsejsCallWithData:(id)data{
    if (!data) {
        return;
    }
}

-(void)responsejsCallWithData:(id)data callBack:(WVJBResponseCallback)responseCallback{
    if (!data) {
        return;
    }
}

-(void)disconnectResponsejsCall{
    
    

}
@end
