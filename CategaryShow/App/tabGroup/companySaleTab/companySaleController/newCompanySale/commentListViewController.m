//
//  commentListViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/12.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "commentListViewController.h"
#import "commentHaveImageTableViewCell.h"
#import "commentModel.h"
#import "commentNoImageTableViewCell.h"
#import "JZAlbumViewController.h"
@interface commentListViewController ()<UITableViewDelegate, UITableViewDataSource,commentDelegate>

@end

@implementation commentListViewController
{
    BaseDomain *getData;
    NSMutableArray *modelArray;
    UITableView *commendTable;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (@available(iOS 11.0, *)) {
        commendTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    modelArray = [NSMutableArray array];
    [self settabTitle:@"评价"];
    getData = [BaseDomain getInstance:NO];
    [self getData];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)getData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_goodId forKey:@"goods_id"];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_CommendList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            NSLog(@"%@", getData.dataRoot);
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"list"] arrayForKey:@"data"]];
            for (NSMutableDictionary *dic in array) {
                commentModel *model = [commentModel new];
                model.commentDic = dic;
                [modelArray addObject:model];
            }
            [self createView];
            
        }
    }];
}
-(void)createView
{
    commendTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    commendTable.delegate = self;
    commendTable.dataSource = self;
    [commendTable registerClass:[commentHaveImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([commentHaveImageTableViewCell class])];
    [commendTable registerClass:[commentNoImageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([commentNoImageTableViewCell class])];
    [commendTable setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:commendTable];
    [commendTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [commendTable setBackgroundColor:[UIColor whiteColor]];

   
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [modelArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat x;
    commentModel *model = [modelArray objectAtIndex:indexPath.section];
    if ( [model.commentDic arrayForKey:@"img_list"].count > 0) {
        
        Class currentClass = [commentHaveImageTableViewCell class];
        
        x =  [commendTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    } else {
        
        Class currentClass = [commentNoImageTableViewCell class];
        x =  [commendTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    }
    return x;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    commentModel *model = [modelArray objectAtIndex:indexPath.section] ;
    if ([model.commentDic arrayForKey:@"img_list"].count > 0) {
        
        Class currentClass = [commentHaveImageTableViewCell class];
        commentHaveImageTableViewCell *cell = nil;
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        cell.model = model;
        cell.delegate = self;
        cell.tag = indexPath.section + 1000;
        
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        reCell = cell;
    } else {
        Class currentClass = [commentNoImageTableViewCell class];
        commentNoImageTableViewCell *cell = nil;
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        cell.model = model;
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        reCell = cell;
        
    }
//    [reCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ///////////////////////////////////////////////////////////////////////
    return reCell;
}


-(void)clickCollectionItem:(NSInteger)item tag:(NSInteger)tag
{
    
    commentModel *model = modelArray[tag - 1000];
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    
    jzAlbumVC.currentIndex = item;//这个参数表示当前图片的index，默认是0
    
    jzAlbumVC.imgArr = [NSMutableArray arrayWithArray:[model.commentDic arrayForKey:@"img_list"]];//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:YES completion:nil];
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
