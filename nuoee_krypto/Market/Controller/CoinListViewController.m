//
//  CoinListViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/26.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "CoinListViewController.h"
#import "UITableView+SCIndexView.h"
#import "Currency.h"
#import "CoinListCell.h"
#import "LLSearchNaviBarView.h"
#import "LLSearchBar.h"

NSString *const CYPinyinGroupResultArray = @"CYPinyinGroupResultArray";

NSString *const CYPinyinGroupCharArray = @"CYPinyinGroupCharArray";

@interface CoinListViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* sortArray */
@property (nonatomic, strong) NSMutableArray *sortArray;
/* nameArray */
@property (nonatomic, strong) NSMutableArray *nameArray;
/* resultArray */
@property (nonatomic, strong) NSArray *resultArray;

@property (nonatomic, strong) UISearchController *searchController;
/* LLSearchNaviBarView */
@property (nonatomic, strong) LLSearchNaviBarView *searchNaviBarView;
/* searchText */
@property (nonatomic, copy) NSString *searchText;


@end

@implementation CoinListViewController{
    CGFloat KeyboardHeightWhenShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择币种";
    [self createUI];
    [self setData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setSearchController{
    
    // 创建UISearchController, 这里使用当前控制器来展示结果
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
    // 设置结果更新代理
    search.searchResultsUpdater = self;
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    search.dimsBackgroundDuringPresentation = NO;
    // 是否自动隐藏导航
    //    search.hidesNavigationBarDuringPresentation = NO;
    self.searchController = search;
    // 将searchBar赋值给tableView的tableHeaderView
    self.tableView.tableHeaderView = search.searchBar;
    
    search.searchBar.delegate = self;
}

- (void)setData{
    
    for (Currency *c in self.listArray) {
        [self.nameArray addObject:c.currency_name];
    }
    
    NSDictionary *dcit = [self sortObjectsAccordingToInitialWith:self.listArray SortKey:@"currency_name"];
    
    [self reloadTable:dcit];
}

- (void)reloadTable:(NSDictionary *)dcit{
    self.dataArray = [NSMutableArray arrayWithArray:dcit[CYPinyinGroupResultArray]];//排好顺序的PersonModel数组
    self.sortArray = [NSMutableArray arrayWithArray:dcit[CYPinyinGroupCharArray]];//排好顺序的首字母数组
    self.tableView.sc_indexViewDataSource = self.sortArray.copy;
    
    if (self.dataArray.count == 0) {
        [self.noDataView showNoDataView:CGRectMake(0, NavbarH, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-NavbarH) type:NoSearchType tagStr:self.searchText needReload:YES reloadBlock:nil];
        [self.tableView addSubview:self.noDataView];
    }else{
        self.noDataView.hidden = YES;
    }
    
    [self.tableView reloadData];
}

// 按首字母分组排序数组
-(NSDictionary *)sortObjectsAccordingToInitialWith:(NSArray *)willSortArr SortKey:(NSString *)sortkey {
    
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    NSLog(@"newSectionsArray %@ %@",newSectionsArray,collation.sectionTitles);
    
    NSMutableArray *firstChar = [NSMutableArray array];
    
    //将每个名字分到某个section下
    for (id Model in willSortArr) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:Model collationStringSelector:NSSelectorFromString(sortkey)];
        
        //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:Model];
        
        //拿出每名字的首字母
        NSString * str= collation.sectionTitles[sectionNumber];
        [firstChar addObject:str];
        NSLog(@"sectionNumbersectionNumber %ld %@",sectionNumber,str);
    }
    
    //返回首字母排好序的数据
    NSArray *firstCharResult = [self SortFirstChar:firstChar];
    
    NSLog(@"firstCharResult== %@",firstCharResult);
    
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:NSSelectorFromString(sortkey)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
        }
    }
    return @{CYPinyinGroupResultArray:finalArr,
             
             CYPinyinGroupCharArray:firstCharResult};
}

-(NSArray *)SortFirstChar:(NSArray *)firstChararry{
    
    //数组去重复
    
    NSMutableArray *noRepeat = [[NSMutableArray alloc]initWithCapacity:8];
    
    NSMutableSet *set = [[NSMutableSet alloc]initWithArray:firstChararry];
    
    [set enumerateObjectsUsingBlock:^(id obj , BOOL *stop){
        
        [noRepeat addObject:obj];
    }];
    
    //字母排序
    NSArray *resultkArrSort1 = [noRepeat sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //把”#“放在最后一位
    NSMutableArray *resultkArrSort2 = [[NSMutableArray alloc]initWithArray:resultkArrSort1];
    if ([resultkArrSort2 containsObject:@"#"]) {
        
        [resultkArrSort2 removeObject:@"#"];
        [resultkArrSort2 addObject:@"#"];
    }
    
    return resultkArrSort2;
}

- (void)filterContentWithSearchStr:(NSString *)searchStr{
    
    if (searchStr.length == 0) {
        [self setData];
        return;
    }
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (Currency *c in self.listArray) {
        if ([c.currency_name containsString:[searchStr uppercaseString]]) {
            [resultArr addObject:c];
        }
    }
    
    [self reloadTable:[self sortObjectsAccordingToInitialWith:resultArr SortKey:@"currency_name"]];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[A-Za-z]*$"];
//    NSMutableArray* resultArry = [NSMutableArray array];
//    //是拼音则匹配以输入的拼音开头的且不区分大小写的游戏名
//    if ([predicate evaluateWithObject:searchStr]) {
//
//        NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@",searchStr];
//        NSArray* spallArry = [self.nameArray filteredArrayUsingPredicate:predict];
//        for (NSString* str in spallArry) {
//
//            NSInteger index = [self.nameArray indexOfObject:str];
//
//            [resultArry addObject:[self.listArray objectAtIndex:index]];
//        }
//        //输入的是数字或者汉字 则匹配名字中包含输入字符的游戏名
//    }else{
//        NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchStr];
//        //或者使用 @"name LIKE[cd] '*%@*'"    //*代表通配符
//        resultArry = [self.listArray filteredArrayUsingPredicate:predict].mutableCopy;
//    }
//    self.resultArray = [NSArray arrayWithArray:resultArry];
//    return resultArry;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = self.dataArray[indexPath.section];
    Currency *c = arr[indexPath.row];
    [self coinTouch:c];
}

- (void)coinTouch:(Currency *)c{
    if (self.coinBlock) {
        self.coinBlock(c.currency_name);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(30);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(47);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *rows = self.dataArray[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoinListCell *cell = [CoinListCell coinListCell:tableView];
    NSArray *arr = self.dataArray[indexPath.section];
    cell.model = arr[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(30))];
    header.backgroundColor = MainDarkColor;
    
    BaseLabel *label = [SEFactory labelWithText:self.sortArray[section] frame:CGRectMake(MidPadding, 0, 120, AdaptY(30)) textFont:Font(14) textColor:TextDarkLightGrayColor textAlignment:NSTextAlignmentLeft];
    [header addSubview:label];
    return header;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sortArray[section];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    
    [self setupSearchNaviBar];
}

- (void)showOrHide:(BOOL)isHide{
    
    if (isHide) {
        
        [UIView animateWithDuration:0.6 animations:^{
            CGRect navFrame = self.navigationBar.frame;
            navFrame.origin.y = -NavbarH;
            self.navigationBar.frame = navFrame;
            
            CGRect tabFrame = self.tableView.frame;
            tabFrame.origin.y = 0;
            tabFrame.size.height = MAINSCREEN_HEIGHT;
            self.tableView.frame = tabFrame;
            
            [self.searchNaviBarView updateFrameOnNav:YES];
        }];
        
    }else{
        [UIView animateWithDuration:0.6 animations:^{
            CGRect navFrame = self.navigationBar.frame;
            navFrame.origin.y = StatusBarH;
            self.navigationBar.frame = navFrame;
            
            CGRect tabFrame = self.tableView.frame;
            tabFrame.origin.y = NavbarH;
            tabFrame.size.height = MAINSCREEN_HEIGHT - NavbarH;
            self.tableView.frame = tabFrame;
            
            [self.searchNaviBarView updateFrameOnNav:NO];
        }];
    }
    
    self.tableView.tableHeaderView = self.searchNaviBarView;
}

//创建导航条
- (void)setupSearchNaviBar
{
    LLSearchNaviBarView *searchNaviBarView = [LLSearchNaviBarView new];
    searchNaviBarView.searbarPlaceHolder = @"搜索";
    searchNaviBarView.searchNaviBarViewType = searchNaviBarViewDefault;
    self.searchNaviBarView = searchNaviBarView;
    
    WeakSelf(self);
    searchNaviBarView.searchBarBeignOnClickBlock = ^(){
        
        NSLog(@"开始点击");
        [weakself showOrHide:YES];
    };
    
    [searchNaviBarView showRightOneBtnWithTitle:@"取消" onClick:^(UIButton *btn) {
        StrongSelf(self);
        [searchNaviBarView.naviSearchBar resignFirstResponder];
        [weakself showOrHide:NO];
        [weakself setData];
    }];
    
    //开始搜索导航条输入
    [searchNaviBarView keyBoardSearchBtnOnClick:^(LLSearchBar *searchBar) {
        self.searchText = searchBar.text;
        [weakself filterContentWithSearchStr:searchBar.text];
    }];
    
    //搜索框即时输入捕捉
    [searchNaviBarView textOfSearchBarDidChangeBlock:^(LLSearchBar *searchBar, NSString *searchText) {
        self.searchText = searchBar.text;
        [weakself filterContentWithSearchStr:searchBar.text];
    }];
    
    [searchNaviBarView updateFrameOnNav:NO];
    
    self.tableView.tableHeaderView = searchNaviBarView;
}

#pragma mark UIKeyboardWillChangeFrameNotification/当键盘的位置大小发生改变时触发
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    KeyboardHeightWhenShow = rect.size.height;
    CGFloat keyboardY = rect.origin.y;
    
    // 用键盘的Y值减去屏幕的高度计算出平移的值
    // 1. 如果是键盘弹出事件, 那么计算出的值就是负的键盘的高度
    // 2. 如果是键盘的隐藏事件, 那么计算出的值就是零， 因为键盘在隐藏以后, 键盘的Y值就等于屏幕的高度。
    CGFloat keyBoardY = keyboardY - MAINSCREEN_HEIGHT;
}

#pragma mark - init
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)nameArray{
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}

- (BaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, NavbarH, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - NavbarH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = MainBlackColor;
        SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
        _tableView.sc_indexViewConfiguration = configuration;
    }
    return _tableView;
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
