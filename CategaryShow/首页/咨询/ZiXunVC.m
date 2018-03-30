
//
//  ZiXunVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/15.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "ZiXunVC.h"
#import "NewMainTabListTableViewCell.h"
#import "ZiXunModel.h"
#import "MainTabDetailViewController.h"
#import "ZiXuCell.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#define URLShare @"/web/jquery-obj/static/fx/html/designer.html"
@interface ZiXunVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)BaseDomain * getdomain;
@property (nonatomic, retain) UITableView *mainTabTable;  //首页的table
@property (nonatomic, retain) NSMutableArray *ListArray;  //list content array
@end

@implementation ZiXunVC
{
    NSInteger page;
    BaseDomain * shouCangDomain;
    BaseDomain *  loveDomain;
    NSDate *datBegin;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"资讯"];
    page =1;
    _getdomain = [BaseDomain getInstance:NO];
    shouCangDomain = [BaseDomain getInstance:NO];
    loveDomain = [BaseDomain getInstance:NO];
    [self getDatas];
    [self createUI];
}
-(void)createUI{
    
    _mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        self.mainTabTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _mainTabTable.delegate = self;
    _mainTabTable.dataSource = self;
    self.mainTabTable.estimatedSectionHeaderHeight = 0;
    [_mainTabTable registerClass:[ZiXuCell class] forCellReuseIdentifier:@"zixunCell"];
    [self.view addSubview:_mainTabTable];
    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_mainTabTable setBackgroundColor:[UIColor whiteColor]];
    self.mainTabTable.estimatedSectionHeaderHeight = 0;
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
-(void)getDatas
{
    NSMutableDictionary * parmeter = [NSMutableDictionary dictionary];
    [parmeter setObject:@(page) forKey:@"page"];
    [_getdomain getData:URL_ZiXun PostParams:parmeter finish:^(BaseDomain *domain, Boolean success) {
        _ListArray  = [ZiXunModel mj_objectArrayWithKeyValuesArray:[[domain.dataRoot objectForKey:@"data"] objectForKey:@"data"]];
        [_mainTabTable reloadData];
    }];
}
-(void)reloadData
{
    page = 1;
    NSMutableDictionary * parmeter = [NSMutableDictionary dictionary];
    [parmeter setObject:@(page) forKey:@"page"];
    [_getdomain getData:URL_ZiXun PostParams:parmeter finish:^(BaseDomain *domain, Boolean success) {
        [_ListArray removeAllObjects];
        [_mainTabTable.mj_header endRefreshing];
        _ListArray  = [ZiXunModel mj_objectArrayWithKeyValuesArray:[[domain.dataRoot objectForKey:@"data"] objectForKey:@"data"]];
        [_mainTabTable reloadData];
    }];
}
-(void)reloadAddData
{
    page ++;
    NSMutableDictionary * parmeter = [NSMutableDictionary dictionary];
    [parmeter setObject:@(page) forKey:@"page"];
    [_getdomain getData:URL_ZiXun PostParams:parmeter finish:^(BaseDomain *domain, Boolean success) {
        [_mainTabTable.mj_footer endRefreshing];
        NSMutableArray * array = [ZiXunModel mj_objectArrayWithKeyValuesArray:[[domain.dataRoot objectForKey:@"data"] objectForKey:@"data"]];
        [_ListArray addObjectsFromArray:array];
        [_mainTabTable reloadData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ListArray.count;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZiXunModel *model = self.ListArray[indexPath.row];
    CGFloat realHeight;
    if ([model.img_info isEqualToString:@""]||model.img_info==nil) {
        realHeight = 0.0001;
    }
    else
    {
    //WCLLog(@"%@--%@",model.title,model.img_info);
    realHeight = (SCREEN_WIDTH-24) /[model.img_info floatValue];
    }
    return realHeight +133.3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell;
    
   
    ZiXunModel *model = _ListArray[indexPath.row];
    
    ZiXuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zixunCell"];
    if (!cell) {
        cell = [[ZiXuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zixunCell"];
    }
        cell.VC = self;
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.models = model;
//        cell.zhuanFaBtn.hidden =YES;
       // cell.tag = indexPath.section * 10000 + indexPath.row;
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
                    [shareParams SSDKSetupShareParamsByText:model.sub_title
                                                     images:imageArray
                                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%ld&type=1&ios=true",URL_HEADURL, URLShare, model.ID]]
                                                      title:model.title
                                                       type:SSDKContentTypeWebPage];
                    [ShareCustom shareWithContent:shareParams];
                }
                    break;
                case 22:
                {
                    [params setObject:@(model.ID) forKey:@"cid"];
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
                    [params setObject:@(model.ID) forKey:@"news_id"];
                    [params setObject:@(model.is_type) forKey:@"is_type"];
                    [loveDomain getData:URL_Love_Main PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                        if ([self checkHttpResponseResultStatus:loveDomain]) {
                            //WCLLog(@"%@",domain.dataRoot);
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
                    MainDetail.webId = [NSString stringWithFormat:@"%ld",model.ID];
                    MainDetail.imageUrl = model.img;
//                       MainDetail.linkUrl = model.linkUrl;
                    MainDetail.titleContent =model.sub_title;
                    MainDetail.tagName = @"咨询页面";
                    MainDetail.titleName =  model.title;
                    [self getDateBegin:datBegin currentView:@"咨询页面" fatherView:@"首页"];
                    [self.navigationController pushViewController:MainDetail animated:YES];
                }break;
                default:
                    break;
            }
        }];
        reCell = cell;
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZiXunModel *model = _ListArray[indexPath.row];
    MainTabDetailViewController *MainDetail = [[MainTabDetailViewController alloc] init];
    MainDetail.webId = [NSString stringWithFormat:@"%ld",model.ID];
    MainDetail.imageUrl = model.img;
//    MainDetail.linkUrl = model.linkUrl;
    MainDetail.titleContent =model.sub_title;
    MainDetail.tagName = @"咨询页面";
    MainDetail.titleName =  model.title;
    [self getDateBegin:datBegin currentView:@"咨询页面" fatherView:@"首页"];
    [self.navigationController pushViewController:MainDetail animated:YES];
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
