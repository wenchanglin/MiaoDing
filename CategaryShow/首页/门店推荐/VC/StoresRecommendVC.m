//
//  StoresRecommendVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/2/28.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StoresRecommendVC.h"
#import "StoreListModel.h"
#import "StoreListCell.h"
#import "StoreRecommendDetailVC.h"
#import "StoresSearchVC.h"
@interface StoresRecommendVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>//UISearchResultsUpdating
@property(nonatomic,strong)NSMutableArray * storeArray;
@property(nonatomic,strong)UITableView * storeTableView;
@property (strong,nonatomic) NSMutableArray  *searchList;//保存搜索结果
//@property (nonatomic, strong) UISearchController *searchController;
@property (assign,nonatomic) BOOL active;

@property(nonatomic,weak)UISearchBar *searchbar;

@end

@implementation StoresRecommendVC
{
    NSInteger page;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNewData) name:@"mandiancollect" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (self.searchController.active) {
//        self.searchController.active = NO;
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [self.searchController.searchBar removeFromSuperview];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    
    _storeArray = [NSMutableArray array];
    page =1;
    [self settabTitle:@"定制店"];
    [self createUI];
    [self getData];
    
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
    __weak __typeof(self)weakSelf = self;
    [WCLMethodTools headerRefreshWithTableView:_storeTableView completion:^{
        [weakSelf loadNewData];
    }];
    [WCLMethodTools footerAutoGifRefreshWithTableView:_storeTableView completion:^{
        page += 1;
        [weakSelf getData];
    }];
    UISearchBar *searchbar=[[UISearchBar alloc]init];
    self.searchbar=searchbar;
    searchbar.delegate=self;
    searchbar.tintColor=[UIColor colorWithHexString:@"#A6A6A6"];// 设置搜索框内按钮文字颜色，以及搜索光标颜色。
    searchbar.placeholder=@"请输入定制店名称、关键字";
    searchbar.frame=CGRectMake(0, 10, self.view.frame.size.width, 44);
    [searchbar setImage:[UIImage imageNamed:@"icon_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchbar setBackgroundImage:[self imageWithColor:[UIColor colorWithHexString:@"#EDEDED"]]];
    [self.view addSubview:searchbar];
    [searchbar setReturnKeyType:UIReturnKeyDone];
    UIButton * button = [[UIButton alloc]initWithFrame:searchbar.frame];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
   
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)btnClick:(UIButton *)button
{
    //WCLLog(@"%@",button);
    StoresSearchVC * svc = [[StoresSearchVC alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)loadNewData
{
    NSMutableDictionary * parameter =[NSMutableDictionary dictionary];
    [parameter setObject:@(1) forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:URL_MenDian parameters:parameter finished:^(id responseObject, NSError *error) {
        [self.storeTableView.mj_header endRefreshing];
        [self.storeTableView.mj_footer resetNoMoreData];
        _storeArray = [StoreListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [_storeTableView reloadData];
    }];
}

-(void)getData
{
    NSMutableDictionary * parameter =[NSMutableDictionary dictionary];
    [parameter setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:URL_MenDian parameters:parameter finished:^(id responseObject, NSError *error) {
        if ([responseObject[@"data"] count]==0&&page>1) {
            [self.storeTableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
//        WCLLog(@"%@",responseObject[@"data"]);
        [self.storeTableView.mj_footer endRefreshing];
        NSMutableArray * array1 = [StoreListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [_storeArray addObjectsFromArray:array1];
        [_storeTableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [self.storeArray count];
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"mendiancell" ;
    StoreListModel * models = self.storeArray[indexPath.row];
    StoreListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StoreListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.model = models;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoreListModel * models1 = _storeArray[indexPath.row];
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
