//
//  designerListViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/5.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "designerListViewController.h"
#import "designerModel.h"
#import "designerCollectionViewCell.h"
#import "designerHomeViewController.h"
@interface designerListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@end

@implementation designerListViewController
{
    BaseDomain *getData;
    NSMutableArray *designerArray;
    NSMutableArray *modelArray;
    UICollectionView *designerCollect;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    designerArray = [NSMutableArray array];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    getData = [BaseDomain getInstance:NO];
    [self getDatas];
    [self createTable];
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_GetDesigner PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            designerArray = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            for (NSDictionary *dic  in designerArray) {
                designerModel *model = [designerModel new];
                model.designerHead = [dic stringForKey:@"avatar"];
                model.designerName = [dic stringForKey:@"name"];
                model.designerSimpleIntd = [dic stringForKey:@"tag"];
                model.desginer_Id = [dic stringForKey:@"id"];
                [modelArray addObject:model];
            }
            [designerCollect reloadData];
        }
    }];
}

-(void)createTable
{
    UITableView *table  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    
    table.tableHeaderView = [self createHeadView];
}



-(UIView *)createHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout1.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    designerCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 24, SCREEN_HEIGHT) collectionViewLayout:flowLayout1];
    
    designerCollect.showsHorizontalScrollIndicator = NO;
    //设置代理
    designerCollect.delegate = self;
    designerCollect.dataSource = self;
    [headView addSubview:designerCollect];
    [designerCollect setBackgroundColor:[UIColor whiteColor]];
    //注册cell和ReusableView（相当于头部）
    
    [designerCollect registerClass:[designerCollectionViewCell class] forCellWithReuseIdentifier:@"designer"];
    [designerCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    return headView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"list";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [designerArray count];
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"designer";
    designerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.model = modelArray[indexPath.item];
    [cell sizeToFit];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    
    return CGSizeMake((SCREEN_WIDTH - 33) / 2, 234);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == designerArray.count - 1) {
        [self alertViewShowOfTime:@"虚位以待" time:1];
    } else {
        designerHomeViewController *designer = [[designerHomeViewController alloc] init];
        designer.desginerId = [designerArray[indexPath.item] stringForKey:@"id"];
        designer.designerImage = [designerArray[indexPath.item] stringForKey:@"avatar"];
        designer.designerName = [designerArray[indexPath.item] stringForKey:@"name"];
        designer.remark = [designerArray[indexPath.item] stringForKey:@"tag"];
        designer.designerStory = [designerArray[indexPath.item] stringForKey:@"story"];
        
        designer.designerDic = designerArray[indexPath.item];
        [self.navigationController pushViewController:designer animated:YES];
    }
    
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
