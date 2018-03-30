//
//  StoresSaveVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/14.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StoresSaveVC.h"
#import "StoreSaveModel.h"
#import "StoreSaveCell.h"
#import "StoresSaveDetailVC.h"
@interface StoresSaveVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation StoresSaveVC
{
    NSMutableArray *modelArray;
    BaseDomain *getData;
    UITableView *mainTabTable;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    page = 1;
    [self createGetData];

}
-(void)createGetData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"3" forKey:@"type"];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_SaveList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            [mainTabTable.mj_header endRefreshing];
            if ([[getData.dataRoot arrayForKey:@"data"] count] == 0) {
                [self createNoSave];
            } else {
                modelArray = [StoreSaveModel mj_objectArrayWithKeyValuesArray:[domain.dataRoot arrayForKey:@"data"]];
                [self createView];
            }
            
        }
        
    }];
}
-(void)reloadAddData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"3" forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [getData getData:URL_SaveList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            [mainTabTable.mj_footer endRefreshing];
            [mainTabTable.mj_header endRefreshing];
        }if ([[getData.dataRoot arrayForKey:@"data"] count] == 0&&page!=1)
        {
            [mainTabTable.mj_footer endRefreshingWithNoMoreData];
            [mainTabTable reloadData];
        }
        else {
            for (NSDictionary *dic in [getData.dataRoot objectForKey:@"data"]) {
                StoreSaveModel *model  = [StoreSaveModel mj_objectWithKeyValues:dic];
                [modelArray addObject:model];
            }
            
            [mainTabTable reloadData];
            
        }
    }];
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
-(void)createView
{
    mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,NavHeight+3, SCREEN_WIDTH, SCREEN_HEIGHT  - 64 - 43) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        mainTabTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [mainTabTable setBackgroundColor:[UIColor whiteColor]];
    mainTabTable.estimatedSectionHeaderHeight =0;
    mainTabTable.delegate = self;
    mainTabTable.dataSource = self;
    [self.view addSubview:mainTabTable];
    [mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [headerImages addObject:image];
    }
    __weak StoresSaveVC *weakSelf = self;

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
            [weakSelf reloadAddData];
            
        });
    }];
    footer.stateLabel.hidden =YES;
    footer.refreshingTitleHidden = YES;
    [footer setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [footer setImages:headerImages duration:1 forState:MJRefreshStateRefreshing];
    mainTabTable.mj_footer = footer;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreSaveModel * models = modelArray[indexPath.row];
    StoreSaveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mendiansave"];
    if (!cell) {
        cell = [[StoreSaveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mendiansave"];
    }
    cell.model =models;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoresSaveDetailVC * vc = [[StoresSaveDetailVC alloc]init];
    vc.model = modelArray[indexPath.row];
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
