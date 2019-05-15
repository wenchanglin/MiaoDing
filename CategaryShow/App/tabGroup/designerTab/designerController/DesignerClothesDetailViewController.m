//
//  DiyClothesDetailViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/19.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//




#import "DesignerClothesDetailViewController.h"
#import "DiyClothesDetailViewController.h"
#import "YYCycleScrollView.h"
#import "diyClothesDetailCollectionViewCell.h"
#import "diyClothesDetailModel.h"
#import "designerForClothesCollectionViewCell.h"
#import "sizeAndColorCollectionViewCell.h"
#import "ClothesFroPay.h"
#import "PayForClothesViewController.h"
#import "DesignerDetailIntroduce.h"
#import "perentOrderViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "commentModel.h"
#import "CommentCollectionViewCell.h"
#import "commentListViewController.h"
#import "CircleScrollView.h"
#import "designerDetailModel.h"
@interface DesignerClothesDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate,CircleScrollDelegate>

@end

@implementation DesignerClothesDetailViewController
{
    BaseDomain *getData;
    BaseDomain *postData;
    NSMutableDictionary *dataDictionary;
    NSMutableArray *pictureArray;
    NSMutableArray *prctureIntro;
    CircleScrollView* csview;
    designerDetailModel*models;
    UICollectionView *colthesCollect;
    
    UIScrollView *scrollerDetail;
    UIImageView *lowView;
    UIButton *buttonLike;
    NSMutableArray *sizeList;
    NSMutableDictionary *sizeShowDic;
    NSString *sizeStr;
    NSString *colorStr;
    NSString *sizeId;
    NSInteger flogSize;
    NSInteger flogSizeShow;
    NSInteger clothesCount;
    NSString *clothesPrice;
    UIView *bgViewAlpha;
    UILabel *priceLabel;
    UILabel *numberLabel;
    UICollectionView *sizeCollection;
    UICollectionView *sizeShowCollection;
    UILabel *countLabel;
    designerModel *designer;
    NSDate *datBegin;
    
    NSMutableDictionary *new_comment;
    NSMutableArray *collectionArray;
    commentModel *modelComm;
    UIPageControl *page;
    NSString*kucunNum;
    NSString *lt_data;
    NSMutableString*idsStr1;
    NSMutableString*idsStr2;
    UIButton *detailButton;
    UIButton *buttonClose;
    UIImageView *imageBg;
}

-(void)viewWillAppear:(BOOL)animated
{
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)shareClick
{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _model.ad_img]]];
    NSMutableDictionary*parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@(_model.ID) forKey:@"goods_id"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_ShareUserForGoodsId_String] parameters:parameter finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
            [shareParams SSDKSetupShareParamsByText:_model.content
                                             images:imageArray
                                                url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?goods_id=%@", URL_HeadForH5,URL_DingZHi, responseObject[@"goods_id"]]]
                                              title:_model.name
                                               type:SSDKContentTypeWebPage];
            [ShareCustom shareWithContent:shareParams];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    new_comment = [NSMutableDictionary dictionary];
    collectionArray = [NSMutableArray array];
    modelComm = [commentModel new];
    flogSize = 0;
    flogSizeShow = 0;
    clothesCount = 1;
    idsStr1 = [[NSMutableString alloc]init];
    idsStr2 = [[NSMutableString alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToOrderAction) name:@"turnToOrder" object:nil];
    pictureArray = [NSMutableArray array];
    prctureIntro=[NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realToOrder) name:@"realToOrder" object:nil];
    sizeList = [NSMutableArray array];
    sizeShowDic = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createGetData];
}

-(void)createBack{
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(12, [ShiPeiIphoneXSRMax isIPhoneX]?HitoSafeAreaHeight+10:24, 33, 33)];
    [buttonBack.layer setCornerRadius:33 / 2];
    [buttonBack.layer setMasksToBounds:YES];
    [buttonBack setImage:[UIImage imageNamed:@"baiBack"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    [self.view bringSubviewToFront:buttonBack];
    
    UIButton *rightShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, [ShiPeiIphoneXSRMax isIPhoneX]?HitoSafeAreaHeight+10:24, 33, 33)];
    [rightShare.layer setCornerRadius:33 / 2];
    [rightShare.layer setMasksToBounds:YES];
    [rightShare setImage:[UIImage imageNamed:@"shareRight"] forState:UIControlStateNormal];
    [rightShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightShare];
    
    [self.view bringSubviewToFront:rightShare];
}
-(void)realToOrder
{
    perentOrderViewController *perentOrder = [[perentOrderViewController alloc] init];
    [self.navigationController pushViewController:perentOrder animated:YES];
}

-(void)turnToOrderAction
{
    paySuccessViewController *paySuccess = [[paySuccessViewController alloc] init];
    [self.navigationController pushViewController:paySuccess animated:YES];
}

-(void)backClick
{
    [sizeCollection removeFromSuperview];
    [sizeShowCollection removeFromSuperview];
    [bgViewAlpha removeFromSuperview];
    [sizeList removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createGetData
{
    
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:@(_model.ID) forKey:@"goods_id"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_DingZhiDetailAndPeiJian_String] parameters:parmas finished:^(id responseObject, NSError *error) {
        //        WCLLog(@"%@----%@",responseObject,error);
        if ([self checkHttpResponseResultStatus:responseObject]) {
            models = [designerDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            NSArray*morepic = models.ad_img.mutableCopy;
            for (imgListModel*modelsss in morepic) {
                [pictureArray addObject:modelsss.img];
                [prctureIntro addObject:modelsss.desc];
            }
            skuOneModel*model1 = [models.sku firstObject];
            skuTwoModel*model3 = model1.sku[0];
            skuOneModel*model2 = models.sku[1];
            skuTwoModel*model4 = model2.sku[0];
            idsStr1 = [NSString stringWithFormat:@"%@",@(model3.ID)].mutableCopy;
            idsStr2 = [NSString stringWithFormat:@"%@",@(model4.ID)].mutableCopy;
            NSString*strlls=[NSString stringWithFormat:@"%@,%@",idsStr1,idsStr2];
            [self createView];
            [self createBack];
            [self createLowView];
            [self createAlphaView];
            [self kucunWithString:strlls];
            [self createAlphaBuyView];
            [self createDetailButton];
        }
        else
        {
            [self createBack];
        }
    }];
    
}
-(void)kucunWithString:(NSString*)string{
    NSMutableDictionary*parmaes = [NSMutableDictionary dictionary];
    parmaes[@"sku_id_s"]=string;
    parmaes[@"goods_id"]=@(models.ID);
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_ChengPinKuCun_String] parameters:parmaes finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            kucunNum = responseObject[@"stock"];
            [numberLabel setText:[NSString stringWithFormat:@"库存%@件",kucunNum]];
        }
    }];
}
-(void)createDetailButton
{
    
    detailButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 42, 100, 42, 40)];
    
    [detailButton setImage:[UIImage imageNamed:@"clothesDetail"] forState:UIControlStateNormal];
    [detailButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [detailButton.titleLabel setNumberOfLines:0];
    [self.view addSubview:detailButton];
    [detailButton addTarget:self action:@selector(clothesDetailClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clothesDetailClick
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [imageBg setAlpha:1];
    [buttonClose setAlpha:1];
    
    [detailButton setAlpha:0];
    [UIView commitAnimations];
}

-(void)closeClick
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [imageBg setAlpha:0];
    [buttonClose setAlpha:0];
    
    [detailButton setAlpha:1];
    [UIView commitAnimations];
}

-(void)createAlphaView
{
    
    imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageBg setUserInteractionEnabled:YES];
    [imageBg setImage:[UIImage imageNamed:@"BGALPHA"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    [self.view addSubview:imageBg];
    [imageBg setAlpha:0];
    [imageBg addGestureRecognizer:tap];
    
    
    UILabel *detailLabel = [UILabel new];
    if ([models.detail isEqualToString:@""]) {
        [detailLabel setText:@"暂无详情介绍"];
    } else {
        [detailLabel setText:models.detail];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailLabel.text length])];
    detailLabel.attributedText = attributedString;
    [detailLabel setNumberOfLines:0];
    
    [detailLabel setFont:[UIFont systemFontOfSize:14]];
    [detailLabel setTextColor:[UIColor whiteColor]];
    detailLabel.frame = CGRectMake(20, 64, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 64 - 100);
    [imageBg addSubview:detailLabel];
}


-(void)createView
{
    CircleScrollView *scr1 = [[CircleScrollView alloc]initWithImgUrls:pictureArray  fram:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) intro:prctureIntro];
    csview = scr1;
    scr1.circleScrollType = CircleScrollTypePageControl;
    scr1.circleScrollStyle = CircleScrollStyleSkewing;
    scr1.circleDelegate = self;
    [self.view addSubview:scr1];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == colthesCollect) {
        int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
        //    NSLog(@"%d", page);
        
        // 设置页码
        page.currentPage = pageNum;
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



-(void)createLowView
{
    
    UIButton* addCar = [UIButton new];
    [self.view addSubview:addCar];
    addCar.sd_layout
    .leftSpaceToView(self.view, 26)
    .bottomSpaceToView(self.view, 26)
    .heightIs(25)
    .widthIs(36);
    [addCar setImage:[UIImage imageNamed:@"addCarDesigner"] forState:UIControlStateNormal];
    [addCar addTarget:self action:@selector(showBuyChoose) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * buyDesigner = [UIButton new];
    [self.view addSubview:buyDesigner];
    buyDesigner.sd_layout
    .leftSpaceToView(addCar, 24)
    .bottomSpaceToView(self.view, 26)
    .heightIs(25)
    .widthIs(36);
    [buyDesigner setImage:[UIImage imageNamed:@"buyDesignerClothes"] forState:UIControlStateNormal];
    [buyDesigner addTarget:self action:@selector(showBuyChoose) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* imageLine = [UIImageView new];
    [self.view addSubview:imageLine];
    imageLine.sd_layout
    .bottomSpaceToView(buyDesigner, 16)
    .leftSpaceToView(self.view, 12)
    .rightSpaceToView(self.view, 12)
    .heightIs(2);
    [imageLine setImage:[UIImage imageNamed:@"imageLine"]];
    
    
    
}


-(void)createAlphaBuyView
{
    bgViewAlpha = [[UIView alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?self.view.frame.size.height-289-21: self.view.frame.size.height - 289, SCREEN_WIDTH,[ShiPeiIphoneXSRMax isIPhoneX]?310:289)];
    [bgViewAlpha setBackgroundColor:[UIColor colorWithHexString:@"#EDEDED"]];
    [self.view addSubview:bgViewAlpha];
    UIImageView *imageHead = [[UIImageView alloc] initWithFrame:CGRectMake(20, -30, 70, 90)];
    imageHead.contentMode = UIViewContentModeScaleAspectFill;
    imgListModel*model3 = [models.ad_img firstObject];
    [imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL, model3.img]]];
    [bgViewAlpha addSubview:imageHead];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 40, 40)];
    [btnClose addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setImage:[UIImage imageNamed:@"CHA"] forState:UIControlStateNormal];
    [bgViewAlpha addSubview:btnClose];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
    [priceLabel setText:[NSString stringWithFormat:@"价格 ¥%@", models.sell_price]];
    [priceLabel setFont:Font_14];
    [bgViewAlpha addSubview:priceLabel];
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 35, 200, 20)];
    //    [numberLabel setText:[NSString stringWithFormat:@"库存%@件",kucunNum]];
    [numberLabel setTextColor:[UIColor grayColor]];
    [numberLabel setFont:[UIFont systemFontOfSize:12]];
    [bgViewAlpha addSubview:numberLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, 60, SCREEN_WIDTH - 40, 1)];
    [line1 setBackgroundColor:getUIColor(Color_BuyLineColor)];
    [bgViewAlpha addSubview:line1];
    
    UILabel *size = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 60, 20)];
    [size setText:@"选择尺码"];
    [size setFont:Font_14];
    [bgViewAlpha addSubview:size];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 20;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    sizeCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(90, 67.5, SCREEN_WIDTH - 110, 45) collectionViewLayout:flowLayout];
    //设置代理
    sizeCollection.delegate = self;
    sizeCollection.dataSource = self;
    [bgViewAlpha addSubview:sizeCollection];
    sizeCollection.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    //注册cell和ReusableView（相当于头部）
    
    sizeCollection.pagingEnabled = YES ;
    
    [sizeCollection registerClass:[sizeAndColorCollectionViewCell class] forCellWithReuseIdentifier:@"sizeCell"];
    [sizeCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView2"];
    [sizeCollection setShowsHorizontalScrollIndicator:NO];
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, 120, SCREEN_WIDTH - 40, 1)];
    [line2 setBackgroundColor:getUIColor(Color_BuyLineColor)];
    [bgViewAlpha addSubview:line2];
    
    UILabel *color = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 60, 20)];
    [color setText:@"选择颜色"];
    [color setFont:Font_14];
    [bgViewAlpha addSubview:color];
    
    
    
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout1.minimumInteritemSpacing = 20;
    
    sizeShowCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(90, 127.5, SCREEN_WIDTH - 110, 45) collectionViewLayout:flowLayout1];
    //设置代理
    sizeShowCollection.delegate = self;
    sizeShowCollection.dataSource = self;
    [bgViewAlpha addSubview:sizeShowCollection];
    sizeShowCollection.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    //注册cell和ReusableView（相当于头部）
    [sizeShowCollection setShowsHorizontalScrollIndicator:NO];
    sizeShowCollection.pagingEnabled = YES ;
    
    [sizeShowCollection registerClass:[sizeAndColorCollectionViewCell class] forCellWithReuseIdentifier:@"sizeShowCell"];
    [sizeShowCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView3"];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(20, 180, SCREEN_WIDTH - 40, 1)];
    [line3 setBackgroundColor:getUIColor(Color_BuyLineColor)];
    [bgViewAlpha addSubview:line3];
    
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 60, 20)];
    [count setText:@"选择数量"];
    [count setFont:Font_14];
    [bgViewAlpha addSubview:count];
    
    
    UIButton *buttonCut = [[UIButton alloc] initWithFrame:CGRectMake(120, 197.5, 60, 25)];
    [buttonCut setTitle:@"-" forState:UIControlStateNormal];
    [buttonCut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonCut.layer setBorderWidth:1];
    [buttonCut.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [bgViewAlpha addSubview:buttonCut];
    [buttonCut setTag:55];
    [buttonCut.layer setCornerRadius:3];
    [buttonCut.layer setMasksToBounds:YES];
    [buttonCut addTarget:self action:@selector(cutAndAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 197.5, 50, 25)];
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [countLabel setFont:[UIFont systemFontOfSize:12]];
    [countLabel setText:[NSString stringWithFormat:@"%ld",clothesCount]];
    [bgViewAlpha addSubview:countLabel];
    
    UIButton *buttonAdd = [[UIButton alloc] initWithFrame:CGRectMake(230, 197.5, 60, 25)];
    [buttonAdd setTitle:@"+" forState:UIControlStateNormal];
    [buttonAdd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonAdd.layer setBorderWidth:1];
    [buttonAdd setTag:56];
    [buttonAdd.layer setCornerRadius:3];
    [buttonAdd.layer setMasksToBounds:YES];
    [buttonAdd.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [buttonAdd addTarget:self action:@selector(cutAndAdd:) forControlEvents:UIControlEventTouchUpInside];
    [bgViewAlpha addSubview:buttonAdd];
    
    UIButton *addBuyBag = [[UIButton alloc] initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH / 2, 49)];
    [addBuyBag.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [addBuyBag setBackgroundColor:getUIColor(Color_saveColor)];
    [bgViewAlpha addSubview:addBuyBag];
    addBuyBag.qi_eventInterval=3;
    [addBuyBag addTarget:self action:@selector(addToBuyBag) forControlEvents:UIControlEventTouchUpInside];
    [addBuyBag setTitle:@"加入购物袋" forState:UIControlStateNormal];
    
    UIButton *BuyClick = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 240, SCREEN_WIDTH / 2, 49)];
    [BuyClick.titleLabel setFont:[UIFont systemFontOfSize:14]];
    BuyClick.qi_eventInterval=3;
    [BuyClick setBackgroundColor:getUIColor(Color_buyColor)];
    [bgViewAlpha addSubview:BuyClick];
    [BuyClick addTarget:self action:@selector(buyClickAction) forControlEvents:UIControlEventTouchUpInside];
    [BuyClick setTitle:@"立即购买" forState:UIControlStateNormal];
    
    
    [bgViewAlpha setAlpha:0];
    
}


-(void)cutAndAdd:(UIButton *)sender
{
    switch (sender.tag) {
        case 55:
            if (clothesCount > 1) {
                clothesCount--;
            }
            break;
        case 56:
            if (clothesCount < [kucunNum integerValue]) {
                clothesCount++;
            }
            
            break;
        default:
            break;
    }
    
    [countLabel setText:[NSString stringWithFormat:@"%ld",clothesCount]];
}

-(void)addToBuyBag
{
    [self hiddenBuyChoose];
    NSMutableDictionary*parrment = [NSMutableDictionary dictionary];
    NSString*string2=[NSString stringWithFormat:@"%@,%@",idsStr1,idsStr2];
    [parrment setObject:string2 forKey:@"sku_id_s"];
    [parrment setObject:@(clothesCount) forKey:@"goods_num"];
    [parrment setObject:@(ShoppingCarTypeAdd) forKey:@"type"];
    [parrment setObject:@(models.ID) forKey:@"goods_id"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_AddShoppingCar_String] parameters:parrment finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            [self alertViewShowOfTime:@"添加购物车成功" time:1.5];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addCarSuccess" object:nil];
        }
    }];
}

-(void)buyClickAction
{
    [self hiddenBuyChoose];
    NSMutableDictionary*parrment = [NSMutableDictionary dictionary];
    NSString*string2=[NSString stringWithFormat:@"%@,%@",idsStr1,idsStr2];
    [parrment setObject:string2 forKey:@"sku_id_s"];
    [parrment setObject:@(clothesCount) forKey:@"goods_num"];
    [parrment setObject:@(ShoppingCarTypeAdd) forKey:@"type"];
    [parrment setObject:@(models.ID) forKey:@"goods_id"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_AddShoppingCar_String] parameters:parrment finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            PayForClothesViewController *clothesPay = [[PayForClothesViewController alloc] init];
            clothesPay.carId = [responseObject stringForKey:@"cart_id"];
            clothesPay.allPrice = models.sell_price;
            [self.navigationController pushViewController:clothesPay animated:YES];
        }
    }];
    
    
}

-(void)clickCancel
{
    [self hiddenBuyChoose];
}


-(void)hiddenBuyChoose
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [bgViewAlpha setAlpha:0];
    [UIView commitAnimations];
}

-(void)showBuyChoose
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [bgViewAlpha setAlpha:1];
    [UIView commitAnimations];
}


//-(void)chatClick
//{
//    QYSource *source = [[QYSource alloc] init];
//    source.title =  @"私人顾问";
//
//    QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];
//    [self.navigationController setNavigationBarHidden:NO];
//    vc.sessionTitle = @"私人顾问";
//    vc.source = source;
//
//
//    if (iPadDevice) {
//        UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:vc];
//        navi.modalPresentationStyle = UIModalPresentationFormSheet;
//        [self presentViewController:navi animated:YES completion:nil];
//    }
//    else{
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    [self alertViewShowOfTime:@"客服不在线哦,请拨打电话:4009901213" time:1];
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == sizeCollection) {
        skuOneModel*onemodel = models.sku[0];
        
        return [onemodel.sku count];
    } else if (collectionView == sizeShowCollection) {
        if ([models.sku count] > 0) {
            skuOneModel*onemodel = models.sku[1];
            return [onemodel.sku count];
        } else
            return 0;
    } else {
        
        return [pictureArray count];
    };
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *recell;
    if (collectionView == sizeCollection) {
        static NSString *identify = @"sizeCell";
        sizeAndColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        skuOneModel*onemodel = models.sku[0];
        skuTwoModel*towmodel = onemodel.sku[indexPath.item];
        
        if (indexPath.item == flogSize) {
            [cell.sizeAndColorLabel setBackgroundColor:getUIColor(Color_buyColor)];
        } else {
            [cell.sizeAndColorLabel setBackgroundColor:getUIColor(Color_saveColor)];
        }
        [cell.sizeAndColorLabel setHidden:NO];
        [cell.colorImg setHidden:YES];
        [cell.whiteAlpha setHidden:YES];
        
        [cell.sizeAndColorLabel setText:towmodel.name];
        [cell sizeToFit];
        recell = cell;
        
    } else if(collectionView == sizeShowCollection) {
        static NSString *identify = @"sizeShowCell";
        sizeAndColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        skuOneModel*onemodel = models.sku[1];
        skuTwoModel*towmodel = onemodel.sku[indexPath.item];
        
        //        [cell.sizeAndColorLabel setText:[[[sizeList[flogSize] arrayForKey:@"size_list"] objectAtIndex:indexPath.item] stringForKey:@"name"]];
        [cell.sizeAndColorLabel setHidden:YES];
        [cell.colorImg setHidden:NO];
        [cell.colorImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, towmodel.img]]];
        
        if (indexPath.item == flogSizeShow) {
            [cell.whiteAlpha setHidden:NO];
            
        } else {
            [cell.whiteAlpha setHidden:YES];
        }
        
        [cell sizeToFit];
        recell = cell;
    }else {
        
        
        static NSString *identify = @"cell";
        
        designerForClothesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.pictureUrl = pictureArray[indexPath.row];
        cell.intro = prctureIntro[indexPath.row];
        cell.model = models;
        
        [cell.headButn addTarget:self action:@selector(designerClick) forControlEvents:UIControlEventTouchUpInside];
        [cell sizeToFit];
        recell = cell;
    }
    
    return recell;
}

-(void)designerClick
{
    //    DesignerDetailIntroduce *introduce = [[DesignerDetailIntroduce alloc] init];
    //    introduce.desginerId = [NSString stringWithFormat:@"%zd",designer.des_uid] ;
    //    introduce.designerImage = designer.avatar;
    //    introduce.designerName = designer.uname;
    //    introduce.remark = designer.recommend_goods_ids;
    //    [self.navigationController pushViewController:introduce animated:YES];
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    CGSize resize;
    if (collectionView == colthesCollect) {
        
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        
        
    }
    else {
        resize = CGSizeMake((SCREEN_WIDTH - 110) / 5, 45);
    }
    
    return resize;
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == colthesCollect) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else
        return UIEdgeInsetsMake(0, 20, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (collectionView == sizeCollection) {
        skuOneModel*onemodel = models.sku[0];
        skuTwoModel*towmodel = onemodel.sku[indexPath.item];
        sizeStr = [NSString stringWithFormat:@"尺寸:%@",towmodel.name];
        sizeId = [NSString stringWithFormat:@"%@",@(towmodel.ID)];
        flogSize = indexPath.item;
        
        colorStr = [NSString stringWithFormat:@"颜色:%@" ,towmodel.name];
        idsStr1 =[NSString stringWithFormat:@"%@",@(towmodel.ID)].mutableCopy;
        flogSizeShow = 0;
        //        sizeShowDic = [[sizeList[indexPath.item] arrayForKey:@"size_list"] firstObject];
        clothesPrice = models.sell_price;
        
        [self reloadLowViewData];
        [sizeCollection reloadData];
        [sizeShowCollection reloadData];
    }else if (collectionView == sizeShowCollection) {
        skuOneModel*onemodel = models.sku[1];
        skuTwoModel*towmodel = onemodel.sku[indexPath.item];
        colorStr = [NSString stringWithFormat:@"颜色:%@" ,towmodel.name];
        idsStr2 =[NSString stringWithFormat:@"%@",@(towmodel.ID)].mutableCopy;
        flogSizeShow = indexPath.item;
        [sizeShowCollection reloadData];
    } else {
        if (indexPath.item == 1) {
            if ([new_comment allKeys].count > 0) {
                commentListViewController *commentList = [[commentListViewController alloc] init];
                commentList.goodId = [_goodDic stringForKey:@"id"];
                [self.navigationController pushViewController:commentList animated:YES];
                
            }
        }
    }
    NSMutableString*str3 = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@,%@",idsStr1,idsStr2]];
    [self kucunWithString:str3];
}

-(void)reloadLowViewData
{
    
    clothesCount = 1;
    [countLabel setText:[NSString stringWithFormat:@"%ld",clothesCount]];
    [priceLabel setText:[NSString stringWithFormat:@"价格 ¥%@", models.sell_price]];
    [numberLabel setText:[NSString stringWithFormat:@"库存%@件",kucunNum]];
    
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
