//
//  designerProductViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/6.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "designerProductViewController.h"
#import "NewDesignerModel.h"
#import "designerInfoTableViewCell.h"
#import "DesignerClothesDetailViewController.h"
#import "DesignerZuoPinCell.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#define URLShare @"/web/jquery-obj/static/fx/html/designer.html"
@interface designerProductViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation designerProductViewController
{
    UITableView *desinger;
    BaseDomain *getData;
    BaseDomain * shouCangDomain;
    BaseDomain * loveDomain;
    NSMutableDictionary *designerDic;
    NSMutableArray *modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    shouCangDomain = [BaseDomain getInstance:NO];
    loveDomain = [BaseDomain getInstance:NO];
    designerDic = [NSMutableDictionary dictionary];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getDatas];
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_desginerId forKey:@"uid"];
    [getData getData:URL_GetDesignerDeetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            designerDic = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
            for (NSDictionary *dic in [designerDic arrayForKey:@"goods_list"]) {
                WCLLog(@"%@",dic);
                DesignerGoodsListModel *model = [DesignerGoodsListModel mj_objectWithKeyValues:dic];
                [modelArray addObject:model];
            }
            
            [self createDeisgner];
        }
    }];
}

-(void)createDeisgner
{
    desinger = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH,IsiPhoneX?SCREEN_HEIGHT-88:SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    
    desinger.delegate = self;
    desinger.dataSource = self;
    [desinger registerClass:[DesignerZuoPinCell class] forCellReuseIdentifier:@"designerzuopin"];
    [self.view addSubview:desinger];
    [desinger setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    
    if ([modelArray count] > 0) {
        desinger.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    } else {
        [self footBack];
    }
    
    
    
}

-(void)footBack
{
    UIView *noDesiback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (392 / 2 + 40))];
    //    [noDesiback setBackgroundColor:[UIColor blackColor]];
    desinger.tableFooterView = noDesiback;
    
    UIImageView *noDes = [UIImageView new];
    [noDesiback addSubview:noDes];
    
    noDes.sd_layout
    .centerXEqualToView(noDesiback)
    .centerYEqualToView(noDesiback)
    .heightIs(442 / 2)
    .widthIs(422 / 2);
    
    [noDes setImage:[UIImage imageNamed:@"noDes"]];
    
}

-(void)backClickAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DesignerGoodsListModel *model = modelArray[indexPath.row];
//    WCLLog(@"%@--%@",model.name,model.img_info);
    CGFloat realHeight;
    if ([model.img_info isEqualToString:@""]||model.img_info==nil) {
        realHeight = 0.0001;
    }
    else
    {
     realHeight = (SCREEN_WIDTH-24) /[model.img_info floatValue];
    }
    return realHeight+113.3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DesignerZuoPinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"designerzuopin" forIndexPath:indexPath];
    DesignerGoodsListModel * model =modelArray[indexPath.row];
    cell.models = model;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __weak __typeof(*&cell) weakCell = cell;
    [cell setZuoPinFourBtns:^(UIButton *buttons) {
        switch (buttons.tag) {
            case 41:
            {
                //1、创建分享参数（必要）
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.thumb]]];
                [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
                [shareParams SSDKSetupShareParamsByText:model.sub_name
                                                 images:imageArray
                                                    url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?goods_id=%zd&type=2&shareout_id=%@", URL_HEADURL,Share_ChengPin, model.goodsListId,[SelfPersonInfo getInstance].personUserKey]]
                                                  title:model.name
                                                   type:SSDKContentTypeWebPage];
                [ShareCustom shareWithContent:shareParams];
            }
                break;
            case 42:
            {
                [params setObject:@(model.goodsListId) forKey:@"cid"];
                [params setObject:@(2) forKey:@"type"];
                [shouCangDomain getData:URL_AddSave PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                    if ([self checkHttpResponseResultStatus:shouCangDomain]) {
//                        WCLLog(@"%@",domain.dataRoot);
                        if ([[domain.dataRoot objectForKey:@"code"]integerValue]==1) {
                            [weakCell.shouChangBtn setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
                            model.is_collect = 1;
                            
                        }
                        else if ([[domain.dataRoot objectForKey:@"code"]integerValue]==2)
                        {
                            [weakCell.shouChangBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                            model.is_collect =0;
                        }
                    }
                }];
            }
                break;
            case 43:
            {
                [params setObject:@(model.goodsListId) forKey:@"news_id"];
                [params setObject:@(2) forKey:@"is_type"];
                [loveDomain getData:URL_Love_Main PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                    if ([self checkHttpResponseResultStatus:loveDomain]) {
                     //   WCLLog(@"%@",domain.dataRoot);
                        if ([[domain.dataRoot objectForKey:@"data"]integerValue]==1) {
                            [weakCell.loveBtn setImage:[UIImage imageNamed:@"喜欢选中"] forState:UIControlStateNormal];
                            [weakCell.loveBtn setTitle:[NSString stringWithFormat:@"%@",[domain.dataRoot objectForKey:@"lovenum"]] forState:UIControlStateNormal];
                            model.is_love = 1;
                            model.love_num = model.love_num+1;
                        }
                        else if ([[domain.dataRoot objectForKey:@"data"]integerValue]==2)
                        {
                            [weakCell.loveBtn setImage:[UIImage imageNamed:@"喜欢"] forState:UIControlStateNormal];
                            [weakCell.loveBtn setTitle:[NSString stringWithFormat:@"%@",[domain.dataRoot objectForKey:@"lovenum"]] forState:UIControlStateNormal];
                            model.is_love = 0;
                            model.love_num = model.love_num-1;
                        }
                    }
                    
                }];
            }
                break;
            default:
                break;
        }
    }];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
    designerClothes.goodDic = [[designerDic arrayForKey:@"goods_list"] objectAtIndex:indexPath.row];
    designerClothes.good_id = [[[designerDic arrayForKey:@"goods_list"] objectAtIndex:indexPath.row] stringForKey:@"id"];
    designerClothes.model = modelArray[indexPath.item];
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
