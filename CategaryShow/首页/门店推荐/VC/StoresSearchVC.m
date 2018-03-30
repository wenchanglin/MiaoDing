//
//  StoresSearchVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/14.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StoresSearchVC.h"
#import "StoreListModel.h"
#import "StoreListCell.h"
#import "StoreRecommendDetailVC.h"
@interface StoresSearchVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)NSMutableArray * storeArray;
@property(nonatomic,strong)UITableView * storeTableView;
@property (strong,nonatomic) NSMutableArray  *searchList;//保存搜索结果
@property (assign,nonatomic) BOOL active;

@property(nonatomic,weak)UISearchBar *searchbar;
@end

@implementation StoresSearchVC
{
    NSInteger page;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchDataWithKeyWord:) name:@"mandiancollect" object:nil];
    _searchList = [NSMutableArray array];
    page =1;
    [self settabTitle:@"门店搜索"];
    [self createUI];
}
-(void)searchDataWithKeyWord:(NSString *)keyword
{
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@(page) forKey:@"page"];
    [parameter setObject:keyword forKey:@"like"];
    [[wclNetTool sharedTools]request:GET urlString:URL_MenDianSelect parameters:parameter finished:^(id responseObject, NSError *error) {
        if ([responseObject[@"data"] count]==0&&page>1) {
            [_storeTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        else if([responseObject[@"data"]count]==0&&page==1)
        {
            [self alertViewShowOfTime:@"未搜索到该关键字的门店，请重新输入" time:2];
        }
        _searchList = [StoreListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [_storeTableView reloadData];

    }];
}
-(void)createUI
{
    if (@available(iOS 11.0, *)) {
        self.storeTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _storeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54+NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-54) style:UITableViewStylePlain];
    _storeTableView.dataSource = self;
    _storeTableView.delegate = self;
    _storeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_storeTableView];
    UISearchBar *searchbar=[[UISearchBar alloc]init];
    self.searchbar=searchbar;
    searchbar.delegate=self;
    searchbar.tintColor=[UIColor colorWithHexString:@"#A6A6A6"];// 设置搜索框内按钮文字颜色，以及搜索光标颜色。
    
    searchbar.placeholder=@"请输入定制店名称、关键字";
    searchbar.frame=CGRectMake(0, 10, self.view.frame.size.width, 44);
    [searchbar setImage:[UIImage imageNamed:@"icon_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchbar setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"#EDEDED"]]];
    [self.view addSubview:searchbar];
    // self.storeTableView.tableHeaderView=searchbar;
    [searchbar setReturnKeyType:UIReturnKeyDone];
    [self updown];
}
- (void)updown {
    __weak StoresSearchVC *weakSelf = self;
    _storeTableView.mj_footer = [MJRefreshBackNormalFooter  footerWithRefreshingBlock:^{
        page += 1;
        [weakSelf searchDataWithKeyWord:self.searchbar.text];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchList count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"mendiansearchcell" ;
    StoreListModel *models=self.searchList[indexPath.row];
    
    StoreListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StoreListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model = models;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//点击了取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchbar resignFirstResponder];
    [self.searchbar setShowsCancelButton:NO animated:YES];
    self.searchbar.text=@"";
    page =1;
    self.active=NO;
}
//点击了搜索按钮
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchbar resignFirstResponder];
    [self.searchbar setShowsCancelButton:NO animated:YES];
    self.active=NO;
    page = 1;
    [self searchDataWithKeyWord:searchBar.text];
    
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.active=YES;
    [self searchBar:searchBar textDidChange:@""];
    [self.searchbar setShowsCancelButton:YES animated:YES];
    for (id obj in [searchBar subviews]) {
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2 in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                }
            }
        }
    }
    return YES;
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
//    NSString *searchString = searchText;
//    page = 1;
    //[self searchDataWithKeyWord:searchString];
//    //刷新表格
//
//    [self.storeTableView reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoreListModel * models1 = _searchList[indexPath.row];
    StoreRecommendDetailVC * vc = [[StoreRecommendDetailVC alloc]init];
    vc.model = models1;
    [self.navigationController pushViewController:vc animated:YES];
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
