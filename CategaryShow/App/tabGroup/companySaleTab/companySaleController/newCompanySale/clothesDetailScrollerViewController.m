//
//  clothesDetailScrollerViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/15.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//
#define URL_SHARE @"/web/jquery-obj/static/fx/html/dingzhi.html"
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
@interface clothesDetailScrollerViewController ()<UIScrollViewDelegate,styleChooseViewDelegate,priceChooseViewDelegate>

@end

@implementation clothesDetailScrollerViewController
{
    BaseDomain *getData;
    UIScrollView *scrollerDetail;
    UIImageView *lowView;
    UIButton *buttonLike;
    UIImageView *alphaView;
    NSDate *datBegin;
    NSDate *datDingBegin;
    NSString *dateId;
    NSMutableDictionary *BanMain;
    priceChooseView *viewPiceChoose;
    styleChoose *chooseStyle;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    
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
    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NSString *string = [[[_dataDictionary arrayForKey:@"price"] valueForKey:@"price"] componentsJoinedByString:@","];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_goodDic stringForKey:@"thumb"]]]];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:[_dataDictionary stringForKey:@"content"]
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?goods_id=%@&type=2&price=%@&shareout_id=%@",URL_HEADURL, URL_SHARE, [_goodDic stringForKey:@"id"], string,[SelfPersonInfo getInstance].personUserKey]]
                                      title:[_dataDictionary stringForKey:@"name"]
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareWithContent:shareParams];
    
    
    
}

-(void)createPriceView
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    
    alphaView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [alphaView setImage:[UIImage imageNamed:@"BGALPHA"]];
    [alphaView setUserInteractionEnabled:YES];
    [self.view addSubview:alphaView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenChoose)];
    [alphaView addGestureRecognizer:tap];
    [alphaView setAlpha:0];
    
    viewPiceChoose = [priceChooseView new];
    [self.view addSubview:viewPiceChoose];
    viewPiceChoose.delegate = self;
    viewPiceChoose.sd_layout
    .leftEqualToView(alphaView)
    .bottomEqualToView(alphaView)
    .rightEqualToView(alphaView)
    .heightIs(45 * ([[_dataDictionary arrayForKey:@"price"] count] + 1));
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [[_dataDictionary arrayForKey:@"price"] count]; i ++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"¥%.2f", [[[[_dataDictionary arrayForKey:@"price"] objectAtIndex:i] stringForKey:@"price"] floatValue]] forKey:@"price"];
        [dic setObject:[[[_dataDictionary arrayForKey:@"price"] objectAtIndex:i] stringForKey:@"introduce"] forKey:@"priceRemark"];
        
        [array addObject:dic];
    }
    
    choosePriceModel *model1 = [choosePriceModel new];
    model1.price = array;
    viewPiceChoose.model = model1;
    [viewPiceChoose setAlpha:0];
    
    
    
    
    chooseStyle = [styleChoose new];
    [self.view addSubview:chooseStyle];
    chooseStyle.delegate = self;
    chooseStyle.sd_layout
    .leftEqualToView(alphaView)
    .bottomEqualToView(alphaView)
    .rightEqualToView(alphaView)
    .heightIs(45 * ([[_dataDictionary arrayForKey:@"banxing_list"] count] + 1));
    
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0; i < [[_dataDictionary arrayForKey:@"banxing_list"] count]; i ++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[[[_dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:i] stringForKey:@"name"] forKey:@"styleName"];
        [dic setObject:[[[_dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:i] stringForKey:@"id"] forKey:@"styleId"];
        
        [array1 addObject:dic];
    }
    
    choosePriceModel *model2 = [choosePriceModel new];
    model2.price = array1;
    chooseStyle.model = model2;
    [chooseStyle setAlpha:0];
    
}

-(void)clickPriceChoose:(NSInteger)item
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [viewPiceChoose setAlpha:0];
    [alphaView setAlpha:0];
    [UIView commitAnimations];
    NSArray *buttons = [_dataDictionary arrayForKey:@"price"];
    
    
    
    
    //    clothesPartChooseViewController *diyClothes = [[clothesPartChooseViewController alloc] init];
    //    diyClothes.price_Type = [[buttons objectAtIndex:item] stringForKey:@"id"];
    //    diyClothes.price = [buttons objectAtIndex:item];
    //    diyClothes.class_id = _class_id;
    //    diyClothes.goodDic = _goodDic;
    //    diyClothes.dateId = dateId;
    //    diyClothes.dateDing = datDingBegin;
    //    [self.navigationController pushViewController:diyClothes animated:YES];
    
    ChooseClothesStyleViewController *chooseStyleCon = [[ChooseClothesStyleViewController alloc] init];
    
    chooseStyleCon.price_Type = [[buttons objectAtIndex:item] stringForKey:@"id"];
    chooseStyleCon.price = [buttons objectAtIndex:item];
    chooseStyleCon.class_id = _class_id;
    chooseStyleCon.goodDic = _goodDic;
    
    [self.navigationController pushViewController:chooseStyleCon animated:YES];
    
}

-(void)hiddenChoose
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:dateId forKey:@"id"];
    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [params setObject:[_goodDic stringForKey:@"name"] forKey:@"goods_name"];
    [params setObject:@"0" forKey:@"click_dingzhi"];
    [params setObject:@"0" forKey:@"click_pay"];
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
    scrollerDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
    if (@available(iOS 11.0, *)) {
        scrollerDetail.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:scrollerDetail];
    scrollerDetail.delegate = self;
    
    UIImageView *imageDetailDes = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [imageDetailDes sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_dataDictionary stringForKey:@"content2"] ]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            CGFloat scan = image.size.width / image.size.height;
            
            if (SCREEN_WIDTH / scan < SCREEN_HEIGHT) {
                scrollerDetail.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT + 80);
                
            } else {
                scrollerDetail.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
            }
            
            [imageDetailDes setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / scan)];
        } else {
            
            
            scrollerDetail.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH + 80);
            
            
            [imageDetailDes setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH )];
        }
        
        
        
        
        
        
        
    }];
    [scrollerDetail addSubview:imageDetailDes];
}


-(void)createLowView
{
    lowView = [[UIImageView alloc] initWithFrame:CGRectMake(0,IsiPhoneX?SCREEN_HEIGHT-70:SCREEN_HEIGHT - 50, SCREEN_WIDTH,IsiPhoneX?70:50)];
    [lowView setImage:[UIImage imageNamed:@"tabBackImage"]];
    [lowView setBackgroundColor:[UIColor whiteColor]];
    [lowView setUserInteractionEnabled:YES];
    [self.view addSubview:lowView];
    
    
    UIButton *buttonShare = [[UIButton alloc] initWithFrame:CGRectMake(17, 15, 25, 25)];
    [buttonShare setImage:[UIImage imageNamed:@"chatLine"] forState:UIControlStateNormal];
    
    [buttonShare addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    [lowView addSubview:buttonShare];
    
    buttonLike = [[UIButton alloc] initWithFrame:CGRectMake(67, 15, 25, 25)];
    [buttonLike addTarget:self action:@selector(saveClothesClick) forControlEvents:UIControlEventTouchUpInside];
    if([_dataDictionary integerForKey:@"is_collect"] == 1) {
        [buttonLike setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
        
    } else {
        [buttonLike setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    }
    
    [lowView addSubview:buttonLike];
//    UIButton *DZButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 113, 0, 113, 50)];
//    [DZButton setBackgroundColor:getUIColor(Color_TKClolor)];
//    [DZButton setTitle:@"个性定制" forState:UIControlStateNormal];
//    [DZButton setTitleColor:getUIColor(Color_shadow) forState:UIControlStateNormal];
//    [DZButton addTarget:self action:@selector(ClickToBuyBut) forControlEvents:UIControlEventTouchUpInside];
//    [DZButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [lowView addSubview:DZButton];
    
    
    UIButton *TKButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - (113*2) , 0, 113*2, 50)];
    [TKButton setBackgroundColor:getUIColor(Color_buyColor)];
    [TKButton setTitle:@"购    买" forState:UIControlStateNormal];
    [TKButton addTarget:self action:@selector(ClickToBuyTK) forControlEvents:UIControlEventTouchUpInside];
    [TKButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [lowView addSubview:TKButton];
    //    [lowView setAlpha:0];
    
    
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(12,IsiPhoneX?HitoSafeAreaHeight:24, 33, 33)];
    
    [buttonBack.layer setCornerRadius:33 / 2];
    [buttonBack.layer setMasksToBounds:YES];
    [buttonBack setImage:[UIImage imageNamed:@"baiBack"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    [self.view bringSubviewToFront:buttonBack];
    
    
    UIButton *rightShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, IsiPhoneX?HitoSafeAreaHeight:24, 33, 33)];
    [rightShare.layer setCornerRadius:33 / 2];
    [rightShare.layer setMasksToBounds:YES];
    [rightShare setImage:[UIImage imageNamed:@"shareRight"] forState:UIControlStateNormal];
    [rightShare addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightShare];
    [self.view bringSubviewToFront:rightShare];
}

-(void)chatClick
{
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"私人顾问";

    QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];
    [self.navigationController setNavigationBarHidden:NO];
    vc.sessionTitle = @"私人顾问";
    vc.source = source;


    if (iPadDevice) {
        UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:vc];
        navi.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:navi animated:YES completion:nil];
    }
    else{
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    [self alertViewShowOfTime:@"客服不在线哦,请拨打电话:4009901213" time:1];
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
        NewDiyPersonalityVC * newdiy = [[NewDiyPersonalityVC alloc]init];
        newdiy.class_id = _class_id;
        newdiy.goodDic = _goodDic;
        newdiy.ifTK = YES;
        newdiy.paramsDic = _goodParams;
        newdiy.defaultImg = _goodDufaultImg;
        [self.navigationController pushViewController:newdiy animated:YES];
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
    
    NSString *string = [NSString stringWithFormat:@"版型：%@", [[[_dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"name"]];
    NSString *stringContnet = [NSString stringWithFormat:@"%@;%@",[_goodParams stringForKey:@"spec_content"], string];
    [_goodParams setObject:stringContnet forKey:@"spec_content"];
    
    [BanMain setObject:[[[_dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"name"] forKey:@"banxing"];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [chooseStyle setAlpha:0];
    [alphaView setAlpha:0];
    [UIView commitAnimations];
    [_goodParams setObject:[[[_dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"id"] forKey:@"banxing_id"];
    DiyWordInClothesViewController *diy = [[DiyWordInClothesViewController alloc] init];
    diy.paramsDic = _goodParams;
    diy.price = [NSDictionary dictionaryWithObject:_default_price forKey:@"price"];
    diy.class_id = _class_id;
    diy.goodDic = _goodDic;
    diy.goodArray = _goodArray;
    diy.dingDate = datDingBegin;
    diy.dateId = dateId;
    diy.banMain = BanMain;
    diy.ifTK = YES;
    diy.defaultImg = _goodDufaultImg;
    [self.navigationController pushViewController:diy animated:YES];
}


-(void)saveClothesClick
{
    //    [self showAlertWithTitle:@"提示" message:@"分享成功"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"type"];
    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"cid"];
    [getData postData:URL_AddSave PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        
        if (domain.result == 1) {
            [buttonLike setImage:[UIImage imageNamed:@"收藏选中"] forState:UIControlStateNormal];
            [_dataDictionary setObject:@"1" forKey:@"is_collect"];
        } else if (domain.result == 10001) {
            [self getDateBeginHaveReturn:datBegin fatherView:@"收藏"];
        } else if(domain.result==2) {
            [buttonLike setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            [_dataDictionary setObject:@"0" forKey:@"is_collect"];
        }
        
        
        
    }];
    
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
