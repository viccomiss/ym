//
//  AboutUsViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/7/2.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "AboutUsViewController.h"
#import "TitleAndFieldCell.h"
#import "AboutUsModel.h"
#import "WXRWebViewController.h"

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* model */
@property (nonatomic, strong) AboutUsModel *usModel;
/* header */
@property (nonatomic, strong) UIView *headerView;
/* icon */
@property (nonatomic, strong) BaseImageView *iconView;
/* viersion */
@property (nonatomic, strong) BaseLabel *versionLabel;
/* footerView */
@property (nonatomic, strong) UIView *footerView;
/*  clause */
@property (nonatomic, strong) BaseLabel *clauseLabel;


@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"关于我们";
    [self createUI];
    [self loadData];
}

- (void)tapClause{
    WXRWebViewController *webVC = [[WXRWebViewController alloc] init];
    webVC.dataFrom = WXRWebViewControllerDataFromAgreenment;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - request
-(void)loadData{
    [EasyLoadingView showLoading];
    [AboutUsModel aboutUs:@{} Success:^(AboutUsModel *item) {
        
        self.usModel = item;
        self.versionLabel.text = [NSString stringWithFormat:@"Version %@",item.version];
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TitleAndFieldCell *cell = [TitleAndFieldCell titleAndFieldCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
    cell.filed.userInteractionEnabled = NO;
    switch (indexPath.row) {
        case 0:
            cell.title = @"邮箱";
            cell.placeholder = self.usModel.email;
            break;
        case 1:
            cell.title = @"QQ交流群";
            cell.placeholder = self.usModel.qqGroup;
            break;
        case 2:
            cell.title = @"微博";
            cell.placeholder = self.usModel.weibo;
            break;
        case 3:
            cell.title = @"Telegram";
            cell.placeholder = self.usModel.telegram;
            break;
        case 4:
            cell.title = @"Facebook";
            cell.placeholder = self.usModel.facebook;
            break;
        case 5:
            cell.title = @"Twitter";
            cell.placeholder = self.usModel.twitter;
            break;
        case 6:
            cell.title = @"地址";
            cell.placeholder = self.usModel.address;
            break;
    }
    return cell;
}

#pragma mark - tableview delagte
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  AdaptY(50);
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    [self.footerView addSubview:self.clauseLabel];
    [self.clauseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.footerView);
    }];
    
    [self.headerView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView);
        make.top.mas_equalTo(self.headerView.mas_top).offset(AdaptY(14));
        make.size.mas_equalTo(CGSizeMake(AdaptX(100), AdaptY(90)));
    }];
    
    [self.headerView addSubview:self.versionLabel];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headerView.mas_centerX);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(MidPadding);
        make.left.right.mas_equalTo(self.headerView);
    }];
}

#pragma mark - init
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NavbarH, MAINSCREEN_WIDTH, AdaptY(156))];
    }
    return _headerView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(50))];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClause)];
        tap.numberOfTapsRequired = 1;
        [_footerView addGestureRecognizer:tap];
    }
    return _footerView;
}

- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] initWithImage:ImageName(@"about_us_header")];
    }
    return _iconView;
}

- (BaseLabel *)clauseLabel{
    if (!_clauseLabel) {
        _clauseLabel = [SEFactory labelWithText:@"《快比特服务条款》" frame:CGRectZero textFont:Font(12) textColor:MainYellowColor textAlignment:NSTextAlignmentCenter];
    }
    return _clauseLabel;
}

- (BaseLabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:TextTagGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _versionLabel;
}

- (BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = MainBlackColor;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
