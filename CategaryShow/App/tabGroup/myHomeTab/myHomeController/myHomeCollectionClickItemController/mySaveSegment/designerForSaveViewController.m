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
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)reloadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(MyCollectTypeZiXun) forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_MyCollect_String] parameters:params finished:^(id responseObject, NSError *error) {
        [mainTabTable.mj_footer endRefreshing];
        if ([self checkHttpResponseResultStatus:responseObject]) {
//            if ([responseObject[@"data"][@"collections"]count]>0&&page>1) {
                NSMutableArray*arr = [MySaveForZiXunModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"collections"]];
                [modelArray addObjectsFromArray:arr];
                [mainTabTable reloadData];
//            }
//            else
//            {
//                [mainTabTable removeFromSuperview];
//                [self createNoSave];
//            }
        }
    }];
}

-(void)createGetData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(MyCollectTypeZiXun) forKey:@"type"];
    [params setObject:@"1" forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_MyCollect_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"data"][@"collections"]count]>0) {
            modelArray = [MySaveForZiXunModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"collections"]];
            [self createView];
            }
            else
            {
                [mainTabTable removeFromSuperview];
                [self createNoSave];
            }
        }
    }];

}

-(void)createView
{
    mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,NavHeight, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT  - 88 - 60:SCREEN_HEIGHT  - 64 - 40) style:UITableViewStyleGrouped];
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
    [WCLMethodTools footerAutoGifRefreshWithTableView:mainTabTable completion:^{
        page+=1;
        [self reloadData];
    }];

}
-(void)createNoSave
{
    UIView *bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgNoDingView.backgroundColor=[UIColor whiteColor];
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
    reCell = cell;
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
