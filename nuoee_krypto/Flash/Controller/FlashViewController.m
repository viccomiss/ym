//
//  FlashViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "FlashViewController.h"
#import "FlashCell.h"
#import "FlashHeaderView.h"
#import "FlashModel.h"
#import "DeviceInfo.h"
#import "DateManager.h"
#import "NSAttributedString+JLAdd.h"
#import "NSString+JLAdd.h"
#import "ShareFlashViewController.h"
#import "WXRWebViewController.h"
#import "DeviceInfo.h"
#import "DHGuidePageHUD.h"

@interface FlashViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/* model */
@property (nonatomic, strong) FlashModel *model;
/* sortArray */
@property (nonatomic, strong) NSMutableArray *sortArray;

@end

@implementation FlashViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadNews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self setRefresh];
    [self addLogoNavView];
}

#pragma mark - request
- (void)reloadNews{
    
    if (self.sortArray.count == 0) {
        return;
    }
    FlashGroupModel *GM = self.sortArray[0];
    Flash *model = GM.flashArray[0];
    [Flash hot_info_get_newInfoNum:@{@"id": model.ID} Success:^(NSInteger num) {
        
        if (self.sortArray.count != 0) {
            FlashGroupModel *GM = self.sortArray[0];
            GM.news = num;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        NSLog(@"news num == %ld",num);
        
    } Failure:^(NSError *error) {
        
    }];
}

-(void)setRefresh{
    [[SERefresh sharedSERefresh] normalModelRefresh:self.tableView refreshType:RefreshTypeDouble firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer endRefreshing];
        [self loadDataWithLoadMore:NO];
    } upDropBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self loadDataWithLoadMore:YES];
    }];
}

-(void)loadDataWithLoadMore:(BOOL)isMore{
    [FlashModel hot_info:@{@"pageNo": [NSString stringWithFormat:@"%d",isMore ? self.model.page.pageNo + 1 : 1] ,@"pageSize":@"10", @"deviceId": [DeviceInfo getUUID]}
                 Success:^(FlashModel *model) {
                         self.model = model;
                         if (self.dataArray.count >= model.page.totalCount) {
                             [self.tableView.mj_footer endRefreshingWithNoMoreData];
                         }else{
                             [self.tableView.mj_footer endRefreshing];
                         }
                         if (isMore) {
                             [self.dataArray addObjectsFromArray:self.model.results];
                         }else{
                             [self.tableView.mj_header endRefreshing];
                             self.dataArray = [NSMutableArray arrayWithArray:self.model.results];
                             
                             if (self.dataArray.count == 0) {
                                 [self.noDataView showNoDataView:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-NavbarH) type:NoFlashType tagStr:@"" needReload:NO reloadBlock:nil];
                                 [self.tableView addSubview:self.noDataView];
                             }else{
                                 self.noDataView.hidden = YES;
                             }
                         }
                     
                        //分组处理
                     self.sortArray = [NSMutableArray arrayWithArray:[self arraySplitSubArrays:self.dataArray]];
                     
                         [self.tableView reloadData];
                     } Failure:^(NSError *error) {
                         
                     }];
}

- (NSMutableArray *)arraySplitSubArrays:(NSArray *)array {
    // 数组去重,根据数组元素对象中time字段去重
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for(Flash *obj in array)
    {
        [dic setValue:obj forKey:[DateManager dateWithTimeIntervalSince1970:obj.updateTime format:@"yyyy-MM-dd"]];
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSString *dictKey in dic) {
        [tempArr addObject:dictKey];
    }
    
    NSArray *sortedArray = [tempArr sortedArrayUsingSelector:@selector(compare:)];
    
    NSLog(@"排序后:%@",sortedArray);
    
    // 字典重不会有重复值,allKeys返回的是无序的数组
    NSLog(@"去重后字典:%@",[dic allKeys]);
    
    NSMutableArray *temps = [NSMutableArray array];
    
    for (NSString *dictKey in sortedArray) {
        
        NSMutableArray *subTemps = [NSMutableArray array];
        for (Flash *obj in array) {
            
            if ([dictKey isEqualToString:[DateManager dateWithTimeIntervalSince1970:obj.updateTime format:@"yyyy-MM-dd"]]) {
                [subTemps addObject:obj];
            }
        }
        
        [temps addObject:subTemps];
    }
    
    
    // 排序后,元素倒序的,逆向遍历
//    NSEnumerator *enumerator = [temps reverseObjectEnumerator];
//    temps = (NSMutableArray*)[enumerator allObjects];
    
    NSMutableArray *groupArray = [NSMutableArray array];
    [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        [parm setObject:obj forKey:@"time"];
        [parm setObject:temps[idx] forKey:@"flashArray"];
        
        FlashGroupModel *model = [FlashGroupModel mj_objectWithKeyValues:parm];
        [groupArray insertObject:model atIndex:0];
    }];
    
    NSLog(@"temps:%@",groupArray);
    return groupArray;
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sortArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FlashGroupModel *model = self.sortArray[section];
    return model.flashArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlashCell *cell = [FlashCell flashCell:tableView];
    FlashGroupModel *GM = self.sortArray[indexPath.section];
    __block Flash *model = GM.flashArray[indexPath.row];
    cell.model = model;
    
    WeakSelf(cell);
    WeakSelf(self);
    cell.riseBlock = ^(BOOL rise){
        [Flash hot_info_rise:@{@"hotInfoId" : model.ID, @"deviceId" : [DeviceInfo getUUID]} Success:^(Flash *flash) {
            
            model.rise = flash.rise;
            model.fall = flash.fall;
            model.riseOrFall = flash.riseOrFall;
            weakcell.model = model;
            [weakcell upSuccess];
            
        } Failure:^(NSError *error) {
            
        }];
    };
    cell.fallBlock = ^(BOOL rise){
        [Flash hot_info_fall:@{@"hotInfoId" : model.ID, @"deviceId" : [DeviceInfo getUUID]} Success:^(Flash *flash) {
            model.rise = flash.rise;
            model.fall = flash.fall;
            model.riseOrFall = flash.riseOrFall;
            weakcell.model = model;
            [weakcell downSuccess];
            
        } Failure:^(NSError *error) {
            
        }];
    };
    cell.shareBlock = ^(){
        ShareFlashViewController *shareVC = [[ShareFlashViewController alloc] init];
        shareVC.flash = model;
        [weakself presentViewController:shareVC animated:YES completion:nil];
    };
    cell.originalBlock = ^(){
        WXRWebViewController *webVC = [[WXRWebViewController alloc] init];
        webVC.dataFrom = WXRWebViewControllerDataFromFlash;
        webVC.url = model.urlSource;
        [weakself.navigationController pushViewController:webVC animated:YES];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FlashGroupModel *GM = self.sortArray[section];
    FlashHeaderView *header = [FlashHeaderView flashHeader:tableView];
    header.model = GM;
    return header;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    Flash *model = self.dataArray[indexPath.section];
//    model.open = !model.open;
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlashGroupModel *GM = self.sortArray[indexPath.section];
    Flash *model = GM.flashArray[indexPath.row];

    model.titleHeight = [model.title getSpaceLabelHeightWithFont:Font(16) withWidth:MAINSCREEN_WIDTH - AdaptX(60) lineSpace:3];
    
    CGFloat marginHeight = AdaptY(20) + AdaptY(24) + 7 * MinPadding + AdaptY(8) * 2 + AdaptY(6);
    
    CGFloat contentHeight = [model.content getSpaceLabelHeightWithFont:Font(14) withWidth:MAINSCREEN_WIDTH - AdaptX(80) lineSpace:3];
    
    model.contentHeight = contentHeight;
    
    return  model.contentHeight + model.titleHeight +  marginHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    FlashGroupModel *GM = self.sortArray[section];
    return GM.news == 0 ? AdaptY(57) : AdaptY(86);
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
    }];
}

#pragma mark - init
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
