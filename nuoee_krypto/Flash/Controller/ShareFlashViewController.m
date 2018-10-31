//
//  ShareFlashViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/8.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "ShareFlashViewController.h"
#import "XHStarRateView.h"
#import "ShareView.h"
#import "DateManager.h"
#import "NSString+JLAdd.h"
#import <ShareSDK/ShareSDK.h>
#import "UIImage+JLAdd.h"
#import <Social/Social.h>

#define HeaderHeight MAINSCREEN_WIDTH * 384 / 750
#define FooterHeight MAINSCREEN_WIDTH * 380 / 750

@interface ShareFlashViewController ()

/* scroll */
@property (nonatomic, strong) UIScrollView *scrolView;
/* header */
@property (nonatomic, strong) BaseImageView *headerView;
/* footer */
@property (nonatomic, strong) BaseImageView *footerView;
/* year */
@property (nonatomic, strong) BaseLabel *yearLabel;
/* time */
@property (nonatomic, strong) BaseLabel *timeLabel;
/* starTag */
@property (nonatomic, strong) BaseLabel *starTag;
/* star */
@property (nonatomic, strong) XHStarRateView *starsControl;
/* upBtn */
@property (nonatomic, strong) BaseButton *upBtn;
/* downBtn */
@property (nonatomic, strong) BaseButton *downBtn;
/* shareView */
@property (nonatomic, strong) ShareView *shareView;
/* title */
@property (nonatomic, strong) BaseLabel *titleLabel;
/* content */
@property (nonatomic, strong) BaseLabel *contentLabel;


@end

@implementation ShareFlashViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    
    if (self.flash == nil) {
        [self sendRequest];
    }
}

- (void)sendRequest{
    
    [Flash hot_info_details:@{@"id" : self.ID} Success:^(Flash *flash) {
        
        self.flash = flash;
        [self setData];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - UI
- (void)createUI{
    
    WeakSelf(self);
    
    [self.view addSubview:self.scrolView];
    [self.scrolView addSubview:self.headerView];
    
    [self.headerView addSubview:self.yearLabel];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_left).offset(4 * MidPadding);
        make.top.mas_equalTo(self.headerView.mas_top).offset(AdaptY(72));
    }];
    
    [self.headerView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yearLabel.mas_left);
        make.top.mas_equalTo(self.yearLabel.mas_bottom).offset(MinPadding);
    }];
    
    [self.headerView addSubview:self.starTag];
    [self.starTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_left);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(AdaptY(13));
        make.width.equalTo(@(AdaptX(50)));
    }];
    
    [self.headerView addSubview:self.starsControl];
    [self.starsControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.starTag.mas_right);
        make.size.mas_equalTo(CGSizeMake(AdaptX(80), AdaptY(14)));
        make.centerY.mas_equalTo(self.starTag.mas_centerY);
    }];
    
    [self.scrolView addSubview:self.footerView];
    
    [self.footerView addSubview:self.upBtn];
    [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yearLabel.mas_left);
        make.top.mas_equalTo(self.footerView.mas_top).offset(MinPadding);
    }];
    
    [self.footerView addSubview:self.downBtn];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.upBtn.mas_right).offset(MidPadding);
        make.top.mas_equalTo(self.upBtn);
    }];
    
    [self.view addSubview:self.shareView];
    self.shareView.cancelBlock = ^(){
        [weakself dismissViewControllerAnimated:YES completion:nil];
    };
   
    
    [self.scrolView addSubview:self.titleLabel];
    [self.scrolView addSubview:self.contentLabel];
    
    [self setData];
    
    //分享
    self.shareView.shareBlock = ^(SSDKPlatformType type){
        UIImage *current = [UIImage captureScreenScrollView:weakself.scrolView];
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        if (type == SSDKPlatformTypeMail) {
            NSArray *images = @[current];
            UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:images applicationActivities:nil];
            [weakself presentViewController:activityController animated:YES completion:nil];
            return;
        }
        
        [shareParams SSDKSetupShareParamsByText:nil images:current url:nil title:nil type:SSDKContentTypeImage];
        
        //进行分享
        [ShareSDK share:type //传入分享的平台类型
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];

         }];
    };
}

- (void)setData{
    //set
    self.starsControl.currentScore = self.flash.weight;
    [self.upBtn setTitle:[NSString stringWithFormat:@"利好 %ld",self.flash.rise] forState:UIControlStateNormal];
    [self.downBtn setTitle:[NSString stringWithFormat:@"利空 %ld",self.flash.fall] forState:UIControlStateNormal];
    self.yearLabel.text = [DateManager dateWithTimeIntervalSince1970:self.flash.updateTime format:@"yyyy"];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[DateManager dateWithTimeIntervalSince1970:self.flash.updateTime format:@"MM月dd日 HH点mm分"],[DateManager weekdayStringFromDate:[DateManager dateWithTimeStamp:self.flash.updateTime]]];
    
    //title height
    CGFloat titleHeight = [self.flash.title getSpaceLabelHeightWithFont:Font(16) withWidth:MAINSCREEN_WIDTH - AdaptX(80) lineSpace:3];
    
    self.titleLabel.frame = CGRectMake(AdaptX(40), HeaderHeight + AdaptY(10), MAINSCREEN_WIDTH - AdaptX(80), titleHeight);
    
    //title content
    self.titleLabel.attributedText = [self.flash.title getAttributedStrWithLineSpace:3 font:Font(16)];
    
    //content height
    CGFloat contentHeight = [self.flash.content getSpaceLabelHeightWithFont:Font(14) withWidth:MAINSCREEN_WIDTH - AdaptX(80) lineSpace:3];
    self.contentLabel.frame = CGRectMake(AdaptX(40), HeaderHeight + titleHeight + AdaptY(20), MAINSCREEN_WIDTH - AdaptX(80), contentHeight);
    
    //content
    self.contentLabel.attributedText = [self.flash.content getAttributedStrWithLineSpace:3 font:Font(14)];
    
    //footer frame
    self.footerView.frame = CGRectMake(0, self.contentLabel.easy_bottom + AdaptY(10), MAINSCREEN_WIDTH, FooterHeight);
    
    //contentSize
    self.scrolView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - (StatusBarH > 20 ? AdaptY(210) : AdaptY(190)));
    self.scrolView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, HeaderHeight + titleHeight + AdaptY(30) + contentHeight + FooterHeight);
}

#pragma mark - init
- (ShareView *)shareView{
    if (!_shareView) {
        _shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - (StatusBarH > 20 ? AdaptY(210) : AdaptY(190)), MAINSCREEN_WIDTH, AdaptY(190))];
    }
    return _shareView;
}

- (BaseLabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(36) textColor:LightYellowColor textAlignment:NSTextAlignmentLeft];
    }
    return _yearLabel;
}

- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:LightYellowColor textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (BaseLabel *)starTag{
    if (!_starTag) {
        _starTag = [SEFactory labelWithText:@"重要度：" frame:CGRectZero textFont:Font(12) textColor:LightYellowColor textAlignment:NSTextAlignmentLeft];
    }
    return _starTag;
}

- (XHStarRateView *)starsControl{
    if (!_starsControl) {
        
        _starsControl = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, AdaptX(80), AdaptY(12))];
        _starsControl.isAnimation = NO;
        _starsControl.rateStyle = IncompleteStar;
    }
    return _starsControl;
}

- (BaseButton *)upBtn{
    if (!_upBtn) {
        _upBtn = [SEFactory buttonWithTitle:@"" image:ImageName(@"k_up") frame:CGRectZero font:Font(12) fontColor:WhiteTextColor];
        [_upBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        [_upBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    }
    return _upBtn;
}

- (BaseButton *)downBtn{
    if (!_downBtn) {
        _downBtn = [SEFactory buttonWithTitle:@"" image:ImageName(@"k_down") frame:CGRectZero font:Font(12) fontColor:WhiteTextColor];
        [_downBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
        [_downBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    }
    return _downBtn;
}

- (UIScrollView *)scrolView{
    if (!_scrolView) {
        _scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - (StatusBarH > 20 ? AdaptY(210) : AdaptY(190)))];
        _scrolView.backgroundColor = MainDarkColor;
    }
    return _scrolView;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [SEFactory labelWithText:@"" frame:CGRectMake(AdaptX(40), HeaderHeight, MAINSCREEN_WIDTH - AdaptX(80), AdaptY(40)) textFont:Font(16) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectMake(AdaptX(40), _titleLabel.easy_bottom + AdaptY(10), MAINSCREEN_WIDTH - AdaptX(80), AdaptY(300)) textFont:Font(14) textColor:TextDarkLightGrayColor textAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (BaseImageView *)headerView{
    if (!_headerView) {
        _headerView = [[BaseImageView alloc] initWithImage:ImageName(@"share_header")];
        _headerView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, HeaderHeight);
    }
    return _headerView;
}

- (BaseImageView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseImageView alloc] initWithImage:ImageName(@"share_footer")];
        _footerView.backgroundColor = MainRedColor;
    }
    return _footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
