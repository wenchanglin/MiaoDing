//
//  DesignerAndClothesViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/13.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "DesignerAndClothesViewController.h"
#import "designerinfoNewTableViewCell.h"
#import "DesignerClothesDetailViewController.h"
@interface DesignerAndClothesViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DesignerAndClothesViewController
{
    BaseDomain *getData;
    NSMutableArray *modelArray;
    UITableView *detailTable;
    NSMutableArray * designerArray;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    page = 1;
    getData = [BaseDomain getInstance:NO];
    [self getDatas];
    [self createTable];
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_designerChengP PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
           designerArray = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            for (NSDictionary *dic in designerArray) {
                designerModel *model = [designerModel new];
                model.clothesImage = [dic stringForKey:@"img"];
                model.titlename = [dic stringForKey:@"name"];
                model.p_time = [dic stringForKey:@"c_time_format"];
                model.good_Id = [dic stringForKey:@"recommend_goods_ids"];
                [modelArray addObject:model];
            }
           
            
            [detailTable reloadData];
        }
        
    }];
}

-(void)createTable
{
    detailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64) style:UITableViewStylePlain];
    detailTable.dataSource = self;
    detailTable.delegate = self;
    [detailTable setShowsVerticalScrollIndicator:NO];
    [detailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [detailTable registerClass:[designerinfoNewTableViewCell class] forCellReuseIdentifier:@"designerList"];
    [self.view addSubview:detailTable];
    
    detailTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self reloadData];
        // 这个地方是网络请求的处理
    }];
    
    
    detailTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
            [detailTable.mj_footer endRefreshing];
        });
        
        // 结束刷新
        
        
    }];
    
}

-(void)reloadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_designerChengP PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            [modelArray removeAllObjects];
            designerArray = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            for (NSDictionary *dic in designerArray) {
                designerModel *model = [designerModel new];
                model.clothesImage = [dic stringForKey:@"img"];
                model.titlename = [dic stringForKey:@"name"];
                model.p_time = [dic stringForKey:@"c_time_format"];
                model.good_Id = [dic stringForKey:@"recommend_goods_ids"];
                [modelArray addObject:model];
            }
            [detailTable.mj_header endRefreshing];
            
            [detailTable reloadData];
        }
        
    }];
}

-(void)reloadAddData
{
    page ++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getData getData:URL_designerChengP PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
                [designerArray addObject:dic] ;
                designerModel *model = [designerModel new];
                model.clothesImage = [dic stringForKey:@"img"];
                model.titlename = [dic stringForKey:@"name"];
                model.p_time = [dic stringForKey:@"c_time_format"];
                model.good_Id = [dic stringForKey:@"recommend_goods_ids"];
                [modelArray addObject:model];
            }

            [detailTable reloadData];
        }
        
    }];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 526.0 / 667.0 * SCREEN_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    designerinfoNewTableViewCell *reCell = [tableView dequeueReusableCellWithIdentifier:@"designerList" forIndexPath:indexPath];
    reCell.model = modelArray[indexPath.row];
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
    designerClothes.goodDic = designerArray[indexPath.row];
//    designerClothes.model = model;
    designerClothes.good_id = [designerArray[indexPath.row] stringForKey:@"recommend_goods_ids"];
    [self.navigationController pushViewController:designerClothes animated:YES];
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
