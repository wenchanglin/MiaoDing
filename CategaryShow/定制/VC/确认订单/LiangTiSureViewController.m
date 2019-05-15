//
//  LiangTiSureViewController.m
//  CategaryShow
//
//  Created by 文长林 on 2018/4/24.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "LiangTiSureViewController.h"
#import "LiangTiModel.h"
#import "ManageLiangTiCell.h"
#import "AddLiangTiVC.h"
#import "DateForBodyViewController.h"
@interface LiangTiSureViewController ()<UITableViewDelegate,UITableViewDataSource,LiangTiAddDelegate>

@end

@implementation LiangTiSureViewController
{
    UIImageView *noAddressImage;
    UILabel *noAddressWoring;
    UIButton *buttonAdd;
    BaseDomain *getData;
    UITableView *liangTiTable;
    NSMutableArray *modelArray;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"管理量体数据"];
    page =1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"quickuploadsucess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"reloadAddress" object:nil];
    
    getData =[BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self reloadData];
}

-(void)reloadAddData
{
    NSMutableDictionary * parames = [NSMutableDictionary dictionary];
    [parames setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:GET urlString:URL_GuanLiLT parameters:parames finished:^(id responseObject, NSError *error) {
        WCLLog(@"%@",responseObject);
        if ([responseObject[@"data"]count]>0) {
            NSArray * array1 = [LiangTiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [modelArray addObjectsFromArray:array1];
            [liangTiTable.mj_footer endRefreshing];
        }
        else
        {
            [liangTiTable.mj_footer endRefreshingWithNoMoreData];
        }
        if (liangTiTable) {
            [liangTiTable reloadData];
        } else {
            [self createTable];
        }
    }];
}
-(void)reloadData
{
    NSMutableDictionary * parames = [NSMutableDictionary dictionary];
    parames[@"page"]=@"1";
    [[wclNetTool sharedTools]request:GET urlString:URL_GuanLiLT parameters:parames finished:^(id responseObject, NSError *error) {
//        WCLLog(@"%@",responseObject);
        [liangTiTable.mj_footer resetNoMoreData];
        [liangTiTable.mj_header endRefreshing];
        modelArray = [LiangTiModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (liangTiTable) {
            [liangTiTable reloadData];
        } else {
            [self createTable];
        }
    }];
   
}
-(void)createTable
{
    if (@available(iOS 11.0, *)) {
        liangTiTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    liangTiTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-92:SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    liangTiTable.dataSource = self;
    liangTiTable.delegate = self;
    [liangTiTable registerClass:[ManageLiangTiCell class] forCellReuseIdentifier:@"ManageLiangTi"];
    [self.view addSubview:liangTiTable];
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 60; i++) {
        @autoreleasepool {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [headerImages addObject:image];
        };
        
    }
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadData];
        });
        
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [header setImages:headerImages duration:1 forState:MJRefreshStateRefreshing];
    liangTiTable.mj_header = header;
    
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            page++;
            [self reloadAddData];
        });
    }];
    footer.stateLabel.hidden =YES;
    footer.refreshingTitleHidden = YES;
    [footer setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [footer setImages:headerImages duration:1 forState:MJRefreshStateRefreshing];
    liangTiTable.mj_footer = footer;
    buttonAdd = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-92:SCREEN_HEIGHT -64- 49, SCREEN_WIDTH, 49)];
    [self.view addSubview:buttonAdd];
    [buttonAdd setBackgroundColor:getUIColor(Color_DZClolor)];
    [buttonAdd setTitle:@"新增量体数据" forState:UIControlStateNormal];
    [buttonAdd.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [buttonAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonAdd addTarget:self action:@selector(addAddLiangTiClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)addAddLiangTiClick
{
    AddLiangTiVC * avc = [[AddLiangTiVC alloc]init];
    avc.chenpingbool=modelArray.count>0?NO:YES;
    [self.navigationController pushViewController:avc animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [modelArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  110;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiangTiModel *model = modelArray[indexPath.section];
    ManageLiangTiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManageLiangTi" forIndexPath:indexPath];
    cell.tag = indexPath.section + 10;
    cell.delegate = self;
    cell.models = model;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)clickChooseLiangTi:(NSInteger)item
{
    LiangTiModel * model = modelArray[item];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(model.ID) forKey:@"lt_id"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_setMorenLiangTi_String] parameters:params finished:^(id responseObject, NSError *error) {
//        WCLLog(@"%@--%@",responseObject,error);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [self reloadData];
        }
    }];
}
-(void)clickUpdateLiangTi:(NSInteger)item
{
    //    UpdateAddressViewController *updataAdd = [[UpdateAddressViewController alloc] init];
    //    updataAdd.addressDic = detailArray[item];
    //
    //    [self.navigationController pushViewController:updataAdd animated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiangTiModel * model = modelArray[indexPath.section];
    if (_comefromwode) {
        DateForBodyViewController * dbvc =[[DateForBodyViewController alloc]init];
        dbvc.lt_id = model.ID;
        [self.navigationController pushViewController:dbvc animated:YES];
    }
    else
    {
        NSMutableDictionary * modeldic = [NSMutableDictionary dictionary];
        [modeldic setObject:model forKey:@"model"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectlt" object:nil userInfo:modeldic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
