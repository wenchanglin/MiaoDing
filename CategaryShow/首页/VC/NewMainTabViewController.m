//
//  MainTabViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/23.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "NewMainTabViewController.h"
#import "NewMainModel.h"
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
@interface NewMainTabViewController ()<UITableViewDataSource, UITableViewDelegate, CellForBanerDownDelegate, MainTableDelegate, DesignerTableViewCellDelegate>
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
    
    UIAlertView *alert;
    NSTimer *timer;
    
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
    getPeiZhi = [BaseDomain getInstance:NO];
    _getBaner = [BaseDomain getInstance:NO];
    getYingDao = [BaseDomain getInstance:NO];
    getFenLei = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    designerArray = [NSMutableArray array];
    _modelArray = [NSMutableArray array];
    detailArray = [NSMutableArray array];
    getNew = [BaseDomain getInstance:NO];
    YDImgArray = [NSMutableArray array];
    page = 1;
    [self createDataGet];
    [self getBanerImage];
    [self getDetailData];
    [self createTableView];
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


-(void)getBanerImage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"type"];
    [params setObject:@"1" forKey:@"tid"];
    [_getBaner getData:URL_GetBaner PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:_getBaner]) {
            
            //NSLog(@"dasdfsdf");
            banerImgArray = [NSMutableArray arrayWithArray:[_getBaner.dataRoot arrayForKey:@"data"]];
            if ([banerImgArray count] > 1) {
                YYCycleScrollView *cycleScrollView = [[YYCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 234) animationDuration:3.0];
                NSMutableArray *viewArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < [banerImgArray count]; i++) {
                    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 234)];
                    [tempImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [banerImgArray[i] objectForKey:@"img"]]]];
                    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
                    tempImageView.clipsToBounds = true;
                    [viewArray addObject:tempImageView];
                }
                [cycleScrollView setFetchContentViewAtIndex:^UIView *(NSInteger(pageIndex)) {
                    return [viewArray objectAtIndex:pageIndex];
                    
                    
                }];
                [cycleScrollView setTotalPagesCount:^NSInteger{
                    return [banerImgArray count];
                }];
                _mainTabTable.tableHeaderView = cycleScrollView;
                
                
                [cycleScrollView setTapActionBlock:^(NSInteger(pageIndex)) {
                    
                    //1-webview；2-设计师详情；3-定制商品；4-成品商品；5-设计师介绍
                    if ([[banerImgArray[pageIndex] stringForKey:@"banner_type"] integerValue] == 1) {
                        MainTabBanerDetailViewController *mainBaner = [[MainTabBanerDetailViewController alloc] init];
                        
                        mainBaner.titleContent = [banerImgArray[pageIndex] stringForKey:@"title"];
                        mainBaner.imageUrl = [banerImgArray[pageIndex] stringForKey:@"img"];
                        mainBaner.webLink = [banerImgArray[pageIndex] stringForKey:@"link"];
                        mainBaner.shareLink = [banerImgArray[pageIndex] stringForKey:@"share_link"];
                        [self getDateBegin:datBegin currentView:@"baner" fatherView:@"首页"];
                        [self.navigationController pushViewController:mainBaner animated:YES];
                        
                    } else if ([[banerImgArray[pageIndex] stringForKey:@"banner_type"] integerValue] == 2){
                        joinDesignerViewController *joinD = [[joinDesignerViewController alloc] init];
                        [self.navigationController pushViewController:joinD animated:YES];
                    } else if ([[banerImgArray[pageIndex] stringForKey:@"banner_type"] integerValue] == 3) {
                        
                    } else if ([[banerImgArray[pageIndex] stringForKey:@"banner_type"] integerValue] == 6) {
                        if ([self userHaveLogin]) {
                            inviteNewViewController *invite = [[inviteNewViewController alloc] init];
                            [self.navigationController pushViewController:invite animated:YES];
                        } else {
                            EnterViewController *enter = [[EnterViewController alloc] init];
                            //                             enter.loginId = [domain.dataRoot stringForKey:@"id"];
                            [self presentViewController:enter animated:YES completion:nil];
                        }
                        
                        
                    }
                    
                }];
            } else {
                UIImageView *banberImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 431.0 / 667 * SCREEN_HEIGHT)];
                [banberImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [banerImgArray[0] objectForKey:@"img"]]]];
                banberImage.contentMode = UIViewContentModeScaleAspectFill;
                [banberImage.layer setMasksToBounds:YES];
                [banberImage setUserInteractionEnabled:YES];
                _mainTabTable.tableHeaderView = banberImage;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(banerClick)];
                [banberImage addGestureRecognizer:tap];
                
            }
        }
        [_mainTabTable reloadData];
    }];
}

-(void)banerClick
{
    
    if ([[banerImgArray[0] stringForKey:@"is_webview"] integerValue] == 1) {
        MainTabBanerDetailViewController *mainBaner = [[MainTabBanerDetailViewController alloc] init];
        
        mainBaner.titleContent = [banerImgArray[0] stringForKey:@"title"];
        mainBaner.imageUrl = [banerImgArray[0] stringForKey:@"img"];
        mainBaner.webLink = [banerImgArray[0] stringForKey:@"link"];
        mainBaner.shareLink = [banerImgArray[0] stringForKey:@"share_link"];
        [self getDateBegin:datBegin currentView:@"baner" fatherView:@"首页"];
        [self.navigationController pushViewController:mainBaner animated:YES];
        
    } else {
        joinDesignerViewController *joinD = [[joinDesignerViewController alloc] init];
        [self.navigationController pushViewController:joinD animated:YES];
    }
    
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
            
            recommend_list = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"recommend_list"]];
            
            designeArray.designerArray = recommend_list;
            
            
            NSArray *array = [_getBaner.dataRoot arrayForKey:@"data"];
            
            for (int i = 0; i < [array count]; i++) {
                NSArray *arrayJ = array[i];
                NSMutableArray *temp = [NSMutableArray array];
                for (int j = 0; j < [arrayJ count]; j ++ ) {
                    NewMainModel *model  = [NewMainModel new];
                    model.ImageUrl = [arrayJ[j] stringForKey:@"img"];
                    model.linkUrl = [arrayJ[j] stringForKey:@"link"];
                    model.LinkId = [arrayJ[j] stringForKey:@"id"];
                    //                    model.titleContent = [arrayJ[j] stringForKey:@"title"];
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,NavHeight-20, SCREEN_WIDTH, SCREEN_HEIGHT - 49+20) style:UITableViewStyleGrouped];
    _mainTabTable.delegate = self;
    _mainTabTable.dataSource = self;
    
    [_mainTabTable registerClass:[NewMainTabListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NewMainTabListTableViewCell class])];
    [_mainTabTable registerClass:[DesignerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DesignerTableViewCell class])];
    [self.view addSubview:_mainTabTable];
    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_mainTabTable setBackgroundColor:[UIColor whiteColor]];
    //    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    _mainTabTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self reloadData];
        [self getBanerImage];
        // 这个地方是网络请求的处理
    }];
    
    
    _mainTabTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
            [_mainTabTable.mj_footer endRefreshing];
        });
        
        // 结束刷新
        
        
    }];
    
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
            
            
            recommend_list = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"recommend_list"]];
            
            designeArray.designerArray = recommend_list;
            NSArray *array = [_getBaner.dataRoot arrayForKey:@"data"];
            
            if ([array count] > 0) {
                for (int i = 0; i < [array count]; i++) {
                    NSArray *arrayJ = array[i];
                    NSMutableArray *temp = [NSMutableArray array];
                    for (int j = 0; j < [arrayJ count]; j ++ ) {
                        NewMainModel *model  = [NewMainModel new];
                        model.ImageUrl = [arrayJ[j] stringForKey:@"img"];
                        model.linkUrl = [arrayJ[j] stringForKey:@"link"];
                        model.LinkId = [arrayJ[j] stringForKey:@"id"];
                        //                    model.titleContent = [arrayJ[j] stringForKey:@"title"];
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
    [_modelArray removeAllObjects];
    [designerArray removeAllObjects];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [_getBaner getData:URL_GetMain PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:_getBaner]) {
            designerArray = [NSMutableArray arrayWithArray:[_getBaner.dataRoot arrayForKey:@"designer_list"]];
            designeArray = [NewDesignerArray new];
            
            recommend_list = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"recommend_list"]];
            
            designeArray.designerArray = recommend_list;
            NSArray *array = [_getBaner.dataRoot arrayForKey:@"data"];
            
            for (int i = 0; i < [array count]; i++) {
                NSArray *arrayJ = array[i];
                NSMutableArray *temp = [NSMutableArray array];
                for (int j = 0; j < [arrayJ count]; j ++ ) {
                    NewMainModel *model  = [NewMainModel new];
                    model.ImageUrl = [arrayJ[j] stringForKey:@"img"];
                    model.linkUrl = [arrayJ[j] stringForKey:@"link"];
                    model.LinkId = [arrayJ[j] stringForKey:@"id"];
                    //                    model.titleContent = [arrayJ[j] stringForKey:@"title"];
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 80, 18)];
        [titleLabel setBackgroundColor:[UIColor whiteColor]];
        
        titleLabel.text = @"店铺活动";
        titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        titleLabel.font =[UIFont fontWithName:@"PingFangSC-Light" size:15];
        [titleView addSubview:titleLabel];
        return titleView;
    }
    else return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section  == 0) {
        return 133;
    }
    return 321;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        return 38;
    }
    return 0.0001;
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
        NewMainModel *model = [[self.modelArray objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
        
        
        Class currentClass = [NewMainTabListTableViewCell class];
        NewMainTabListTableViewCell *cell = nil;
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
        cell.model = model;
        cell.tag = indexPath.section * 10000 + indexPath.row;
        
        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
        reCell = cell;
        
    }
    
    
    [reCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ///////////////////////////////////////////////////////////////////////
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
    
    
    
    if ([[designerArray[item] stringForKey:@"name"] isEqualToString:@"虚位以待"]) {
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"妙定期待您的加入～" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hiddenAlert) userInfo:nil repeats:NO];
    } else {
        //门店推荐
        StoresRecommendVC * svc = [[StoresRecommendVC alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
        
        //        if ([[recommend_list[item] stringForKey:@"goods_type"] isEqualToString:@"1"]) {
        //
        //
        //            DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
        //            NSDictionary *dicList = recommend_list[item];
        //            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dicList];
        //            [dic setObject:[dicList stringForKey:@"goods_id"] forKey:@"id"];
        //            toButy.goodDic = dic;
        //
        //            [self.navigationController pushViewController:toButy animated:YES];
        //
        //        } else {
        //            DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
        //            designerClothes.goodDic = recommend_list[item];
        //
        //            //    designerClothes.model = model;
        //            designerClothes.good_id = [recommend_list[item] stringForKey:@"goods_id"];
        //            [self.navigationController pushViewController:designerClothes animated:YES];
        //        }
        
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
