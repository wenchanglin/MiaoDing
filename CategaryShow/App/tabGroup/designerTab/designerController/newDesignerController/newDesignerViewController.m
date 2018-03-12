//
//  newDesignerViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/20.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "newDesignerViewController.h"
#import "designerModel.h"
#import "DesignersClothesViewController.h"
#import "DesignerForCollectionViewCell.h"
#import "DesignerDetailIntroduce.h"
#import "DesignerClothesDetailViewController.h"
#import "JCFlipPageView.h"
#import "JCFlipPage.h"
@interface newDesignerViewController ()<JCFlipPageViewDataSource>

@property (nonatomic, strong) JCFlipPageView *flipPage;

@end

@implementation newDesignerViewController
{
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
    
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [buttonRight setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [buttonRight setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
   
    
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    getData = [BaseDomain getInstance:NO];
    
    modelArray = [NSMutableArray array];
    
    [self getDatas];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAction:) name:@"searchTKRun" object:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
}

-(void)searchAction:(NSNotification *)noti
{
    
    
    designerModel *searchModel = [designerModel new];
    NSDictionary *dict = noti.userInfo;
    for (designerModel *model in modelArray) {
        if ([model.goods_id isEqualToString:[dict stringForKey:@"goods_id"]]) {
            searchModel = model;
        }
    }
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionary];
    for (NSMutableDictionary *dic in collectionItem) {
        if ([[dic stringForKey:@"goods_id"] isEqualToString:[dict stringForKey:@"goods_id"]]) {
            searchDic = dic;
        }
    }
    
    
    
    
    DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
    designerClothes.goodDic = searchDic;
    designerClothes.model = searchModel;
    [self.navigationController pushViewController:designerClothes animated:YES];
        
    
    
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
            
            [self createFi];
            
            
        }
        
    }];
}


-(void)createFi
{
    _flipPage = [[JCFlipPageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    [self.view addSubview:_flipPage];
    
    _flipPage.dataSource = self;
    [_flipPage reloadData];
}


#pragma mar - JCFlipPageViewDataSource
- (NSUInteger)numberOfPagesInFlipPageView:(JCFlipPageView *)flipPageView
{
    return [modelArray count];
}
- (JCFlipPage *)flipPageView:(JCFlipPageView *)flipPageView pageAtIndex:(NSUInteger)index
{
    static NSString *kPageID = @"numberPageID";
    JCFlipPage *page = [flipPageView dequeueReusablePageWithReuseIdentifier:kPageID];
    if (!page)
    {
        page = [[JCFlipPage alloc] initWithFrame:flipPageView.bounds reuseIdentifier:kPageID];
    }else{}
    [page.designer setTag: index + 1000];
    [page.designer addTarget:self action:@selector(designerClick:) forControlEvents:UIControlEventTouchUpInside];
    [page.designerClothes setTag:index +10000];
    [page.designerClothes addTarget:self action:@selector(designerClothesClick:) forControlEvents:UIControlEventTouchUpInside];
    page.model = modelArray[index];
    
    return page;
}

-(void)designerClothesClick:(UIButton *)sender
{
    designerModel *model = modelArray[sender.tag - 10000];
    if (![model.goods_id isEqualToString:@""]) {
        NSMutableDictionary *dic = collectionItem[sender.tag - 10000];
        DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
        designerClothes.goodDic = dic;
        designerClothes.model = model;
        [self.navigationController pushViewController:designerClothes animated:YES];

    }
    
}
-(void)designerClick:(UIButton *)sender
{
    
        designerModel *model = modelArray[sender.tag - 1000];
    if (![model.goods_id isEqualToString:@""]) {
        DesignerDetailIntroduce *introduce = [[DesignerDetailIntroduce alloc] init];
        introduce.desginerId = [NSString stringWithFormat:@"%zd",model.des_uid];
        introduce.designerImage = model.avatar;
        introduce.designerName = model.uname;
        introduce.remark = model.introduce;
        [self.navigationController pushViewController:introduce animated:YES];
    }
    
    
    
}


- (void)showPage:(NSNumber *)pageNum
{
    [_flipPage flipToPageAtIndex:pageNum.integerValue animation:YES];
}

- (void)didReceiveMemoryWarning
{
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
