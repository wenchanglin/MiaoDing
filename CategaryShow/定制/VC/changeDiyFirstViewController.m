//
//  changeDiyFirstViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/26.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "changeDiyFirstViewController.h"
#import "SearchEViewController.h"
#import "DiyClothesDetailViewController.h"
#import "changeDiyCollectionViewCell.h"
#import "chageDiyModel.h"
#import "DesignerClothesDetailViewController.h"

@interface changeDiyFirstViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation changeDiyFirstViewController
{
    BaseDomain *getData;
    UICollectionView *clothesCollection;
    UIButton *seleBtn;
    UIView *titleView;
    UIView *lineView;
    
    NSMutableArray *FLArray;
    NSMutableArray *detailArray;
    NSInteger page;
    NSMutableArray *modelArray;
    
    NSInteger FLFlog;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userD arrayForKey:@"FL"];
    
    if (!titleView) {
        titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80 * array.count, 40)];
        lineView = [[UIView alloc] initWithFrame:CGRectMake(1, 34, 25, 2)];
        [titleView addSubview:lineView];
        [lineView setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
        
        for (int i = 0; i < array.count; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(80*i,0, 80, 30)];
            [titleView addSubview:button];
            [button.titleLabel setFont:Font_14];
            [button setTitle:[array[i] stringForKey:@"name"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:(UIControlStateNormal)];
//            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
            button.tag = i + 80;
            if ( i == 0) {
                seleBtn = button;
                [seleBtn setSelected:YES];
            }
            [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        lineView.centerX = seleBtn.centerX;
    }
    self.rdv_tabBarController.navigationItem.titleView = titleView;
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [buttonRight setImage:[UIImage imageNamed:@"searchE"] forState:UIControlStateNormal];
    [buttonRight setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [buttonRight addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
}

-(void)rightClick
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        SearchEViewController *search = [[SearchEViewController alloc] init];
        [self.navigationController pushViewController:search animated:YES];
    }
    else
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该设备不支持相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        [self alertViewShowOfTime:@"该设备不支持相机" time:1.5];
    }
    
}

-(void)searchTK:(NSNotification *)noti
{

    NSDictionary *dic = noti.userInfo;
    DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
    designerClothes.marketId = [dic stringForKey:@"marketId"];
    designerClothes.shopId = [dic stringForKey:@"shopId"];
    designerClothes.good_id = [dic stringForKey:@"goods_id"];
    [self.navigationController pushViewController:designerClothes animated:YES];
}

-(void)searchAction:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
//    for (NSDictionary *dict in detailArray) {
//        if ([[dict stringForKey:@"id"] isEqualToString:[dic stringForKey:@"goods_id"]]) {
    DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
    NSMutableDictionary *dict= [NSMutableDictionary dictionary];
    [dict setObject:[dic stringForKey:@"goods_id"] forKey:@"id"];
    toButy.goodDic = dict;
    toButy.marketId = [dic stringForKey:@"marketId"];
    toButy.shopId = [dic stringForKey:@"shopId"];
    toButy.good_id = [dic stringForKey:@"goods_id"];
    
    [self.navigationController pushViewController:toButy animated:YES];
//        }
//    }
  
}

-(void)clickAction:(UIButton *)sender
{
    [seleBtn setSelected:NO];
    seleBtn = sender;
    [seleBtn setSelected:YES];
    FLFlog = sender.tag - 80;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    lineView.centerX = seleBtn.centerX;
    [UIView commitAnimations];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:[FLArray[sender.tag - 80] stringForKey:@"id"] forKey:@"classify_id"];
    [params setObject:@"1" forKey:@"page"];
    
    [getData getData:URL_GetYouPingList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            [modelArray removeAllObjects];
            detailArray = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            for (NSMutableDictionary *dic in detailArray) {
                chageDiyModel *model = [chageDiyModel mj_objectWithKeyValues:dic];
                [modelArray addObject:model];
            }
            
            
            [clothesCollection reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getUIColor(Color_clothDiyBack)];
    getData = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userD arrayForKey:@"FL"];
    FLArray = [NSMutableArray arrayWithArray:array];
    page = 1;
    
    FLFlog = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAction:) name:@"searchDZ" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTK:) name:@"searchTK" object:nil];
    [self getDatas];
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:[FLArray[FLFlog] stringForKey:@"id"] forKey:@"classify_id"];
    [params setObject:@"1" forKey:@"page"];
    
    [getData getData:URL_GetYouPingList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            [modelArray removeAllObjects];
            detailArray = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            for (NSMutableDictionary *dic in detailArray) {
                chageDiyModel *model = [chageDiyModel mj_objectWithKeyValues:dic];
                [modelArray addObject:model];
            }
            
            [self viewCreate];
            
        }
    }];
    
}

-(void)viewCreate
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    clothesCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT -64- 49) collectionViewLayout:flowLayout];
    
    //设置代理
    clothesCollection.delegate = self;
    clothesCollection.dataSource = self;
    clothesCollection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:clothesCollection];
    if (@available(iOS 11.0, *)) {
        clothesCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    clothesCollection.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
//    clothesCollection.layer.masksToBounds = NO;
//    [[clothesCollection layer] setShadowOffset:CGSizeMake(0, 3)]; // 阴影的范围
//    [[clothesCollection layer] setShadowRadius:3];                // 阴影扩散的范围控制
//    [[clothesCollection layer] setShadowOpacity:0.5];               // 阴影透明度
//    [[clothesCollection layer] setShadowColor:[UIColor grayColor].CGColor];
    //注册cell和ReusableView（相当于头部）
    [clothesCollection registerClass:[changeDiyCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    clothesCollection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self reloadData];
       
        // 这个地方是网络请求的处理
    }];
    
    clothesCollection.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        
            [self reloadAddData];
        // 结束刷新
    }];
    
}

-(void)reloadAddData
{
    page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:[FLArray[FLFlog] stringForKey:@"id"] forKey:@"classify_id"];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    [getData getData:URL_GetYouPingList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
                [detailArray addObject:dic];
                chageDiyModel *model = [chageDiyModel mj_objectWithKeyValues:dic];
                [modelArray addObject:model];
               
            }
            
            [clothesCollection.mj_footer endRefreshing];
            [clothesCollection reloadData];
            
        }
    }];
}

-(void)reloadData
{
    page = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:[FLArray[FLFlog] stringForKey:@"id"] forKey:@"classify_id"];
    [params setObject:@"1" forKey:@"page"];
    
    [getData getData:URL_GetYouPingList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            [modelArray removeAllObjects];
            detailArray = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            
            for (NSMutableDictionary *dic in detailArray) {
                chageDiyModel *model = [chageDiyModel mj_objectWithKeyValues:dic];
                [modelArray addObject:model];
            }
            
            [clothesCollection.mj_header endRefreshing];
            [clothesCollection reloadData];
            
        }
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [detailArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    changeDiyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.itemIdex = indexPath.item;
    chageDiyModel *model = modelArray[indexPath.item];
    cell.model = model;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH / 2 - 6, 266);
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
    DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
    toButy.goodDic = [NSMutableDictionary dictionaryWithDictionary:detailArray[indexPath.item]];
    [self.navigationController pushViewController:toButy animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
