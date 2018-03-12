//
//  DiyClothesDetailViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/19.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//



#define URL_SHARE @"/web/jquery-obj/static/fx/html/chengping.html"

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
@interface DesignerClothesDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate,CircleScrollDelegate>

@end

@implementation DesignerClothesDetailViewController
{
    BaseDomain *getData;
    BaseDomain *postData;
    NSMutableDictionary *dataDictionary;
    NSMutableArray *pictureArray;
    NSMutableArray *prctureIntro;
    
    
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
    
    NSString *lt_data;
    
    UIButton *detailButton;
    UIButton *buttonClose;
    UIImageView *imageBg;
}

-(void)viewWillAppear:(BOOL)animated
{
   
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}

-(void)shareClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    
    NSString *goodsId;
    if (_good_id) {
        goodsId = _good_id;
    } else {
        goodsId = [_goodDic stringForKey:@"goods_id"];
    }
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [dataDictionary stringForKey:@"thumb"]]]];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:[dataDictionary stringForKey:@"content"]
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?goods_id=%@&shop_id=%@&market_id=%@&type=2", URL_HEADURL,URL_SHARE, goodsId,_shopId,_marketId]]
                                      title:[dataDictionary stringForKey:@"name"]
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareWithContent:shareParams];
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    new_comment = [NSMutableDictionary dictionary];
    collectionArray = [NSMutableArray array];
    modelComm = [commentModel new];
    flogSize = 0;
    flogSizeShow = 0;
    clothesCount = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToOrderAction) name:@"turnToOrder" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realToOrder) name:@"realToOrder" object:nil];
    sizeList = [NSMutableArray array];
    sizeShowDic = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    designer = [designerModel new];
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
//    perentOrderViewController *perentOrder = [[perentOrderViewController alloc] init];
//    [self.navigationController pushViewController:perentOrder animated:YES];
    paySuccessViewController *paySuccess = [[paySuccessViewController alloc] init];
    [self.navigationController pushViewController:paySuccess animated:YES];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createGetData
{
    
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    
    if (_good_id) {
        [parmas setObject:_good_id forKey:@"goods_id"];
    } else {
        [parmas setObject:[_goodDic stringForKey:@"goods_id"] forKey:@"goods_id"];

    }
    [getData getData:URL_GetYouPingDetailNew PostParams:parmas finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            dataDictionary = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
            _class_id = [dataDictionary stringForKey:@"classify_id"];
            pictureArray = [NSMutableArray arrayWithArray:[dataDictionary arrayForKey:@"img_list"]];
            prctureIntro = [NSMutableArray arrayWithArray:[dataDictionary arrayForKey:@"img_introduce"]];
            
            lt_data = [domain.dataRoot stringForKey:@"lt_data"];
            designer.content = [dataDictionary stringForKey:@"content"];
            designer.img = [dataDictionary stringForKey:@"thumb"];
            designer.name = [[dataDictionary dictionaryForKey:@"designer"] stringForKey:@"name"];
            designer.avatar = [[dataDictionary dictionaryForKey:@"designer"] stringForKey:@"avatar"];
            designer.tag = [[dataDictionary dictionaryForKey:@"designer"] stringForKey:@"tag"];
            designer.name = [dataDictionary stringForKey:@"sub_name"];
//            _model.good_Id = [dataDictionary stringForKey:@"uid"];
            designer.detailClothesImg = [dataDictionary arrayForKey:@"img_list"][0];
            designer.deginerID = [[dataDictionary dictionaryForKey:@"designer"] stringForKey:@"id"];
            designer.introduce = [[dataDictionary dictionaryForKey:@"designer"] stringForKey:@"introduce"];
            
            new_comment = [NSMutableDictionary dictionaryWithDictionary:[dataDictionary dictionaryForKey:@"new_comment"]];
            collectionArray = [NSMutableArray arrayWithArray:[dataDictionary arrayForKey:@"collect_user"]];
            
            
            modelComm.collectArray = [NSMutableArray arrayWithArray:collectionArray];
            modelComm.commentDic =[NSMutableDictionary dictionaryWithDictionary: new_comment];
            modelComm.comentNum = [dataDictionary stringForKey:@"comment_num"];
            
            
            if (_good_id) {
                designer.goods_id = _good_id;
            } else {
                designer.goods_id = [_goodDic stringForKey:@"goods_id"];
                
            }
            
            sizeList = [NSMutableArray arrayWithArray:[dataDictionary arrayForKey:@"size_list"]];
            sizeShowDic = [[[sizeList firstObject] arrayForKey:@"size_list"] firstObject];
            if ([sizeList count] > 0) {
//                sizeStr = [NSString stringWithFormat:@"%@:%@", [sizeList[0] stringForKey:@"size_name"],[sizeList[0] stringForKey:@"name"]];
                sizeStr = [NSString stringWithFormat:@"尺寸:%@", [sizeList[0] stringForKey:@"size_name"]];
//                colorStr = [NSString stringWithFormat:@"%@:%@", [[[sizeList[flogSize] arrayForKey:@"size_list"] firstObject] stringForKey:@"size_name"],[[[sizeList[flogSize] arrayForKey:@"size_list"] firstObject] stringForKey:@"name"]];
                colorStr = [NSString stringWithFormat:@"颜色:%@", [[[sizeList[flogSize] arrayForKey:@"size_list"] firstObject] stringForKey:@"color_name"]];
                sizeId = [sizeList[0] stringForKey:@"id"];
            }
            
            
            clothesPrice = [sizeShowDic stringForKey:@"price"];
            [self createView];
//            [self createScroller];
            [self createLowView];
            [self createAlphaBuyView];
            [self createDetailButton];
            [self createAlphaView];
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
    if ([[dataDictionary stringForKey:@"chengping_canshu"] isEqualToString:@""]) {
        [detailLabel setText:@"暂无详情介绍"];
    } else {
        [detailLabel setText:[dataDictionary stringForKey:@"chengping_canshu"]];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailLabel.text length])];
    detailLabel.attributedText = attributedString;
    [detailLabel setNumberOfLines:0];
    
    [detailLabel setFont:[UIFont systemFontOfSize:14]];
    [detailLabel setTextColor:[UIColor whiteColor]];
    
    //    detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 40, 9999);//labelsize的最大值
//    //关键语句
//    CGSize expectSize = [detailLabel sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    detailLabel.frame = CGRectMake(20, 64, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 64 - 100);
    [imageBg addSubview:detailLabel];
    
   
    
    //    scrollerClothesDetail.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
    
    
    
    
}


-(void)createView
{
//    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    flowLayout.minimumLineSpacing = 0;
//    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
//    colthesCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
//
//    //设置代理
//    colthesCollect.delegate = self;
//    colthesCollect.dataSource = self;
//    [self.view addSubview:colthesCollect];
//
//    colthesCollect.showsHorizontalScrollIndicator = FALSE;
//
//    colthesCollect.backgroundColor = [UIColor whiteColor];
//    //注册cell和ReusableView（相当于头部）
////    colthesCollect.alwaysBounceVertical = YES;
//    colthesCollect.pagingEnabled = YES ;
//
//    [colthesCollect registerClass:[designerForClothesCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//
//    [colthesCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
    CircleScrollView *scr1 = [[CircleScrollView alloc]initWithImgUrls:pictureArray  fram:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) intro:prctureIntro];
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


//-(void)createScroller
//{
//    scrollerDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
//    [self.view addSubview:scrollerDetail];
//    scrollerDetail.delegate = self;
//    
//    UIImageView *imageDetailDes = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
//    [imageDetailDes sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [dataDictionary stringForKey:@"content2"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        CGFloat scan = image.size.width / image.size.height;
//        
//        if (SCREEN_WIDTH / scan < SCREEN_HEIGHT) {
//            scrollerDetail.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT + 80);
//            
//        } else {
//            scrollerDetail.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
//        }
//        
//        [imageDetailDes setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / scan)];
//        
//    }];
//    [scrollerDetail addSubview:imageDetailDes];
//}


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
    
    
//    page = [UIPageControl new];
//    [self.view addSubview:page];
//    page.sd_layout
//    .rightSpaceToView(self.view, 14)
//    .bottomSpaceToView(self.view, 26)
//    .heightIs(15)
//    .widthIs(90);
//    page.numberOfPages = [pictureArray count];//指定页面个数
//    page.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
//    page.pageIndicatorTintColor = [UIColor grayColor];// 设置非选中页的圆点颜色
//    
//    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(12, 24, 33, 33)];
    
    [buttonBack.layer setCornerRadius:33 / 2];
    [buttonBack.layer setMasksToBounds:YES];
    [buttonBack setImage:[UIImage imageNamed:@"baiBack"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    [self.view bringSubviewToFront:buttonBack];
    
    UIButton *rightShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 24, 33, 33)];
    
    [rightShare.layer setCornerRadius:33 / 2];
    [rightShare.layer setMasksToBounds:YES];
    [rightShare setImage:[UIImage imageNamed:@"shareRight"] forState:UIControlStateNormal];
    [rightShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightShare];
    
    [self.view bringSubviewToFront:rightShare];
    
}


-(void)createAlphaBuyView
{
    bgViewAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 289, SCREEN_WIDTH, 289)];
    [bgViewAlpha setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgViewAlpha];
    UIImageView *imageHead = [[UIImageView alloc] initWithFrame:CGRectMake(20, -30, 70, 90)];
    [imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL, [dataDictionary stringForKey:@"thumb"]]]];
    [bgViewAlpha addSubview:imageHead];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 5, 40, 40)];
    [btnClose addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setImage:[UIImage imageNamed:@"CHA"] forState:UIControlStateNormal];
    [bgViewAlpha addSubview:btnClose];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
    [priceLabel setText:[NSString stringWithFormat:@"¥ %@", [sizeShowDic stringForKey:@"price"]]];
    [priceLabel setFont:Font_14];
    [bgViewAlpha addSubview:priceLabel];
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 35, 200, 20)];
    [numberLabel setText:[NSString stringWithFormat:@"库存%@件",[sizeShowDic stringForKey:@"sku_num"]]];
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
    sizeCollection.backgroundColor = [UIColor whiteColor];
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
    sizeShowCollection.backgroundColor = [UIColor whiteColor];
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
    [addBuyBag addTarget:self action:@selector(addToBuyBag) forControlEvents:UIControlEventTouchUpInside];
    [addBuyBag setTitle:@"加入购物袋" forState:UIControlStateNormal];
    
    UIButton *BuyClick = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 240, SCREEN_WIDTH / 2, 49)];
    [BuyClick.titleLabel setFont:[UIFont systemFontOfSize:14]];
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
            if (clothesCount < [[sizeShowDic stringForKey:@"sku_num"] integerValue]) {
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
    //
    if (_marketId==nil) {
        _marketId = @"";
    }
    if (_shopId==nil) {
        _shopId = @"";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:designer.goods_id forKey:@"goods_id"];
    [params setObject:@"2" forKey:@"goods_type"];
    [params setObject:clothesPrice forKey:@"price"];
    [params setObject:[dataDictionary stringForKey:@"name"] forKey:@"goods_name"];
    [params setObject:[NSString stringWithFormat:@"%@;%@", colorStr,sizeStr] forKey:@"size_content"];
    [params setObject:[NSNumber numberWithInteger:clothesCount] forKey:@"num"];
    [params setObject:[sizeShowDic stringForKey:@"id"] forKey:@"size_ids"];
    [params setObject:[dataDictionary stringForKey:@"thumb"] forKey:@"goods_thumb"];
    [params setObject:_marketId forKey:@"market_id"];
    [params setObject:_shopId forKey:@"shop_id"];
    if ([sizeShowDic integerForKey:@"type"] == 1) {
        [params setObject:[sizeShowDic stringForKey:@"type"] forKey:@"size_type"];
    } else {
        [params setObject:[sizeShowDic stringForKey:@"type"] forKey:@"size_type"];
        if (lt_data.length > 0) {
             [params setObject:lt_data forKey:@"lt_data_id"];
        }
       
    }
    [params setObject:@"2" forKey:@"type"];
    [postData postData:URL_AddClothesCar PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if (postData.result == 10001) {
            [self getDateBeginHaveReturn:datBegin fatherView:@"收藏"];
        } else if (postData.result == 1) {
//            [self showAlertWithTitle:@"提示" message:@"加入购物车成功"];
            [self alertViewShowOfTime:@"加入购物车成功" time:1.5];
        }
        
    }];
    
    
}

-(void)buyClickAction
{
    [self hiddenBuyChoose];
    if (_marketId==nil) {
        _marketId = @"";
    }
    if (_shopId==nil) {
        _shopId = @"";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:designer.goods_id forKey:@"goods_id"];
    [params setObject:@"2" forKey:@"goods_type"];
    [params setObject:clothesPrice forKey:@"price"];
    [params setObject:[dataDictionary stringForKey:@"name"] forKey:@"goods_name"];
    [params setObject:[NSString stringWithFormat:@"%@;%@", colorStr,sizeStr] forKey:@"size_content"];
    [params setObject:[NSNumber numberWithInteger:clothesCount] forKey:@"num"];
    [params setObject:[sizeShowDic stringForKey:@"id"] forKey:@"size_ids"];
    [params setObject:[dataDictionary stringForKey:@"thumb"] forKey:@"goods_thumb"];
    [params setObject:@"1" forKey:@"type"];
    [params setObject:_marketId forKey:@"market_id"];
    [params setObject:_shopId forKey:@"shop_id"];
    if ([sizeShowDic integerForKey:@"type"] == 1) {
        [params setObject:[sizeShowDic stringForKey:@"type"] forKey:@"size_type"];
    } else {
        [params setObject:[sizeShowDic stringForKey:@"type"] forKey:@"size_type"];
        if (lt_data.length > 0) {
            [params setObject:lt_data forKey:@"lt_data_id"];
        }
    }
    
    [postData postData:URL_AddClothesCar PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if (postData.result == 10001) {
            [self getDateBeginHaveReturn:datBegin fatherView:@"收藏"];
        } else if (postData.result == 1) {
            ClothesFroPay *model = [ClothesFroPay new];
            model.clothesImage = [dataDictionary stringForKey:@"thumb"];
            model.clothesCount = [NSString stringWithFormat:@"%ld",clothesCount];
            model.clothesName = [dataDictionary stringForKey:@"name"];
            model.clothesPrice = clothesPrice;
            model.clotheMaxCount = [sizeShowDic stringForKey:@"sku_num"];
            NSMutableArray *array = [NSMutableArray arrayWithObjects:model, nil];
            PayForClothesViewController *clothesPay = [[PayForClothesViewController alloc] init];
            clothesPay.arrayForClothes = array;
            
            clothesPay.carId = [[postData.dataRoot objectForKey:@"data"] stringForKey:@"car_id"];
            clothesPay.allPrice = [NSString stringWithFormat:@"%.2f",[clothesPrice floatValue] * clothesCount];
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


-(void)saveClothesClick
{
    //    [self showAlertWithTitle:@"提示" message:@"分享成功"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"type"];
    [params setObject:designer.goods_id forKey:@"cid"];
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




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView == sizeCollection) {
        return [sizeList count];
    } else if (collectionView == sizeShowCollection) {
        if ([sizeList count] > 0) {
            return [[sizeList[flogSize] arrayForKey:@"size_list"] count];
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
        if (indexPath.item == flogSize) {
            [cell.sizeAndColorLabel setBackgroundColor:getUIColor(Color_buyColor)];
        } else {
            [cell.sizeAndColorLabel setBackgroundColor:getUIColor(Color_saveColor)];
        }
        [cell.sizeAndColorLabel setHidden:NO];
        [cell.colorImg setHidden:YES];
        [cell.whiteAlpha setHidden:YES];
        [cell.sizeAndColorLabel setText:[sizeList[indexPath.item] stringForKey:@"size_name"]];
        [cell sizeToFit];
        recell = cell;
        
    } else if(collectionView == sizeShowCollection) {
        static NSString *identify = @"sizeShowCell";
        sizeAndColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
       
//        [cell.sizeAndColorLabel setText:[[[sizeList[flogSize] arrayForKey:@"size_list"] objectAtIndex:indexPath.item] stringForKey:@"name"]];
        [cell.sizeAndColorLabel setHidden:YES];
        [cell.colorImg setHidden:NO];
        [cell.colorImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[[sizeList[flogSize] arrayForKey:@"size_list"] objectAtIndex:indexPath.item] stringForKey:@"color_img"]]]];
        
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
        cell.model = designer;
        
        [cell.headButn addTarget:self action:@selector(designerClick) forControlEvents:UIControlEventTouchUpInside];
        [cell sizeToFit];
        recell = cell;
    }

    return recell;
}

-(void)designerClick
{
    DesignerDetailIntroduce *introduce = [[DesignerDetailIntroduce alloc] init];
    introduce.desginerId = [NSString stringWithFormat:@"%zd",designer.des_uid] ;
    introduce.designerImage = designer.avatar;
    introduce.designerName = designer.uname;
    introduce.remark = designer.recommend_goods_ids;
    [self.navigationController pushViewController:introduce animated:YES];
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

        sizeStr = [NSString stringWithFormat:@"尺寸:%@",[sizeList[indexPath.item] stringForKey:@"size_name"]];
        sizeId = [sizeList[indexPath.item] stringForKey:@"id"];
        flogSize = indexPath.item;
        
        colorStr = [NSString stringWithFormat:@"颜色:%@" ,[[[sizeList[flogSize] arrayForKey:@"size_list"] firstObject] stringForKey:@"color_name"]];
        
        flogSizeShow = 0;
        sizeShowDic = [[sizeList[indexPath.item] arrayForKey:@"size_list"] firstObject];
        clothesPrice = [sizeShowDic stringForKey:@"price"];
        
        [self reloadLowViewData];
        [sizeCollection reloadData];
        [sizeShowCollection reloadData];
    }else if (collectionView == sizeShowCollection) {

        colorStr = [NSString stringWithFormat:@"颜色:%@" ,[[[sizeList[flogSize] arrayForKey:@"size_list"]objectAtIndex:indexPath.item] stringForKey:@"color_name"]];
        sizeShowDic = [[sizeList[flogSize] arrayForKey:@"size_list"] objectAtIndex:indexPath.item];
        clothesPrice = [sizeShowDic stringForKey:@"price"];
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
    
}

-(void)reloadLowViewData
{
    
    clothesCount = 1;
    [countLabel setText:[NSString stringWithFormat:@"%ld",clothesCount]];
    [priceLabel setText:[NSString stringWithFormat:@"价格 ¥%@", [sizeShowDic stringForKey:@"price"]]];
    [numberLabel setText:[NSString stringWithFormat:@"库存%@件",[sizeShowDic stringForKey:@"sku_num"]]];
    
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
