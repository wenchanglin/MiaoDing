//
//  DiyClothesDetailViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/19.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//



#define URL_SHARE @"/web/jquery-obj/static/fx/html/dingzhi.html"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "JZAlbumViewController.h"
#import "NewDiyPersonalityVC.h"
#import "perentOrderViewController.h"
#import "DiyClothesDetailViewController.h"
#import "YYCycleScrollView.h"
#import "diyClothesDetailCollectionViewCell.h"
#import "diyClothesDetailModel.h"
#import "YuYueToBuyViewController.h"
#import "priceChooseView.h"
#import "styleChoose.h"
#import "choosePriceModel.h"
#import "ChooseStyleNewViewController.h"
#import "clothesPartChooseViewController.h"
#import "DiyWordInClothesViewController.h"
#import "CommentCollectionViewCell.h"
#import "commentModel.h"
#import "commentListViewController.h"
#import "ChooseClothesStyleViewController.h"
#import "clothesDetailScrollerViewController.h"
#import "JYHNavigationController.h"
#import "PageViewController.h"
#import "imgListModel.h"
#import "DiyAllPicCell.h"
#import <XHWebImageAutoSize.h>
#import "diyClothesDetailModel.h"
@interface DiyClothesDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate,priceChooseViewDelegate,styleChooseViewDelegate,diyClothesDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation DiyClothesDetailViewController
{
    BaseDomain *getData;
    NSMutableDictionary *dataDictionary;
    NSMutableArray *pictureArray;
    UICollectionView *colthesCollect;
    UITableView *detailPicTableView;
    UIImageView *lowView;
    priceChooseView *viewPiceChoose;
    UIImageView *alphaView;
    UIButton *buttonLike;
    NSDate *datBegin;
    NSDate *datDingBegin;
    NSString *dateId;
    NSInteger isopencv;
    NSMutableArray*imgListArr;
    NSMutableArray *contentIdArray;
    NSMutableArray *contentArray;
    NSString *mianId;
    NSMutableDictionary *goodParams;
    NSMutableArray *goodArray;
    NSString *default_price;
    styleChoose *chooseStyle;
    
    NSMutableDictionary *BanMain;
    
    
    NSMutableArray *mainDataArr;
    NSMutableArray *collectionArray;
    commentModel *modelComm;
    NSString *goodDufaultImg;
}

-(void)viewWillAppear:(BOOL)animated
{
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.rdv_tabBarController.tabBarHidden=YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.rdv_tabBarController.tabBarHidden=NO;
    
}
-(void)shareClick:(UIButton *)sender
{
    diyClothesDetailModel* models = [mainDataArr firstObject];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    imgListModel*model2= [models.ad_img firstObject];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model2.img]]];
    NSMutableDictionary*parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@(models.ID) forKey:@"goods_id"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_ShareUserForGoodsId_String] parameters:parameter finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
            [shareParams SSDKSetupShareParamsByText:models.content
                                             images:imageArray
                                                url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?goods_id=%@",URL_HeadForH5, URL_DingZHi, responseObject[@"goods_id"]]]
                                              title:models.name
                                               type:SSDKContentTypeWebPage];
            [ShareCustom shareWithContent:shareParams];
        }
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    mainDataArr = [NSMutableArray array];
    collectionArray = [NSMutableArray array];
    imgListArr=[NSMutableArray array];
    modelComm = [commentModel new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realToOrder) name:@"realToOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToOrderAction) name:@"turnToOrder" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLowView) name:@"showLowView" object:nil];
    BanMain = [NSMutableDictionary dictionary];
    goodParams = [NSMutableDictionary dictionary];
    [self createGetData];
}

-(void)realToOrder
{
    perentOrderViewController *perentOrder = [[perentOrderViewController alloc] init];
    [self.navigationController pushViewController:perentOrder animated:YES];
}

-(void)turnToOrderAction
{
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    //    perentOrderViewController *perentOrder = [[perentOrderViewController alloc] init];
    //    [self.navigationController pushViewController:perentOrder animated:YES];
    paySuccessViewController *paySuccess = [[paySuccessViewController alloc] init];
    [self.navigationController pushViewController:paySuccess animated:YES];
    
}

-(void)backClick
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:dateId forKey:@"id"];
    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [params setObject:[_goodDic stringForKey:@"name"] forKey:@"goods_name"];
    [params setObject:@"0" forKey:@"click_dingzhi"];
    [params setObject:@"0" forKey:@"click_pay"];
    [self getDateDingZhi:params beginDate:datBegin ifDing:NO];
    detailPicTableView=nil;
    [detailPicTableView removeFromSuperview];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    

    if ([self.vcString isEqualToString:@"changeDiySecondViewController"]) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"motaifanhui" object:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)createGetData
{
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [self progressShow:@"" animated:YES];
    [[wclNetTool sharedTools]request:GET urlString:URL_GetYouPingDetail parameters:parmas finished:^(id responseObject, NSError *error) {
        if([self checkHttpResponseResultStatus:responseObject])
        {
//            WCLLog(@"%@",responseObject[@"data"]);
            [self progressHide:YES];
            if ([responseObject[@"data"]count]>0) {
                diyClothesDetailModel* model = [diyClothesDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                dateId = [NSString stringWithFormat:@"%@",@(model.ID)];
                pictureArray = model.ad_img.mutableCopy;
                imgListArr = model.img_info.mutableCopy;
                collectionArray = model.collect_list.mutableCopy;
                modelComm.collectArray = collectionArray;
                modelComm.likeNum = model.collect_num;
                [mainDataArr addObject:model];
            }
        }
        else
        {
            dateId =@"0";
        }
//        [self createView];
        [self createScroller];
        [self createLowView];
        
    }];
    
}

-(void)createView
{
//    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    flowLayout.minimumLineSpacing = 0;
//    colthesCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-70:SCREEN_HEIGHT - 49) collectionViewLayout:flowLayout];
//    if (@available(iOS 11.0, *)) {
//        colthesCollect.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
//    }else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//
//    //设置代理
//    colthesCollect.delegate = self;
//    colthesCollect.dataSource = self;
//    [self.view addSubview:colthesCollect];
//    colthesCollect.backgroundColor = [UIColor whiteColor];
//    //注册cell和ReusableView（相当于头部）
//    colthesCollect.alwaysBounceVertical = YES;
//    //    colthesCollect.pagingEnabled = YES ;
//
//    [colthesCollect registerClass:[diyClothesDetailCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [colthesCollect registerClass:[CommentCollectionViewCell class] forCellWithReuseIdentifier:@"comment"];
//    [colthesCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
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
    //    .heightIs(45 * ([[dataDictionary arrayForKey:@"price"] count] + 1));
    //
    //
    //    NSMutableArray *array = [NSMutableArray array];
    //    for (int i = 0; i < [[dataDictionary arrayForKey:@"price"] count]; i ++) {
    //
    //        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //        [dic setObject:[NSString stringWithFormat:@"¥%.2f", [[[[dataDictionary arrayForKey:@"price"] objectAtIndex:i] stringForKey:@"price"] floatValue]] forKey:@"price"];
    //        [dic setObject:[[[dataDictionary arrayForKey:@"price"] objectAtIndex:i] stringForKey:@"introduce"] forKey:@"priceRemark"];
    //
    //        [array addObject:dic];
    //    }
    //    choosePriceModel *model1 = [choosePriceModel new];
    //    model1.price = array;
    //    viewPiceChoose.model = model1;
    //    [viewPiceChoose setAlpha:0];
    //
    //    chooseStyle = [styleChoose new];
    //    [self.view addSubview:chooseStyle];
    //    chooseStyle.delegate = self;
    //    chooseStyle.sd_layout
    //    .leftEqualToView(alphaView)
    //    .bottomEqualToView(alphaView)
    //    .rightEqualToView(alphaView)
    //    .heightIs(45 * ([[dataDictionary arrayForKey:@"banxing_list"] count] + 1));
    //
    //    NSMutableArray *array1 = [NSMutableArray array];
    //    for (int i = 0; i < [[dataDictionary arrayForKey:@"banxing_list"] count]; i ++) {
    //
    //        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //        [dic setObject:[[[dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:i] stringForKey:@"name"] forKey:@"styleName"];
    //        [dic setObject:[[[dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:i] stringForKey:@"id"] forKey:@"styleId"];
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
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.5];
    //    [viewPiceChoose setAlpha:0];
    //    [alphaView setAlpha:0];
    //    [UIView commitAnimations];
    //    NSArray *buttons = [dataDictionary arrayForKey:@"price"];
    //
    
    
    
    //    clothesPartChooseViewController *diyClothes = [[clothesPartChooseViewController alloc] init];
    //    diyClothes.price_Type = [[buttons objectAtIndex:item] stringForKey:@"id"];
    //    diyClothes.price = [buttons objectAtIndex:item];
    //    diyClothes.class_id = _class_id;
    //    diyClothes.goodDic = _goodDic;
    //    diyClothes.dateId = dateId;
    //    diyClothes.dateDing = datDingBegin;
    //    [self.navigationController pushViewController:diyClothes animated:YES];
    //
    //    ChooseClothesStyleViewController *chooseStyleCon = [[ChooseClothesStyleViewController alloc] init];
    //
    //    chooseStyleCon.price_Type = [[buttons objectAtIndex:item] stringForKey:@"id"];
    //    chooseStyleCon.price = [buttons objectAtIndex:item];
    //    chooseStyleCon.class_id = _class_id;
    //    chooseStyleCon.goodDic = _goodDic;
    //
    //    [self.navigationController pushViewController:chooseStyleCon animated:YES];
    
}

-(void)hiddenChoose
{
    
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params setObject:dateId forKey:@"id"];
    //    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    //    [params setObject:[_goodDic stringForKey:@"name"] forKey:@"goods_name"];
    //    [params setObject:@"0" forKey:@"click_dingzhi"];
    //    [params setObject:@"0" forKey:@"click_pay"];
    //    [self getDateDingZhi:params beginDate:datDingBegin ifDing:YES];
    //
    //
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.5];
    //    [viewPiceChoose setAlpha:0];
    //    [chooseStyle setAlpha:0];
    //    [alphaView setAlpha:0];
    //    [UIView commitAnimations];
}

-(void)createScroller
{
//    detailPicTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-70:SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
        detailPicTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-70:SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
    detailPicTableView.delegate=self;
    detailPicTableView.dataSource=self;
    [detailPicTableView registerClass:[DiyAllPicCell class] forCellReuseIdentifier:@"DiyAllPicCell"];
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
    buttonLike.qi_eventInterval=1;
    [buttonLike addTarget:self action:@selector(saveClothesClick) forControlEvents:UIControlEventTouchUpInside];
    diyClothesDetailModel*models = [mainDataArr firstObject];
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
    TKButton.qi_eventInterval=1;
    [TKButton setBackgroundColor:getUIColor(Color_buyColor)];
    [TKButton setTitle:@"购    买" forState:UIControlStateNormal];
    [TKButton addTarget:self action:@selector(ClickToBuyTK) forControlEvents:UIControlEventTouchUpInside];
    [TKButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [lowView addSubview:TKButton];
    
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
//购    买
-(void)ClickToBuyTK
{
    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    diyClothesDetailModel*model = [mainDataArr firstObject];
    if ([[userd stringForKey:@"token"] length] > 0) {
        NewDiyPersonalityVC * newdiy = [[NewDiyPersonalityVC alloc]init];
        newdiy.diyDetailModel = model;
        newdiy.ifTK = YES;
        [self.navigationController pushViewController:newdiy animated:YES];
        
    } else {
        [self getDateBeginHaveReturn:datBegin fatherView:@"立即购买"];
    }
    
    
}

-(void)clickStyleChoose:(NSInteger)item
{
    
//    NSString *string = [NSString stringWithFormat:@"版型：%@", [[[dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"name"]];
//    NSString *stringContnet = [NSString stringWithFormat:@"%@;%@",[goodParams stringForKey:@"spec_content"], string];
//    [goodParams setObject:stringContnet forKey:@"spec_content"];
//
//    [BanMain setObject:[[[dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"name"] forKey:@"banxing"];
//
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [chooseStyle setAlpha:0];
//    [alphaView setAlpha:0];
//    [UIView commitAnimations];
//    [goodParams setObject:[[[dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"id"] forKey:@"banxing_id"];
//    DiyWordInClothesViewController *diy = [[DiyWordInClothesViewController alloc] init];
//    diy.paramsDic = goodParams;
//    diy.price = [NSDictionary dictionaryWithObject:default_price forKey:@"price"];
//    diy.class_id = _class_id;
//    diy.goodDic = _goodDic;
//    diy.goodArray = goodArray;
//    diy.dingDate = datDingBegin;
//    diy.dateId = dateId;
//    diy.banMain = BanMain;
//    diy.ifTK = YES;
//    diy.defaultImg = goodDufaultImg;
//    [self.navigationController pushViewController:diy animated:YES];
}


-(void)saveClothesClick
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"type"];
    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"rid"];
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

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//    if (scrollView == colthesCollect) {
//        CGFloat offset =0.0;
//        if ([collectionArray count ]> 0) {
//            for (collect_listModel*model in collectionArray) {
//                if (model.head_ico.length > 0) {
//                    offset = (SCREEN_WIDTH - 100) / 5 + 100;
//                } else {
//                    offset = (SCREEN_HEIGHT - 100) / 5 + 245;
//                }
//            }
//        }
//        if (scrollView.contentOffset.y >offset + 49 ) {
//
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.3];
//            [colthesCollect setOrigin:CGPointMake(0, - SCREEN_HEIGHT)];
//            [detailPicTableView setOrigin:CGPointMake(0, 0)];
//            [lowView setAlpha:1];
//            [UIView commitAnimations];
//
//        }
//    } else {
//        if (scrollView.contentOffset.y < -80) {
//
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.3];
//            //            [lowView setAlpha:0];
//            [colthesCollect setOrigin:CGPointMake(0, 0)];
//            [detailPicTableView setOrigin:CGPointMake(0, SCREEN_HEIGHT)];
//            [UIView commitAnimations];
//
//        }
//    }
//    //
//}


-(void)showLowView
{
    clothesDetailScrollerViewController *clothe = [[clothesDetailScrollerViewController alloc] init];
    clothe.allDataArr = mainDataArr;
    clothe.picArr = imgListArr;
    clothe.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:clothe animated:YES];
}




-(void)clickBanerItem:(NSInteger)item
{
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    
    jzAlbumVC.currentIndex = item;//这个参数表示当前图片的index，默认是0
    
    jzAlbumVC.imgArr = pictureArray;//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:YES completion:nil];
    //
}


-(void)clickAction
{
    commentListViewController *commentList = [[commentListViewController alloc] init];
    commentList.goodId = [_goodDic stringForKey:@"id"];
    [self.navigationController pushViewController:commentList animated:YES];
}

-(void)chatClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[userd stringForKey:@"kf_tel"]]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

#pragma mark --uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return imgListArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    imgListModel*model = imgListArr[indexPath.row];
    DiyAllPicCell*cell = [tableView dequeueReusableCellWithIdentifier:@"DiyAllPicCell"];
    NSString * url = [NSString stringWithFormat:@"%@%@",PIC_HEADURL,model.img];
    [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    imgListModel * model = imgListArr[indexPath.row];
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
#pragma mark --UICollectionViewDelegateFlowLayout
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionArray count ]> 0) {
        return 2;
    } else
        return 1;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cellRe;
//    if (indexPath.item == 0) {
//        static NSString *identify = @"cell";
//        diyClothesDetailModel*model2 = mainDataArr[indexPath.row];
//        diyClothesDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
//        cell.banerArray = pictureArray;
//        cell.model = model2;
//        cell.delegate = self;
//        [cell sizeToFit];
//
//        cellRe = cell;
//    } else {
//        static NSString *identify = @"comment";
//        CommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
//        cell.modelComment = modelComm;
//        [cell sizeToFit];
//        cellRe = cell;
//    }
//
//    return cellRe;
//}
////定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    diyClothesDetailModel*model= mainDataArr[0];
//    if (indexPath.item == 0) {
//        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
//    } else {
//        if ([model.collect_list count] > 0) {
//            return CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH - 100) / 5+100);
//        } else {
//            return CGSizeMake(SCREEN_WIDTH, (SCREEN_HEIGHT - 100) / 5 + 245);
//        }
//    }
//
//
//
//}
////定义每个UICollectionView 的间距
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
////定义每个UICollectionView 纵向的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    if (indexPath.item == 1) {
//        //        if ([new_comment allKeys].count > 0) {
//        //            commentListViewController *commentList = [[commentListViewController alloc] init];
//        //            commentList.goodId = [_goodDic stringForKey:@"id"];
//        //            [self.navigationController pushViewController:commentList animated:YES];
//        //
//        //        }
//    }
//
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
