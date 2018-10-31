//
//  EditNickViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/9.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "EditNickViewController.h"
#import "SEUserDefaults.h"

@interface EditNickViewController ()<UITextFieldDelegate>

/* text */
@property (nonatomic, strong) BaseTextField *nickField;
/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* user */
@property (nonatomic, strong) UserModel *user;


@end

@implementation EditNickViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    if (self.user.username.length != 0) {
        self.nickField.text = self.user.username;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"修改用户名";
    [self createUI];
}

#pragma mark - action
- (void)saveTouch{
    
    if (self.nickField.text.length == 0) {
        [SEHUD showAlertWithText:@"用户名不能为空"];
        return;
    }
    
    if (self.nickField.text.length < 2) {
        [SEHUD showAlertWithText:@"用户名长度为2-15之间"];
        return;
    }
    
    if (self.nickField.text.length > 15) {
        [SEHUD showAlertWithText:@"用户名长度为2-15之间"];
        return;
    }

    [UserModel account_change:@{@"username" : self.nickField.text} Success:^(UserModel *user) {
        
        [SEHUD showAlertWithText:@"保存成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } Failure:^(NSError *error) {
        
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if ([self.nickField stringContainsEmoji:string]) {
//        self.nickField.textLocation = range.location;
//    }else {
//        self.nickField.textLocation = -1;
//    }
//    return YES;
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：，。？！；“”（）¥「」＂、[]{}#%-*+=_//|~＜＞$€^£•'@#$%^&*():;.,?!<>\\_+'/\""];
    NSString *str = [tem stringByTrimmingCharactersInSet:set];
    if (![string isEqualToString:str]) {
        return NO;
    }
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textField{
    
//    if (self.nickField.textLocation == -1) {
//        NSLog(@"输入不含emoji表情");
//    }else {
//        NSLog(@"输入含emoji表情");
//        [SEHUD showAlertWithText:@"不能输入emoji表情"];
//        //截取emoji表情前
//        textField.text = [textField.text substringToIndex:self.nickField.textLocation];
//    }
    
    //    if (_pubModel) {
    //        _pubModel.name = textField.text;
    //    }
    
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 15)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:15];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:15];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 15)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

#pragma mark - UI
- (void)createUI{
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveTouch)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = MainDarkColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(2 * MidPadding + NavbarH);
        make.height.equalTo(@(AdaptY(50)));
    }];
    
    [view addSubview:self.nickField];
    [self.nickField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(MidPadding);
        make.top.bottom.mas_equalTo(view);
        make.right.mas_equalTo(view.mas_right).offset(-MidPadding);
    }];
    
    [self.view addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(2 * MidPadding);
        make.right.mas_equalTo(self.view.mas_right).offset(- 2 * MidPadding);
        make.top.mas_equalTo(self.nickField.mas_bottom).offset(MidPadding);
    }];
}

#pragma mark - init
- (BaseTextField *)nickField{
    if (!_nickField) {
        _nickField = [SEFactory textFieldWithPlaceholder:@"2-15位,支持汉字、英文及数字" frame:CGRectZero font:Font(14)];
        _nickField.text = self.user.username;
        _nickField.textColor = WhiteTextColor;
        _nickField.delegate = self;
        _nickField.clearButtonMode = UITextFieldViewModeAlways;
        [_nickField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _nickField.backgroundColor = MainDarkColor;
    }
    return _nickField;
}

- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@"为保护您的隐私，请避免使用手机号作为昵称" frame:CGRectZero textFont:Font(14) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _tagLabel;
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
