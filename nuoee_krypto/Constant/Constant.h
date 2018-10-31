//
//  Constant.h
//  AFNetworking-demo
//
//  Created by Jakey on 15/6/3.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifdef SYNTHESIZE_CONSTS
# define CONST(name, value) NSString* const name = @ value
#else
# define CONST(name, value) extern NSString* const name
#endif

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


#if 1 // 0 测试环境  1生产环境

//---------------------生产环境---------------------
#define SEDebug 0
CONST(API_VERSION, "2.2");
//CONST(URI_BASE_SERVER, "https://api.verasti.com/"); //正式服务器
//
//CONST(WEBSOCKET_URL, "wss://stream.verasti.com/ws");
//CONST(IM_URL, "im.wakkaa.com");
//CONST(IM_PORT, "19001");
//
//CONST(H5_USER_AGREENMENT, "https://web.verasti.com/userAgreenment");//用户协议
//CONST(H5_CURRENCY_INFO, "https://web.verasti.com/currencyInfo/"); //币种详情
//CONST(H5_MES_CENTER, "https://web.verasti.com/mes/center/"); //消息详情
//CONST(H5_HOTINFO_DETAIL, "https://web.verasti.com/hotInfo/details/"); //快讯详情
//
//CONST(XGAPPID, "2200296901");
//CONST(XGSECRETKEY, "IQ1WVL7F451N");
//
//CONST(IMAGE_SERVICE, "https://web.verasti.com/image/icon/");

//----------- 国内服务器
CONST(URI_BASE_SERVER, "http://122.224.164.10:9902/"); //正式服务器
//
CONST(WEBSOCKET_URL, "ws://122.224.164.10:9904/ws");
CONST(IM_URL, "im.wakkaa.com");
CONST(IM_PORT, "19001");

CONST(H5_USER_AGREENMENT, "http://122.224.164.10:9903/userAgreenment");//用户协议
CONST(H5_CURRENCY_INFO, "http://122.224.164.10:9903/currencyInfo/"); //币种详情
CONST(H5_MES_CENTER, "http://122.224.164.10:9903/mes/center/"); //消息详情
CONST(H5_HOTINFO_DETAIL, "http://122.224.164.10:9903/hotInfo/details/"); //快讯详情

CONST(XGAPPID, "2200296901");
CONST(XGSECRETKEY, "IQ1WVL7F451N");

CONST(IMAGE_SERVICE, "http://122.224.164.10:9903/image/icon/");


#else

//---------------------测试环境---------------------
#define SEDebug 1
CONST(API_VERSION, "2.2");
CONST(URI_BASE_SERVER, "http://10.106.0.4:9083/"); //测试服务器
//CONST(URI_BASE_SERVER, "http://10.106.208.48:9083/");

CONST(WEBSOCKET_URL, "ws://10.106.0.4:8086/ws");
//CONST(WEBSOCKET_URL, "ws://10.106.208.48:8086/ws");
CONST(IM_URL, "sandbox-im.wakkaa.com");
CONST(IM_PORT, "19001");

CONST(H5_USER_AGREENMENT, "http://10.106.0.4:8281/userAgreenment");//用户协议
CONST(H5_CURRENCY_INFO, "http://10.106.0.4:8281/currencyInfo/"); //币种详情
CONST(H5_MES_CENTER, "http://10.106.0.4:8281/mes/center/"); //消息详情
CONST(H5_HOTINFO_DETAIL, "http://10.106.0.4:8281/hotInfo/details/"); //快讯详情

CONST(XGAPPID, "2200296231");
CONST(XGSECRETKEY, "IRQ2212C1EVC");

CONST(IMAGE_SERVICE, "http://10.106.0.4:19030/imgs/icon/");

#endif


//----------------------分享------------------------
CONST(QQ_ID, "1106987208"); //qqid
CONST(QQ_KEY, "C0K9XRpiOOvxTVDF");

CONST(WEIXIN_SSO_ID, "wx01add0874e70b5b7"); //微信KEY
CONST(WEIXIN_SECRET, "38eb4006d0a177b682693895f7d81066");

CONST(SINA_KEY, "2606686924"); //新浪
CONST(SINA_SECRET, "c5bfa83e578b547a8324ad73aaeec862");

CONST(MOB_APPKEY, "267ce54f2ddd9"); //Mob
CONST(MOB_SECRET, "e23ca4b781a467e4fba159d89abf2680");


/*====================================接口============================================*/
//user
CONST(URI_SIGNIN, "sign/getAccessToken");//登录注册
CONST(URI_SIGN_DESTORY, "sign/destroy");//退出登录
CONST(URI_SIGN_RETRIEVEPASSWORD, "sign/retrievePassword");//找回密码
CONST(URI_ACCOUNT_CHANGE, "account/change"); //修改用户信息
CONST(URI_SIGN_SENDMESSAGE, "sign/sendMessage"); //发送验证码
CONST(URI_CHANGEPHONE, "account/changePhone"); //修改手机号
CONST(URI_ACCOUNTCHANGE, "account/change"); //修改用户信息
CONST(URI_ACCOUNTCHANGEPASSWORD, "account/changePassword"); //修改用户密码
CONST(URI_ACCOUNTCHANGEMARKCOLOR, "account/changeMarkColor"); //修改红绿信息
CONST(URI_ACCOUNTSENDUPDATEMESSAGE, "account/sendUpdateMessage"); //手机号、密码修改发送短信
CONST(URI_ACCOUNTGETMARKCOLOR, "account/getMarkColor"); //获得红绿信息
CONST(URI_ACCOUNTUPLOADFILE, "account/upload/file"); //上传图片
CONST(URI_ABOUT_US, "aboutUs"); //关于我们


//flash
CONST(URI_HOTINFO, "hotInfo");//快讯list
CONST(URI_HOTINFO_RISE, "hotInfo/RISE");//利好
CONST(URI_HOTINFO_FALL, "hotInfo/FALL");//利空
CONST(URI_HOTINFO_DETAILS, "hotInfo/details");//单条快讯
CONST(URI_HOTINFO_GET_NEWHOTINFONUM, "hotInfo/getNewHotInfoSum");//最新快讯条数

//market
CONST(URI_EXCHANGERANKS, "exchangeRanks"); //交易所行情
CONST(URI_CURRENCYLIST, "currencyList"); //币种列表
CONST(URI_CURRENCYRANKS, "currencyRanks"); //排行
CONST(URI_CURRENCYMARKET, "currencyMarket"); //币行情
CONST(URI_CURRENCYTICKS, "exchangeTicks"); //交易所币对行情列表
CONST(URI_SEARCH, "search"); //搜索
CONST(URI_HOTCOIN, "hotCoin"); //热门币种
CONST(URI_EXCHANGE, "exchange"); //交易所

//message
CONST(URI_MES_CENTER, "mes/center"); //消息中心
CONST(URI_MES_CENTER_DELETE_ID, "mes/center/delete/id"); //删除消息
CONST(URI_ACCOUNT_INITCONTENT, "account/initContent"); //消息中心红点
CONST(URI_MES_CENTER_DELETEALL, "mes/center/deleteAll"); //消息删除所有

//warn
CONST(URI_ALERTS_EXCHANGE_SHOW, "alerts/exchange/show"); //未触发预警
CONST(URI_ALERTS_HISTROY_TRIGGER, "alerts/history/UN_DELETE"); //历史预警
CONST(URI_ALERTS_HISTROY_UN_TRIGGER, "alerts/history/UN_TRIGGER"); //未触发预警
CONST(URI_ALERTS_NEW, "alerts/new"); //新增预警
CONST(URI_ALERTS_DELSINGLE, "alerts/delSingle/id"); //单挑删除
CONST(URI_ALERTS_DELALL_HISTORY, "alerts/delAll/history"); //全部删除
CONST(URI_ALERTS_STYLE, "alerts/style"); //提示设置

@interface Constant : NSObject

@end
