//
//  QuickPhotoYinDaoVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/4/4.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "QuickPhotoYinDaoVC.h"
#import "QuickPhotoCell.h"
#import "putInUserInfoViewController.h"
#import "NewPototUserInfoViewController.h"
#import "QuickPhotoVC.h"
@interface QuickPhotoYinDaoVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation QuickPhotoYinDaoVC
{
    UICollectionView *photoCollection;
    NSMutableArray *photoArray;
    UIPageControl *page;

}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    photoArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    if (@available(iOS 11.0, *)) {
        photoCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(back) name:@"quickuploadsucess" object:nil];
    [self settabTitle:@"拍照量体引导图"];
    [self getPaiZhaoYinDaoTu];
    [self createPhotoShow];

}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getPaiZhaoYinDaoTu
{
    NSMutableDictionary * parames = [NSMutableDictionary dictionary];
    [parames setObject:@"7" forKey:@"id"];
    [[wclNetTool sharedTools]request:GET urlString:URL_GetYingDao parameters:parames finished:^(id responseObject, NSError *error) {
        [photoArray addObject:responseObject[@"data"][@"img_urls"]];
        [photoCollection reloadData];
    }];

}
-(void)createPhotoShow
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    photoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,NavHeight, SCREEN_WIDTH,IsiPhoneX?SCREEN_HEIGHT-88:SCREEN_HEIGHT-64) collectionViewLayout:flowLayout];
    
    //设置代理
    photoCollection.delegate = self;
    photoCollection.dataSource = self;
    [photoCollection setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:photoCollection];
    
    //    [photoCollection setAlpha:0];
    photoCollection.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    photoCollection.pagingEnabled = YES ;
    [photoCollection registerClass:[QuickPhotoCell class] forCellWithReuseIdentifier:@"quickcell"];
    [photoCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    page = [[UIPageControl alloc]initWithFrame:CGRectMake(10, IsiPhoneX?SCREEN_HEIGHT-88:SCREEN_HEIGHT-64, SCREEN_WIDTH-20, 40)];
    [self.view addSubview:page];
    [self.view bringSubviewToFront:page];
    
    
    page.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    page.pageIndicatorTintColor = [UIColor grayColor];// 设置非选中页的圆点颜色
    
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
//
//    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0,IsiPhoneX?HitoSafeAreaHeight:20, 45, 45)];
//    
//    [buttonBack.layer setCornerRadius:33 / 2];
//    [buttonBack.layer setMasksToBounds:YES];
//    [buttonBack setImage:[UIImage imageNamed:@"baiBack"] forState:UIControlStateNormal];
//    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:buttonBack];
//    
//    [self.view bringSubviewToFront:buttonBack];
}
-(void)backClick
{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:dateId forKey:@"id"];
//    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
//    [params setObject:[_goodDic stringForKey:@"name"] forKey:@"goods_name"];
//    [params setObject:@"0" forKey:@"click_dingzhi"];
//    [params setObject:@"0" forKey:@"click_pay"];
//    [self getDateDingZhi:params beginDate:datBegin ifDing:NO];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)backHome
{
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 设置页码
    page.currentPage = pageNum;
   
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (photoArray.count>0) {
        return [photoArray[0] count];
    }
    return 0;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    NSString *identify = @"quickcell";
    QuickPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell.imagePhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL,photoArray[0][indexPath.item]]]];
    if (_ishelp==YES) {
        [[cell viewWithTag:10234] removeFromSuperview];
    }
    else
    {
    if (indexPath.item==3) {
        UIButton *nextStep = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-140,IsiPhoneX?SCREEN_HEIGHT-84-64:SCREEN_HEIGHT-64-40, 120, 40)];
        nextStep.backgroundColor = [UIColor colorWithHexString:@"#90c551"];
        nextStep.layer.cornerRadius =3;
        nextStep.tag = 10234;
        [nextStep setTitle:@"立即拍照" forState:(UIControlStateNormal)];
        [nextStep addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:nextStep];
    }
    else
    {
        [[cell viewWithTag:10234] removeFromSuperview];
    }
    }
    reCell = cell;
    return reCell;
}
-(void)next:(UIButton *)btn
{
//    WCLLog(@"你点击了我");
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
    QuickPhotoVC * pvc = [[QuickPhotoVC alloc]init];
    pvc.params = _params;
    pvc.bodyHeight = _bodyHeight;
    pvc.comefromGeXingDingZhi = _comefromGeXingDingZhi;
    [self.navigationController pushViewController:pvc animated:YES];
    }
    else
    {
        [self alertViewShowOfTime:@"该设备不支持相机" time:1];
    }
//    NewPototUserInfoViewController *putInfo = [[NewPototUserInfoViewController alloc] init];
//
//
//    UIViewController *target = nil;
//    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
//        if ([controller isKindOfClass:[putInfo class]]) { //这里判断是否为你想要跳转的页面
//            target = controller;
//            break;
//        }
//    }
//    if (target) {
//        [self.navigationController popToViewController:target animated:NO]; //跳转
//    }
    
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
