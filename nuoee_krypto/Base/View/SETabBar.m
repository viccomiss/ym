//
//  SETabBar.m
//  SuperEducation_Host
//
//  Created by yangming on 2017/3/29.
//  Copyright © 2017年 shanghailuoqi. All rights reserved.
//

#import "SETabBar.h"
#import "UIView+EasyFrame.h"
#import "UIImage+GIF.h"

@interface SETabBar ()

@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) BaseImageView *centerView; //播放中播放按钮gif图

@end

@implementation SETabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        self.btnArray = [NSMutableArray array];
        [self setupCenterButton];
    }
    return self;
}

- (void)centerButtonClicked:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.centerView.hidden = NO;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"center_playing" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage sd_animatedGIFWithData:data];
        self.centerView.image = image;
    }else{
        self.centerView.hidden = YES;
    }
    if (self.centerBlock) {
        self.centerBlock();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * view = [super hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        BOOL pointInRound = [self touchPointInsideCircle:self.centerButton.center radius:30 targetPoint:point];
        // 判断触摸点是否在button上
        if (pointInRound) {
            view = self.centerButton;
        }
    }
    return view;
}

- (BOOL)touchPointInsideCircle:(CGPoint)center radius:(CGFloat)radius targetPoint:(CGPoint)point
{
    CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) +
                         (point.y - center.y) * (point.y - center.y));
    return (dist <= radius);
}

- (void)setupCenterButton{
    
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.centerButton setImage:ImageName(@"tabbar_center") forState:UIControlStateNormal];
    [self.centerButton setImage:ImageName(@"center_selected") forState:UIControlStateSelected];
    [self.centerButton addTarget:self action:@selector(centerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.centerButton];
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-2);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    self.centerView = [[BaseImageView alloc] init];
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.cornerRadius = 64 / 2;
    self.centerView.hidden = YES;
    [self.centerButton addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerButton.mas_centerX);
        make.centerY.mas_equalTo(self.centerButton.mas_centerY).offset(2.5);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
}

- (void)addButtonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    [self addSubview:btn];
    [self.btnArray addObject:btn];
    
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //如果是第一个按钮, 则选中(按顺序一个个添加)
    if (self.btnArray.count == 1) {
        [self clickBtn:btn];
    }
}

/**
 *  自定义TabBar的按钮点击事件
 */
- (void)clickBtn:(UIButton *)button {
    
    //1.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    //2.再将当前按钮设置为选中
    button.selected = YES;
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = button;
    
    //却换视图控制器的事情,应该交给controller来做
    //最好这样写, 先判断该代理方法是否实现
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)]) {
        [self.delegate tabBar:self selectedFrom:self.selectedBtn.tag to:button.tag];
    }
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    int btnIndex = 0;

    for (int i = 0; i < self.btnArray.count; i++) {
        
        UIButton *btn = self.btnArray[i];
        btn.tag = i;
        
        CGFloat width = self.easy_width / 5;
        btn.frame = CGRectMake(width * btnIndex, 0, width, self.easy_height);
        
        btnIndex++;
        //如果是索引是1(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
        if (btnIndex == 2) {
            btnIndex++;
        }
    }
}

@end
