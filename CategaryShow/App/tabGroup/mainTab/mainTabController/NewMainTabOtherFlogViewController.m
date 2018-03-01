   //
//  NewMainTabOtherFlogViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/27.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "NewMainTabOtherFlogViewController.h"
#import "NewMainTabListTableViewCell.h"
#import "MainTabModel.h"
#import "MainTabDetailViewController.h"

#import <MJRefresh.h>
@interface NewMainTabOtherFlogViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation NewMainTabOtherFlogViewController
{
    BaseDomain *getData;
    UITableView *mainTabTable;
    
    NSDate *datBegin;
    NSMutableArray *modelArray;
    
    NSInteger page;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    page = 1;
    getData = [BaseDomain getInstance:NO];
    [self getDatas];
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *parms  = [NSMutableDictionary dictionary];
    [parms setObject:_MainId forKey:@"tags_id"];
    [parms setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getData getData:URL_OtherMain PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            for (NSDictionary *dic in [[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
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
    }];
}

-(void)createView
{
    mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,3, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64 - 43) style:UITableViewStyleGrouped];
    mainTabTable.delegate = self;
    mainTabTable.dataSource = self;
    [mainTabTable registerClass:[NewMainTabListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NewMainTabListTableViewCell class])];
    [self.view addSubview:mainTabTable];
    
    mainTabTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self reloadData];
        // 这个地方是网络请求的处理
    }];
    
    
    mainTabTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
            [mainTabTable.mj_footer endRefreshing];
        });
        
            // 结束刷新
        
        
    }];
    
    [mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mainTabTable setBackgroundColor:[UIColor whiteColor]];
    //    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    
    
    // 设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    return scaledImage; 
    
}


-(void)reloadAddData
{
     page ++;
    NSMutableDictionary *parms  = [NSMutableDictionary dictionary];
    [parms setObject:_MainId forKey:@"tags_id"];
    [parms setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getData getData:URL_OtherMain PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            
            if ([[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"] count] > 0) {
                for (NSDictionary *dic in [[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
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
                
               
                [mainTabTable.mj_footer endRefreshing];
                [mainTabTable reloadData];
            } else {
                [mainTabTable.mj_footer endRefreshingWithNoMoreData];
            
            }
            
        }
        
        
    }];
}


-(void)reloadData
{
    NSMutableDictionary *parms  = [NSMutableDictionary dictionary];
    [parms setObject:_MainId forKey:@"tags_id"];
    [parms setObject:@"1" forKey:@"page"];
    [getData getData:URL_OtherMain PostParams:parms finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            
            [modelArray removeAllObjects];
            for (NSDictionary *dic in [[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
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
            page = 1;
            [mainTabTable.mj_footer resetNoMoreData];
            [mainTabTable.mj_header endRefreshing];
            [mainTabTable reloadData];
        }
        
        
    }];
    
}


#pragma - mark table delegate and datasource
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
    [self getDateBegin:datBegin currentView:model.tagName fatherView:@"首页"];
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
