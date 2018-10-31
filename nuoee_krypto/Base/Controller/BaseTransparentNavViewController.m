//
//  BaseTransparentNavViewController.m
//  SuperEducation
//
//  Created by yangming on 2017/4/20.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "BaseTransparentNavViewController.h"
#import "BaseViewController.h"
#import "CommonUtils.h"
#import "BaseHiddenNavViewController.h"

@interface BaseTransparentNavViewController ()

@property (nonatomic, strong) CAGradientLayer *navLayer;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) BaseLabel *titleLabel;
@property (nonatomic, strong) BaseButton *backBtn;

@end

@implementation BaseTransparentNavViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navView.hidden = YES;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
    
    if (!self.isNotShowNav) {
        [[UIApplication sharedApplication].delegate.window addSubview:self.navView];
        
        [self.navView addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navView.mas_top).offset(StatusBarH);
            make.left.mas_equalTo(self.navView.mas_left);
            make.size.mas_equalTo(CGSizeMake(NavbarH - StatusBarH, NavbarH - StatusBarH));
        }];
        
        [self.navView addSubview:self.titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.navView.mas_centerX);
            make.height.equalTo(@(NavbarH - StatusBarH));
            make.top.mas_equalTo(self.navView.mas_top).offset(StatusBarH);
        }];
        
        //透明黑渐变
//        [self insertTransparentGradient];
    }
    
    [self setUpUI];
}
-(void)dealloc{
    [self.navView removeFromSuperview];
}

- (void) insertTransparentGradient {
    UIColor *colorOne = [UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:0.4];
    UIColor *colorTwo = [UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = self.navView.bounds;
    [self.navView.layer insertSublayer:headerLayer atIndex:0];
}

- (void)setUpUI{

}

-(void)backTouched:(UIButton*)sender{
    self.navView.hidden = YES;
    [self backOtherOperation];
}

- (void)backOtherOperation{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    _titleLabel.text = title;
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, NavbarH)];
    }
    return _navView;
}
-(BaseLabel *)titleLabel{
    if (!_titleLabel) {
     _titleLabel = [SEFactory labelWithText:self.title frame:CGRectZero textFont:Font(17) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (BaseButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [SEFactory buttonWithImage:ImageName(@"nav_back_white")];
        [_backBtn addTarget:self action:@selector(backTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
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
