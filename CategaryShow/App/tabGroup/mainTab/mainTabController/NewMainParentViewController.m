//
//  NewMainParentViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/27.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#import "NewMainParentViewController.h"
#import "MainTouchTableTableView.h"
#import "MYSegmentView.h"

#import "NewMainTabViewController.h"
#import "NewMainTabOtherFlogViewController.h"

@interface NewMainParentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property (nonatomic, strong) MYSegmentView   * RCSegView;
@property (nonatomic,retain) NSMutableArray *FLArray;
@property (nonatomic,retain) BaseDomain *getData;

@end

@implementation NewMainParentViewController
{
    BaseDomain *getNew;
    NSMutableArray *YDImgArray;
}
@synthesize mainTableView;

-(void)viewWillAppear:(BOOL)animated
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    self.rdv_tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.rdv_tabBarController.navigationController setNavigationBarHidden:YES animated:animated];
    
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.rdv_tabBarController.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    getNew = [BaseDomain getInstance:NO];
    _getData = [BaseDomain getInstance:NO];
    _FLArray = [NSMutableArray array];
    [self getDatas];
    
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [_getData getData:URL_GetMainFenLei PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:_getData]) {
            
            _FLArray = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            [self.view addSubview:self.mainTableView];
            
            
            
        }
    }];
}



-(void)acceptMsg : (NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = NO;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     * 处理联动
     */
    
    //获取滚动视图y值的偏移量
    
    
    CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y - 64;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
    
    
    
    
}

-(UITableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,Main_Screen_Width,Main_Screen_Height)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(64,0, 0, 0);
        mainTableView.backgroundColor = [UIColor whiteColor];
    }
    return mainTableView;
}

#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Main_Screen_Height-64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //添加pageView
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}


/*
 * 这里可以任意替换你喜欢的pageView
 */
-(UIView *)setPageViewControllers
{
    if (!_RCSegView) {
        
        
        //        SecondViewTableViewController * Second=[[SecondViewTableViewController alloc]init];
        
        NSMutableArray *arrayTitle = [NSMutableArray arrayWithArray:[_FLArray valueForKey:@"name"]];
        [_FLArray insertObject:@"" atIndex:0];
        [arrayTitle insertObject:@"推荐" atIndex:0];
        
        NSMutableArray *controllers = [NSMutableArray array];
        for (int i = 0; i < [arrayTitle count]; i ++) {
            
            if (i == 0) {
                NewMainTabViewController *newMain= [[NewMainTabViewController alloc] init];
                [controllers addObject:newMain];
            } else {
                NewMainTabOtherFlogViewController *newOther = [[NewMainTabOtherFlogViewController alloc] init];
                newOther.MainId = [_FLArray[i] stringForKey:@"id"];
                [controllers addObject:newOther];
            }
            
            
        }
        MYSegmentView * rcs=[[MYSegmentView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - 64) controllers:controllers titleArray:arrayTitle ParentController:self lineWidth:25 lineHeight:2.];
        
        _RCSegView = rcs;
    }
    return _RCSegView;
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
