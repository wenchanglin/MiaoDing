//
//  designerForSaveViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "designerForSaveViewController.h"
#import "MySaveForZiXunModel.h"
#import "MySaveForZiXunCell.h"
#import "MainTabDetailViewController.h"
@interface designerForSaveViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation designerForSaveViewController
{
    NSMutableArray *modelArray;
    BaseDomain *getData;
    NSInteger page;
    UITableView *mainTabTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    page =1;
    [self createGetData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (mainTabTable) {
        [self reloadData];
    }
}

-(void)reloadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [getData getData:URL_SaveList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            [mainTabTable.mj_footer endRefreshing];
            [mainTabTable.mj_header endRefreshing];
            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0&&page==1) {
                [mainTabTable removeFromSuperview];
                [self createNoSave];
            }
            else if ([[getData.dataRoot arrayForKey:@"data"] count] == 0&&page!=1)
            {
                [mainTabTable.mj_footer endRefreshingWithNoMoreData];
                [mainTabTable reloadData];
            }
            else {
                for (NSDictionary *dic in [getData.dataRoot objectForKey:@"data"]) {
                    MySaveForZiXunModel *model  = [MySaveForZiXunModel mj_objectWithKeyValues:dic];
                    [modelArray addObject:model];
                }
                
                [mainTabTable reloadData];
                
            }
            
        }
        
    }];
    
}

-(void)createGetData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_SaveList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            [mainTabTable.mj_header endRefreshing];
            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0) {
                [self createNoSave];
            } else {
                [modelArray removeAllObjects];
                for (NSDictionary *dic in [getData.dataRoot objectForKey:@"data"]) {
                    MySaveForZiXunModel *model  = [MySaveForZiXunModel mj_objectWithKeyValues:dic];
                    [modelArray addObject:model];
                }
                
                
                [self createView];
            }
            
        }
        
    }];
}

-(void)createView
{
    mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,NavHeight+3, SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - 43) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        mainTabTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [mainTabTable setBackgroundColor:[UIColor whiteColor]];
    mainTabTable.estimatedSectionHeaderHeight = 0;
    mainTabTable.delegate = self;
    mainTabTable.dataSource = self;
    [self.view addSubview:mainTabTable];
    [mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [headerImages addObject:image];
    }
    __weak designerForSaveViewController *weakSelf = self;

    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf createGetData];
        });
        
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [header setImages:headerImages duration:1 forState:MJRefreshStateRefreshing];
    mainTabTable.mj_header = header;

    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            page += 1;
            [weakSelf reloadData];
            
        });
    }];
    footer.stateLabel.hidden =YES;
    footer.refreshingTitleHidden = YES;
    [footer setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [footer setImages:headerImages duration:1 forState:MJRefreshStateRefreshing];
    mainTabTable.mj_footer = footer;

}
-(void)createNoSave
{
    UIView *bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:bgNoDingView];
    
    UIImageView *NoDD = [UIImageView new];
    [bgNoDingView addSubview:NoDD];
    NoDD.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(bgNoDingView, (SCREEN_HEIGHT - 64 - 50 ) / 2 - 110  - 35)
    .widthIs(211)
    .heightIs(220);
    [NoDD setImage:[UIImage imageNamed:@"haveNoSave"]];
    
    UIButton *clickToLookOther = [UIButton new];
    [bgNoDingView addSubview:clickToLookOther];
    
    clickToLookOther.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(NoDD, 20)
    .widthIs(80)
    .heightIs(35);
    [clickToLookOther.layer setCornerRadius:3];
    [clickToLookOther.layer setMasksToBounds:YES];
    [clickToLookOther addTarget:self action:@selector(goToLookClothes) forControlEvents:UIControlEventTouchUpInside];
    [clickToLookOther.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [clickToLookOther setBackgroundColor:[UIColor blackColor]];
    [clickToLookOther setTitle:@"去逛逛" forState:UIControlStateNormal];
    
    
}
-(void)goToLookClothes
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LookZixun" object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [modelArray count];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MySaveForZiXunModel * model = modelArray[indexPath.section];
    CGFloat realHeight;
    if ([model.img_info isEqualToString:@""]||model.img_info ==nil) {
        realHeight =0.0001;
    }
    else
    {
        realHeight = (SCREEN_WIDTH-24) /[model.img_info floatValue];
    }
    return 79+realHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    
    
    MySaveForZiXunModel *model = [modelArray objectAtIndex:indexPath.section];
    MySaveForZiXunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sflkj"];
    if (!cell) {
        cell =[[MySaveForZiXunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sflkj"];
    }
    cell.zhuanFaBtn.hidden = YES;
    cell.shouCangBtn.hidden = YES;
    cell.xiHuanBtn.hidden =YES;
    cell.lastView.hidden =YES;
    cell.pingLunBtn.hidden = YES;
    cell.model = model;
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    reCell = cell;
    
    
    
    
    //    [reCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ///////////////////////////////////////////////////////////////////////
    return reCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySaveForZiXunModel *model = [modelArray objectAtIndex:indexPath.section];
    MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
    MainDetail.webId = [NSString stringWithFormat:@"%ld",model.ID];
    MainDetail.imageUrl = model.img;
    MainDetail.titleName = model.title;
    MainDetail.tagName = model.sub_title;
    //    [self getDateBegin:datBegin currentView:model.tagName fatherView:@"首页"];
    [self.navigationController pushViewController:MainDetail animated:YES];
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
