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
#import "designerHomeViewController.h"
@interface DesignerAndClothesViewController ()<UITableViewDelegate, UITableViewDataSource,DesignerMoreBtnsClickDelegate>

@end

@implementation DesignerAndClothesViewController
{
    NSMutableArray *modelArray;
    UITableView *detailTable;
    NSMutableArray * designerArray;
    NSInteger page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (@available(iOS 11.0, *)) {
        detailTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    page = 1;
    [self getDatas];
    [self createTable];
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_DesignerChengPin_String] parameters:params finished:^(id responseObject, NSError *error) {
        //        WCLLog(@"%@",responseObject);
        if([self checkHttpResponseResultStatus:responseObject])
        {
            [detailTable.mj_footer endRefreshing];
            [detailTable.mj_header endRefreshing];
            modelArray = [designerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"goods"]];
            [detailTable reloadData];
        }
    }];
}

-(void)createTable
{
    detailTable = [[UITableView alloc] initWithFrame:CGRectMake(0,NavHeight, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-88-84:SCREEN_HEIGHT -49 - 64) style:UITableViewStylePlain];
    detailTable.dataSource = self;
    detailTable.delegate = self;
    [detailTable setShowsVerticalScrollIndicator:NO];
    [detailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [detailTable registerClass:[designerinfoNewTableViewCell class] forCellReuseIdentifier:@"designerList"];
    [self.view addSubview:detailTable];
    [WCLMethodTools footerAutoGifRefreshWithTableView:detailTable completion:^{
        page +=1;
        [self reloadAddData];
    }];
    [WCLMethodTools headerRefreshWithTableView:detailTable completion:^{
        page =1;
        [self getDatas];
    }];
}
-(void)reloadAddData
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_DesignerChengPin_String] parameters:params finished:^(id responseObject, NSError *error) {
        [detailTable.mj_footer endRefreshing];
        [detailTable.mj_header endRefreshing];
        if ([self checkHttpResponseResultStatus:responseObject]) {
            NSMutableArray*arr = [designerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"goods"]];
            [modelArray addObjectsFromArray:arr];
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
    designerModel *model = modelArray[indexPath.row];
    CGFloat realHeight;
    if ([model.ad_img_info isEqualToString:@""]||model.ad_img_info ==nil) {
        realHeight =0.0001;
        return realHeight;
    }
    else
    {
        realHeight = (SCREEN_WIDTH-24) /[model.ad_img_info floatValue];
        return 128+realHeight;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    designerinfoNewTableViewCell *reCell = [tableView dequeueReusableCellWithIdentifier:@"designerList" forIndexPath:indexPath];
    designerModel* model = modelArray[indexPath.row];
    reCell.selectionStyle=UITableViewCellSelectionStyleNone;
    reCell.model = model;
    reCell.delegate=self;
    return reCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    designerModel*model = modelArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
    designerClothes.model = model;
    [self.navigationController pushViewController:designerClothes animated:YES];
}
-(void)moreBtnClickWithBtnTag:(NSInteger)tag withModel:(designerModel *)model withCell:(designerinfoNewTableViewCell *)cell
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    switch (tag) {
        case 31:
        {
            //1、创建分享参数（必要）
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.ad_img]]];
            NSMutableDictionary*parameter = [NSMutableDictionary dictionary];
            [parameter setObject:@(model.ID) forKey:@"goods_id"];
            [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_ShareUserForGoodsId_String] parameters:parameter finished:^(id responseObject, NSError *error) {
                if ([self checkHttpResponseResultStatus:responseObject]) {
                    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
                    [shareParams SSDKSetupShareParamsByText:model.title
                                                     images:imageArray
                                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?goods_id=%@",URL_HeadForH5, URL_DingZHi,responseObject[@"goods_id"]]]
                                                      title:model.name
                                                       type:SSDKContentTypeWebPage];
                    [ShareCustom shareWithContent:shareParams];
                }
            }];
        }
            break;
        case 32:
        {
            [params setObject:@(model.ID) forKey:@"rid"];
            [params setObject:@"2" forKey:@"type"];
            [[wclNetTool sharedTools]request:POST urlString:URL_CollectSave parameters:params finished:^(id responseObject, NSError *error) {
                //                        WCLLog(@"%@",responseObject);
                if([self checkHttpResponseResultStatus:responseObject]){
                    if ([responseObject[@"status"]integerValue]==1) {
                        [cell.shouChangBtn setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
                        model.is_collect = 1;
                    }
                    else
                    {
                        [cell.shouChangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                        model.is_collect =0;
                    }
                }
                
            }];
        }
            break;
        case 33:
        {
            [params setObject:@(model.ID) forKey:@"rid"];
            [params setObject:@"2" forKey:@"type"];
            [[wclNetTool sharedTools]request:POST urlString:URL_LoveSave parameters:params finished:^(id responseObject, NSError *error) {
                if ([self checkHttpResponseResultStatus:responseObject]) {
                    if ([responseObject[@"status"]integerValue]==1) {
                        [cell.loveBtn setImage:[UIImage imageNamed:@"喜欢选中"] forState:UIControlStateNormal];
                        [cell.loveBtn setTitle:[NSString stringWithFormat:@"%@",responseObject[@"love_num"]] forState:UIControlStateNormal];
                        model.is_love = 1;
                    }
                    else
                    {
                        [cell.loveBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
                        [cell.loveBtn setTitle:[NSString stringWithFormat:@"%@",responseObject[@"love_num"]] forState:UIControlStateNormal];
                        model.is_love =0;
                    }
                }
            }];
        }
            break;
        default:
            break;
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
