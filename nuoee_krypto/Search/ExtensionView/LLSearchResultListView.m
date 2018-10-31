//
//  LLSearchResultListView.m
//  LLSearchViewController
//
//  Created by 李龙 on 2017/7/28.
//
//

#import "LLSearchResultListView.h"
#import "UIView+LLRect.h"
#import "LLSearchVCConst.h"
#import "CoinListCell.h"
#import "NoDataView.h"

@interface LLSearchResultListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,copy) resultListViewCellDidClickBlock myCellDidClickBlock;
/* noData */
@property (nonatomic, strong) NoDataView *noDataView;

@end

@implementation LLSearchResultListView
static NSString *const flag = @"LLSearchResultListViewCell";



//不要xxx.frame = GRectmake()这样设置frame
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //初始化控件
        [self addSubview:self.myTableView];
        
        self.noDataView = [[NoDataView alloc] init];
        self.noDataView.hidden = YES;
        [self addSubview:self.noDataView];
    }
    return self;
}


//---------------------------------------------------------------------------------------------------
#pragma mark ================================== UITableViewDataSource/UITableViewDataSource ==================================
//---------------------------------------------------------------------------------------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CoinListCell *cell = [CoinListCell coinListCell:tableView];
    id model = self.resultArray[indexPath.row];
    if ([model isKindOfClass:[SearchModel class]]) {
        cell.search = model;
    }else{
        cell.model = model;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AdaptY(47);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //回调
    LLBLOCK_EXEC(_myCellDidClickBlock,tableView,indexPath.row);
}



- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _myTableView.backgroundColor = MainBlackColor;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [UIView new];
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:flag];

    }
    return _myTableView;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _myTableView.frame = self.bounds;
}


//---------------------------------------------------------------------------------------------------
#pragma mark ================================== 对外接口 ==================================
//---------------------------------------------------------------------------------------------------
-(void)setResultArray:(NSArray<NSString *> *)resultArray
{
    _resultArray = resultArray;
    if (resultArray.count == 0) {
        [self.noDataView showNoDataView:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-NavbarH) type:NoSearchType tagStr:self.searchText needReload:YES reloadBlock:nil];
        [self.myTableView addSubview:self.noDataView];
    }else{
        self.noDataView.hidden = YES;
    }
    [self.myTableView reloadData];
}

- (void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    
}

- (void)resultListViewDidSelectedIndex:(resultListViewCellDidClickBlock)cellDidClickBlock
{
    _myCellDidClickBlock = cellDidClickBlock;
}


@end
