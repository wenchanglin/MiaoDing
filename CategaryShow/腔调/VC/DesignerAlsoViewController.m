//
//  DesignerAlsoViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//


#import "DesignerAlsoViewController.h"
#import "OneViewTableTableViewController.h"
#import "SecondViewTableViewController.h"
#import "designerListViewController.h"
#import "MainTouchTableTableView.h"
#import "MySegMentViewNew.h"
#import "newDesignerViewController.h"
#import "designerViewController.h"
#import "DesignerForCollectionViewController.h"
#import "DesignerAndClothesViewController.h"
#import "DesignerCardViewController.h"
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width


@interface DesignerAlsoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property (nonatomic, strong) MySegMentViewNew * RCSegView;
@property(nonatomic,strong)UIImageView *headImageView;//头部图片
@property(nonatomic,strong)UIImageView * avatarImage;
@property(nonatomic,strong)UILabel *countentLabel;
@property (nonatomic, retain) UIView *alpha;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@end

@implementation DesignerAlsoViewController
{
    BaseDomain *getBaner;
    NSMutableDictionary *banerDic;
}
@synthesize mainTableView;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    getBaner = [BaseDomain getInstance:NO];
    [self.view addSubview:self.mainTableView];
    [self getDataBaner];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
}

-(void)getDataBaner
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getBaner getData:URL_getDesignerBaner PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:domain]) {
            
            banerDic = [NSMutableDictionary dictionaryWithDictionary:[domain.dataRoot dictionaryForKey:@"data"]];
            [self.mainTableView addSubview:self.headImageView];
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
    
    
    CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y ;
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
        
        if (@available(iOS 11.0, *)) {
            mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        [mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        mainTableView.contentInset = UIEdgeInsetsMake(0,0, 0, 0);
        mainTableView.backgroundColor = [UIColor colorWithHexString:@"#202020"];
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
    
    return Main_Screen_Height - 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#202020"];
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
        
        DesignerAndClothesViewController * First=[[DesignerAndClothesViewController alloc]init];
        
        //        SecondViewTableViewController * Second=[[SecondViewTableViewController alloc]init];
        
        DesignerCardViewController * Third=[[DesignerCardViewController alloc]init];
        
        NSArray *controllers=@[First];//,Third];
        
        NSArray *titleArray =@[@"腔调"];//,@"设计师"];
        
        MySegMentViewNew * rcs=[[MySegMentViewNew alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) controllers:controllers titleArray:titleArray ParentController:self lineWidth:25 lineHeight:2.0 butHeight:30 viewHeight:64 showLine:NO];
        
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
