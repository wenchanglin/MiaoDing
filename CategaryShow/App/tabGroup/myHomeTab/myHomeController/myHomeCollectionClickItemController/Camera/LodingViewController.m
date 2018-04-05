//
//  LodingViewController.m
//  PhotoAppStore
//
//  Created by 黄梦炜 on 2017/4/11.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "LodingViewController.h"
#import "takePhotoCollectionViewCell.h"
#import "photoModel.h"
#import "putInUserInfoViewController.h"
#import "NewPototUserInfoViewController.h"
#import "NewDiyPersonalityVC.h"
@interface LodingViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation LodingViewController

{
    UICollectionView *photoCollection;
    NSMutableArray *photoArray;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    photoArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor clearColor]];
    NSArray *array = [NSArray arrayWithObjects:@"step1",@"step2", @"step3", @"step4", nil];
    for (int i = 0 ; i < [array count]; i ++) {
        UIImage *iamge = [UIImage imageNamed:array[i]];
        photoModel *model = [photoModel new];
        model.photo = iamge;
        [photoArray addObject:model];
        
        
    }
    
    [self createPhotoShow];
    
}

-(void)createPhotoShow
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    photoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  ) collectionViewLayout:flowLayout];
    
    //设置代理
    photoCollection.delegate = self;
    photoCollection.dataSource = self;
    [photoCollection setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:photoCollection];
    
//    [photoCollection setAlpha:0];
    photoCollection.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    photoCollection.pagingEnabled = YES ;
    [photoCollection registerClass:[takePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [photoCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)backHome
{
    NewPototUserInfoViewController *putInfo = [[NewPototUserInfoViewController alloc] init];
    NewDiyPersonalityVC * newdiy = [[NewDiyPersonalityVC alloc]init];
    
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[putInfo class]]||[controller isKindOfClass:[newdiy class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
            break;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:NO]; //跳转
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [photoArray count];
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *reCell;
    static NSString *identify = @"cell";
    takePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.model =photoArray[indexPath.item];
    [cell sizeToFit];
    reCell = cell;
    return reCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//    [photoCollection setAlpha:0];
//    [UIView commitAnimations];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
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
