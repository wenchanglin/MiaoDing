//
//  MainTabViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/23.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//
#import "MainTabViewController.h"
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
#import "newMainOtherBanTableViewCell.h"
@interface MainTabViewController ()<UITableViewDataSource, UITableViewDelegate, CellForBanerDownDelegate, MainTableDelegate, DesignerTableViewCellDelegate>
@property (nonatomic, retain) UITableView *mainTabTable;  //首页的table
@property (nonatomic, retain) NSMutableArray *ListArray;  //list content array
@property (nonatomic, retain) NSMutableArray *modelArray;  //model list;
@property (nonatomic, retain) BaseDomain *getBaner;
@end

//[self.tableView scrollToRowAtIndexPath:indexPath
//                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];


@implementation MainTabViewController
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
    
}
-(void)viewWillAppear:(BOOL)animated
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.rdv_tabBarController.navigationController setNavigationBarHidden:YES animated:animated];
    self.rdv_tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //    [self settabImg:@"MainLogo"];
    
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    
    
    
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

    [self getBanerImage];
    [self getDetailData];
    [self createTableView];
    [self getPeiZhi];
    [self getFenLei];
 
}

-(void)getFenLei
{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getFenLei getData:URL_GETFenLei PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getFenLei]) {
            NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            [userD setObject:array forKey:@"FL"];
            
        }
    }];
}

-(void)getPeiZhi
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_UserLoginProtocol_String] parameters:nil finished:^(id responseObject, NSError *error) {
//        WCLLog(@"%@",responseObject);
    }];
//    [getPeiZhi getData:URL_GETPEIZHI PostParams:params finish:^(BaseDomain *domain, Boolean success) {
//        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
//        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"privateKey"] forKey:@"privateKey"];
//        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"appid"] forKey:@"appId"];
//        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"login_img"] forKey:@"loginImage"];
//        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"price_remark"] forKey:@"price_remark"];
//        [userd setObject:[[domain.dataRoot objectForKey:@"data"] stringForKey:@"kf_tel"] forKey:@"kf_tel"];
//        [userd setObject:[domain.dataRoot stringForKey:@"cobbler_banner"] forKey:@"cobbler_banner"];
//
//    }];
}


-(void)getBanerImage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"type"];
    [params setObject:@"1" forKey:@"tid"];
    [_getBaner getData:URL_GetBaner PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:_getBaner]) {
            
            NSLog(@"dasdfsdf");
            banerImgArray = [NSMutableArray arrayWithArray:[_getBaner.dataRoot arrayForKey:@"data"]];
            if ([banerImgArray count] > 1) {
                YYCycleScrollView *cycleScrollView = [[YYCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250) animationDuration:3.0];
                NSMutableArray *viewArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < [banerImgArray count]; i++) {
                    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
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
                    
                    MainTabBanerDetailViewController *mainBaner = [[MainTabBanerDetailViewController alloc] init];
                    
                    mainBaner.titleContent = [banerImgArray[pageIndex] stringForKey:@"title"];
                    mainBaner.imageUrl = [banerImgArray[pageIndex] stringForKey:@"img"];
                    mainBaner.webLink = [banerImgArray[pageIndex] stringForKey:@"link"];
                    mainBaner.shareLink = [banerImgArray[pageIndex] stringForKey:@"share_link"];
                    
                    
                    [self getDateBegin:datBegin currentView:@"baner" fatherView:@"首页"];
                    
                    [self.navigationController pushViewController:mainBaner animated:YES];
                    
                }];
            } else {
                UIImageView *banberImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
                [banberImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [banerImgArray[0] objectForKey:@"img"]]]];
                banberImage.contentMode = UIViewContentModeScaleAspectFill;
                [banberImage.layer setMasksToBounds:YES];
                [banberImage setUserInteractionEnabled:YES];
                _mainTabTable.tableHeaderView = banberImage;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(banerClick)];
                [banberImage addGestureRecognizer:tap];
                
            }
            
            
        }
        
    }];
}

-(void)banerClick
{
    MainTabBanerDetailViewController *mainBaner = [[MainTabBanerDetailViewController alloc] init];
    
    mainBaner.titleContent = [banerImgArray[0] stringForKey:@"title"];
    mainBaner.imageUrl = [banerImgArray[0] stringForKey:@"img"];
    mainBaner.webLink = [banerImgArray[0] stringForKey:@"link"];
    mainBaner.shareLink = [banerImgArray[0] stringForKey:@"share_link"];
    [self getDateBegin:datBegin currentView:@"baner" fatherView:@"首页"];
    [self.navigationController pushViewController:mainBaner animated:YES];
}

-(void)getDetailData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params setObject:@"1" forKey:@"page"];
    [_getBaner getData:URL_GetMain PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:_getBaner]) {
            designerArray = [NSMutableArray arrayWithArray:[_getBaner.dataRoot arrayForKey:@"designer_list"]];
            designeArray = [NewDesignerArray new];
            designeArray.designerArray = designerArray;
            NSArray *array = [_getBaner.dataRoot arrayForKey:@"data"];
            
            for (int i = 0; i < [array count]; i++) {
                NSArray *arrayJ = array[i];
                NSMutableArray *temp = [NSMutableArray array];
                for (int j = 0; j < [arrayJ count]; j ++ ) {
                    NewMainModel *model  = [NewMainModel new];
//                    model.ImageUrl = [arrayJ[j] stringForKey:@"img"];
//                    model.linkUrl = [arrayJ[j] stringForKey:@"link"];
//                    model.LinkId = [arrayJ[j] stringForKey:@"id"];
//                    //                    model.titleContent = [arrayJ[j] stringForKey:@"title"];
//                    model.fenLei = [arrayJ[j] stringForKey:@"name"];
//                    model.name = [arrayJ[j] stringForKey:@"title"];
//                    model.tagName = [arrayJ[j] stringForKey:@"tag_name"];
//                    model.detail = [NSString stringWithFormat:@"%@·%@",[arrayJ[j] stringForKey:@"tag_name"], [arrayJ[j] stringForKey:@"sub_title"]];
//                    if (j == 0) {
//                        model.time = [arrayJ[j] stringForKey:@"p_time"];
//
//
//
//                    }
                    
                    [temp addObject:model];
                }
                
                [_modelArray addObject:temp];
            }
            
            
            NSLog(@"%@", _modelArray);
            
            [_mainTabTable reloadData];
            
            
        }
    }];
}

#pragma -mark tableView create To show the baner and anyother thing like today TUIJIAN

-(void)createTableView
{
    _mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 ) style:UITableViewStyleGrouped];
    _mainTabTable.delegate = self;
    _mainTabTable.dataSource = self;
    _mainTabTable.showsVerticalScrollIndicator = NO;
    [_mainTabTable registerClass:[newMainOtherBanTableViewCell class] forCellReuseIdentifier:NSStringFromClass([newMainOtherBanTableViewCell class])];
    [_mainTabTable registerClass:[DesignerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DesignerTableViewCell class])];
    [self.view addSubview:_mainTabTable];
    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_mainTabTable setBackgroundColor:[UIColor whiteColor]];
    //    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
#pragma - mark Baner create to show the hot adv
    
    
}

#pragma - mark table delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[_modelArray objectAtIndex:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_modelArray count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [titleLabel setBackgroundColor:[UIColor whiteColor]];
    
    
    MainTabModel *model = _modelArray[section ][0];
    [titleLabel setText:[NSString stringWithFormat:@"%@",model.time]];
    
    
    
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];;
    [titleLabel setFont:[UIFont systemFontOfSize:10]];
    [titleView addSubview:titleLabel];
    return titleView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    
    //    if (indexPath.section == 0) {
    //
    //
    //        Class currentClass = [DesignerTableViewCell class];
    //        DesignerTableViewCell *cell = nil;
    //        [cell setBackgroundColor:[UIColor whiteColor]];
    //        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    //        cell.model = designeArray;
    //        cell.delegate = self;
    //        ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    //        reCell = cell;
    //
    //    } else {
    NewMainModel *model = [[self.modelArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row];
    Class currentClass = [newMainOtherBanTableViewCell class];
    newMainOtherBanTableViewCell *cell = nil;
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    cell.model = model;
    cell.tag = indexPath.section * 10000 + indexPath.row;
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    reCell = cell;
    
    //    }
    
    
    //    [reCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ///////////////////////////////////////////////////////////////////////
    return reCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMainModel *model = [[self.modelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
//    MainDetail.webId = model.LinkId;
//    MainDetail.imageUrl = model.ImageUrl;
//    MainDetail.linkUrl = model.linkUrl;
//    MainDetail.titleContent = model.name;
//    MainDetail.tagName = model.tagName;
//    [self getDateBegin:datBegin currentView:model.tagName fatherView:@"首页"];
    [self.navigationController pushViewController:MainDetail animated:YES];
}

-(void)clickCollectionItem:(NSInteger)item {
    
    
    DesignerDetailIntroduce *introduce = [[DesignerDetailIntroduce alloc] init];
    introduce.desginerId = [designerArray[item] stringForKey:@"id"];
    introduce.designerImage = [designerArray[item] stringForKey:@"avatar"];
    introduce.designerName = [designerArray[item] stringForKey:@"name"];
    introduce.remark = [designerArray[item] stringForKey:@"tag"];
    [self.navigationController pushViewController:introduce animated:YES];
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
