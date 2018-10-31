//
//  Enumeration.h
//  UNIS-LEASE
//
//  Created by runlin on 2016/11/10.
//  Copyright © 2016年 unis. All rights reserved.
//

#ifndef Enumeration_h
#define Enumeration_h

typedef NS_ENUM(NSUInteger, RoseOrFallType){
    RoseType = 0, //上涨
    FallType = 1, //下跌
};

typedef NS_ENUM(NSUInteger, KMenuStateType){
    KMenuFixedType = 0, //固定
    KMenuDynamicType = 1, //动态隐藏
    KMenuQuataType = 2, //指标
};

/** kMenuType */
typedef NS_ENUM(NSUInteger, KMenuType){
    KMenuNormalType = 0,
    KMenuMoreType = 1,
    KMenuIndType = 2,
    KMenuRotatType = 3,
};

/** riseOrFall */
typedef NS_ENUM(NSUInteger, RiseOrFallType){
    UnRiseAndUnFallType = 0,
    RiseAndUnFallType = 1,
    UnRiseAndFallType = 2,
};

/** warn type */
typedef NS_ENUM(NSUInteger, WarnType){
    WarnTriggerType,
    WarnUnTriggerType,
};

/** number type */
typedef NS_ENUM(NSUInteger, NumberType){
    NumberPriceType, //价格
    NumberChangeType, //涨跌幅
    NumberVolType, //成交额
    NumberVolNumType, //成交量
    NumberSupplyType, //流通量
    NumberMarketCapType, //总市值
    NumberFlowRateType, //流通率
    NumberMaxSupplyType, //发行总量
};

/** cell type */
typedef NS_ENUM(NSUInteger, MineCellType){
    MineNormalCellType,
    MineMessageTagCellType,
    MineSummaryCellType,
    MineSwitchCellType,
};

/** 排行or交易所类型 */
typedef NS_ENUM(NSUInteger, LoginType){
    LoginCodeType,
    LoginPasswordType,
    LoginFindPasswordType,
    LoginEditPhoneType,
    LoginEditPasswordType,
    LoginSetPasswordType,
};

/** 排行or交易所类型 */
typedef NS_ENUM(NSUInteger, CoinRankOrExchangeType){
    CoinRankType,
    ExchangeType,
    ExchangeTicksType,
};

/** 无数据类型 */
typedef NS_ENUM(NSUInteger, NoDataType){
    NoTextType = 1,
    NoNetworkType = 2,
    NoFlashType = 3,
    NoUnWarnType = 4,
    NoHistoryType = 5,
    NoMessageType,
    NoSearchType,
};

/** 网络监听 */
typedef NS_ENUM(NSUInteger,NetWorkState) {
    NetWorkUnknow = 0,  //没网
    NetWorkConnected = 1,     //有网
};
#endif /* Enumeration_h */
