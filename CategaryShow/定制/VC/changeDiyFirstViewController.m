//
//  changeDiyFirstViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/26.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "changeDiyFirstViewController.h"
#import "LLSegmentBarVC.h"
#import "changeDiySecondViewController.h"
#import "SearchEViewController.h"
#import "changeDiyThreeViewController.h"
@interface changeDiyFirstViewController ()
@property (nonatomic,weak) LLSegmentBarVC * segmentVC;//

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
#pragma mark - segmentVC
- (LLSegmentBarVC *)segmentVC{
    if (!_segmentVC) {
        LLSegmentBarVC *vc = [[LLSegmentBarVC alloc]init];
        // 添加到到控制器
        [self addChildViewController:vc];
        _segmentVC = vc;
    }
    return _segmentVC;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.rdv_tabBarController.tabBarHidden=NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userD arrayForKey:@"FL"];
    self.segmentVC.segmentBar.frame = CGRectMake(50, 0, SCREEN_WIDTH-100, 35);
    self.navigationItem.titleView = self.segmentVC.segmentBar;
    // 2 添加控制器的View
    self.segmentVC.view.frame = self.view.bounds;
    [self.view addSubview:self.segmentVC.view];
    NSMutableArray*vcArr= [NSMutableArray array];
    NSMutableArray*vcName = [NSMutableArray array];
    for (NSDictionary*dict in array) {
        changeDiyThreeViewController*svc = [[changeDiyThreeViewController alloc]init];
        svc.title = [dict stringForKey:@"name"];
        svc.shopID=[dict integerForKey:@"id"];
        svc.feileiString =[dict stringForKey:@"type"];
        [vcName addObject:svc.title];
        [vcArr addObject:svc];
    }
 
    
    // 3 添加标题数组和控住器数组
    [self.segmentVC setUpWithItems:vcName childVCs:vcArr];
    self.segmentVC.contentView.scrollEnabled=NO;
//     4  配置基本设置  可采用链式编程模式进行设置
    [self.segmentVC.segmentBar updateWithConfig:^(LLSegmentBarConfig *config) {
        config.itemNormalColor([UIColor colorWithHexString:@"#FFFFFF"]).itemSelectColor([UIColor colorWithHexString:@"#FFFFFF"]).indicatorColor([UIColor colorWithHexString:@"#FFFFFF"]).itemFont(Font_14);
    }];
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [buttonRight setImage:[UIImage imageNamed:@"searchE"] forState:UIControlStateNormal];
    [buttonRight setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [buttonRight addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
}

-(void)rightClick
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        SearchEViewController *search = [[SearchEViewController alloc] init];
        search.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:search animated:YES];
    }
    else
    {
        [self alertViewShowOfTime:@"该设备不支持相机" time:1.5];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
