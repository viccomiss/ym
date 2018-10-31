//
//  PathMacros.h
//  wxer_manager
//
//  Created by Jacky on 2017/11/8.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#ifndef PathMacros_h
#define PathMacros_h

#define AUDIO @"audio"//音频课
#define VIDEO @"video"//视频课
#define ARTICLE @"article"//图文课
#define AUDIOLIVE @"audiolive"//语音直播
#define VIDEOLIVE @"videolive"//视频直播
#define BUNDLE @"bundle"//系列课
#define COMMUNITY @"community"//社群
#define PROMOTION @"promotion"//推广中心
#define BANNER @"banner"//轮播图
#define COMPOUND @"compound"//制图
#define COMMODITY @"commodity" //商品
#define CLASSIFY  @"classify"
#define ACTIVITY @"activity"//线下活动
#define FINANCE @"finance"//财务
#define TRADE @"trade"//订单
#define TRAINER @"trainer"//老师
#define QUESTION @"question"//问答
#define MEMBER  @"member"//会员
#define ADMIN @"admin"//管理员
#define USER @"user"//用户
#define ARTICLE_IMPORT @"article_import" //文章导入
#define MEDIA  @"media"  //店铺基本装修/资料修改
#define MEDIA_CUSTOMUI @"media_customui"//店铺自定义装修

//本地路径
#define SearchHistoryPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"searchhistory.data"]
#define NoteSearchHistoryPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"noteSearchhistory.data"]

#define GuideCoverShow @"GuideCoverShow"  //引导页本地标记
#define GuideTextShow @"GuideTextShow"
#define GuideImageShow @"GuideImageShow"

#define EqualToSuccess  isEqualToString:@"success"

#define BOOLFORKEY @"dhGuidePage"


#endif /* PathMacros_h */
