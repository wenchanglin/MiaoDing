//
//  designerForSaveViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "designerForSaveViewController.h"
#import "NewMainModel.h"
#import "NewMainTabListTableViewCell.h"
#import "MainTabDetailViewController.h"
@interface designerForSaveViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation designerForSaveViewController
{
    NSMutableArray *modelArray;
    BaseDomain *getData;
    UITableView *mainTabTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    
    
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
    [modelArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [getData getData:URL_SaveList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            
            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0) {
                [mainTabTable removeFromSuperview];
                [self createNoSave];
            } else {
                for (NSDictionary *dic in [getData.dataRoot objectForKey:@"data"]) {
                    NewMainModel *model  = [NewMainModel new];
                    model.ImageUrl = [dic stringForKey:@"img"];
                    model.linkUrl = [dic stringForKey:@"link"];
                    model.LinkId = [dic stringForKey:@"id"];
                    model.fenLei = [dic stringForKey:@"name"];
                    model.name = [dic stringForKey:@"title"];
                    model.detail = [dic stringForKey:@"sub_title"];
                    model.tagName = [dic stringForKey:@"tags_name"];
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
    [getData getData:URL_SaveList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            
            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0) {
                [self createNoSave];
            } else {
                
                    for (NSDictionary *dic in [getData.dataRoot objectForKey:@"data"]) {
                        NewMainModel *model  = [NewMainModel new];
                        model.ImageUrl = [dic stringForKey:@"img"];
                        model.linkUrl = [dic stringForKey:@"link"];
                        model.LinkId = [dic stringForKey:@"id"];
                        //                model.titleContent = [dic stringForKey:@"title"];
                        model.fenLei = [dic stringForKey:@"name"];
                        model.name = [dic stringForKey:@"title"];
                        model.detail = [dic stringForKey:@"sub_title"];
                        model.tagName = [dic stringForKey:@"tags_name"];
                        [modelArray addObject:model];
                    }
                
                
                [self createView];
            }
            
        }
        
    }];
}

-(void)createView
{
    mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,3, SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - 43) style:UITableViewStyleGrouped];
    mainTabTable.delegate = self;
    mainTabTable.dataSource = self;
    [mainTabTable registerClass:[NewMainTabListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NewMainTabListTableViewCell class])];
    [self.view addSubview:mainTabTable];
    
//    NSMutableArray *headerImages = [NSMutableArray array];
//    
//    for (int i = 1; i < 60; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"load%d",i]];
//        [headerImages addObject:[self scaleToSize:image size:CGSizeMake(60, 60)]];
//    }
//    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self reloadData];
//        });
//        
//        //下拉刷新要做的操作.
//        
//    }];
//    
//    gifHeader.stateLabel.hidden = YES;
//    
//    gifHeader.lastUpdatedTimeLabel.hidden = YES;
//    
//    
//    
//    [gifHeader setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
//    
//    [gifHeader setImages:headerImages forState:MJRefreshStateRefreshing];
//    
//    mainTabTable.mj_header = gifHeader;
//    // mainTabTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//    
//    
//    // 这个地方是网络请求的处理
//    // }];
//    
//    
//    mainTabTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self reloadAddData];
//            [mainTabTable.mj_footer endRefreshing];
//        });
//        
//        // 结束刷新
//        
//        
//    }];
    
    [mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mainTabTable setBackgroundColor:[UIColor whiteColor]];
    //    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    
    return 270;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    
    
    NewMainModel *model = [modelArray objectAtIndex:indexPath.section];
    
    
    Class currentClass = [NewMainTabListTableViewCell class];
    NewMainTabListTableViewCell *cell = nil;
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    cell.model = model;
    cell.tag = indexPath.section * 10000 + indexPath.row;
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    reCell = cell;
    
    
    
    
    //    [reCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ///////////////////////////////////////////////////////////////////////
    return reCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMainModel *model = [modelArray objectAtIndex:indexPath.section];
    MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
    MainDetail.webId = model.LinkId;
    MainDetail.imageUrl = model.ImageUrl;
    MainDetail.titleContent = model.name;
    MainDetail.tagName = model.tagName;
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
