//
//  Notification.h
//  SuperEducation
//
//  Created by yangming on 2017/3/8.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#ifndef Notification_h
#define Notification_h

#define  SENotificationCenter [NSNotificationCenter defaultCenter]

//上涨标识
#define INCREASE @"INCREASE"

//kvo 列表联动
#define ContentCollectionContentOffset @"contentCollectionContentOffset"
#define TopTagCollectionContentOffset @"topTagCollectionContentOffset"

//个人信息登录
#define MINEDITNICKSUCCESS @"editNickNameSuccess"
#define MINEUPTEHEADERSUCCESS @"updateHeaderSuccess"
#define MINELINKMOBILESUCCESS @"linkMobileSuccess"
//path
#define HeaderCachePath @"http://user/avatar.jpg"//头像缓存路径

//login
#define LOGINSUCCESS @"LoginSuccess"
#define LOGOUTSUCCESS @"logoutSuccess"
#define FINDPASSWORDSUCCESS @"FindPassWordSuccess"


//编辑成功时 发送
#define ARTICLERLEASESUCCESS @"articleReleaseSuccess"//文章发表成功
#define LIVERELEASESUCCESS @"liveReleaseSuccess" //直播发布成功
#define BUNDLERELEASESUCCESS @"bundleReleaseSuccess" //专栏发布成功
#define COMMUNITYRELEASESUCCESS @"communityReleaseSuccess" //社群发布成功
#define AUDIORELEASESUCCESS @"audioReleaseSuccess" //音频课程发布成功
#define VIDEORELEASESUCCESS @"videoReleaseSuccess" //视频课程发布成功
#define PRODUCTRELEASESUCCESS @"productReleaseSuccess" //商品发布成功

//IM
#define RESUMESENDSUCCESS @"resumeSendSuccess" //重传成功
#define PUSHMESSAGEINSERTSUCCESS @"PushMessageInsertrSuccess" //推送消息插入数据成功
#define REVICENEWCHATMESSGAE @"ReviceNewChatMessgae" //收到新聊天消息
#define RECONNECTIONSUCCESS @"reconnectionSuccess" //重连网络成功
#define UPLOADNETWORKBREAK @"uploadNetworkBreak" //上传资源网络错误
#define NETBREAK @"netBreak" //网络中断

//积分 人民币 兑换率
#define Spread 10
#define MAXVisit 1000000

#endif /* Notification_h */
