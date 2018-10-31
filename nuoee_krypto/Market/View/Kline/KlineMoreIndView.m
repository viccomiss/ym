//
//  KlineMoreIndView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "KlineMoreIndView.h"

@interface KlineMoreIndView()

/* mainArr */
@property (nonatomic, strong) NSMutableArray *mainArray;
/* vice */
@property (nonatomic, strong) NSMutableArray *viceArray;

@end

@implementation KlineMoreIndView

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = MainDarkColor;
        [self createUI:0];
        [self createUI:1];
    }
    return self;
}

- (NSArray *)setData:(NSInteger)index{
    if (index == 0) {
        return @[@"MA",@"BOLL"];
    }
    return @[@"MACD",@"KDJ",@"RSI",@"WR"];
}

#pragma mark - action
- (void)cancelTouch:(BaseButton *)sender{
    self.hidden = YES;
    if (sender.tag == 0) {
        if (self.mainCancelBlock) {
            self.mainCancelBlock();
        }
        
        for (BaseButton *btn in self.mainArray) {
            btn.selected = NO;
        }
        
    }else{
        if (self.viceCancelBlock) {
            self.viceCancelBlock();
        }
        
        for (BaseButton *btn in self.viceArray) {
            btn.selected = NO;
        }
    }
}

- (void)selectTouch:(BaseButton *)sender{
    
    if (sender.selected) {
        return;
    }
    
    if (sender.tag >= 100) {
        //副图
        if (self.viceSelectBlock) {
            self.viceSelectBlock(sender.titleLabel.text);
        }
        for (BaseButton *btn in self.viceArray) {
            if (btn.tag == sender.tag) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
       
    }else{
        if (self.mainSelectBlock) {
            self.mainSelectBlock(sender.titleLabel.text);
        }
        
        for (BaseButton *btn in self.mainArray) {
            if (btn.tag == sender.tag) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
    }
    self.hidden = YES;
}

#pragma mark - UI
- (void)createUI:(NSInteger)index{
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (index == 0) {
            make.top.mas_equalTo(self.mas_top);
        }else{
            make.bottom.mas_equalTo(self.mas_bottom);
        }
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.5);
    }];
    
    BaseLabel *tag = [SEFactory labelWithText:index == 0 ? @"主图" : @"副图" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    [view addSubview:tag];
    [tag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(view);
        make.left.mas_equalTo(view.mas_left).offset(MidPadding);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = MarginLineColor;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tag.mas_right).offset(MidPadding);
        make.centerY.mas_equalTo(view);
        make.size.mas_equalTo(CGSizeMake(1, AdaptY(20)));
    }];
    
    BaseButton *cancel = [SEFactory buttonWithTitle:@"取消" image:nil frame:CGRectZero font:Font(12) fontColor:TextDarkGrayColor];
    cancel.tag = index;
    [cancel addTarget:self action:@selector(cancelTouch:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view.mas_right).offset(-MidPadding);
        make.top.bottom.mas_equalTo(view);
        make.width.equalTo(@(AdaptX(45)));
    }];
    
    CGFloat width = MAINSCREEN_WIDTH / 7;
    for (int i = 0; i < [self setData:index].count; i++) {
        BaseButton *btn = [SEFactory buttonWithTitle:[self setData:index][i] frame:CGRectZero font:Font(12) fontColor:TextDarkGrayColor];
        [btn setTitleColor:MainYellowColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectTouch:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + index * 100;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(line.mas_right).offset(2 * MidPadding + width * i);
            make.top.bottom.mas_equalTo(view);
            make.width.equalTo(@(width));
        }];
        
        if (index == 0) {
            [self.mainArray addObject:btn];
        }else{
            [self.viceArray addObject:btn];
        }
    }
}

#pragma mark - init
- (NSMutableArray *)mainArray{
    if (!_mainArray) {
        _mainArray = [NSMutableArray array];
    }
    return _mainArray;
}

- (NSMutableArray *)viceArray{
    if (!_viceArray) {
        _viceArray = [NSMutableArray array];
    }
    return _viceArray;
}

@end
