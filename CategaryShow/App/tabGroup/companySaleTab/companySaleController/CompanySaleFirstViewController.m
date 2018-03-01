//
//  CompanySaleFirstViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/26.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "CompanySaleFirstViewController.h"
#import "RPSlidingMenuCell.h"
#import "RPSlidingMenuLayout.h"
#import "ToBuyCompanyClothesViewController.h"
#import "ToBuyCompanyClothes(SecondPlan)ViewController.h"
#import "ToBuyNewViewController.h"
@interface CompanySaleFirstViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic, retain) BaseDomain *getData;


@end

@implementation CompanySaleFirstViewController
{
    NSArray *arrayImage;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self settabTitle:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _getData = [BaseDomain getInstance:NO];
    
     arrayImage = [NSArray array];
    [self getDatas];
    [self createView];
   
    
    
    
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:_class_id forKey:@"classify_id"];
    [params setObject:@"1" forKey:@"page"];
    
    [_getData getData:URL_GetYouPingList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:_getData]) {
            
            arrayImage = [[_getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"];
            [_collectionView reloadData];
        }
    }];
    
}

-(void)createView
{
        
    RPSlidingMenuLayout *layout = [[RPSlidingMenuLayout alloc] initWithDelegate:nil];
    
    layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 100);
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView registerClass:[RPSlidingMenuCell class] forCellWithReuseIdentifier:@"companyList"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableView = header;
    }
    reusableView.backgroundColor = [UIColor greenColor];
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor purpleColor];
        reusableView = footerview;
    }
    return reusableView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrayImage count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RPSlidingMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"companyList" forIndexPath:indexPath];
    cell.textLabel.text = [arrayImage[indexPath.item] stringForKey:@"name"];
    cell.detailTextLabel.text = [arrayImage[indexPath.item] stringForKey:@"sub_name"];
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,[arrayImage[indexPath.item] stringForKey:@"thumb"]]]];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
//    ToBuyCompanyClothes_SecondPlan_ViewController *toBuy = [[ToBuyCompanyClothes_SecondPlan_ViewController alloc] init];
//    toBuy.goodDic = arrayImage[indexPath.row];
//    [self.navigationController pushViewController:toBuy animated:YES];
    ToBuyNewViewController *toButy = [[ToBuyNewViewController alloc] init];
    toButy.goodDic = arrayImage[indexPath.row];
    [self.navigationController pushViewController:toButy animated:YES];
    
    
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
