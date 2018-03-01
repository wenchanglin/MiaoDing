
//
//  DiyFirstViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/18.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "DiyFirstViewController.h"
#import "uiimageShowViewController.h"
#import "DiyClothesDetailViewController.h"
#import "SearchEViewController.h"
@interface DiyFirstViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property(nonatomic ,strong) UIPageViewController *pageViewController;
@property(nonatomic ,strong) NSMutableArray       *dataArray;
@end

@implementation DiyFirstViewController
{
    BaseDomain *getData;
    NSMutableArray *FLArray;
    NSMutableArray *detailArray;
    NSTimer *timer;
    UIImageView *woring;
    UIView *listView;
    BOOL ifShow;
    BOOL haveLoad;
    NSString *haveLoadTitle;
    UIView *viewCanTouch;
    
    UIButton *seleBtn;
    UIView *titleView;
    
    UIView *lineView;
    
    NSInteger FLFlog;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    if (haveLoad) {
//        [self settabTitle:haveLoadTitle];
//    } else {
//        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
//        NSArray *array = [userD arrayForKey:@"FL"];
//        haveLoad = YES;
//        [self settabTitle:[array[0] stringForKey:@"name"]];
//        haveLoadTitle = [array[0] stringForKey:@"name"];
//    }

    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userD arrayForKey:@"FL"];
    
    if (!titleView) {
        titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80 * array.count, 40)];
        
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(1, 34, 25, 2)];
        [titleView addSubview:lineView];
        [lineView setBackgroundColor:[UIColor blackColor]];
        
        for (int i = 0; i < array.count; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(80*i,0, 80, 30)];
            [titleView addSubview:button];
            [button.titleLabel setFont:Font_14];
            [button setTitle:[array[i] stringForKey:@"name"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
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
    
    
    
    
    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    
//    UIButton *buttonLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [buttonLeft setImage:[UIImage imageNamed:@"listBtn"] forState:UIControlStateNormal];
//    [buttonLeft setContentEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
//    [buttonLeft addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.rdv_tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    
    
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [buttonRight setImage:[UIImage imageNamed:@"searchE"] forState:UIControlStateNormal];
    [buttonRight setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [buttonRight addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
}

-(void)rightClick
{
    SearchEViewController *search = [[SearchEViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}



-(void)leftClick
{
    if (ifShow) {
        [self hiddenview];
        
    } else {
        [self showView];
        
    }
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    ifShow = NO;
    getData = [BaseDomain getInstance:NO];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userD arrayForKey:@"FL"];
    FLArray = [NSMutableArray arrayWithArray:array];
    _dataArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapClickAction:) name:@"tapClick" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAction:) name:@"searchDZ" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTK:) name:@"searchTK" object:nil];
    
    // Do n additional setup after loading the view.
    [self getDatas];
}

-(void)searchTK:(NSNotification *)noti
{
    [self.rdv_tabBarController setSelectedIndex:2];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchTKRun" object:nil userInfo:noti.userInfo];
}

-(void)searchAction:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    
    
    for (NSDictionary *dict in detailArray) {
        if ([[dict stringForKey:@"id"] isEqualToString:[dic stringForKey:@"goods_id"]]) {
            DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
            [self hiddenview];
            toButy.goodDic = [NSMutableDictionary dictionaryWithDictionary:dict];
            [self.navigationController pushViewController:toButy animated:YES];
        }
    }
    
    
    
}


-(void)tapClickAction:(NSNotification *)noti
{
    DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
    [self hiddenview];
    toButy.goodDic = detailArray[[[noti.userInfo stringForKey:@"index"] integerValue]];
    [self.navigationController pushViewController:toButy animated:YES];
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:[FLArray[FLFlog] stringForKey:@"id"] forKey:@"classify_id"];
    [params setObject:@"1" forKey:@"page"];
    
    [getData getData:URL_GetYouPingList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            
            detailArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            [self createPage];
            [self createListFL];
            
        }
    }];
    
}


-(void)createListFL
{
    listView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, [FLArray count] * 45)];
    [listView setBackgroundColor:[UIColor whiteColor]];
    [listView setAlpha:0];
    [self.view addSubview:listView];
    for (int i = 0; i < [FLArray count]; i ++) {
        UIButton *fBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 45 * i, SCREEN_WIDTH, 45)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, 44, SCREEN_WIDTH - 10, 1)];
        [line setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
        [fBtn addSubview:line];
        [fBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [fBtn.titleLabel setFont:Font_15];
        [fBtn setTitle:[FLArray[i] stringForKey:@"name"] forState:UIControlStateNormal];
        [fBtn addTarget:self action:@selector(clickFL:) forControlEvents:UIControlEventTouchUpInside];
        [listView addSubview:fBtn];
        [fBtn setTag:i + 50];
        
    }
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
        if ([self checkHttpResponseResultStatus:getData]) {
            
            detailArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            [self pageReload];
            
            
        }
    }];
}


-(void)clickFL:(UIButton *)sender
{
    
    haveLoadTitle = [FLArray[sender.tag - 50] stringForKey:@"name"];
    [self settabTitle:[FLArray[sender.tag - 50] stringForKey:@"name"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:[FLArray[sender.tag - 50] stringForKey:@"id"] forKey:@"classify_id"];
    [params setObject:@"1" forKey:@"page"];
    
    [getData getData:URL_GetYouPingList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            
            detailArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            [self pageReload];
            
            
        }
    }];
}


-(void)hiddenview
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [listView setAlpha:0];
    [UIView commitAnimations];
    ifShow = NO;
}

-(void)showView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [listView setAlpha:1];
    [UIView commitAnimations];
    ifShow = YES;
}

-(void)pageReload
{
    [self hiddenview];
    
    [_dataArray removeAllObjects];
    for (int i = 0; i < [detailArray count]; i++) {
        
        uiimageShowViewController *imageVC = [[uiimageShowViewController alloc]init];
        imageVC.imageUrl = [detailArray[i] stringForKey:@"thumb"];
        imageVC.index = i;
        imageVC.goodDic = detailArray[i];
        [_dataArray addObject:imageVC];
        
        
    }
    uiimageShowViewController *imageViewController = [self createImage:0];
    NSArray *array = [NSArray arrayWithObjects:imageViewController, nil];
    [_pageViewController setViewControllers:array
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:YES
                                 completion:nil];

}

-(void)createPage
{
    for (int i = 0; i < [detailArray count]; i++) {
        
        uiimageShowViewController *imageVC = [[uiimageShowViewController alloc]init];
        imageVC.imageUrl = [detailArray[i] stringForKey:@"thumb"];
        imageVC.index = i;
        imageVC.goodDic = detailArray[i];
        [_dataArray addObject:imageVC];
        
      
    }
    
    //设置第三个参数
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    
    //初始化UIPageViewController
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    //指定代理
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    //设置frame
    _pageViewController.view.frame = CGRectMake(0, 64 , self.view.frame.size.width, self.view.frame.size.height - 64);
    
    //是否双面显示，默认为NO
    _pageViewController.doubleSided = NO;
    
    //设置首页显示数据
    uiimageShowViewController *imageViewController = [self createImage:0];
    NSArray *array = [NSArray arrayWithObjects:imageViewController, nil];
    [_pageViewController setViewControllers:array
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:YES
                                 completion:nil];
    
    //添加pageViewController到Controller
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    viewCanTouch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:viewCanTouch];
    [viewCanTouch setAlpha:0];
    
    woring = [UIImageView new];
    [self.view addSubview:woring];
    woring.sd_layout
    .centerYEqualToView(self.view)
    .centerXEqualToView(self.view)
    .heightIs(222 / 2)
    .widthIs(396 / 2);
    [woring setAlpha:0];
    
    
    
    
    
}

//获取指定显示controller
-(uiimageShowViewController *)createImage:(NSInteger)integer
{
    return [_dataArray objectAtIndex:integer];
}

//获取显示controller元素下标
-(NSInteger)integerWithController:(uiimageShowViewController *)vc
{
    return [_dataArray indexOfObject:vc];
}


#pragma mark - UIPageViewControllerDataSource
//显示前一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    [self hiddenview];
    NSInteger integer = [self integerWithController:(uiimageShowViewController *)viewController];
//    [self hiddenChoose];
    if (integer == 0 || integer == NSNotFound) {
        
        
        [woring setImage:[UIImage imageNamed:@"firstImg"]];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [woring setAlpha:1];
        [viewCanTouch setAlpha:1];
        [UIView commitAnimations];
        
        timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myLog) userInfo:nil repeats:NO];
        return nil;
    }
    integer--;
//    pageCntroller.currentPage = integer;
    return [self createImage:integer];
}

-(void)myLog
{
    if (timer.isValid) {
        [timer invalidate];
    }
    timer=nil;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [woring setAlpha:0];
    [viewCanTouch setAlpha:0];
    [UIView commitAnimations];
}

//显示下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self integerWithController:(uiimageShowViewController *)viewController];
    [self hiddenview];
    if (index == NSNotFound)
    {
        
        
        
        [woring setImage:[UIImage imageNamed:@"LastImg"]];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [woring setAlpha:1];
        [viewCanTouch setAlpha:1];
        [UIView commitAnimations];
        
        timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myLog) userInfo:nil repeats:NO];
        return nil;
    }
    index++;
    if (index == _dataArray.count)
    {
        [woring setImage:[UIImage imageNamed:@"LastImg"]];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [woring setAlpha:1];
        [viewCanTouch setAlpha:1];
        [UIView commitAnimations];
        
        timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myLog) userInfo:nil repeats:NO];
        
        return nil;
    }
    
    
    
    
    return [self createImage:index];
    
}

//返回页控制器中页的数量
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return _dataArray.count;
}

//返回页控制器中当前页的索引
-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - UIPageViewControllerDelegate
//翻页视图控制器将要翻页时执行的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    NSLog(@"将要翻页也就是手势触发时调用方法");
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer

{

    return NO;

}

//可以通过返回值重设书轴类型枚举
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return UIPageViewControllerSpineLocationMin;
}

//返回页控制器中控制器的页内容控制器数
-(UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController
{
    return UIInterfaceOrientationMaskPortrait;
}


//防止上一个动画还没有结束,下一个动画就开始了
//当用户从一个页面转向下一个或者前一个页面,或者当用户开始从一个页面转向另一个页面的途中后悔 了,并撤销返回到了之前的页面时,将会调用这个方法。假如成功跳转到另一个页面时,transitionCompleted 会被置成 YES,假如在跳转途中取消了跳转这个动作将会被置成 NO。
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(finished && completed)
    {
        // 无论有无翻页，只要动画结束就恢复交互。
        pageViewController.view.userInteractionEnabled = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hiddenview];
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
