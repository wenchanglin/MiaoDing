//
//  clothesDetailScrollerViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/15.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//
#import "clothesDetailScrollerViewController.h"
#import "DiyWordInClothesViewController.h"
#import "NewDiyPersonalityVC.h"
#import "choosePriceModel.h"
#import "priceChooseView.h"
#import "styleChoose.h"
#import "ChooseClothesStyleViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "diyClothesDetailModel.h"
#import "DiyAllPicCell.h"
#import "imgListModel.h"
@interface clothesDetailScrollerViewController ()<UITableViewDelegate,UITableViewDataSource,styleChooseViewDelegate,priceChooseViewDelegate>

@end

@implementation clothesDetailScrollerViewController
{
    BaseDomain *getData;
    UIImageView *lowView;
    UIButton *buttonLike;
    UIImageView *alphaView;
    NSDate *datBegin;
    NSDate *datDingBegin;
    NSString *dateId;
    NSMutableDictionary *BanMain;
    priceChooseView *viewPiceChoose;
    styleChoose *chooseStyle;
    UITableView*detailPicTableView;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.rdv_tabBarController.tabBarHidden=YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.rdv_tabBarController.tabBarHidden=NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScroller];
    [self createLowView];
    [self createPriceView];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareClick:(UIButton *)sender
{
    diyClothesDetailModel* models = [_allDataArr firstObject];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    imgListModel*model2= [models.ad_img firstObject];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model2.img]]];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:models.content
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?goods_id=%@",URL_HeadForH5, URL_DingZHi, @(models.ID)]]
                                      title:models.name
                                       type:SSDKContentTypeWebPage];

    [ShareCustom shareWithContent:shareParams];
    
    
    
}

-(void)createPriceView
{
//    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
//
//
//    alphaView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [alphaView setImage:[UIImage imageNamed:@"BGALPHA"]];
//    [alphaView setUserInteractionEnabled:YES];
//    [self.view addSubview:alphaView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenChoose)];
//    [alphaView addGestureRecognizer:tap];
//    [alphaView setAlpha:0];
//
//    viewPiceChoose = [priceChooseView new];
//    [self.view addSubview:viewPiceChoose];
//    viewPiceChoose.delegate = self;
//    viewPiceChoose.sd_layout
//    .leftEqualToView(alphaView)
//    .bottomEqualToView(alphaView)
//    .rightEqualToView(alphaView)
//    .heightIs(45 * ([[_dataDictionary arrayForKey:@"price"] count] + 1));
//
//
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < [[_dataDictionary arrayForKey:@"price"] count]; i ++) {
//
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:[NSString stringWithFormat:@"¥%.2f", [[[[_dataDictionary arrayForKey:@"price"] objectAtIndex:i] stringForKey:@"price"] floatValue]] forKey:@"price"];
//        [dic setObject:[[[_dataDictionary arrayForKey:@"price"] objectAtIndex:i] stringForKey:@"introduce"] forKey:@"priceRemark"];
//
//        [array addObject:dic];
//    }
//
//    choosePriceModel *model1 = [choosePriceModel new];
//    model1.price = array;
//    viewPiceChoose.model = model1;
//    [viewPiceChoose setAlpha:0];
//
//
//
//
//    chooseStyle = [styleChoose new];
//    [self.view addSubview:chooseStyle];
//    chooseStyle.delegate = self;
//    chooseStyle.sd_layout
//    .leftEqualToView(alphaView)
//    .bottomEqualToView(alphaView)
//    .rightEqualToView(alphaView)
//    .heightIs(45 * ([[_dataDictionary arrayForKey:@"banxing_list"] count] + 1));
//
//    NSMutableArray *array1 = [NSMutableArray array];
//    for (int i = 0; i < [[_dataDictionary arrayForKey:@"banxing_list"] count]; i ++) {
//
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:[[[_dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:i] stringForKey:@"name"] forKey:@"styleName"];
//        [dic setObject:[[[_dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:i] stringForKey:@"id"] forKey:@"styleId"];
//
//        [array1 addObject:dic];
//    }
//
//    choosePriceModel *model2 = [choosePriceModel new];
//    model2.price = array1;
//    chooseStyle.model = model2;
//    [chooseStyle setAlpha:0];
    
}

-(void)clickPriceChoose:(NSInteger)item
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [viewPiceChoose setAlpha:0];
    [alphaView setAlpha:0];
    [UIView commitAnimations];
//    NSArray *buttons = [_dataDictionary arrayForKey:@"price"];
    
    
    
    
    //    clothesPartChooseViewController *diyClothes = [[clothesPartChooseViewController alloc] init];
    //    diyClothes.price_Type = [[buttons objectAtIndex:item] stringForKey:@"id"];
    //    diyClothes.price = [buttons objectAtIndex:item];
    //    diyClothes.class_id = _class_id;
    //    diyClothes.goodDic = _goodDic;
    //    diyClothes.dateId = dateId;
    //    diyClothes.dateDing = datDingBegin;
    //    [self.navigationController pushViewController:diyClothes animated:YES];
    
    ChooseClothesStyleViewController *chooseStyleCon = [[ChooseClothesStyleViewController alloc] init];
    
//    chooseStyleCon.price_Type = [[buttons objectAtIndex:item] stringForKey:@"id"];
//    chooseStyleCon.price = [buttons objectAtIndex:item];
//    chooseStyleCon.class_id = _class_id;
//    chooseStyleCon.goodDic = _goodDic;
    
    [self.navigationController pushViewController:chooseStyleCon animated:YES];
    
}

-(void)hiddenChoose
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:dateId forKey:@"id"];
//    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
//    [params setObject:[_goodDic stringForKey:@"name"] forKey:@"goods_name"];
//    [params setObject:@"0" forKey:@"click_dingzhi"];
//    [params setObject:@"0" forKey:@"click_pay"];
    [self getDateDingZhi:params beginDate:datDingBegin ifDing:YES];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [viewPiceChoose setAlpha:0];
    [chooseStyle setAlpha:0];
    [alphaView setAlpha:0];
    [UIView commitAnimations];
}


-(void)createScroller
{
    detailPicTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?-44:-24, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-26:SCREEN_HEIGHT - 26) style:UITableViewStylePlain];
    detailPicTableView.delegate=self;
    detailPicTableView.dataSource=self;
    [detailPicTableView registerClass:[DiyAllPicCell class] forCellReuseIdentifier:@"DiyAllPicCells"];
    [self.view addSubview:detailPicTableView];
    
}


-(void)createLowView
{
    lowView = [[UIImageView alloc] init];
    [lowView setImage:[UIImage imageNamed:@"tabBackImage"]];
    [lowView setBackgroundColor:[UIColor whiteColor]];
    [lowView setUserInteractionEnabled:YES];
    [self.view addSubview:lowView];
    [lowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo([ShiPeiIphoneXSRMax isIPhoneX]?-20:0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    buttonLike = [[UIButton alloc] init];//WithFrame:CGRectMake(67, 15, 25, 25)];
    [buttonLike addTarget:self action:@selector(saveClothesClick) forControlEvents:UIControlEventTouchUpInside];
    diyClothesDetailModel* models = [_allDataArr firstObject];
    if([models.is_collect integerValue]== 1) {
        [buttonLike setImage:[UIImage imageNamed:@"收藏选中2"] forState:UIControlStateNormal];
        
    } else {
        [buttonLike setImage:[UIImage imageNamed:@"收藏2"] forState:UIControlStateNormal];
    }
    
    [lowView addSubview:buttonLike];
    [buttonLike mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lowView.mas_centerY);
        make.left.mas_equalTo(iPadDevice?61:25);
    }];
    UIButton *buttonShare = [[UIButton alloc] init];//WithFrame:CGRectMake(17, 15, 25, 25)];
    [buttonShare setImage:[UIImage imageNamed:@"chatLine"] forState:UIControlStateNormal];
    
    [buttonShare addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    [lowView addSubview:buttonShare];
    [buttonShare mas_makeConstraints:^(MASConstraintMaker *make) {
        if(iPadDevice)
        {
            make.left.equalTo(buttonLike.mas_right).offset(101);
        }
        else
        {
            make.left.mas_equalTo(75);
        }
        make.centerY.equalTo(lowView.mas_centerY);
        
    }];

    UIButton *TKButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (113*2) , 0, 113*2, 50)];
    [TKButton setBackgroundColor:getUIColor(Color_buyColor)];
    [TKButton setTitle:@"购    买" forState:UIControlStateNormal];
    [TKButton addTarget:self action:@selector(ClickToBuyTK) forControlEvents:UIControlEventTouchUpInside];
    [TKButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [lowView addSubview:TKButton];
    
    //    [lowView setAlpha:0];
    
    
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?HitoSafeAreaHeight:20, 45, 45)];
    
    [buttonBack.layer setCornerRadius:33 / 2];
    [buttonBack.layer setMasksToBounds:YES];
    [buttonBack setImage:[UIImage imageNamed:@"baiBack"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    [self.view bringSubviewToFront:buttonBack];
    
    
    UIButton *rightShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, [ShiPeiIphoneXSRMax isIPhoneX]?HitoSafeAreaHeight:20, 45, 45)];
    [rightShare.layer setCornerRadius:33 / 2];
    [rightShare.layer setMasksToBounds:YES];
    [rightShare setImage:[UIImage imageNamed:@"shareRight"] forState:UIControlStateNormal];
    [rightShare addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightShare];
    [self.view bringSubviewToFront:rightShare];
}

-(void)chatClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[userd stringForKey:@"kf_tel"]]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}


//-(void)ClickToBuyBut {
//
//
//
//    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
//    if ([[userd stringForKey:@"token"] length] > 0) {
//        DiyWordInClothesViewController *diy = [[DiyWordInClothesViewController alloc] init];
//        diy.class_id = _class_id;
//
//        diy.goodDic = _goodDic;
//        diy.ifTK = YES;
//        diy.paramsDic = _goodParams;
//        diy.defaultImg = _goodDufaultImg;
//        [self.navigationController pushViewController:diy animated:YES];
//    } else {
//        [self getDateBeginHaveReturn:datBegin fatherView:@"立即购买"];
//    }
//
//}



-(void)ClickToBuyTK
{
    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    if ([[userd stringForKey:@"token"] length] > 0) {
//        NewDiyPersonalityVC * newdiy = [[NewDiyPersonalityVC alloc]init];
//        newdiy.class_id = _class_id;
//        newdiy.goodDic = _goodDic;
//        newdiy.ifTK = YES;
//        newdiy.paramsDic = _goodParams;
//        newdiy.defaultImg = _goodDufaultImg;
//        [self.navigationController pushViewController:newdiy animated:YES];
//        DiyWordInClothesViewController *diy = [[DiyWordInClothesViewController alloc] init];
//        diy.class_id = _class_id;
//
//        diy.goodDic = _goodDic;
//        diy.ifTK = YES;
//        diy.paramsDic = _goodParams;
//        diy.defaultImg = _goodDufaultImg;
//        [self.navigationController pushViewController:diy animated:YES];
        
        
        
    } else {
        [self getDateBeginHaveReturn:datBegin fatherView:@"立即购买"];
    }
    
    
}

-(void)clickStyleChoose:(NSInteger)item
{
    
//    NSString *string = [NSString stringWithFormat:@"版型：%@", [[[_dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"name"]];
//    NSString *stringContnet = [NSString stringWithFormat:@"%@;%@",[_goodParams stringForKey:@"spec_content"], string];
//    [_goodParams setObject:stringContnet forKey:@"spec_content"];
//
//    [BanMain setObject:[[[_dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"name"] forKey:@"banxing"];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [chooseStyle setAlpha:0];
    [alphaView setAlpha:0];
    [UIView commitAnimations];
//    [_goodParams setObject:[[[_dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"id"] forKey:@"banxing_id"];
//    DiyWordInClothesViewController *diy = [[DiyWordInClothesViewController alloc] init];
//    diy.paramsDic = _goodParams;
//    diy.price = [NSDictionary dictionaryWithObject:_default_price forKey:@"price"];
//    diy.class_id = _class_id;
//    diy.goodDic = _goodDic;
//    diy.goodArray = _goodArray;
//    diy.dingDate = datDingBegin;
//    diy.dateId = dateId;
//    diy.banMain = BanMain;
//    diy.ifTK = YES;
//    diy.defaultImg = _goodDufaultImg;
//    [self.navigationController pushViewController:diy animated:YES];
}


-(void)saveClothesClick
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"type"];
    diyClothesDetailModel* models = [_allDataArr firstObject];

    [params setObject:@(models.ID) forKey:@"rid"];
    [[wclNetTool sharedTools]request:POST urlString:URL_CollectSave parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"status"]integerValue]==1) {
                [self alertViewShowOfTime:responseObject[@"msg"] time:1.5];
                [buttonLike setImage:[UIImage imageNamed:@"收藏选中2"] forState:UIControlStateNormal];
            }
            else
            {
                [self alertViewShowOfTime:responseObject[@"msg"] time:1.5];
                [buttonLike setImage:[UIImage imageNamed:@"收藏2"] forState:UIControlStateNormal];
                
            }
        }
        
    }];
    
    
    
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _picArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    imgListModel*model = _picArr[indexPath.row];
    DiyAllPicCell*cell = [tableView dequeueReusableCellWithIdentifier:@"DiyAllPicCells"];
    NSString * url = [NSString stringWithFormat:@"%@%@",PIC_HEADURL,model.img];
    [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    imgListModel * model = _picArr[indexPath.row];
    return SCREEN_WIDTH/[model.ratio floatValue];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
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
