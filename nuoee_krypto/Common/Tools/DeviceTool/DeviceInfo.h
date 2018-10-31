//
//  DeviceInfo.h
//  SuperEducation
//
//  Created by wangcl on 2017/6/13.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

//获取设备UUID
+ (NSString *)getUUID;
// 获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName;
/** 获取设备上次重启的时间 */
- (NSDate *)getSystemUptime;
// CPU总数目
+ (NSUInteger)getCPUCount;
/** 获取磁盘总空间 */
- (int64_t)getTotalDiskSpace;
/** 获取未使用的磁盘空间 */
- (int64_t)getFreeDiskSpace;
/** 获取已使用的磁盘空间 */
- (int64_t)getUsedDiskSpace;
/** 获取设备内存 */
+ (int64_t)getTotalMemory;
/** 获取可释放的内存空间 */
+ (int64_t)getPurgableMemory;
/** 获取存放内核的内存空间 */
+ (int64_t)getWiredMemory;
/** 获取正在使用的内存空间 */
+ (int64_t)getUsedMemory;
/** 获取空闲的内存空间 */
+ (int64_t)getFreeMemory;
/** 获取不活跃的内存空间 */
+ (int64_t)getInActiveMemory;
/** 获取活跃的内存空间 */
+ (int64_t)getActiveMemory;

@end
