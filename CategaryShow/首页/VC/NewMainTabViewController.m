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

#import "UIImageView+WebCache.h"
#import "XHWebImageAutoSize.h"
@interface NewMainTabViewController ()<UITableViewDataSource, UITableViewDelegate, CellForBanerDownDelegate, MainTableDelegate, DesignerTableViewCellDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, retain) UITableView *mainTabTable;  //首页的table
@property (nonatomic, retain) NSMutableArray *ListArray;  //list content array
@property (nonatomic, retain) NSMutableArray *modelArray;  //model list;
@property (nonatomic, retain) BaseDomain *getBaner;

@end



@implementation NewMainTabViewController
{
    NSMutableArray *banerImgArray;
    NSMutableArray *detailArray;
    NSMutableArray *designerArray;
    NewDesignerArray *designeArray;
    NSDate *datBegin;
    
    UIAlertView *alert;
    NSTimer *timer;
    NSMutableArray * dianpuArr;
    NSInteger page;
    NSMutableArray *YDImgArray;
    UIImageView *imag;
    NSMutableArray *recommend_list;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    [MobClick beginLogPageView:@"首页"];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首页"];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.mainTabTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    recommend_list = [NSMutableArray array];
    designerArray = [NSMutableArray array];
    _modelArray = [NSMutableArray array];
    detailArray = [NSMutableArray array];
    dianpuArr = [NSMutableArray array];
    YDImgArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetNewUser) name:@"showmoney" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDetailData) name:@"loginSuccess" object:nil];
    page = 1;
    [self createDataGet];
    [self createTableView];
    [self getDetailData];
    [self getPeiZhi];
    [self getFenLei];
}
#pragma mark - 获取数据
-(void)createDataGet
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [[wclNetTool sharedTools]request:GET urlString:URL_GetUserInfo parameters:params finished:^(id responseObject, NSError *error) {
        if ([responseObject[@"code"]integerValue]==10000) {
//            WCLLog(@"%@",responseObject);
            //            [[SelfPersonInfo shareInstance].userModelsetPersonInfoFromJsonData:responseObject];
        }
    }];
}

-(void)getFenLei
{
    [[wclNetTool sharedTools]request:POST urlString:URL_GETFenLei parameters:nil finished:^(id responseObject, NSError *error) {
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        NSMutableArray *array = responseObject[@"data"];
//        WCLLog(@"%@",array);
        [userD setObject:array forKey:@"FL"];
    }];
}

-(void)createNewUser
{
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
    // 这里判断是否第一次
    imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imag.contentMode=UIViewContentModeScaleAspectFill;
    [imag setUserInteractionEnabled:YES];
    UIWindow *win = self.view.window;
    [imag sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, YDImgArray[0]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            CGFloat scan = image.size.width / image.size.height;
            if (iPadDevice) {
                imag.frame = CGRectMake(0,0, SCREEN_WIDTH,SCREEN_WIDTH/scan-280);
            }
            else
            {
                imag.frame = CGRectMake(0,0, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?150+SCREEN_WIDTH/scan:SCREEN_WIDTH/scan);
            }
        }
        else
        {
            [imag setFrame:CGRectMake(0, 0, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?150+SCREEN_WIDTH:SCREEN_WIDTH)];
            
        }
    }];
    
    
    UIButton *buttonLogin = [[UIButton alloc] initWithFrame:CGRectMake(86.0 / 375.0 * SCREEN_WIDTH, 385 / 667.0 * SCREEN_HEIGHT, 203 / 375.0 * SCREEN_WIDTH, 48.0 / 667.0 * SCREEN_HEIGHT)];
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
    
    //    }
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
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_GetYinDaoForID_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            YDImgArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"data"] arrayForKey:@"img_urls"]];
            [self createNewUser];
        }
    }];
}

//
-(void)getPeiZhi
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_GetKeFuPhone_String] parameters:nil finished:^(id responseObject, NSError *error) {
        if ([responseObject[@"data"]count]>0) {
            [userd setObject:[[responseObject objectForKey:@"data"] stringForKey:@"kf_tel"] forKey:@"kf_tel"];
        }
    }];
}
//
-(void)getDetailData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:URL_GetMain parameters:params finished:^(id responseObject, NSError *error) {
        if([self checkHttpResponseResultStatus:responseObject])
        {
            designeArray = [NewDesignerArray new];
            banerImgArray = [NSMutableArray arrayWithArray:[responseObject[@"data"] arrayForKey:@"banner"]];
            dianpuArr = [NSMutableArray arrayWithArray:[responseObject[@"data"] arrayForKey:@"indextype"]];
            designeArray.designerArray = dianpuArr;
            NSArray*article = [responseObject[@"data"] arrayForKey:@"article"];
            _modelArray = [NewMainModel mj_objectArrayWithKeyValuesArray:article];
            [_mainTabTable.mj_header endRefreshing];
            [_mainTabTable.mj_footer resetNoMoreData];
            [_mainTabTable reloadData]; 
        }
    }];
    
}

-(void)createTableView
{
    _mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?NavHeight-44:NavHeight-20, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-40:SCREEN_HEIGHT - 29) style:UITableViewStyleGrouped];
    _mainTabTable.delegate = self;
    _mainTabTable.dataSource = self;
    self.mainTabTable.estimatedSectionHeaderHeight = 0;
    self.mainTabTable.estimatedSectionFooterHeight=0;
    [_mainTabTable registerClass:[NewMainTabListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NewMainTabListTableViewCell class])];
    [_mainTabTable registerClass:[DesignerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DesignerTableViewCell class])];
    [self.view addSubview:_mainTabTable];
    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_mainTabTable setBackgroundColor:[UIColor whiteColor]];
    [WCLMethodTools headerRefreshWithTableView:_mainTabTable completion:^{
        page=1;
        [self getDetailData];
        
    }];
    [WCLMethodTools footerAutoGifRefreshWithTableView:_mainTabTable completion:^{
        page ++;
        [self reloadAddData];
        
    }];
}
-(void)reloadAddData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:URL_GetMain parameters:params finished:^(id responseObject, NSError *error) {
        designeArray = [NewDesignerArray new];
        banerImgArray = [NSMutableArray arrayWithArray:[responseObject[@"data"] arrayForKey:@"banner"]];
        dianpuArr = [NSMutableArray arrayWithArray:[responseObject[@"data"] arrayForKey:@"indextype"]];
        designeArray.designerArray = dianpuArr;
        NSArray*article = [responseObject[@"data"] arrayForKey:@"article"];
        if ([article count]>0) {
            NSMutableArray*arr2 = [NewMainModel mj_objectArrayWithKeyValuesArray:article];
            for (NewMainModel*twomodel in arr2) {
                [_modelArray addObject:twomodel];
            }
            [_mainTabTable.mj_footer endRefreshing];
            [_mainTabTable reloadData];
        }
        else
        {
            [_mainTabTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma - mark table delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return _modelArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//
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
        NewMainModel *model = self.modelArray[indexPath.row];
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
                    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.img]]];
                    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
                    [shareParams SSDKSetupShareParamsByText:model.title
                                                     images:imageArray
                                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&type=1&ios=true",URL_HEADURL, URLShare, @(model.ID)]]
                                                      title:model.name
                                                       type:SSDKContentTypeWebPage];
                    [ShareCustom shareWithContent:shareParams];
                }
                    break;
                case 22:
                {
                    [params setObject:@(model.ID) forKey:@"rid"];
                    [params setObject:@"1" forKey:@"type"];
                    [[wclNetTool sharedTools]request:POST urlString:URL_CollectSave parameters:params finished:^(id responseObject, NSError *error) {
                        //                        WCLLog(@"%@",responseObject);
                        if([self checkHttpResponseResultStatus:responseObject]){
                            if ([responseObject[@"status"]integerValue]==1) {
                                [weakCell.shouCangBtn setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
                                model.is_collect = 1;
                            }
                            else
                            {
                                [weakCell.shouCangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                                model.is_collect =0;
                            }
                        }
                        
                    }];
                }break;
                case 23:
                {
                    [params setObject:@(model.ID) forKey:@"rid"];
                    [params setObject:@"1" forKey:@"type"];
                    [[wclNetTool sharedTools]request:POST urlString:URL_LoveSave parameters:params finished:^(id responseObject, NSError *error) {
                        //                        WCLLog(@"%@",responseObject);
                        if ([self checkHttpResponseResultStatus:responseObject]) {
                            if ([responseObject[@"status"]integerValue]==1) {
                                [weakCell.xiHuanBtn setImage:[UIImage imageNamed:@"喜欢选中"] forState:UIControlStateNormal];
                                [weakCell.xiHuanBtn setTitle:[NSString stringWithFormat:@"%@",responseObject[@"love_num"]] forState:UIControlStateNormal];
                                model.is_love = 1;
                            }
                            else
                            {
                                [weakCell.xiHuanBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
                                [weakCell.xiHuanBtn setTitle:[NSString stringWithFormat:@"%@",responseObject[@"love_num"]] forState:UIControlStateNormal];
                                model.is_love =0;
                            }
                        }
                    }];
                    
                }break;
                case 24:
                {
                    MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
                    MainDetail.webId = [NSString stringWithFormat:@"%@",@(model.ID)];
                    MainDetail.imageUrl = model.img;
                    MainDetail.titleName =  model.name;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section  == 0) {
        if (dianpuArr.count>0) {
            NSString*infos = [dianpuArr[0] stringForKey:@"img_info"];//indexPath.row
            if (iPadDevice) {
                return 142+((SCREEN_WIDTH-20)/2.5/[infos floatValue]);
            }
            else
            {
                return [ShiPeiIphoneXSRMax isIPhoneX]?110+(SCREEN_WIDTH/2/[infos floatValue]):150+(SCREEN_WIDTH/2/[infos floatValue]);;
            }
        }
       
    }
    else
    {
        NewMainModel *model = self.modelArray[indexPath.row];
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
        SDCycleScrollView * cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) delegate:self placeholderImage:[UIImage imageNamed:@"loading"]];
        NSMutableArray * array1 = [NSMutableArray array];
        for (NSDictionary * dic in banerImgArray) {
            NSString * str2 = [NSString stringWithFormat:@"%@%@",PIC_HEADURL,[dic stringForKey:@"img"]];
            [array1 addObject:str2];
        }
        cycle.imageURLStringsGroup = array1;
       
        return cycle;
    }
    return nil;
}

#pragma mark - 广告栏
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //1.咨询，2.申请入驻，3.定制商铺，4.成品，5.设计师详情，6.邀请有礼
    [MobClick event:@"banner" label:[SelfPersonInfo shareInstance].userModel.username];
    if ([[banerImgArray[index] stringForKey:@"type"] integerValue] == 1) {//webview
        MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
        MainDetail.webId = [banerImgArray[index] stringForKey:@"link"];
        MainDetail.imageUrl = [banerImgArray[index] stringForKey:@"img"];
        MainDetail.titleName= [banerImgArray[index] stringForKey:@"name"];
        [self.navigationController pushViewController:MainDetail animated:YES];
    } else if ([[banerImgArray[index] stringForKey:@"type"] integerValue] == 2){//设计师入驻
        joinDesignerViewController *joinD = [[joinDesignerViewController alloc] init];
        [MobClick event:@"apply_join" label:[SelfPersonInfo shareInstance].userModel.username];
        [self.navigationController pushViewController:joinD animated:YES];
    } else if ([[banerImgArray[index] stringForKey:@"type"] integerValue] == 3) {//定制
        DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
        NSMutableDictionary *dict= [NSMutableDictionary dictionary];
        [dict setObject:[banerImgArray[index] stringForKey:@"link"] forKey:@"id"];
        toButy.goodDic = dict;
        toButy.good_id = [banerImgArray[index] stringForKey:@"id"];
        [self.navigationController pushViewController:toButy animated:YES];
    }
    else if ([[banerImgArray[index] stringForKey:@"type"] integerValue] == 4)//成品
    {
        DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
        designerClothes.good_id =[banerImgArray[index] stringForKey:@"link"];
        [self.navigationController pushViewController:designerClothes animated:YES];
    }
    else if ([[banerImgArray[index] stringForKey:@"type"] integerValue] == 5){//设计师详情
        designerHomeViewController * designer = [[designerHomeViewController alloc]init];
        designer.desginerId = [banerImgArray[index] stringForKey:@"link"];
        [self.navigationController pushViewController:designer animated:YES];
    }
    else if ([[banerImgArray[index] stringForKey:@"type"] integerValue] == 6) {
        if ([self userHaveLogin]) {
            inviteNewViewController *invite = [[inviteNewViewController alloc] init];
            [self.navigationController pushViewController:invite animated:YES];
        } else {
            EnterViewController *enter = [[EnterViewController alloc] init];
            //  enter.loginId = [domain.dataRoot stringForKey:@"id"];
            [self presentViewController:enter animated:YES completion:nil];
        }
        
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewMainModel *model =self.modelArray[indexPath.row];
    MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
    MainDetail.webId = [NSString stringWithFormat:@"%@",@(model.ID)];
    MainDetail.imageUrl = model.img;
    MainDetail.titleName =  model.name;
    [self.navigationController pushViewController:MainDetail animated:YES];
}
//
-(void)clickCollectionItem:(NSInteger)item {
    //    WCLLog(@"%@",dianpuArr[item]);
    //1.咨询列表，2.定制商品,3.成品,4.店铺列表，5.设计师详情
    if ([[dianpuArr[item] objectForKey:@"type"] intValue] ==1) {//咨询
        MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
        MainDetail.webId = [dianpuArr[item] stringForKey:@"link"];
        MainDetail.imageUrl = [dianpuArr[item] stringForKey:@"img"];
        MainDetail.titleName= [dianpuArr[item] stringForKey:@"name"];
        [self.navigationController pushViewController:MainDetail animated:YES];
        
    }
    else if ([[dianpuArr[item] stringForKey:@"type"] isEqualToString:@"2"]) {
        
        DiyClothesDetailViewController *toButy = [[DiyClothesDetailViewController alloc] init];
        NSDictionary *dicList = dianpuArr[item];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dicList];
        [dict setObject:[dicList stringForKey:@"link"] forKey:@"id"];
        toButy.goodDic = dict;
        toButy.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:toButy animated:YES];
        
        
    }
    else if ([[dianpuArr[item] stringForKey:@"type"] isEqualToString:@"3"])
    {
        DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
        designerModel *Model = [designerModel new];
        Model.ID=[[dianpuArr[item] stringForKey:@"link"] integerValue];
        designerClothes.model =Model;
        [self.navigationController pushViewController:designerClothes animated:YES];
    }
    else if ([[dianpuArr[item] objectForKey:@"type"]intValue] ==4)//店铺
    {
        //门店推荐
        StoresRecommendVC * svc = [[StoresRecommendVC alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }
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
