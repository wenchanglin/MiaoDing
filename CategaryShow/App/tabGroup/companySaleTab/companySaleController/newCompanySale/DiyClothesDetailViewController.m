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
@interface DiyClothesDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate,priceChooseViewDelegate,styleChooseViewDelegate,diyClothesDelegate>

@end

@implementation DiyClothesDetailViewController
{
    BaseDomain *getData;
    NSMutableDictionary *dataDictionary;
    NSMutableArray *pictureArray;
    UICollectionView *colthesCollect;
    diyClothesDetailModel *model;
    UIScrollView *scrollerDetail;
    UIImageView *lowView;
    priceChooseView *viewPiceChoose;
    UIImageView *alphaView;
    UIButton *buttonLike;
    NSDate *datBegin;
    NSDate *datDingBegin;
    NSString *dateId;
    
    
    NSMutableArray *contentIdArray;
    NSMutableArray *contentArray;
    NSString *mianId;
    NSMutableDictionary *goodParams;
    NSMutableArray *goodArray;
    NSString *default_price;
    styleChoose *chooseStyle;
    
    NSMutableDictionary *BanMain;
    
    
    NSMutableDictionary *new_comment;
    NSMutableArray *collectionArray;
    commentModel *modelComm;
    NSString *goodDufaultImg;
}

-(void)viewWillAppear:(BOOL)animated
{
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)shareClick:(UIButton *)sender
{

    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NSString *string = [[[dataDictionary arrayForKey:@"price"] valueForKey:@"price"] componentsJoinedByString:@","];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_goodDic stringForKey:@"thumb"]]]];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:[dataDictionary stringForKey:@"content"]
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?goods_id=%@&shop_id=%@&market_id=%@&type=2",URL_HEADURL, URL_SHARE, [_goodDic stringForKey:@"id"],_shopId,_marketId]]
                                      title:[dataDictionary stringForKey:@"name"]
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareWithContent:shareParams];
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    new_comment = [NSMutableDictionary dictionary];
    collectionArray = [NSMutableArray array];
    modelComm = [commentModel new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realToOrder) name:@"realToOrder" object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToOrderAction) name:@"turnToOrder" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLowView) name:@"showLowView" object:nil];
    BanMain = [NSMutableDictionary dictionary];
    goodParams = [NSMutableDictionary dictionary];
    getData = [BaseDomain getInstance:NO];
    [self createGetData];
    
   
    // Do any additional setup after loading the view.
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
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

-(void)createGetData
{
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [getData getData:URL_GetYouPingDetailNew PostParams:parmas finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            dataDictionary = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
            [_goodDic setObject:[dataDictionary stringForKey:@"name"] forKey:@"name"];
            [_goodDic setObject:[dataDictionary stringForKey:@"sub_name"] forKey:@"sub_name"];
            [_goodDic setObject:[dataDictionary stringForKey:@"thumb"] forKey:@"thumb"];
            [_goodDic setObject:[dataDictionary stringForKey:@"type"] forKey:@"type"];
            
            
            _class_id = [dataDictionary stringForKey:@"classify_id"];
            dateId = [domain.dataRoot stringForKey:@"id"];
            pictureArray = [NSMutableArray arrayWithArray:[dataDictionary arrayForKey:@"img_list"]];
            new_comment = [NSMutableDictionary dictionaryWithDictionary:[dataDictionary dictionaryForKey:@"new_comment"]];
            collectionArray = [NSMutableArray arrayWithArray:[dataDictionary arrayForKey:@"collect_user"]];
            goodDufaultImg = [dataDictionary stringForKey:@"default_img"];
            modelComm.collectArray = [NSMutableArray arrayWithArray:collectionArray];
            modelComm.commentDic =[NSMutableDictionary dictionaryWithDictionary: new_comment];
            modelComm.comentNum = [dataDictionary stringForKey:@"comment_num"];
            modelComm.likeNum = [dataDictionary stringForKey:@"collect_num"];
            goodArray = [NSMutableArray arrayWithArray:[dataDictionary arrayForKey:@"default_spec_list"]];
             default_price = [dataDictionary stringForKey:@"default_price"];
            mianId = [dataDictionary stringForKey:@"default_mianliao"];
            [BanMain setObject:[dataDictionary stringForKey:@"default_mianliao_name"] forKey:@"mianliao"];
            [goodParams setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
            [goodParams setObject:[_goodDic stringForKey:@"name"] forKey:@"goods_name"];
            [goodParams setObject:[_goodDic stringForKey:@"thumb"] forKey:@"goods_thumb"];
            [goodParams setObject:[dataDictionary stringForKey:@"price_type"] forKey:@"price_id"];
            [goodParams setObject:[_goodDic stringForKey:@"type"] forKey:@"type"];
            [goodParams setObject:mianId forKey:@"mianliao_id"];
             [goodParams setObject:default_price forKey:@"price"];
            [goodParams setObject:[dataDictionary stringForKey:@"default_spec_ids"] forKey:@"spec_ids"];
            [goodParams setObject:[dataDictionary stringForKey:@"default_spec_content"] forKey:@"spec_content"];
            model = [diyClothesDetailModel new];
            model.banerArray = pictureArray;
            model.sub_name = [dataDictionary stringForKey:@"sub_name"];
            model.clothesName = [dataDictionary stringForKey:@"name"];
            [self createView];
            [self createScroller];
            [self createLowView];
            [self createPriceView];
        }
        
    }];
}

-(void)createView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    colthesCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) collectionViewLayout:flowLayout];
    
    
    if (@available(iOS 11.0, *)) {
        colthesCollect.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //设置代理
    colthesCollect.delegate = self;
    colthesCollect.dataSource = self;
    [self.view addSubview:colthesCollect];
    colthesCollect.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    colthesCollect.alwaysBounceVertical = YES;
//    colthesCollect.pagingEnabled = YES ;
    
    [colthesCollect registerClass:[diyClothesDetailCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [colthesCollect registerClass:[CommentCollectionViewCell class] forCellWithReuseIdentifier:@"comment"];
    [colthesCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    

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
    .heightIs(45 * ([[dataDictionary arrayForKey:@"price"] count] + 1));
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [[dataDictionary arrayForKey:@"price"] count]; i ++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSString stringWithFormat:@"¥%.2f", [[[[dataDictionary arrayForKey:@"price"] objectAtIndex:i] stringForKey:@"price"] floatValue]] forKey:@"price"];
        [dic setObject:[[[dataDictionary arrayForKey:@"price"] objectAtIndex:i] stringForKey:@"introduce"] forKey:@"priceRemark"];
        
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
    .heightIs(45 * ([[dataDictionary arrayForKey:@"banxing_list"] count] + 1));
    
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i = 0; i < [[dataDictionary arrayForKey:@"banxing_list"] count]; i ++) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[[[dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:i] stringForKey:@"name"] forKey:@"styleName"];
        [dic setObject:[[[dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:i] stringForKey:@"id"] forKey:@"styleId"];
        
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
    NSArray *buttons = [dataDictionary arrayForKey:@"price"];
    
    
    
    
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
    scrollerDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
    [self.view addSubview:scrollerDetail];
    scrollerDetail.delegate = self;
    if (@available(iOS 11.0, *)) {
        scrollerDetail.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIImageView *imageDetailDes = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [imageDetailDes sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [dataDictionary stringForKey:@"content2"] ]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    lowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
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
    if([dataDictionary integerForKey:@"is_collect"] == 1) {
        [buttonLike setImage:[UIImage imageNamed:@"fullHeart"] forState:UIControlStateNormal];
        
    } else {
        [buttonLike setImage:[UIImage imageNamed:@"Empty"] forState:UIControlStateNormal];
        
    }
    
    [lowView addSubview:buttonLike];
    UIButton *DZButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 113, 0, 113, 50)];
    [DZButton setBackgroundColor:getUIColor(Color_TKClolor)];
    [DZButton setTitle:@"个性定制" forState:UIControlStateNormal];
    [DZButton setTitleColor:getUIColor(Color_shadow) forState:UIControlStateNormal];
    [DZButton addTarget:self action:@selector(ClickToBuyBut) forControlEvents:UIControlEventTouchUpInside];
    [DZButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [lowView addSubview:DZButton];
    
    
    UIButton *TKButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 113 * 2, 0, 113, 50)];
    [TKButton setBackgroundColor:getUIColor(Color_DZClolor)];
    [TKButton setTitle:@"购买同款" forState:UIControlStateNormal];
    [TKButton setTitleColor:getUIColor(Color_shadow) forState:UIControlStateNormal];
    [TKButton addTarget:self action:@selector(ClickToBuyTK) forControlEvents:UIControlEventTouchUpInside];
    [TKButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [lowView addSubview:TKButton];
    
//    [lowView setAlpha:0];
    
    
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 45, 45)];
    
    [buttonBack.layer setCornerRadius:33 / 2];
    [buttonBack.layer setMasksToBounds:YES];
    [buttonBack setImage:[UIImage imageNamed:@"baiBack"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    [self.view bringSubviewToFront:buttonBack];
    
    
    UIButton *rightShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 20, 45, 45)];
    [rightShare.layer setCornerRadius:33 / 2];
    [rightShare.layer setMasksToBounds:YES];
    [rightShare setImage:[UIImage imageNamed:@"shareRight"] forState:UIControlStateNormal];
    [rightShare addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightShare];
    [self.view bringSubviewToFront:rightShare];
}

-(void)ClickToBuyTK
{
    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    if ([[userd stringForKey:@"token"] length] > 0) {
        
        datDingBegin = [NSDate dateWithTimeIntervalSinceNow:0];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [chooseStyle setAlpha:1];
        [alphaView setAlpha:1];
        [UIView commitAnimations];
        
        
        
    } else {
        [self getDateBeginHaveReturn:datBegin fatherView:@"立即购买"];
    }
    
    
}

-(void)clickStyleChoose:(NSInteger)item
{
    
    NSString *string = [NSString stringWithFormat:@"版型：%@", [[[dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"name"]];
    NSString *stringContnet = [NSString stringWithFormat:@"%@;%@",[goodParams stringForKey:@"spec_content"], string];
    [goodParams setObject:stringContnet forKey:@"spec_content"];
    
    [BanMain setObject:[[[dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"name"] forKey:@"banxing"];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [chooseStyle setAlpha:0];
    [alphaView setAlpha:0];
    [UIView commitAnimations];
    [goodParams setObject:[[[dataDictionary arrayForKey:@"banxing_list"] objectAtIndex:item] stringForKey:@"id"] forKey:@"banxing_id"];
    DiyWordInClothesViewController *diy = [[DiyWordInClothesViewController alloc] init];
    diy.paramsDic = goodParams;
    diy.price = [NSDictionary dictionaryWithObject:default_price forKey:@"price"];
    diy.class_id = _class_id;
    diy.goodDic = _goodDic;
    diy.goodArray = goodArray;
    diy.dingDate = datDingBegin;
    diy.dateId = dateId;
    diy.banMain = BanMain;
    diy.ifTK = YES;
    diy.defaultImg = goodDufaultImg;
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
            
            [buttonLike setImage:[UIImage imageNamed:@"fullHeart"] forState:UIControlStateNormal];
        } else if (domain.result == 10001) {
            [self getDateBeginHaveReturn:datBegin fatherView:@"收藏"];
        } else {
            
            [buttonLike setImage:[UIImage imageNamed:@"Empty"] forState:UIControlStateNormal];
        }
        
        
        
    }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == colthesCollect) {
        
        CGFloat offset = 0;
        
        
        if ([new_comment allKeys].count > 0 && [collectionArray count ]> 0) {
            if ([[new_comment arrayForKey:@"img_list"] count] > 0) {
                offset = (SCREEN_WIDTH - 100) / 5 + 264 + (SCREEN_WIDTH - 48) / 3;
            } else {
               offset = (SCREEN_HEIGHT - 100) / 5 + 245;
            }
        } else if ([new_comment allKeys].count == 0 && [collectionArray count ]> 0) {
               offset = (SCREEN_WIDTH - 100) / 5 + 89;
        } else if ([new_comment allKeys].count > 0 && [collectionArray count ] == 0) {
            if ([[new_comment arrayForKey:@"img_list"] count] > 0) {
                offset = 205 + (SCREEN_WIDTH - 48) / 3;
            } else {
                offset =  186;
            }
        }
        
        
        
            if (scrollView.contentOffset.y > 80 + offset + 49 ) {
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.3];
                [colthesCollect setOrigin:CGPointMake(0, - SCREEN_HEIGHT)];
                [scrollerDetail setOrigin:CGPointMake(0, 0)];
                [lowView setAlpha:1];
                [UIView commitAnimations];
                
            }
        
        
       
    } else {
        if (scrollView.contentOffset.y < -80) {
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
//            [lowView setAlpha:0];
            [colthesCollect setOrigin:CGPointMake(0, 0)];
            [scrollerDetail setOrigin:CGPointMake(0, SCREEN_HEIGHT)];
            [UIView commitAnimations];
            
        }
    }
    

//    
    
    
}


-(void)showLowView
{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    [colthesCollect setOrigin:CGPointMake(0, - SCREEN_HEIGHT)];
//    [scrollerDetail setOrigin:CGPointMake(0, 0)];
//    [lowView setAlpha:1];
//    [UIView commitAnimations];
    
    clothesDetailScrollerViewController *clothe = [[clothesDetailScrollerViewController alloc] init];
    
    clothe.dataDictionary = dataDictionary;
    clothe.goodParams = goodParams;
    clothe.goodDic = _goodDic;
    clothe.good_id = _good_id;
    clothe.class_id = _class_id;
    clothe.type_id = _type_id;
    clothe.goodArray = goodArray;
    clothe.default_price = default_price;
    clothe.goodDufaultImg = goodDufaultImg;
    
    [self.navigationController pushViewController:clothe animated:YES];
    

    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (![[new_comment stringForKey:@"id"] isEqualToString:@""] || [collectionArray count ]> 0) {
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
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cellRe;
    if (indexPath.item == 0) {
        static NSString *identify = @"cell";
        diyClothesDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.banerArray = pictureArray;
        cell.model = model;
        cell.delegate = self;

        [cell sizeToFit];
        
        cellRe = cell;
    } else {
        static NSString *identify = @"comment";
        CommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
       
        cell.modelComment = modelComm;
        [cell sizeToFit];
        cellRe = cell;
    }
    
    return cellRe;
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


-(void)ClickToBuyBut {
    

    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    if ([[userd stringForKey:@"token"] length] > 0) {
        
        datDingBegin = [NSDate dateWithTimeIntervalSinceNow:0];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [viewPiceChoose setAlpha:1];
        [alphaView setAlpha:1];
        [UIView commitAnimations];
            
       
        
    } else {
        [self getDateBeginHaveReturn:datBegin fatherView:@"立即购买"];
    }
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    if (indexPath.item == 0) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    } else {
        if ([new_comment allKeys].count > 0 && [collectionArray count ]> 0) {
            if ([[new_comment arrayForKey:@"img_list"] count] > 0) {
                return CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH - 100) / 5 + 264 + (SCREEN_WIDTH - 48) / 3);
            } else {
                return CGSizeMake(SCREEN_WIDTH, (SCREEN_HEIGHT - 100) / 5 + 245);
            }
        } else if ([new_comment allKeys].count == 0 && [collectionArray count ]> 0) {
            return CGSizeMake(SCREEN_WIDTH, (SCREEN_WIDTH - 100) / 5 + 89);
        } else if ([new_comment allKeys].count > 0 && [collectionArray count ] == 0) {
            if ([[new_comment arrayForKey:@"img_list"] count] > 0) {
                return CGSizeMake(SCREEN_WIDTH, 205 + (SCREEN_WIDTH - 48) / 3);
            } else {
                return CGSizeMake(SCREEN_WIDTH,  186);
            }
        } else return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 200);
    }
        
        
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item == 1) {
        if ([new_comment allKeys].count > 0) {
            commentListViewController *commentList = [[commentListViewController alloc] init];
            commentList.goodId = [_goodDic stringForKey:@"id"];
            [self.navigationController pushViewController:commentList animated:YES];

        }
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
