//
//  DesignerDetailIntroduce.m
//  CategaryShow
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//
#import "designerModel.h"
#import "DesignerDetailIntroduce.h"
#import "ToBuyCompanyClothes(SecondPlan)ViewController.h"
#import "BuyDesignerClothesViewController.h"
#define URL_DESIGNERWEB @"html/jiangxin.html"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#define URL_SHARE @"http://www.cloudworkshop.cn/web/jquery-obj/static/fx/html/jiangxin.html"
#import "designerInfoTableViewCell.h"
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "DesignerClothesDetailViewController.h"
@interface DesignerDetailIntroduce ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DesignerDetailIntroduce
{
    UITableView *desinger;
    BaseDomain *getData;
    NSMutableDictionary *designerDic;
    NSMutableArray *modelArray;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    designerDic = [NSMutableDictionary dictionary];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"";

    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
    [buttonRight addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
    
    
    [self getDatas];
}

-(void)shareClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _designerImage]]];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:_remark
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&token=%@", URL_SHARE, _desginerId, [userd stringForKey:@"token"]]]
                                      title:_designerName
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareWithContent:shareParams];    

}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_desginerId forKey:@"uid"];
    [getData getData:URL_GetDesignerDeetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:getData]) {
            
            designerDic = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
          
            
            for (NSDictionary *dic in [designerDic arrayForKey:@"goods_list"]) {
                designerModel *model = [designerModel mj_objectWithKeyValues:dic];
                [modelArray addObject:model];
            }
            
            [self createDeisgner];
        }
    }];
}

-(void)createDeisgner
{
    desinger = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    desinger.delegate = self;
    desinger.dataSource = self;
    [desinger registerClass:[designerInfoTableViewCell class] forCellReuseIdentifier:@"designer"];
    [self.view addSubview:desinger];
    [desinger setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self headBack];
    
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

-(void)headBack
{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 392 / 2 + 40)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    

    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 392 / 2)];
    [imgHead setImage:[UIImage imageNamed:@"designerBack"]];
    [headView addSubview:imgHead];
    
    
    UIImageView *designerHead = [[UIImageView alloc] initWithFrame:CGRectMake(44, 68, 80, 80)];
    [designerHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _designerImage]]];
    [designerHead.layer setCornerRadius:40];
    [designerHead.layer setMasksToBounds:YES];
    [imgHead addSubview:designerHead];
    
    desinger.tableHeaderView = headView;
    
    
    UILabel *labelName = [UILabel new];
    [imgHead addSubview:labelName];
    labelName.sd_layout
    .centerXEqualToView(designerHead)
    .topSpaceToView(designerHead, 7)
    .heightIs(20)
    .widthIs(80);
    
    
    [labelName setText:_designerName];
    [labelName setTextAlignment:NSTextAlignmentCenter];
    [labelName setFont:Font_20];
    
    
    UILabel *ZPLabel = [UILabel new];
    [headView addSubview:ZPLabel];
    ZPLabel.sd_layout
    .leftEqualToView(headView)
    .topSpaceToView(imgHead, 0)
    .widthIs(SCREEN_WIDTH / 3 - 1)
    .heightIs(15);
    [ZPLabel setFont:Font_15];
    [ZPLabel setTextAlignment:NSTextAlignmentCenter];
    if ([[designerDic stringForKey:@"goods_num"]isEqualToString:@""]) {
        [ZPLabel setText:@"0"];
    } else {
        [ZPLabel setText:[designerDic stringForKey:@"goods_num"]];

    }
    
    
    
    
    UILabel *ZPLabelTitle = [UILabel new];
    [headView addSubview:ZPLabelTitle];
    ZPLabelTitle.sd_layout
    .leftEqualToView(headView)
    .topSpaceToView(ZPLabel, 3)
    .widthIs(SCREEN_WIDTH / 3 - 1)
    .heightIs(15);
    [ZPLabelTitle setFont:[UIFont systemFontOfSize:14]];
    [ZPLabelTitle setTextAlignment:NSTextAlignmentCenter];
    [ZPLabelTitle setTextColor:[UIColor blackColor]];
    [ZPLabelTitle setText:@"作品"];
    
    
    UIView *lineView = [UIView new];
    [headView addSubview:lineView];
    lineView.sd_layout
    .leftSpaceToView(ZPLabelTitle,0)
    .topSpaceToView(imgHead, 3)
    .widthIs(1)
    .heightIs(25);
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    
    
    
    UILabel *SaleLabel = [UILabel new];
    [headView addSubview:SaleLabel];
    SaleLabel.sd_layout
    .leftSpaceToView(ZPLabel,1)
    .topSpaceToView(imgHead, 0)
    .widthIs(SCREEN_WIDTH / 3 - 1)
    .heightIs(15);
    [SaleLabel setFont:Font_15];
    [SaleLabel setTextAlignment:NSTextAlignmentCenter];
    
    if ([[designerDic stringForKey:@"sale_num"] isEqualToString:@""]) {
        [SaleLabel setText:@"0"];
    } else {
        [SaleLabel setText:[designerDic stringForKey:@"sale_num"]];
    }
    
    
    UILabel *SaleLabelTitle = [UILabel new];
    [headView addSubview:SaleLabelTitle];
    SaleLabelTitle.sd_layout
    .leftSpaceToView(ZPLabel,1)
    .topSpaceToView(SaleLabel, 3)
    .widthIs(SCREEN_WIDTH / 3 - 1)
    .heightIs(15);
    [SaleLabelTitle setFont:[UIFont systemFontOfSize:14]];
    [SaleLabelTitle setTextAlignment:NSTextAlignmentCenter];
    [SaleLabelTitle setTextColor:[UIColor blackColor]];
    [SaleLabelTitle setText:@"售出"];
    
    UIView *lineView1 = [UIView new];
    [headView addSubview:lineView1];
    lineView1.sd_layout
    .leftSpaceToView(SaleLabelTitle,0)
    .topSpaceToView(imgHead, 3)
    .widthIs(1)
    .heightIs(25);
    [lineView1 setBackgroundColor:[UIColor lightGrayColor]];
    
    
    UILabel *collectLabel = [UILabel new];
    [headView addSubview:collectLabel];
    collectLabel.sd_layout
    .leftSpaceToView(SaleLabel,1)
    .topSpaceToView(imgHead, 0)
    .widthIs(SCREEN_WIDTH / 3 - 1)
    .heightIs(15);
    [collectLabel setFont:Font_15];
    [collectLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    if ([[designerDic stringForKey:@"collect_num"] isEqualToString:@""]) {
        [collectLabel setText:@"0"];
    } else {
        [collectLabel setText:[designerDic stringForKey:@"collect_num"]];
    }
    
    
    
    
    UILabel *collectLabelTitle = [UILabel new];
    [headView addSubview:collectLabelTitle];
    collectLabelTitle.sd_layout
    .leftSpaceToView(SaleLabel,1)
    .topSpaceToView(collectLabel, 3)
    .widthIs(SCREEN_WIDTH / 3 - 1)
    .heightIs(15);
    [collectLabelTitle setFont:[UIFont systemFontOfSize:14]];
    [collectLabelTitle setTextAlignment:NSTextAlignmentCenter];
    [collectLabelTitle setTextColor:[UIColor blackColor]];
    [collectLabelTitle setText:@"收藏"];
    
    
    UIButton *backBtn = [UIButton new];
    [headView addSubview:backBtn];
    backBtn.sd_layout
    .leftSpaceToView(headView, 12)
    .topSpaceToView(headView, 27)
    .widthIs(20)
    .heightIs(20);
    [backBtn setImage:[UIImage imageNamed:@"baiBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClickAction) forControlEvents:UIControlEventTouchUpInside];
    
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
    return 300;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    designerInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"designer" forIndexPath:indexPath];
    cell.model = modelArray[indexPath.row];
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



















//-(void)createScrollerView
//{
//    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
//    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [web sizeToFit];
//    UIScrollView *tempView = (UIScrollView *)[web.subviews objectAtIndex:0];
//    tempView.scrollEnabled = NO;
//    NSURLRequest *request;
//    request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&token=%@&ios=true", URL_WEBHEADURL, URL_DESIGNERWEB, _desginerId, [userd stringForKey:@"token"]]]];
//    [web loadRequest:request];
//    web.delegate = self;
//    [self.view addSubview:web];
//}
//
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    
//    
//    if ([[[request URL] scheme] isEqualToString:@"onlogin"]) {
//        EnterViewController *enter = [[EnterViewController alloc] init];
//        [self presentViewController:enter animated:YES completion:nil];
//    } else if ([[[request URL] scheme] isEqualToString:@"sale"]) {
//        NSString *webData = [[[request URL] resourceSpecifier] stringByReplacingOccurrencesOfString:@"//" withString:@""];
//        NSArray *arrayWeb = [webData componentsSeparatedByString:@";"];
//        
//        if ([arrayWeb[2] integerValue] == 1) {
//            ToBuyCompanyClothes_SecondPlan_ViewController *toBuy = [[ToBuyCompanyClothes_SecondPlan_ViewController alloc] init];
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            [dic setObject:arrayWeb[0] forKey:@"id"];
//            [dic setObject:arrayWeb[1] forKey:@"thumb"];
//            toBuy.goodDic = dic;
//            [self.navigationController pushViewController:toBuy animated:YES];
//        } else {
//            
//            
//            BuyDesignerClothesViewController *buyDesigner = [[BuyDesignerClothesViewController alloc] init];
//            buyDesigner.good_Id = arrayWeb[0];
//            buyDesigner.imageURl = arrayWeb[1];
//            [self.navigationController pushViewController:buyDesigner animated:YES];
//            
//        }
//        
//        
//        
//    }
//    
//    return YES;
//}

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
