//
//  DesignerForCollectionViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/22.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "DesignerForCollectionViewController.h"
#import "designerModel.h"
#import "DesignersClothesViewController.h"
#import "DesignerForCollectionViewCell.h"
#import "DesignerDetailIntroduce.h"
#import "DesignerClothesDetailViewController.h"
@interface DesignerForCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation DesignerForCollectionViewController
{
    UICollectionView *clothesColllection;
    NSMutableArray *modelArray;
    UILabel *titleView;
    NSMutableArray *collectionItem;
    BaseDomain *getData;
}

-(void)viewWillAppear:(BOOL)animated
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.rdv_tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self settabTitle:@"腔调"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    getData = [BaseDomain getInstance:NO];
    
    modelArray = [NSMutableArray array];
    collectionItem = [NSMutableArray array];
    
//    for (int i = 0; i < 3; i ++) {
//        designerModel *model = [[designerModel alloc] init];
//        model.clothesImage = @"designerForClothes";
//        [modelArray addObject:model];
//    }
//    
    [self getDatas];
    [self createHaveSave];
    
   
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_DesingerList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:getData]) {
            
            NSLog(@"%@", getData.dataRoot);
            collectionItem = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            for (NSDictionary *dic in [[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
                designerModel *model = [designerModel mj_objectWithKeyValues:dic];
                [modelArray addObject:model];
            }
            
            [clothesColllection reloadData];
            if ([modelArray count] > 1) {
                [clothesColllection setContentOffset:CGPointMake(([modelArray count] - 2) *SCREEN_WIDTH, 0)];
            }
            
        }
        
    }];
}


-(void)createHaveSave
{
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout1.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    clothesColllection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-49-64) collectionViewLayout:flowLayout1];
    
    clothesColllection.showsHorizontalScrollIndicator = NO;
    //设置代理
    clothesColllection.delegate = self;
    clothesColllection.dataSource = self;
    [clothesColllection setPagingEnabled:YES];
    [self.view addSubview:clothesColllection];
    clothesColllection.backgroundColor = getUIColor(Color_myOrderBack);
    //注册cell和ReusableView（相当于头部）
    
    [clothesColllection registerClass:[DesignerForCollectionViewCell class] forCellWithReuseIdentifier:@"mysaveClothes"];
    [clothesColllection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [modelArray count];
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"mysaveClothes";
    DesignerForCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell.designer setTag: indexPath.item + 1000];
    [cell.designer addTarget:self action:@selector(designerClick:) forControlEvents:UIControlEventTouchUpInside];
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
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64);
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
    if (indexPath.item != [modelArray count] - 1) {
        NSMutableDictionary *dic = collectionItem[indexPath.item];
        DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
        designerClothes.goodDic = dic;
        designerClothes.model = modelArray[indexPath.item];
        [self.navigationController pushViewController:designerClothes animated:YES];
    }
}

-(void)designerClick:(UIButton *)sender
{
    if (sender.tag - 1000 != [modelArray count] - 1) {
        designerModel *model = modelArray[sender.tag - 1000];
        DesignerDetailIntroduce *introduce = [[DesignerDetailIntroduce alloc] init];
        introduce.desginerId = [NSString stringWithFormat:@"%zd",model.des_uid];
        introduce.designerImage = model.avatar;
        introduce.designerName = model.uname;
        introduce.remark = model.recommend_goods_ids;
        [self.navigationController pushViewController:introduce animated:YES];
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
