//
//  SEJSApiPay.m
//  Hybrid
//
//  Created by Jacky on 2017/10/27.
//  Copyright © 2017年 从知科技. All rights reserved.
//

#import "SEJSApiPay.h"

@implementation SEJSApiPay
-(void)responsejsCallWithData:(id)data{
    [super responsejsCallWithData:data];
    [SEHUD showAlertWithText:[NSString stringWithFormat:@"支付==%@",data]];

}
@end
