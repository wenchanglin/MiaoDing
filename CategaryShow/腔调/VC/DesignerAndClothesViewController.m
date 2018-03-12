//
//  DesignerAndClothesViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/13.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "DesignerAndClothesViewController.h"
#import "designerinfoNewTableViewCell.h"
#import "DesignerClothesDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#define URLShare @"/web/jquery-obj/static/fx/html/designer.html"
#import "designerHomeViewController.h"
@interface DesignerAndClothesViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DesignerAndClothesViewController
{
    BaseDomain *getData;
    BaseDomain * shouCangDomain;
    BaseDomain * loveDomain;
    NSMutableArray *modelArray;
    UITableView *detailTable;
    NSMutableArray * designerArray;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    page = 1;
    getData = [BaseDomain getInstance:NO];
    shouCangDomain = [BaseDomain getInstance:NO];
    loveDomain = [BaseDomain getInstance:NO];
    [self getDatas];
    [self createTable];
}

-(void)getDatas
{
    NSDictionary *params = [NSDictionary dictionary];
    params = @{@"page":@(page)};
    [[wclNetTool sharedTools]request:GET urlString:URL_designerChengP parameters:params finished:^(id responseObject, NSError *error) {
        designerArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"data"] arrayForKey:@"data"]];
        for (NSDictionary *dic in designerArray) {
            designerModel *model = [designerModel mj_objectWithKeyValues:dic];
            [modelArray addObject:model];
        }
        [detailTable reloadData];
        
    }];
}

-(void)createTable
{
    detailTable = [[UITableView alloc] initWithFrame:CGRectMake(0,NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        detailTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    detailTable.dataSource = self;
    detailTable.delegate = self;
    [detailTable setShowsVerticalScrollIndicator:NO];
    [detailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [detailTable registerClass:[designerinfoNewTableViewCell class] forCellReuseIdentifier:@"designerList"];
    [self.view addSubview:detailTable];
    
    detailTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page =1;
        [self reloadData];
        // 这个地方是网络请求的处理
    }];
    
    
    detailTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAddData];
            [detailTable.mj_footer endRefreshing];
        });
        
        // 结束刷新
        
        
    }];
    
}

-(void)reloadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [getData getData:URL_designerChengP PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            [modelArray removeAllObjects];
            designerArray = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]];
            for (NSDictionary *dic in designerArray) {
                designerModel *model = [designerModel mj_objectWithKeyValues:dic];
                [modelArray addObject:model];
            }
            [detailTable.mj_header endRefreshing];
            
            [detailTable reloadData];
        }
        
    }];
}

-(void)reloadAddData
{
    page ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [getData getData:URL_designerChengP PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"data"]) {
                [designerArray addObject:dic] ;
                designerModel *model = [designerModel mj_objectWithKeyValues:dic];
              
                [modelArray addObject:model];
            }
            
            [detailTable reloadData];
        }
        
    }];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 428;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    designerinfoNewTableViewCell *reCell = [tableView dequeueReusableCellWithIdentifier:@"designerList" forIndexPath:indexPath];
    designerModel* model = modelArray[indexPath.row];
    reCell.model = model;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __weak __typeof(*&reCell) weakCell = reCell;

    [reCell setFourBtns:^(UIButton *buttons) {
        switch (buttons.tag) {
            case 31:
            {
                //1、创建分享参数（必要）
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.img]]];
                [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
                [shareParams SSDKSetupShareParamsByText:model.title
                                                 images:imageArray
                                                    url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?goods_id=%@&type=2",URL_HEADURL, Share_ChengPin, model.goods_id]]
                                                  title:model.name
                                                   type:SSDKContentTypeWebPage];
                [ShareCustom shareWithContent:shareParams];
            }
                break;
            case 32:
            {
                [params setObject:model.goods_id forKey:@"cid"];
                [params setObject:@(2) forKey:@"type"];
                [shouCangDomain getData:URL_AddSave PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                    if ([self checkHttpResponseResultStatus:shouCangDomain]) {
                        //                            WCLLog(@"%@",domain.dataRoot);
                        if ([[domain.dataRoot objectForKey:@"code"]integerValue]==1) {
                            [weakCell.shouChangBtn setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
                            
                        }
                        else if ([[domain.dataRoot objectForKey:@"code"]integerValue]==2)
                        {
                            [weakCell.shouChangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                        }
                    }
                }];
            }
                break;
            case 33:
            {
                [params setObject:model.goods_id forKey:@"news_id"];
                [params setObject:@(2) forKey:@"is_type"];
                [loveDomain getData:URL_Love_Main PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                    if ([self checkHttpResponseResultStatus:loveDomain]) {
                   //     WCLLog(@"%@",domain.dataRoot);
                        if ([[domain.dataRoot objectForKey:@"data"]integerValue]==1) {
                            [weakCell.loveBtn setImage:[UIImage imageNamed:@"喜欢选中"] forState:UIControlStateNormal];
                            [weakCell.loveBtn setTitle:[NSString stringWithFormat:@"%@",[domain.dataRoot objectForKey:@"lovenum"]] forState:UIControlStateNormal];
                        }
                        else if ([[domain.dataRoot objectForKey:@"data"]integerValue]==2)
                        {
                            [weakCell.loveBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
                            [weakCell.loveBtn setTitle:[NSString stringWithFormat:@"%@",[domain.dataRoot objectForKey:@"lovenum"]] forState:UIControlStateNormal];
                        }
                    }
                    
                }];
            }
                break;
            default:
                break;
        }
    }];
    [reCell setDesignerInfo:^(UITapGestureRecognizer *tap) {
        designerHomeViewController * designer = [[designerHomeViewController alloc]init];
        designer.desginerId = [NSString stringWithFormat:@"%zd",model.des_uid];
        designer.designerImage = model.avatar;
        designer.designerName = model.uname;
        designer.remark = model.tag;
//        designer.designerStory = mo
        [self.navigationController pushViewController:designer animated:YES];
    }];
    [reCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return reCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
    designerClothes.goodDic = designerArray[indexPath.row];
    //    designerClothes.model = model;
    designerClothes.good_id = [designerArray[indexPath.row] stringForKey:@"recommend_goods_ids"];
    [self.navigationController pushViewController:designerClothes animated:YES];
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
