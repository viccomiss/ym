//
//  JoinUpSocketViewController.m
//  ZXKlineDemo
//
//  Created by 郑旭 on 2017/9/13.
//  Copyright © 2017年 郑旭. All rights reserved.
//
#import <Masonry.h>
#import "KlineDetailViewController.h"
#import "ZXAssemblyView.h"
#import <SocketRocket.h>
#import "KLineDetailHeader.h"
#import "WarnSettingViewController.h"
#import "KlineIndView.h"
#import "KlineIndModel.h"
#import "KlineMoreIndView.h"
#import "NSString+JLAdd.h"
#import "SEUserDefaults.h"
#import "UserModel.h"
#import "LoginViewController.h"

#define HEADERHEIGHT AdaptY(146)
#define MENUHEIGHT AdaptY(36)

@interface KlineDetailViewController ()<AssemblyViewDelegate,ZXSocketDataReformerDelegate,SRWebSocketDelegate>
/**
 *k线实例对象
 */
@property (nonatomic,strong) ZXAssemblyView *assenblyView;
/**
 *横竖屏方向
 */
@property (nonatomic,assign) UIInterfaceOrientation orientation;
/**
 *当前绘制的指标名
 */
@property (nonatomic,strong) NSString *currentDrawQuotaName;
/**
 *所有的指标名数组
 */
@property (nonatomic,strong) NSArray *quotaNameArr;
/**
 *所有数据模型
 */
@property (nonatomic,strong) NSMutableArray *dataArray;
/**
 *
 */
@property (nonatomic,assign) ZXTopChartType topChartType;

@property (nonatomic,strong) NSTimer  *timer;
/* socket */
@property (nonatomic, strong) SRWebSocket *webSocket;
/* drawDone */
@property (nonatomic, assign) BOOL drawDone;
/* channel */
@property (nonatomic, copy) NSString *channel;
/* header */
@property (nonatomic, strong) KLineDetailHeader *headerView;
/* ind */
@property (nonatomic, strong) KlineIndView *indView;
/* more */
@property (nonatomic, strong) KlineIndView *moreIndView;
/* quota */
@property (nonatomic, strong) KlineIndView *quotaView;

/* ind 当前指标 */
@property (nonatomic, copy) NSString *currentInd;

/* 横屏price */
@property (nonatomic, strong) UIView *landScapePriceView;
/* curreny */
@property (nonatomic, strong) BaseLabel *landScapeCurrenyLabel;
/* price */
@property (nonatomic, strong) BaseLabel *landScapePriceLabel;
/* 最新kline */
@property (nonatomic, strong) KlineModel *newklineModel;


@end

@implementation KlineDetailViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)navigationBarClickBack{
    
    self.webSocket.delegate = nil;
    [self.webSocket close];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubviews];
    [self addConstrains];
//    [self configureData];
    
    //这句话必须要,否则拖动到两端会出现白屏
    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    self.topChartType = ZXTopChartTypeCandle;
    //
    self.currentDrawQuotaName = self.quotaNameArr[0];
    
    //监测旋转:用于适配横竖屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    //socket请求
    [self initWebScoket];
    
    
    //soclet数据暂时用假数据替代
//    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(creatFakeSocketData) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //止盈止损线
//    [self.assenblyView updateStopHoldLineWithStopProfitPrice:0.7646 stopLossPrice:0.7620];
//    [self.assenblyView hideStopHoldLine];
    //止盈止损线+委托价格线
//    [self.assenblyView updateStopHoldLineWithStopProfitPrice:0.7646 stopLossPrice:0.7620 delegatePrice:0.7630];
//    [self.assenblyView hideAllReferenceLine];
}

- (void)timeMargin{
    NSLog(@"111111");
}

#pragma mark - action
- (void)warnTouch{
    
    if (self.newklineModel == nil) {
        return;
    }
    
    UserModel *user = [[SEUserDefaults shareInstance] getUserModel];
    if (user.token == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            BaseNavigationController *loginNav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:loginNav animated:YES completion:nil];
        });
        return;
    }
    WarnSettingViewController *settingVC = [[WarnSettingViewController alloc] init];
    settingVC.market = self.currencyMarket;
    settingVC.kline = self.newklineModel;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - 创建socket
- (void)initWebScoket{
    
//    {"event":"kline","exchange":"HUOBIPRO","symbol":"BTCUSDT","period":"M15"}
    
//    NSString *prama = [NSString stringWithFormat:@"%@?event=%@&exchange=%@&period=%@&symbol=%@",@"ws://10.106.0.4:8086/ws",@"kline",@"HUOBIPRO",@"M15",@"BTCUSDT"];
//
//    NSLog(@"prama = %@",prama);
    
    self.webSocket.delegate = nil;
    
    [self.webSocket close];
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBSOCKET_URL]]];
    
    self.webSocket.delegate = self;
    
    [self.webSocket open];
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;{
    
    NSLog(@"Websocket Connected success");
    self.currentInd = @"H4";
    [self sendIndData];
}

- (void)sendIndData{
    NSDictionary *dic = @{@"event": @"kline", @"exchange": self.currencyMarket.exchange_code, @"period": self.currentInd, @"symbol": [[self.currencyMarket.ticker subStringFrom:@":"] uppercaseString]};
    self.channel = [NSString stringWithFormat:@"%@_%@_%@_%@",@"kline",self.currencyMarket.exchange_code,[[self.currencyMarket.ticker subStringFrom:@":"] uppercaseString],self.currentInd];
    [self sendJsonData:dic];
}

//发送json包
- (void)sendJsonData:(NSDictionary *)dic{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self.webSocket send:jsonString];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;{
    
    NSLog(@":( Websocket Failed With Error %@", error);
    if (error.code == 57) {
        //断网
        
    }else{
        
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;{
    
//    NSLog(@"Received \"%@\"", message);
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:jsonData
                             
                                                            options:NSJSONReadingMutableContainers
                             
                                                              error:&err];
    
   
    
    if ([[dicData objectForKey:@"event"] isEqualToString:@"kline"]) {
        
        //逐条
        if (self.drawDone && [self.channel isEqualToString:[dicData objectForKey:@"channel"]] &&  [dicData objectForKey:@"kline"] != nil) {
            
            NSLog(@"kline === %@", [dicData objectForKey:@"kline"]);
            NSDictionary *d = [dicData objectForKey:@"kline"];
            //必须在主线程执行
            dispatch_async(dispatch_get_main_queue(), ^{
                
                KlineModel *m = [[KlineModel alloc] init];
                m.timestamp = [[d objectForKey:@"dateTime"] integerValue];
                m.closePrice = [[d objectForKey:@"close"] doubleValue];
                m.degree = [[d objectForKey:@"degree"] doubleValue];
                m.openPrice = [[d objectForKey:@"open"] doubleValue];
                m.highestPrice = [[d objectForKey:@"high"] doubleValue];
                m.lowestPrice = [[d objectForKey:@"low"] doubleValue];
                m.volumn = [NSNumber numberWithDouble:[[d objectForKey:@"vol24"] doubleValue]];
                m.usdPrice = [[d objectForKey:@"usdPrice"] doubleValue];
                
                self.newklineModel = m;
                self.headerView.model = m;
                self.landScapePriceLabel.text = [NSString stringWithFormat:@"￥%.2f",m.closePrice];
                
                //socket数据处理
                [[ZXSocketDataReformer sharedInstance] bulidNewKlineModelWithNewPrice:m timestamp:m.timestamp volumn:m.volumn dataArray:self.dataArray isFakeData:NO];
            });
        }
        
        //首屏
        if ([dicData objectForKey:@"klines"] != nil) {
            NSArray *klines = [[[dicData objectForKey:@"klines"] reverseObjectEnumerator] allObjects];
//            NSLog(@"revice === %@",klines);
            if (klines.count == 0) {
                return;
            }
            [self configureData:klines];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;{
    
    NSLog(@"WebSocket closed");
    
    webSocket = nil;
}

#pragma mark - 屏幕旋转通知事件
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        //翻转为竖屏时
        [self updateConstrainsForPortrait];
        self.navigationBar.hidden = NO;
    }else if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        
        [self updateConstrsinsForLandscape];
        self.navigationBar.hidden = YES;
    }
}
- (void)updateConstrainsForPortrait
{
    self.headerView.hidden = NO;
    
    [self.assenblyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH + HEADERHEIGHT + MENUHEIGHT);
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);
    }];
    
    [self.indView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH + HEADERHEIGHT);
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(MENUHEIGHT));
    }];
    [self.indView adjustSubviews:self.orientation];
    
    [self.moreIndView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.indView.mas_bottom);
        make.left.right.height.mas_equalTo(self.indView);
    }];
    
    [self.quotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moreIndView.mas_top);
        make.left.right.height.mas_equalTo(self.moreIndView);
    }];
}
- (void)updateConstrsinsForLandscape
{
    //翻转为横屏时
    self.headerView.hidden = YES;
    
    [self.landScapePriceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(ZX_IS_IPHONE_X ? SafeAreaTopMargin : 0);
        make.top.mas_equalTo(self.view.mas_top).offset(HAdaptY(50) - HAdaptY(36));
        make.height.equalTo(@(HAdaptY(36)));
    }];
    
    [self.landScapeCurrenyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.landScapePriceView.mas_left).offset(HAdaptX(20));
        make.centerY.mas_equalTo(self.landScapePriceView.mas_centerY);
    }];
    
    [self.landScapePriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.landScapeCurrenyLabel.mas_right).offset(HAdaptX(10));
        make.centerY.mas_equalTo(self.landScapeCurrenyLabel);
    }];
    
    [self.indView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(HAdaptY(50) - HAdaptY(36));
        make.right.mas_equalTo(self.view.mas_right).offset(ZX_IS_IPHONE_X ? -SafeAreaBottomMargin : 0);
        make.height.equalTo(@(HAdaptY(36)));
        make.width.equalTo(@(ZX_IS_IPHONE_X ? MAINSCREEN_HEIGHT : MAINSCREEN_HEIGHT));
    }];
    [self.indView adjustSubviews:self.orientation];
    
    [self.moreIndView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.indView.mas_bottom);
        make.height.mas_equalTo(self.indView);
        make.left.mas_equalTo(self.view.mas_left).offset(ZX_IS_IPHONE_X ? SafeAreaTopMargin : 0);
        make.right.mas_equalTo(self.view.mas_right).offset(ZX_IS_IPHONE_X ? -SafeAreaBottomMargin : 0);
    }];
    
    [self.quotaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moreIndView.mas_top);
        make.left.right.height.mas_equalTo(self.moreIndView);
    }];
    
    [self.assenblyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(HAdaptY(50));
        make.width.mas_equalTo(TotalWidth);
        make.height.mas_equalTo(TotalHeight);
    }];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - Private Methods
- (void)addSubviews
{
    WeakSelf(self);
    [self setNavView];
    
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.indView];
    self.indView.changeIndBlock = ^(KlineIndModel *k){
        if (k.type == KMenuNormalType) {
            weakself.currentInd = k.code;
            [weakself sendIndData];
            weakself.moreIndView.hidden = YES;
            weakself.quotaView.hidden = YES;
            [weakself.moreIndView reloadClear];
            [weakself drawCandleAreaWithCode:k.code];
            
        }else if (k.type == KMenuMoreType){
            weakself.moreIndView.hidden = NO;
            weakself.quotaView.hidden = YES;
        }else if (k.type == KMenuIndType){
            weakself.quotaView.hidden = NO;
            weakself.moreIndView.hidden = YES;
            
        }else if (k.type == KMenuRotatType){
            [weakself interfaceOrientation:self.orientation == UIInterfaceOrientationPortrait ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait];
            weakself.landScapePriceView.hidden = self.orientation == UIInterfaceOrientationPortrait ? YES : NO;
        }
    };
    
    //需要加载在最上层，为了旋转的时候直接覆盖其他控件
    [self.view addSubview:self.assenblyView];
    
    //更多分时
    [self.view addSubview:self.moreIndView];
    self.moreIndView.changeIndBlock = ^(KlineIndModel *k){
        weakself.moreIndView.hidden = YES;
        weakself.currentInd = k.code;
        [weakself.indView reloadClear];
        [weakself sendIndData];
    };
    
    [self.view addSubview:self.quotaView];
    self.quotaView.changeIndBlock = ^(KlineIndModel *k){
        [weakself drawQuotaWithCurrentDrawQuotaName:k.ind];
    };
    
    //横屏price
    [self.view addSubview:self.landScapePriceView];
    [self.landScapePriceView addSubview:self.landScapeCurrenyLabel];
    self.landScapeCurrenyLabel.text = [self.currencyMarket.ticker subStringFrom:@":"];
    [self.landScapePriceView addSubview:self.landScapePriceLabel];
    
//    self.quotaView.mainSelectBlock = ^(NSString *str){
//        NSLog(@"主图 == %@",str);
//        if ([str isEqualToString:@"MA"]) {
//            weakself.assenblyView.isDrawMA = YES;
//            [weakself.assenblyView reDrawMAWithMA1Day:5 MA2:10 MA3:20];
//        }
//    };
//    self.quotaView.viceSelectBlock = ^(NSString *str){
//        NSLog(@"副图 == %@",str);
//    };
//    self.quotaView.mainCancelBlock = ^(){
//        weakself.assenblyView.isDrawMA = NO;
////        [weakself drawCandleAreaWithCode:weakself.currentInd];
//        [weakself.assenblyView reDrawMAWithMA1Day:5 MA2:10 MA3:20];
//    };
//    self.quotaView.viceCancelBlock = ^(){
//
//    };
    
//    [self.view addSubview:self.landScapeView];
//    self.landScapeView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
}

- (void)setNavView{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake((MAINSCREEN_WIDTH - 280)/2, 0, 280, NavbarH - StatusBarH)];
    [self.navigationBar addSubview:navView];
    
    BaseLabel *coinLabel = [SEFactory labelWithText:self.currencyMarket.exchange_code frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
    [navView addSubview:coinLabel];
    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(navView.mas_centerX);
        make.bottom.mas_equalTo(navView.mas_centerY);
    }];
    
    BaseLabel *tickLabel = [SEFactory labelWithText:[[self.currencyMarket.ticker subStringFrom:@":"] stringByReplacingOccurrencesOfString:self.currencyMarket.currency_name withString:[NSString stringWithFormat:@"%@/",self.currencyMarket.currency_name]] frame:CGRectZero textFont:Font(11) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
    [navView addSubview:tickLabel];
    [tickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(navView.mas_centerX);
        make.top.mas_equalTo(navView.mas_centerY);
    }];

    NSString *img = self.currencyMarket.logo.length != 0 ? self.currencyMarket.logo : [NSString stringWithFormat:@"%@%@.png",IMAGE_SERVICE,self.currencyMarket.exchange_code];
    BaseImageView *iconView = [[BaseImageView alloc] init];
    [iconView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:ImageName(@"coin_place")];
    ViewRadius(iconView, AdaptX(12));
    [navView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(tickLabel.mas_left).offset(-8);
        make.centerY.mas_equalTo(navView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(24), AdaptX(24)));
    }];
    
    UIBarButtonItem *warnItem = [[UIBarButtonItem alloc] initWithImage:ImageName(@"warn_nav") style:UIBarButtonItemStylePlain target:self action:@selector(warnTouch)];
    self.navigationItem.rightBarButtonItem = warnItem;
}

- (void)addConstrains
{
    if (self.orientation == UIDeviceOrientationPortrait || self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        //初始为竖屏
        self.navigationBar.hidden = NO;
        
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
            make.height.equalTo(@(HEADERHEIGHT));
        }];
        
        [self.indView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerView.mas_bottom);
            make.left.right.mas_equalTo(self.view);
            make.height.equalTo(@(MENUHEIGHT));
        }];
        
        [self.assenblyView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.view);
            make.width.mas_equalTo(TotalWidth);
//            make.height.mas_equalTo(TotalHeight);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(StatusBarH > 20 ? -30 : 0);
            make.top.mas_equalTo(self.indView.mas_bottom);
        }];
    
        [self.moreIndView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.indView.mas_bottom);
            make.left.right.height.mas_equalTo(self.indView);
        }];
        
        [self.quotaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.moreIndView.mas_top);
            make.left.right.height.mas_equalTo(self.moreIndView);
        }];
        
    }else if (self.orientation==UIDeviceOrientationLandscapeLeft || self.orientation == UIDeviceOrientationLandscapeRight) {
        //初始为横屏
        self.navigationBar.hidden = YES;
        
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
            make.height.equalTo(@(AdaptY(0)));
        }];
        
        [self.assenblyView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
            make.width.mas_equalTo(TotalWidth);
            make.height.mas_equalTo(TotalHeight);
        }];
    }
}

- (void)configureData:(NSArray *)kDataArr
{
    //==精度计算
    NSInteger precision = [self calculatePrecisionWithOriginalDataArray:kDataArr];
    
    //将请求到的数据数组传递过去，并且精度也是需要你自己传;
    /*
     数组中数据格式:@[@"时间戳,收盘价,开盘价,最高价,最低价,成交量",
     @"时间戳,收盘价,开盘价,最高价,最低价,成交量",
     @"时间戳,收盘价,开盘价,最高价,最低价,成交量",
     @"...",
     @"..."];
     */
    /*如果的数据格式和此demo中不同，那么你需要点进去看看，并且修改响应的取值为你的数据格式;
     修改数据格式→  ↓↓↓↓↓↓↓点它↓↓↓↓↓↓↓↓↓  ←
     */
    //===数据处理
    NSArray *transformedDataArray =  [[ZXDataReformer sharedInstance] transformDataWithOriginalDataArray:kDataArr currentRequestType:self.currentInd];
    
    //绘制header
    KlineModel *headerData = [transformedDataArray lastObject];
    self.headerView.model = headerData;
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:transformedDataArray];
    
    
    //====绘制k线图
    [self.assenblyView drawHistoryCandleWithDataArr:self.dataArray precision:(int)precision stackName:@"股票名" needDrawQuota:self.currentDrawQuotaName];
    
    //监听首屏绘制结束
    self.drawDone = YES;
    
    //如若有socket实时绘制的需求，需要实现下面的方法
    //socket
    //定时器不再沿用
    [ZXSocketDataReformer sharedInstance].delegate = self;
    
}
#pragma mark -  计算精度
- (NSInteger)calculatePrecisionWithOriginalDataArray:(NSArray *)dataArray
{
    NSDictionary *dic = dataArray.lastObject;
    //取的最高值
    NSInteger maxPrecision = [self calculatePrecisionWithPrice:[NSString stringWithFormat:@"%@",[dic objectForKey:@"high"]]];
    return maxPrecision;
}
- (NSInteger)calculatePrecisionWithPrice:(NSString *)price
{
    //计算精度
    NSInteger dig = 0;
    if ([price containsString:@"."]) {
        NSArray *com = [price componentsSeparatedByString:@"."];
        dig = ((NSString *)com.lastObject).length;
    }
    return dig;
}
#pragma mark - AssemblyViewDelegate

//底部touch
- (void)tapActionActOnQuotaArea
{
    if (self.topChartType==ZXTopChartTypeTimeLine) {
        return;
    }
    //这里可以进行quota图的切换
    NSInteger index = [self.quotaNameArr indexOfObject:self.currentDrawQuotaName];
    if (index<self.quotaNameArr.count-1) {
        
        self.currentDrawQuotaName = self.quotaNameArr[index+1];
    }else{
        self.currentDrawQuotaName = self.quotaNameArr[0];
    }
    [self drawQuotaWithCurrentDrawQuotaName:self.currentDrawQuotaName];
}

//顶部视图
- (void)tapActionActOnCandleArea
{
    if (self.topChartType==ZXTopChartTypeBrokenLine) {

        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeCandle];
        self.topChartType = ZXTopChartTypeCandle;
    }
//    else if (self.topChartType==ZXTopChartTypeCandle)
//    {
//        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeTimeLine];
//        [self drawQuotaWithCurrentDrawQuotaName:@"VOL"];
//        self.currentDrawQuotaName = @"VOL";
//        self.topChartType = ZXTopChartTypeTimeLine;
//    }
    else if (self.topChartType==ZXTopChartTypeCandle)
    {
        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeBrokenLine];
        self.topChartType = ZXTopChartTypeBrokenLine;
    }
}
#pragma mark - 画指标
//画蜡烛
- (void)drawCandleAreaWithCode:(NSString *)code{
    if ([code isEqualToString:@"M1"]) {
        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeBrokenLine];
        self.topChartType = ZXTopChartTypeBrokenLine;
    }else{
        [self.assenblyView switchTopChartWithTopChartType:ZXTopChartTypeCandle];
        self.topChartType = ZXTopChartTypeCandle;
    }
}

//在返回的数据里面。可以调用预置的指标接口绘制指标，也可以根据返回的数据自己计算数据，然后调用绘制接口进行绘制
- (void)drawQuotaWithCurrentDrawQuotaName:(NSString *)currentDrawQuotaName
{
    
    if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[0]])
    {
        //macd绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithMACD];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[1]])
    {
        
        //KDJ绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithKDJ];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[2]])
    {
        
        //BOLL绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithBOLL];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[3]])
    {
        
        //RSI绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithRSI];
    }else if ([currentDrawQuotaName isEqualToString:self.quotaNameArr[4]])
    {
        
        //Vol绘制
        [self.assenblyView drawPresetQuotaWithQuotaName:PresetQuotaNameWithVOL];
    }
}

//socket 假数据
- (void)creatFakeSocketData
{
    KlineModel *model = self.dataArray[self.dataArray.count-2];
    int32_t highestPrice = model.highestPrice*100000;
    int32_t lowestPrice = model.lowestPrice*100000;
    CGFloat newPrice = (arc4random_uniform(highestPrice-lowestPrice)+lowestPrice)/100000.0;
    NSLog(@"%f",newPrice);
    NSInteger volumn = arc4random_uniform(100);
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    //socket数据处理
//    [[ZXSocketDataReformer sharedInstance] bulidNewKlineModelWithNewPrice:newPrice timestamp:timestamp volumn:@(volumn) dataArray:self.dataArray isFakeData:NO];
}
#pragma mark - ZXSocketDataReformerDelegate
- (void)bulidSuccessWithNewKlineModel:(KlineModel *)newKlineModel
{
    //维护控制器数据源
    if (newKlineModel.isNew) {
        
        [self.dataArray addObject:newKlineModel];
        [[ZXQuotaDataReformer sharedInstance] handleQuotaDataWithDataArr:self.dataArray model:newKlineModel index:self.dataArray.count-1];
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
        
    }else{
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
        
        [[ZXQuotaDataReformer alloc] handleQuotaDataWithDataArr:self.dataArray model:newKlineModel index:self.dataArray.count-1];
        
        [self.dataArray replaceObjectAtIndex:self.dataArray.count-1 withObject:newKlineModel];
    }
    //绘制最后一个蜡烛
    [self.assenblyView drawLastKlineWithNewKlineModel:newKlineModel];
}


#pragma mark - Event Response



#pragma mark - CustomDelegate



#pragma mark - Getters & Setters
- (ZXAssemblyView *)assenblyView
{
    if (!_assenblyView) {
        //仅仅只有k线的初始化方法
//        _assenblyView = [[ZXAssemblyView alloc] initWithDrawJustKline:YES];
        //带指标的初始化
        _assenblyView = [[ZXAssemblyView alloc] init];
        _assenblyView.delegate = self;
        _assenblyView.isDrawMA = YES;
    }
    return _assenblyView;
}

- (KLineDetailHeader *)headerView{
    if (!_headerView) {
        _headerView = [[KLineDetailHeader alloc] init];
    }
    return _headerView;
}

- (KlineIndView *)indView{
    if (!_indView) {
        _indView = [[KlineIndView alloc] initWithType:KMenuFixedType];
    }
    return _indView;
}

- (KlineIndView *)moreIndView{
    if (!_moreIndView) {
        _moreIndView = [[KlineIndView alloc] initWithType:KMenuDynamicType];
        _moreIndView.hidden = YES;
    }
    return _moreIndView;
}

//- (KlineMoreIndView *)quotaView{
//    if (!_quotaView) {
//        _quotaView = [[KlineMoreIndView alloc] init];
//        _quotaView.hidden = YES;
//    }
//    return _quotaView;
//}

- (UIView *)landScapePriceView{
    if (!_landScapePriceView) {
        _landScapePriceView = [[UIView alloc] init];
        _landScapePriceView.hidden = YES;
    }
    return _landScapePriceView;
}

- (BaseLabel *)landScapeCurrenyLabel{
    if (!_landScapeCurrenyLabel) {
        _landScapeCurrenyLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _landScapeCurrenyLabel;
}

- (BaseLabel *)landScapePriceLabel{
    if (!_landScapePriceLabel) {
        _landScapePriceLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(20) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _landScapePriceLabel;
}

- (KlineIndView *)quotaView{
    if (!_quotaView) {
        _quotaView = [[KlineIndView alloc] initWithType:KMenuQuataType];
        _quotaView.hidden = YES;
    }
    return _quotaView;
}

- (UIInterfaceOrientation)orientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}
- (NSArray *)quotaNameArr
{
    if (!_quotaNameArr) {
        _quotaNameArr = @[@"MACD",@"KDJ",@"BOLL",@"RSI",@"VOL"];
    }
    return _quotaNameArr;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
