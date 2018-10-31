//
//  WXRWebViewController.m
//  wxer_manager
//
//  Created by levin on 2017/8/11.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "WXRWebViewController.h"
#import <WebKit/WebKit.h>
#import "SEJSBridgeEngine.h"
#import "NSString+JLAdd.h"
#import "AppInfo.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SEJSApiShare.h"

static NSString *HOTINFOSHARE = @"hotInfoShare";

static NSString *SHARE = @"Share";
static NSString *ERROR = @"Error";

@interface WXRWebViewController ()<WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *urlPath;//url
@property (nonatomic, strong) BaseButton *closeBtn;
/* progress */
@property (nonatomic, strong) UIProgressView *progressView;

@property SEJSBridgeEngine *webViewBridge;
@property (nonatomic ,strong) WKUserContentController * userCC;


@end

@implementation WXRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [WKWebViewJavascriptBridge enableLogging];
    
    [self setContraints];
  
    switch (self.dataFrom) {
        case WXRWebViewControllerDataFromAgreenment:
        {
            self.title = @"用户协议";
            self.url = H5_USER_AGREENMENT;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
            break;
        case WXRWebViewControllerDataFromCurrencyInfo:
        {
            [self addCurrencyNav];
            self.url = [NSString stringWithFormat:@"%@%@",H5_CURRENCY_INFO,self.currencyRank.currency];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
            break;
        case WXRWebViewControllerDataFromFlash:
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
            break;
        case WXRWebViewControllerDataFromFlashDetail:
        {
            self.title = @"快讯详情";
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
            [self.userCC addScriptMessageHandler:self name:SHARE];
            [self.userCC addScriptMessageHandler:self name:ERROR];
        }
            break;
        case WXRWebViewControllerDataFromMessage:
        {
            self.title = @"消息详情";
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
            break;
        default:
            break;
    }
    
//    [self sendRequest];
}

//币种nav
- (void)addCurrencyNav{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake((MAINSCREEN_WIDTH - 280)/2, 0, 280, NavbarH - StatusBarH)];
    [self.navigationBar addSubview:navView];
    
    BaseLabel *coinLabel = [SEFactory labelWithText:[NSString stringWithFormat:@"%@信息",self.currencyRank.currency] frame:CGRectZero textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
    [navView addSubview:coinLabel];
    [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(navView);
    }];
    
    BaseImageView *iconView = [[BaseImageView alloc] init];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.currencyRank.iconUrl]];
    ViewRadius(iconView, AdaptX(19 / 2));
    [navView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(coinLabel.mas_left).offset(-8);
        make.centerY.mas_equalTo(navView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(19), AdaptX(19)));
    }];
}

-(void)setContraints{
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
    }];
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [_webViewBridge removeResponsingNativeService];
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    if ([AppInfo currentIOSVersion] >= 9.0) {
        [webView reload];
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{

}
//
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

}

////收到服务器重定向请求后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlPath]]];
//}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    
    //https://open.weixin.qq.com  微信授权
    NSString *str = [URL absoluteString];
    NSString *scheme = [URL scheme];
    NSLog(@"scheme == %@ url == %@",scheme, URL);
    if ([str hasPrefix:@"https://open.weixin.qq.com"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlPath]]];
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView) {
        if ([keyPath isEqualToString:@"title"]){
            if (_webView.title == nil) {
                [_webView reload];
            }
            if (![self.title notEmptyOrNull]) {
                self.title = self.webView.title;
            }
        }
        if ([keyPath isEqualToString:@"canGoBack"]){
            self.closeBtn.hidden = !self.webView.canGoBack;
        }
        if ([keyPath isEqual: @"estimatedProgress"]) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:_webView.estimatedProgress animated:YES];
            if(_webView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//js 调用 OC
#pragma mark - WKScriptMessageHandler delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //这个回调里面， message.name代表方法名（‘本例为 callFunction’）， message.body代表JS给我们传过来的参数
    NSLog(@"message ==== %@ --- %@",message.name, message.body);
    if ([message.name isEqualToString:SHARE]) {
        [[SEJSApiShare shareJSApiBase] responsejsCallWithData:message.body];
        
    }else if ([message.name isEqualToString:ERROR]){
        NSDictionary *dic = message.body;
        NSLog(@"js error === %@",dic);
        [SEHUD showAlertWithText:[dic jk_stringForKey:@"message"]];
    }
}

#pragma mark =========action=========
-(void)backAction{
    if (_webViewBridge.hasResponsing) {
        [_webViewBridge removeResponsingNativeService];
        _webViewBridge.hasResponsing = NO;
        return;
    }
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)closeAction {
    [_webViewBridge removeResponsingNativeService];
    
    if (self.modelType == WXRWebViewControllerModelTypePresent) {
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark =========UI=========
- (void)addNavigationBackBtn {
    UIBarButtonItem *leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftBarButtonItem.width = -AdaptX(10);
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 105, 44)];
    [btnView setBackgroundColor:[UIColor clearColor]];
    BaseButton *backButton =  [SEFactory buttonWithTitle:@"返回" frame:CGRectMake(0, 0, 40, 44) font:AdaptFont(16) fontColor:WhiteTextColor];
    [backButton setBackgroundColor:[UIColor clearColor]];
    backButton.imageView.contentMode = UIViewContentModeCenter;
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeBtn =  [SEFactory buttonWithTitle:@"关闭" frame:CGRectMake(backButton.easy_right + 15, 0, 40, 44) font:AdaptFont(16) fontColor:WhiteTextColor];
    [self.closeBtn setBackgroundColor:[UIColor clearColor]];
    self.closeBtn.imageView.contentMode = UIViewContentModeCenter;
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setHidden:YES];
    [btnView addSubview:backButton];
    [btnView addSubview:self.closeBtn];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItems = @[ leftBarButtonItem, backBarButtonItem ];
    }
}

-(WKWebView *)webView{
    if (!_webView) {
        //内容自适应处理 加载html字符串使用
        NSString *adaptCss = [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{max-width: 100%%; width:auto; height:auto;}</style>"];
        
        //禁止长按弹出 UIMenuController 相关
        NSString *disableCss = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
        //css 选中样式取消
        NSMutableString*disableCssJS = [NSMutableString string];
        [disableCssJS appendString:@"var style = document.createElement('style');"];
        [disableCssJS appendString:@"style.type = 'text/css';"];
        [disableCssJS appendFormat:@"var cssContent = document.createTextNode('%@');", disableCss];
        [disableCssJS appendString:@"style.appendChild(cssContent);"];
        [disableCssJS appendString:@"document.body.appendChild(style);"];
        [disableCssJS appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        [disableCssJS appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        WKUserScript *longTapUScript = [[WKUserScript alloc] initWithSource:disableCssJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        _webView.backgroundColor = MainBlackColor;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:NSInternalInconsistencyException options:NSKeyValueObservingOptionNew context:nil];
        
        self.userCC = wkWebConfig.userContentController;
        [self.userCC addUserScript:longTapUScript];
    }
    return _webView;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NavbarH, MAINSCREEN_WIDTH, 2)];
        _progressView.progressTintColor = MainYellowColor;
        _progressView.tintColor = MainBlackColor;
    }
    return _progressView;
}

-(void)dealloc{
    [_webViewBridge removeResponsingNativeService];
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:NSInternalInconsistencyException];
    [self.userCC removeScriptMessageHandlerForName:SHARE];
    [self.userCC removeScriptMessageHandlerForName:ERROR];
    
    //清除缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
        NSLog(@"缓存清除成功");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
