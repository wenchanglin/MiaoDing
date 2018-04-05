//
//  MainTabViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/23.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "NewMainTabViewController.h"
#import "NewMainModel.h"
#import <SDCycleScrollView.h>
#import "NewMainTabListTableViewCell.h"
#import "YYCycleScrollView.h"
#import "MainTabViewCellForBanerDownCell.h"
#import "MainTabListCell.h"
#import "MainTabModel.h"
#import "DontHaveThreeImageTableViewCell.h"
#import "MainTabDetailViewController.h"
#import "MainTabBanerDetailViewController.h"
#import "DesignerTableViewCell.h"
#import "NewDesignerArray.h"
#import "DesignerDetailIntroduce.h"
#import "designerHomeViewController.h"
#import "joinDesignerViewController.h"
#import "inviteNewViewController.h"
#import "DiyClothesDetailViewController.h"
#import "DesignerClothesDetailViewController.h"
#import "StoresRecommendVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#define URLShare @"/web/jquery-obj/static/fx/html/designer.html"
#import "ZiXunVC.h"

#import "UIImageView+WebCache.h"
#import "XHWebImageAutoSize.h"
@interface NewMainTabViewController ()<UITableViewDataSource, UITableViewDelegate, CellForBanerDownDelegate, MainTableDelegate, DesignerTableViewCellDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, retain) UITableView *mainTabTable;  //首页的table
@property (nonatomic, retain) NSMutableArray *ListArray;  //list content array
@property (nonatomic, retain) NSMutableArray *modelArray;  //model list;
@property (nonatomic, retain) BaseDomain *getBaner;

@end

//[self.tableView scrollToRowAtIndexPath:indexPath
//                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];


@implementation NewMainTabViewController
{
    NSMutableArray *banerImgArray;
    NSMutableArray *detailArray;
    NSMutableArray *designerArray;
    NewDesignerArray *designeArray;
    BaseDomain *getPeiZhi;
    BaseDomain *getYingDao;
    BaseDomain *getFenLei;
    NSDate *datBegin;
    BaseDomain *postData;
    BaseDomain * shouCangDomain;
    BaseDomain * loveDomain;
    UIAlertView *alert;
    NSTimer *timer;
    NSMutableArray * dianpuArr;
    NSInteger page;
    BaseDomain *getNew;
    NSMutableArray *YDImgArray;
    
    UIImageView *imag;
    
    
    
    NSMutableArray *recommend_list;
}
-(void)viewWillAppear:(BOOL)animated
{
    // UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    self.rdv_tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //    self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //    [self settabImg:@"MainLogo"];
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)createDataGet
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(1) forKey:@"page"];
    [getPeiZhi getData:URL_GetUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        
        if (domain.result == 10001) {
            
        } else {
            
            
            [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:getPeiZhi.dataRoot];
            
            
        }
        
        
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.mainTabTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    getPeiZhi = [BaseDomain getInstance:NO];
    _getBaner = [BaseDomain getInstance:NO];
    getYingDao = [BaseDomain getInstance:NO];
    getFenLei = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    shouCangDomain = [BaseDomain getInstance:NO];
    recommend_list = [NSMutableArray array];
    loveDomain =[BaseDomain getInstance:NO];
    designerArray = [NSMutableArray array];
    _modelArray = [NSMutableArray array];
    detailArray = [NSMutableArray array];
    dianpuArr = [NSMutableArray array];
    getNew = [BaseDomain getInstance:NO];
    YDImgArray = [NSMutableArray array];
    page = 1;
    [self createTableView];
    [self createDataGet];
    [self getDetailData];
    [self getPeiZhi];
    [self getFenLei];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
}

-(void)getFenLei
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(1) forKey:@"page"];
    [getFenLei getData:URL_GETFenLei PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getFenLei]) {
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            [userD setObject:array forKey:@"FL"];
            [self GetNewUser];
        }
    }];
}


-(void)createNewUser
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次
        imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [imag setUserInteractionEnabled:YES];
        UIWindow *win = self.view.window;
        [imag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, YDImgArray[0]]]];
        
        
        UIButton *buttonLogin = [[UIButton alloc] initWithFrame:CGRectMake(86.0 / 375.0 * SCREEN_WIDTH, 365.0 / 667.0 * SCREEN_HEIGHT, 203.0 / 375.0 * SCREEN_WIDTH, 48.0 / 667.0 * SCREEN_HEIGHT)];
        [buttonLogin addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        
        [imag addSubview:buttonLogin];
        
        
        
        UIButton *buttonLoginSmall = [UIButton new];
        [imag addSubview:buttonLoginSmall];
        buttonLoginSmall.sd_layout
        .leftSpaceToView(imag, 188.0 / 375 * SCREEN_WIDTH)
        .topSpaceToView(buttonLogin, 1)
        .widthIs(51.0 / 375 * SCREEN_WIDTH)
        .heightIs(22.0 / 667 * SCREEN_HEIGHT);
        [buttonLoginSmall addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIButton *cancel = [UIButton new];
        [imag addSubview:cancel];
        
        cancel.sd_layout
        .centerXEqualToView(imag)
        .bottomSpaceToView(imag, 113.0 / 667 * SCREEN_HEIGHT)
        .heightIs(50.0 / 375 * SCREEN_WIDTH)
        .widthIs(50.0 / 375 * SCREEN_WIDTH);
        [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [win addSubview:imag];
        
    }
}

-(void)cancelClick
{
    [imag removeFromSuperview];
    imag = nil;
}

-(void)loginClick
{
    [imag removeFromSuperview];
    imag = nil;
    
    [self.rdv_tabBarController setSelectedIndex:3];
}

-(void)GetNewUser
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"5" forKey:@"id"];
    [getNew getData:URL_GetYingDao PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            
            YDImgArray = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"img_urls"]];
            
            [self createNewUser];
        }
    }];
}


-(void)getPeiZhi
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [getPeiZhi getData:URL_GETPEIZHI PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"privateKey"] forKey:@"privateKey"];
        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"appid"] forKey:@"appId"];
        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"login_img"] forKey:@"loginImage"];
        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"price_remark"] forKey:@"price_remark"];
        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"kf_tel"] forKey:@"kf_tel"];
        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"cobbler_banner"] forKey:@"cobbler_banner"];
    }];
}

-(void)getDetailData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [_getBaner getData:URL_GetMain PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:_getBaner]) {
            designerArray = [NSMutableArray arrayWithArray:[_getBaner.dataRoot arrayForKey:@"designer_list"]];
            designeArray = [NewDesignerArray new];
            //            designeArray.designerArray = designerArray;
            
            banerImgArray = [NSMutableArray arrayWithArray:[_getBaner.dataRoot arrayForKey:@"lunbo"]];
            
//            recommend_list = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"recommend_list"]];
            dianpuArr = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"indextype"]];
            
            designeArray.designerArray = dianpuArr;
            
            
            NSArray *array = [_getBaner.dataRoot arrayForKey:@"data"];
            //WCLLog(@"%@",domain.dataRoot[@"data"]);
            for (int i = 0; i < [array count]; i++) {
                NSArray *arrayJ = array[i];
                NSMutableArray *temp = [NSMutableArray array];
                for (int j = 0; j < [arrayJ count]; j ++ ) {
                    NewMainModel *model  = [NewMainModel new];
                    model.ImageUrl = [arrayJ[j] stringForKey:@"img"];
                    model.img_new = [arrayJ[j] stringForKey:@"img_new"];
                    model.linkUrl = [arrayJ[j] stringForKey:@"link"];
                    model.LinkId = [arrayJ[j] stringForKey:@"id"];
                    model.is_love = [[arrayJ[j] objectForKey:@"is_love"]integerValue];
                    model.is_collect = [[arrayJ[j] objectForKey:@"is_collect"]integerValue];
                    model.commentnum = [[arrayJ[j] objectForKey:@"commentnum"]integerValue];
                    model.lovenum = [[arrayJ[j] objectForKey:@"lovenum"]integerValue];
                    model.is_type = [[arrayJ[j] objectForKey:@"is_type"] integerValue];
                    model.img_info = [arrayJ[j] stringForKey:@"img_info"];
                    model.fenLei = [arrayJ[j] stringForKey:@"name"];
                    model.name = [arrayJ[j] stringForKey:@"title"];
                    model.tagName = [arrayJ[j] stringForKey:@"tag_name"];
                    model.subTitle = [arrayJ[j] stringForKey:@"sub_title"];
                    model.detail = [NSString stringWithFormat:@"%@·%@",[arrayJ[j] stringForKey:@"tag_name"], [arrayJ[j] stringForKey:@"sub_title"]];
                    if (j == 0) {
                        model.time = [arrayJ[j] stringForKey:@"p_time"];
                    }
                    
                    [temp addObject:model];
                }
                
                [_modelArray addObject:temp];
            }
            
            
            // NSLog(@"%@", _modelArray);
            
            [_mainTabTable reloadData];
            
            
        }
    }];
}

-(void)createTableView
{
    
    _mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,IsiPhoneX?NavHeight-44:NavHeight-20, SCREEN_WIDTH,IsiPhoneX?SCREEN_HEIGHT-40:SCREEN_HEIGHT - 29) style:UITableViewStyleGrouped];
    _mainTabTable.delegate = self;
    _mainTabTable.dataSource = self;
    self.mainTabTable.estimatedSectionHeaderHeight = 0;
    self.mainTabTable.estimatedSectionFooterHeight=0;
    [_mainTabTable registerClass:[NewMainTabListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NewMainTabListTableViewCell class])];
    [_mainTabTable registerClass:[DesignerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DesignerTableViewCell class])];
    [self.view addSubview:_mainTabTable];
    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_mainTabTable setBackgroundColor:[UIColor whiteColor]];
    //    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [headerImages addObject:image];
    }
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadData];
        });
        
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [header setImages:headerImages duration:1 forState:MJRefreshStateRefreshing];
    _mainTabTable.mj_header = header;
    
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
        });
    }];
    footer.stateLabel.hidden =YES;
    footer.refreshingTitleHidden = YES;
    [footer setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [footer setImages:headerImages duration:1 forState:MJRefreshStateRefreshing];
    _mainTabTable.mj_footer = footer;
    
}
-(void)reloadAddData
{
    page ++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [_getBaner getData:URL_GetMain PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:_getBaner]) {
            designerArray = [NSMutableArray arrayWithArray:[_getBaner.dataRoot arrayForKey:@"designer_list"]];
            designeArray = [NewDesignerArray new];
            
            banerImgArray = [NSMutableArray arrayWithArray:[_getBaner.dataRoot arrayForKey:@"lunbo"]];
//            recommend_list = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"recommend_list"]];//recommend_list
            dianpuArr = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"indextype"]];
            
            designeArray.designerArray = dianpuArr;
            NSArray *array = [_getBaner.dataRoot arrayForKey:@"data"];
            
            if ([array count] > 0) {
                for (int i = 0; i < [array count]; i++) {
                    NSArray *arrayJ = array[i];
                    NSMutableArray *temp = [NSMutableArray array];
                    for (int j = 0; j < [arrayJ count]; j ++ ) {
                        NewMainModel *model  = [NewMainModel new];
                        model.ImageUrl = [arrayJ[j] stringForKey:@"img"];
                        model.img_new = [arrayJ[j] stringForKey:@"img_new"];
                        model.linkUrl = [arrayJ[j] stringForKey:@"link"];
                        model.LinkId = [arrayJ[j] stringForKey:@"id"];
                        model.is_type = [[arrayJ[j] objectForKey:@"is_type"] integerValue];
                        model.img_info = [arrayJ[j] stringForKey:@"img_info"];
                        
                        model.is_love = [[arrayJ[j] objectForKey:@"is_love"]integerValue];
                        model.is_collect = [[arrayJ[j] objectForKey:@"is_collect"]integerValue];
                        model.commentnum = [[arrayJ[j] objectForKey:@"commentnum"]integerValue];
                        model.lovenum = [[arrayJ[j] objectForKey:@"lovenum"]integerValue];
                        model.fenLei = [arrayJ[j] stringForKey:@"name"];
                        model.name = [arrayJ[j] stringForKey:@"title"];
                        model.tagName = [arrayJ[j] stringForKey:@"tag_name"];
                        model.detail = [NSString stringWithFormat:@"%@·%@",[arrayJ[j] stringForKey:@"tag_name"], [arrayJ[j] stringForKey:@"sub_title"]];
                        model.subTitle = [arrayJ[j] stringForKey:@"sub_title"];
                        if (j == 0) {
                            model.time = [arrayJ[j] stringForKey:@"p_time"];
                        }
                        
                        [temp addObject:model];
                    }
                    
                    [_modelArray addObject:temp];
                }
                
                
                // NSLog(@"%@", _modelArray);
                [_mainTabTable.mj_footer endRefreshing];
                [_mainTabTable reloadData];
            } else {
                [_mainTabTable.mj_footer endRefreshingWithNoMoreData];
            }
            
            
            
        }
    }];
}

-(void)reloadData
{
    
    page = 1;
   
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [_getBaner getData:URL_GetMain PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:_getBaner]) {
            [_modelArray removeAllObjects];
            [designerArray removeAllObjects];
            designerArray = [NSMutableArray arrayWithArray:[_getBaner.dataRoot arrayForKey:@"designer_list"]];
            designeArray = [NewDesignerArray new];
            
            dianpuArr = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"indextype"]];
            banerImgArray = [NSMutableArray arrayWithArray:[_getBaner.dataRoot arrayForKey:@"lunbo"]];

            designeArray.designerArray = dianpuArr;
            NSArray *array = [_getBaner.dataRoot arrayForKey:@"data"];
            
            for (int i = 0; i < [array count]; i++) {
                NSArray *arrayJ = array[i];
                NSMutableArray *temp = [NSMutableArray array];
                for (int j = 0; j < [arrayJ count]; j ++ ) {
                    NewMainModel *model  = [NewMainModel new];
                    model.ImageUrl = [arrayJ[j] stringForKey:@"img"];
                    model.img_new = [arrayJ[j] stringForKey:@"img_new"];
                    model.img_info = [arrayJ[j] stringForKey:@"img_info"];
                    model.linkUrl = [arrayJ[j] stringForKey:@"link"];
                    model.LinkId = [arrayJ[j] stringForKey:@"id"];
                    model.is_type = [[arrayJ[j] objectForKey:@"is_type"] integerValue];
                    model.is_love = [[arrayJ[j] objectForKey:@"is_love"] integerValue];
                    model.is_collect = [[arrayJ[j] objectForKey:@"is_collect"] integerValue];
                    model.commentnum = [[arrayJ[j] objectForKey:@"commentnum"]integerValue];
                    model.lovenum = [[arrayJ[j] objectForKey:@"lovenum"]integerValue];
                    model.fenLei = [arrayJ[j] stringForKey:@"name"];
                    model.name = [arrayJ[j] stringForKey:@"title"];
                    model.tagName = [arrayJ[j] stringForKey:@"tag_name"];
                    model.detail = [NSString stringWithFormat:@"%@·%@",[arrayJ[j] stringForKey:@"tag_name"], [arrayJ[j] stringForKey:@"sub_title"]];
                    model.subTitle = [arrayJ[j] stringForKey:@"sub_title"];
                    if (j == 0) {
                        model.time = [arrayJ[j] stringForKey:@"p_time"];
                    }
                    
                    [temp addObject:model];
                }
                
                [_modelArray addObject:temp];
            }
            
            
            // NSLog(@"%@", _modelArray);
            [_mainTabTable.mj_footer resetNoMoreData];
            [_mainTabTable.mj_header endRefreshing];
            [_mainTabTable reloadData];
            
            
        }
    }];
}

#pragma - mark table delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return [[_modelArray objectAtIndex:section - 1] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_modelArray count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section  == 0) {
        return (SCREEN_WIDTH-36)/2/169.5*105+24;
    }
    else
    {
        NewMainModel *model = [[self.modelArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        CGFloat realHeight;
        if ([model.img_info isEqualToString:@""]||model.img_info==nil) {
            realHeight = 0.0001;
            return realHeight;
        }
        else
        {
            realHeight = (SCREEN_WIDTH-24) /[model.img_info floatValue];
            return realHeight +133.3;
        }
    }
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        if (banerImgArray.count>0) {
            NSDictionary * dict = banerImgArray[0];
            return SCREEN_WIDTH/[[dict stringForKey:@"img_info"] floatValue];
        }
        
    }
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        SDCycleScrollView * cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        NSMutableArray * array1 = [NSMutableArray array];
        for (NSDictionary * dic in banerImgArray) {
            NSString * str2 = [NSString stringWithFormat:@"%@%@",PIC_HEADURL,[dic stringForKey:@"img_new"]];
            [array1 addObject:str2];
        }
        cycle.imageURLStringsGroup = array1;
        return cycle;
    }
    return nil;
}
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if ([[banerImgArray[index] stringForKey:@"banner_type"] integerValue] == 1) {
        MainTabBanerDetailViewController *mainBaner = [[MainTabBanerDetailViewController alloc] init];
        
        mainBaner.titleContent = [banerImgArray[index] stringForKey:@"title"];
        mainBaner.imageUrl = [banerImgArray[index] stringForKey:@"img"];
        mainBaner.webLink = [banerImgArray[index] stringForKey:@"link"];
        mainBaner.shareLink = [banerImgArray[index] stringForKey:@"share_link"];
        [self getDateBegin:datBegin currentView:@"baner" fatherView:@"首页"];
        [self.navigationController pushViewController:mainBaner animated:YES];
        
    } else if ([[banerImgArray[index] stringForKey:@"banner_type"] integerValue] == 2){
        joinDesignerViewController *joinD = [[joinDesignerViewController alloc] init];
        [self.navigationController pushViewController:joinD animated:YES];
    } else if ([[banerImgArray[index] stringForKey:@"banner_type"] integerValue] == 3) {
        
    } else if ([[banerImgArray[index] stringForKey:@"banner_type"] integerValue] == 6) {
        if ([self userHaveLogin]) {
            inviteNewViewController *invite = [[inviteNewViewController alloc] init];
            [self.navigationController pushViewController:invite animated:YES];
        } else {
            EnterViewController *enter = [[EnterViewController alloc] init];
            //                             enter.loginId = [domain.dataRoot stringForKey:@"id"];
            [self presentViewController:enter animated:YES completion:nil];
        }
        
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    
    if (indexPath.section == 0) {
        
        
        Class currentClass = [DesignerTableViewCell class];
        DesignerTableViewCell *cell = nil;
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        cell.model = designeArray;
        cell.delegate = self;
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        reCell = cell;
        
    } else {
        NewMainModel *model = [[self.modelArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        
        
        Class currentClass = [NewMainTabListTableViewCell class];
        NewMainTabListTableViewCell *cell = nil;
        cell.VC = self;
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        cell.model = model;
        
        
        cell.tag = indexPath.section * 10000 + indexPath.row;
        __weak __typeof(*&cell) weakCell = cell;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [cell setFourBtn:^(UIButton *buttons) {
            switch (buttons.tag) {
                case 21:
                {
                    //1、创建分享参数（必要）
                    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.ImageUrl]]];
                    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
                    [shareParams SSDKSetupShareParamsByText:model.titleContent
                                                     images:imageArray
                                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&type=1&ios=true",URL_HEADURL, URLShare, model.LinkId]]
                                                      title:model.name
                                                       type:SSDKContentTypeWebPage];
                    [ShareCustom shareWithContent:shareParams];
                }
                    break;
                case 22:
                {
                    [params setObject:model.LinkId forKey:@"cid"];
                    [params setObject:@(model.is_type) forKey:@"type"];
                    [shouCangDomain getData:URL_AddSave PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                        if ([self checkHttpResponseResultStatus:shouCangDomain]) {
                            //                            WCLLog(@"%@",domain.dataRoot);
                            if ([[domain.dataRoot objectForKey:@"code"]integerValue]==1) {
                                [weakCell.shouCangBtn setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
                                model.is_collect = 1;
                            }
                            else if ([[domain.dataRoot objectForKey:@"code"]integerValue]==2)
                            {
                                [weakCell.shouCangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                                model.is_collect =0;
                                
                            }
                        }
                    }];
                }break;
                case 23:
                {
                    [params setObject:model.LinkId forKey:@"news_id"];
                    [params setObject:@(model.is_type) forKey:@"is_type"];
                    [loveDomain getData:URL_Love_Main PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                        if ([self checkHttpResponseResultStatus:domain]) {
//                            WCLLog(@"%@",domain.dataRoot);
                            if ([[domain.dataRoot objectForKey:@"data"]integerValue]==1) {
                                [weakCell.xiHuanBtn setImage:[UIImage imageNamed:@"喜欢选中"] forState:UIControlStateNormal];
                                [weakCell.xiHuanBtn setTitle:[NSString stringWithFormat:@"%@",[domain.dataRoot objectForKey:@"lovenum"]] forState:UIControlStateNormal];
                                model.is_love = 1;
                                model.lovenum = model.lovenum+1;
                            }
                            else if ([[domain.dataRoot objectForKey:@"data"]integerValue]==2)
                            {
                                [weakCell.xiHuanBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
                                [weakCell.xiHuanBtn setTitle:[NSString stringWithFormat:@"%@",[domain.dataRoot objectForKey:@"lovenum"]] forState:UIControlStateNormal];
                                model.is_love =0;
                                model.lovenum = model.lovenum-1;
                            }
                        }

                    }];
                }break;
                case 24:
                {
                    
                    MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
                    MainDetail.webId = model.LinkId;
                    MainDetail.imageUrl = model.ImageUrl;
                    MainDetail.linkUrl = model.linkUrl;
                    MainDetail.titleContent =model.subTitle;
                    MainDetail.tagName = model.tagName;
                    MainDetail.titleName =  model.name;
                    [self getDateBegin:datBegin currentView:model.tagName fatherView:@"首页"];
                    [self.navigationController pushViewController:MainDetail animated:YES];
                }break;
                default:
                    break;
            }
        }];
        reCell = cell;
        
    }
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMainModel *model = [[self.modelArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
    MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
    MainDetail.webId = model.LinkId;
    MainDetail.imageUrl = model.ImageUrl;
    MainDetail.linkUrl = model.linkUrl;
    MainDetail.titleContent =model.subTitle;
    MainDetail.tagName = model.tagName;
    MainDetail.titleName =  model.name;
    [self getDateBegin:datBegin currentView:model.tagName fatherView:@"首页"];
    [self.navigationController pushViewController:MainDetail animated:YES];
}

-(void)clickCollectionItem:(NSInteger)item {
    if ([[dianpuArr[item] objectForKey:@"is_type"] intValue] ==1) {//咨询
        ZiXunVC * zixun = [[ZiXunVC alloc]init];
        [self.navigationController pushViewController:zixun animated:YES];
    }else if ([[dianpuArr[item] objectForKey:@"is_type"]intValue] ==3)//店铺
    {
        //门店推荐
        StoresRecommendVC * svc = [[StoresRecommendVC alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }
    else if ([[dianpuArr[item] stringForKey:@"is_type"] isEqualToString:@"2"]) {//成品
        if ([dianpuArr[item][@"goods_type"]intValue]==1) {
            DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
            NSDictionary *dicList = dianpuArr[item];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dicList];
            [dict setObject:[dicList stringForKey:@"goods_id"] forKey:@"id"];
            toButy.goodDic = dict;
            [self.navigationController pushViewController:toButy animated:YES];
        }
        else if([[dianpuArr[item] stringForKey:@"goods_type"]intValue]==2)
        {
            DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
            designerClothes.goodDic = dianpuArr[item];
            //    designerClothes.model = model;
            designerClothes.good_id = [dianpuArr[item] stringForKey:@"goods_id"];
            [self.navigationController pushViewController:designerClothes animated:YES];
        }
    }
}



-(void)hiddenAlert
{
    if (timer.isValid) {
        [timer invalidate];
    }
    timer=nil;
    [alert dismissWithClickedButtonIndex:0 animated:YES];
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
