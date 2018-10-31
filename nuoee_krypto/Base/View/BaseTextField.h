//
//  BaseTextField.h
//  SuperEducation
//
//  Created by 123 on 2017/2/28.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTextField : UITextField

- (BOOL)stringContainsEmoji:(NSString *)string;

/* textLocation */
@property (nonatomic, assign) NSInteger textLocation;

@end
