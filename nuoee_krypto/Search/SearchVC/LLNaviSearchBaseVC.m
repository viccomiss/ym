//
//  LLNaviSearchBaseVC.m
//  LLSearchViewController
//
//  Created by 李龙 on 2017/7/15.
//
//

#import "LLNaviSearchBaseVC.h"
#import "LLSearchNaviBarView.h"
#import "LLSearchBar.h"
#import "NBSSearchShopHistoryView.h"
#import "HistoryAndCategorySearchHistroyViewP.h"
#import "UIView+LLRect.h"
#import "SearchModel.h"

@interface LLNaviSearchBaseVC () <UIScrollViewDelegate>

@property (nonatomic,strong) LLSearchNaviBarView *searchNaviBarView;
@property (nonatomic,strong) LLSearchBar *searchBar;

@property (nonatomic,strong) NBSSearchShopHistoryView *shopHistoryView;
@property (nonatomic,strong) NBSSearchShopHistoryView *shopHotView;


@property (nonatomic,copy) beginSearchBlock beginSearchBlock;
@property (nonatomic,copy) searchBarDidChangeBlock srdidChangeBlock;

@property (nonatomic,copy) LLSearchResultListView *resultListView;

@property (nonatomic,copy) resultListViewCellDidClickBlock myCellDidClickBlock;

@end

@implementation LLNaviSearchBaseVC{
    CGFloat KeyboardHeightWhenShow;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.searchBar becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MainBlackColor;
    //导航条
    [self setupSearchNaviBar];
    
    [self getData];
    
    //监听键盘时间
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)fetchCategotyTypeData{
    
    [SearchModel hot_coin:@{} Success:^(NSArray *list) {
        
        [self setupShopHot:list];
        
    } Failure:^(NSError *error) {
        
    }];
    
    //FIXME:模拟网络请求!!!
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        NSArray *titleArray = @[@"全部",@"美女",@"烟酒",@"汽车",@"服装",@"超市",@"洗发水",@"电视机",@"洗衣用品",@"家具电器",@"家具用品",@"篮球",@"运动鞋",@"裤子",@"袜子",@"面包",@"水果"];
////        if(!error)
//        [self setupShopHot:titleArray];
////        else
////            [self myBGScrollView];
//    });
}

- (void)getData
{
    @LLWeakObj(self);
    if (_showHotView) {
        //开始获取热门数据
        [self fetchCategotyTypeData];
    }
    
    //开始获取数据
    [self.shopHistoryP getSearchCache];
    [self.shopHistoryP fetchAndHaveSearchCache:^(BOOL isHave) {
        @LLStrongObj(self);
        if (isHave)
            [self setupShopHistory];
        else
            [self myBGScrollView];
    }];
}


//创建热门搜索栏
- (void)setupShopHot:(NSArray *)hotArray
{
    self.shopHotView = [NBSSearchShopHistoryView searchShopCategoryViewWithPresenter:self.shopHotP WithFrame:(CGRect){0,0,ZYHT_ScreenWidth,0} seachType:NaviBarSearchTypeHot];
    self.shopHotView.hotArray = hotArray;
    
    @LLWeakObj(self);

    [self.shopHotView historyTagonClick:^(UILabel *tagLabel) {
        @LLStrongObj(self);
        weak_self.resultListView.searchText = tagLabel.text;
        [self beignToSearch:NaviBarSearchTypeHot cellP:nil tagLabel:tagLabel searchBar:nil];
        //保存到历史
        [self.shopHistoryP saveSearchCache:tagLabel.text result:nil];
    }];
    
    [self.shopHotView setModifyFrameBlock:^(CGRect rect){
        @LLStrongObj(self);
        [self modifyViewFrame];
    }];
    
    //刷新数据
    [self.shopHotView reloadData];
    
    [self.myBGScrollView addSubview:self.shopHotView];
}

//创建历史搜索栏
- (void)setupShopHistory
{
    self.shopHistoryView = [NBSSearchShopHistoryView searchShopCategoryViewWithPresenter:self.shopHistoryP WithFrame:(CGRect){0,self.shopHotView.bottom,ZYHT_ScreenWidth,0} seachType:NaviBarSearchTypeHistory];
    
    @LLWeakObj(self);
    //开始搜索历史记录
    [self.shopHistoryView historyTagonClick:^(UILabel *tagLabel) {
        @LLStrongObj(self);
        weak_self.resultListView.searchText = tagLabel.text;
        [self beignToSearch:NaviBarSearchTypeHistory cellP:nil tagLabel:tagLabel searchBar:nil];
        
    }];
    
    //清空搜索历史
    [self.shopHistoryView setClearHistoryBtnOnClick:^{
        @LLStrongObj(self);
        //清空
        [self.shopHistoryP clearSearchHistoryWithResult:nil];
        
        [self.shopHistoryView removeFromSuperview];
    }];
    
    //刷新数据
    [self.shopHistoryView reloadData];
    
    [self.myBGScrollView addSubview:self.shopHistoryView];
}


//创建导航条
- (void)setupSearchNaviBar
{
    LLSearchNaviBarView *searchNaviBarView = [LLSearchNaviBarView new];
    searchNaviBarView.searbarPlaceHolder = @"请输入币种或交易所";
    searchNaviBarView.searchNaviBarViewType = searchNaviBarViewDefault;
    self.searchBar = searchNaviBarView.naviSearchBar;
    
    @LLWeakObj(self);
    [searchNaviBarView showRightOneBtnWithTitle:@"取消" onClick:^(UIButton *btn) {
        @LLStrongObj(self);
        
        [searchNaviBarView.naviSearchBar resignFirstResponder];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    //开始搜索导航条输入
    [searchNaviBarView keyBoardSearchBtnOnClick:^(LLSearchBar *searchBar) {
        @LLStrongObj(self);
        //通知外界开始搜索
        weak_self.resultListView.searchText = searchBar.text;
        [self beignToSearch:NaviBarSearchTypeDefault cellP:nil tagLabel:nil searchBar:searchBar];
        //保存搜索历史记录
        [self.shopHistoryP saveSearchCache:searchBar.text result:nil];
    }];
    
    //搜索框即时输入捕捉
    [searchNaviBarView textOfSearchBarDidChangeBlock:^(LLSearchBar *searchBar, NSString *searchText) {
        @LLStrongObj(self);
        weak_self.resultListView.searchText = searchText;
        LLBLOCK_EXEC(self.srdidChangeBlock,NaviBarSearchTypesearchBarDidChange,searchBar,searchText)
    }];
    
    [self.view addSubview:searchNaviBarView];
}


#pragma mark ================ 更新界面 Frame ================
-(void)modifyViewFrame
{
    self.shopHistoryView.y = self.shopHotView.bottom;
}

#pragma mark ================ UISCrollDelegate ================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 私有方法 ================
//-----------------------------------------------------------------------------------------------------------
- (UIScrollView *)myBGScrollView
{
    if (!_myBGScrollView) {
        _myBGScrollView = ({
            UIScrollView *bgScrollView =  [[UIScrollView alloc] initWithFrame:CGRectMake(0,NavbarH, ZYHT_ScreenWidth,ZYHT_ScreenHeight-NavbarH)];
            bgScrollView.backgroundColor = MainBlackColor;
            bgScrollView.contentSize = CGSizeMake(ZYHT_ScreenWidth, ZYHT_ScreenHeight-NavbarH - 4);
            bgScrollView.showsVerticalScrollIndicator = NO;
            bgScrollView.delegate = self;
            [self.view addSubview:bgScrollView];
            bgScrollView;
        });
    }
    return _myBGScrollView;
}


- (void)beignToSearch:(NaviBarSearchType)searchType cellP:(NBSSearchShopCategoryViewCellP *)cellP tagLabel:(UILabel *)tagLabel searchBar:(LLSearchBar *)searchBar{
    if (searchType == NaviBarSearchTypeDefault)
    {
        LLBLOCK_EXEC(self.beginSearchBlock,searchType,nil,nil,searchBar);
    }
    else if (searchType == NaviBarSearchTypeCategory)
    {
        LLBLOCK_EXEC(self.beginSearchBlock,searchType,cellP,nil,searchBar);
    }
    else  if (searchType == NaviBarSearchTypeHistory)
    {
        LLBLOCK_EXEC(self.beginSearchBlock,searchType,nil,tagLabel,nil);
    }
    else  if (searchType == NaviBarSearchTypeHot)
    {
        LLBLOCK_EXEC(self.beginSearchBlock,searchType,nil,tagLabel,nil);
    }
    
    //退出
//    [self dismissVC];
}

- (void)dismissVC{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}


//创建即时匹配页面
- (LLSearchResultListView *)resultListView
{
    if (!_resultListView) {
        _resultListView = [[LLSearchResultListView alloc] init];
        
        //列表被点击
        @LLWeakObj(self);
        [_resultListView  resultListViewDidSelectedIndex:^(UITableView *tableView, NSInteger index) {
            @LLStrongObj(self);
            
            SearchModel *m = self.resultListArray[index];
            [self.shopHistoryP saveSearchCache:m.name result:nil];
            
            LLBLOCK_EXEC(self.myCellDidClickBlock,tableView,index);
            
            //退出搜索控制器
            [self dismissVC];
        }];
        
        [self.view addSubview:_resultListView];
    }
    return _resultListView;
}

#pragma mark UIKeyboardWillChangeFrameNotification/当键盘的位置大小发生改变时触发
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    KeyboardHeightWhenShow = rect.size.height;
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 接口 ================
//-----------------------------------------------------------------------------------------------------------
- (void)beginSearch:(beginSearchBlock)beginSearchBlock {
    _beginSearchBlock = beginSearchBlock;
}

-(void)setSearchBarText:(NSString *)searchBarText{
}

-(void)setResultListArray:(NSArray *)resultListArray
{
    _resultListArray = resultListArray;
    self.resultListView.frame = CGRectMake(0, NavbarH, self.view.width, ZYHT_ScreenHeight-KeyboardHeightWhenShow-NavbarH);
    self.resultListView.resultArray = resultListArray;
}


- (void)searchbarDidChange:(searchBarDidChangeBlock)didChangeBlock;
{
    _srdidChangeBlock = didChangeBlock;
}


/**
 即时匹配结果列表cell点击事件
 */
- (void)resultListViewDidSelectedIndex:(resultListViewCellDidClickBlock)cellDidClickBlock
{
    _myCellDidClickBlock = cellDidClickBlock;
}


-(void)dealloc
{
    NSLog(@"LLNaviSearchBaseVC 页面销毁");
}

@end
