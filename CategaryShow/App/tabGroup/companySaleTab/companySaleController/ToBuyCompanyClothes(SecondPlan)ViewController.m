//
//  ToBuyCompanyClothes(SecondPlan)ViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/11.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//
#define URL_SHARE @"http://www.cloudworkshop.cn/web/jquery-obj/static/fx/html/youpin_one.html"
#import "ToBuyCompanyClothes(SecondPlan)ViewController.h"
#import "CompanySaleModel.h"
#import "secondPlanToBuyCollectionCollectionViewCell.h"
#import "STAlertView.h"
#import "ChooseClothesStyleViewController.h"
#import "EnterViewController.h"
#define URL_PINLUN @"html/comment.html"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>


#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "perentOrderViewController.h"
#import "YuYueToBuyViewController.h"
#import "priceChooseView.h"
#import "choosePriceModel.h"
#import "DiyWordInClothesViewController.h"
#import "JZAlbumViewController.h"
@interface ToBuyCompanyClothes_SecondPlan_ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIWebViewDelegate, priceChooseViewDelegate>

@end

@implementation ToBuyCompanyClothes_SecondPlan_ViewController
{
    UICollectionView *colthesCollect;
    NSMutableArray *arrayModel;
    UIButton *toBuyButton;   //立即订购
    UIButton *toSave;     //加入购物车
    UIButton *chatService;  //私人顾问
    UIButton *clothesDetail;  //商品详情
    UIButton *buttonShare;
    
    UIScrollView *scrollerClothesDetail;
    UIButton *buttonClose;
    UIView *lineView;
    UIPageControl *pageCntroller;
    UIScrollView *pinlunScroller;
    UIButton *detailButton;
    UILabel *lowWoringLabel;
    NSMutableDictionary *dataDictionary;
    UIWebView *webPL;
    BaseDomain *getData;
    BaseDomain *getYingDao;
    priceChooseView *viewPiceChoose;
    UIImageView *alphaView;
    NSMutableArray *pictureArray;
    UIImageView *Yingdao;
    NSMutableArray *YDImgArray;
    NSInteger flogTouch;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    getData = [BaseDomain getInstance:NO];
    getYingDao = [BaseDomain getInstance:NO];
    pictureArray = [NSMutableArray array];
    arrayModel = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
   
    UIButton *share = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [share setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:share];
    [share addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [self createGetData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToOrderAction) name:@"turnToOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStatus) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStatus) name:@"YYSuccess" object:nil];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    if ([[userd stringForKey:@"firstEnter"] isEqualToString:@""]) {
        flogTouch = 1;
        [self getYingDao];
    }
}



-(void)getYingDao
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"id"];
    [getYingDao getData:URL_GetYingDao PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getYingDao]) {
            
            YDImgArray = [NSMutableArray arrayWithArray:[[getYingDao.dataRoot objectForKey:@"data"] arrayForKey:@"img_urls"]];
            [self createYingDao];
            
        }
    }];
}

-(void)createYingDao
{
    Yingdao = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [Yingdao setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yingDaoClick)];
    [Yingdao addGestureRecognizer:tap];
    
    [Yingdao sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [YDImgArray firstObject]]]];
    [self.view addSubview:Yingdao];
    
    
}

-(void)yingDaoClick
{
    if (flogTouch < [YDImgArray count]) {
        [Yingdao sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [YDImgArray objectAtIndex:flogTouch]]]];
        flogTouch ++;
    } else {
        [Yingdao removeFromSuperview];
         NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
        [userd setObject:@"yes" forKey:@"firstEnter"];
    }
}

-(void)turnToOrderAction
{
    perentOrderViewController *perentOrder = [[perentOrderViewController alloc] init];
    [self.navigationController pushViewController:perentOrder animated:YES];
    
    
    
    
}



-(void)shareClick:(UIButton *)sender
{


    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
     NSString *string = [[dataDictionary arrayForKey:@"price"] componentsJoinedByString:@","];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_goodDic stringForKey:@"thumb"]]]];
     [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:[dataDictionary stringForKey:@"content"]
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&type=2&price=%@", URL_SHARE, [_goodDic stringForKey:@"id"], string]]
                                      title:[dataDictionary stringForKey:@"name"]
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareWithContent:shareParams];

    

}

-(void)SuccessAction
{
    
}

-(void)createGetData
{
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [getData postData:URL_GetYouPingDetail PostParams:parmas finish:^(BaseDomain *domain, Boolean success) {
       
        if ([self checkHttpResponseResultStatus:getData]) {
            dataDictionary = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
            _class_id = [dataDictionary stringForKey:@"classify_id"];
            [self createSecondPlanView];
            pictureArray = [NSMutableArray arrayWithArray:[dataDictionary arrayForKey:@"img_list"]];
            self.title = [dataDictionary stringForKey:@"name"];
            for (int i = 0; i < [pictureArray count]; i ++) {
                CompanySaleModel *model = [[CompanySaleModel alloc] init];
                model.clothesUrl = pictureArray[i];
                
                [arrayModel addObject:model];
            }
            
            self.title = [dataDictionary stringForKey:@"name"];
            [colthesCollect reloadData];
            [self createPage];
            
        }
        
    }];
}

-(void)reloadStatus
{
    [dataDictionary removeAllObjects];
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [getData postData:URL_GetYouPingDetail PostParams:parmas finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            dataDictionary = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
             _class_id = [dataDictionary stringForKey:@"classify_id"];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [viewPiceChoose setAlpha:1];
            [alphaView setAlpha:1];
            [UIView commitAnimations];
            NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
            NSURLRequest *request;
            request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&token=%@&type=2",URL_WEBHEADURL, URL_PINLUN, [_goodDic stringForKey:@"id"] , [userd stringForKey:@"token"]]]];
            [webPL loadRequest:request];
        }
        
    }];
   
}


//-(void)lowViewWoringCreate
//{
//    lowWoringLabel = [UILabel new];
//    [self.view addSubview:lowWoringLabel];
//    
//    lowWoringLabel.sd_layout
//    .centerXEqualToView(self.view)
//    .bottomSpaceToView(self.view,80)
//    .heightIs(20)
//    .widthIs(SCREEN_WIDTH);
//    [lowWoringLabel setText:@"即将看到商品评论～"];
//    [lowWoringLabel setFont:[UIFont systemFontOfSize:14]];
//    [lowWoringLabel setTextAlignment:NSTextAlignmentCenter];
//    [lowWoringLabel setHidden:YES];
//    
//}

-(void)createDetailButton
{
    
    detailButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, colthesCollect.frame.origin.y + 20, 30, 233 / 2)];
    
    [detailButton setImage:[UIImage imageNamed:@"clothesDetail"] forState:UIControlStateNormal];
    [detailButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [detailButton.titleLabel setNumberOfLines:0];
    [self.view addSubview:detailButton];
    [detailButton addTarget:self action:@selector(clothesDetailClick) forControlEvents:UIControlEventTouchUpInside];
}

//-(void)createPinLun
//{
//    NSString *string = [[dataDictionary arrayForKey:@"price"] componentsJoinedByString:@","];
//    
//    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
//    
//    webPL = [[UIWebView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40)];
//    webPL.delegate = self;
//    [webPL setBackgroundColor:[UIColor whiteColor]];
//    webPL.scrollView.delegate = self;
//    [self.view addSubview:webPL];
//    NSURLRequest *request;
//    request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&token=%@&type=2&price=%@",URL_WEBHEADURL, URL_PINLUN, [_goodDic stringForKey:@"id"] , [userd stringForKey:@"token"], string]]];
//    [webPL loadRequest:request];
//    
//}

-(void)createSecondPlanView
{
    
    
    UILabel *hotLable = [UILabel new];
    [self.view addSubview:hotLable];
    [hotLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).with.offset(10);
        make.top.equalTo(self.view.mas_top).with.offset(74);
        make.height.equalTo(@20);
    }];
    [hotLable setText:[NSString stringWithFormat:@"%@℃", [dataDictionary stringForKey:@"heat"]]];
    [hotLable setTextColor:getUIColor(Color_measureTableTitle)];
    [hotLable setTextAlignment:NSTextAlignmentLeft];
    [hotLable setFont:[UIFont systemFontOfSize:14]];
    
    UIImageView *hot = [UIImageView new];
    [self.view addSubview:hot];
    hot.sd_layout
    .rightSpaceToView(hotLable, 2)
    .topSpaceToView(self.view, 76)
    .heightIs(15)
    .widthIs(15);
    [hot setImage:[UIImage imageNamed:@"hot"]];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    colthesCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64 + 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40) collectionViewLayout:flowLayout];
    
    //设置代理
    colthesCollect.delegate = self;
    colthesCollect.dataSource = self;
    [self.view addSubview:colthesCollect];
    colthesCollect.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    colthesCollect.alwaysBounceVertical = YES;
    colthesCollect.pagingEnabled = YES ;
    
    [colthesCollect registerClass:[secondPlanToBuyCollectionCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [colthesCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
   

}

-(void)createPage
{
    pageCntroller = [[UIPageControl alloc] initWithFrame:CGRectMake(-20, SCREEN_HEIGHT / 2 - 50, 60, 40)];
    CGAffineTransform rotation = CGAffineTransformMakeRotation( M_PI_2);
    [pageCntroller setTransform:rotation];
    pageCntroller.numberOfPages = [arrayModel count];
    pageCntroller.currentPage = 0;
    [self.view addSubview:pageCntroller];
    pageCntroller.pageIndicatorTintColor = [UIColor grayColor];
    pageCntroller.currentPageIndicatorTintColor = [UIColor whiteColor];
    
    
//    [self createPinLun];
    [self createDetailButton];
    [self createLowView];
    [self createAlphaView];
//    [self lowViewWoringCreate];
    [self createPriceView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if (scrollView == colthesCollect) {
        int index = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
        pageCntroller.currentPage = index;
        
//        if (scrollView.contentOffset.y > (SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40) * ([arrayModel count] - 1) + 30) {
//            [lowWoringLabel setHidden:NO];
//        }
//        
//        if (scrollView.contentOffset.y > (SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40) * ([arrayModel count] - 1) + 80) {
//            [lowWoringLabel setHidden:YES];
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.3];
//            [colthesCollect setOrigin:CGPointMake(0, - (SCREEN_HEIGHT - 64 - 49 - 40))];
//            [webPL setOrigin:CGPointMake(0, 64 + 40)];
//            [detailButton setAlpha:0];
//            [UIView commitAnimations];
//        
//        }
//    } else {
//        if (scrollView.contentOffset.y < - 80) {
//            [lowWoringLabel setHidden:YES];
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.3];
//            [colthesCollect setOrigin:CGPointMake(0, 64 + 40)];
//            [webPL setOrigin:CGPointMake(0, SCREEN_HEIGHT - 49)];
//            [detailButton setAlpha:1];
//            [UIView commitAnimations];
//        }
    }
    
    
}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [lowWoringLabel setHidden:YES];
//}

-(void)createAlphaView
{
    
    buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 72 , 32, 32)];
    [self.view addSubview:buttonClose];
    [buttonClose setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [buttonClose setAlpha:0];
    [buttonClose addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    scrollerClothesDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40 -49)];
    UILabel *detailLabel = [UILabel new];
    if ([[dataDictionary stringForKey:@"content"] isEqualToString:@""]) {
        [detailLabel setText:@"暂无详情介绍"];
    } else {
        [detailLabel setText:[dataDictionary stringForKey:@"content"]];
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
    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 40, 9999);//labelsize的最大值
        //关键语句
    CGSize expectSize = [detailLabel sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    detailLabel.frame = CGRectMake(20, 40, expectSize.width, expectSize.height);
    
    CGFloat scan = expectSize.width / expectSize.height;
    UIImageView *imageBg;
    if (SCREEN_WIDTH / scan < SCREEN_HEIGHT - 64 - 49 - 40) {
      imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40)];
    } else {
      imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / scan)];
    }
    
    [imageBg setImage:[UIImage imageNamed:@"BGALPHA"]];
    //    scrollerClothesDetail.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
    [scrollerClothesDetail addSubview:imageBg];
    
    
    [scrollerClothesDetail addSubview:detailLabel];
    scrollerClothesDetail.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
    [self.view addSubview:scrollerClothesDetail];
    
    [scrollerClothesDetail setAlpha:0];
}

-(void)createLowView
{
    
    UIView *line = [UIView new];
    [self.view addSubview:line];
    line.sd_layout
    .bottomSpaceToView(self.view,49)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(1);
    [line setBackgroundColor:getUIColor(Color_background)];
    
    
    chatService = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:chatService];
    [chatService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_bottom).with.offset(-49);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH / 4));
    }];
    
    [chatService setImage:[UIImage imageNamed:@"chatLine"] forState:UIControlStateNormal];
    [chatService setBackgroundColor:[UIColor whiteColor]];
    [chatService addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    
    toBuyButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:toBuyButton];
    [toBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chatService.mas_right);
        make.top.equalTo(self.view.mas_bottom).with.offset(-49);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH / 2));
    }];
    [toBuyButton setTitle:@"立即定制" forState:UIControlStateNormal];
    [toBuyButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [toBuyButton addTarget:self action:@selector(ClickToBuyBut) forControlEvents:UIControlEventTouchUpInside];
    
    [toBuyButton setBackgroundColor:getUIColor(Color_buyColor)];
    
    buttonShare = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:buttonShare];
    [buttonShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toBuyButton.mas_right);
        make.top.equalTo(self.view.mas_bottom).with.offset(-49);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH / 4));
    }];
    
    
    if([dataDictionary integerForKey:@"is_collect"] == 1) {
        [buttonShare setImage:[UIImage imageNamed:@"fullHeart"] forState:UIControlStateNormal];

    } else {
        [buttonShare setImage:[UIImage imageNamed:@"Empty"] forState:UIControlStateNormal];

    }
    [buttonShare.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [buttonShare setBackgroundColor:[UIColor whiteColor]];
    [buttonShare addTarget:self action:@selector(saveClothesClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}


-(void)chatClick
{
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"私人顾问";
    source.urlString = @"https://8.163.com/";
    
    QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = [dataDictionary stringForKey:@"name"];
    commodityInfo.desc = [dataDictionary stringForKey:@"remark"];
    commodityInfo.pictureUrlString = [NSString stringWithFormat:@"%@%@", PIC_HEADURL,[dataDictionary stringForKey:@"thumb"] ];
//    commodityInfo.urlString = _urlString.text;
//    commodityInfo.note = _note.text;
//    commodityInfo.show = _show.on;
    
    
    QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];
    vc.sessionTitle = @"私人顾问";
    vc.source = source;
    vc.commodityInfo = commodityInfo;

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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrayModel count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    secondPlanToBuyCollectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.model = arrayModel[indexPath.item];
    [cell sizeToFit];
   
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40);
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
    
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    
    jzAlbumVC.currentIndex = indexPath.item;//这个参数表示当前图片的index，默认是0
    
    jzAlbumVC.imgArr = pictureArray;//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:YES completion:nil];

}

#pragma mark - all button click

-(void)ClickToBuyBut {
    

    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    if ([[userd stringForKey:@"token"] length] > 0) {
        if ([dataDictionary integerForKey:@"is_yuyue"] == 1) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [viewPiceChoose setAlpha:1];
            [alphaView setAlpha:1];
            [UIView commitAnimations];
            
        } else {
            
            YuYueToBuyViewController *YuYue = [[YuYueToBuyViewController alloc] init];
            YuYue.goodName = [dataDictionary stringForKey:@"name"];
            [self.navigationController pushViewController:YuYue animated:YES];
        }

    } else {
        EnterViewController *enter = [[EnterViewController alloc] init];
        [self presentViewController:enter animated:YES completion:nil];
    }
    
    
    
}

-(void)hiddenChoose
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [viewPiceChoose setAlpha:0];
    [alphaView setAlpha:0];
    [UIView commitAnimations];
}

-(void)createPriceView
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NSArray *arrayPriceRemark = [[userd stringForKey:@"price_remark"] componentsSeparatedByString:@"/"];
    
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
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(55 * ([[dataDictionary arrayForKey:@"price"] count] + 1));
    
   
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [[dataDictionary arrayForKey:@"price"] count]; i ++) {
        NSString *string = [NSString stringWithFormat:@"￥%@  %@", [dataDictionary arrayForKey:@"price"][i], arrayPriceRemark[i]];
        [array addObject:string];
    }

    choosePriceModel *model = [choosePriceModel new];
    model.price = array;
    
    viewPiceChoose.model = model;
    [viewPiceChoose setAlpha:0];
    
    [self.view bringSubviewToFront:Yingdao];
    
}

-(void)clickPriceChoose:(NSInteger)item
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [viewPiceChoose setAlpha:0];
    [alphaView setAlpha:0];
    [UIView commitAnimations];
    NSArray *buttons = [dataDictionary arrayForKey:@"price"];
//    ChooseClothesStyleViewController *chooseStyle = [[ChooseClothesStyleViewController alloc] init];
//    chooseStyle.price_Type = [NSString stringWithFormat:@"%ld", item + 1];
//    chooseStyle.price = [buttons objectAtIndex:item];
//    chooseStyle.class_id = _class_id;
//    chooseStyle.goodDic = _goodDic;
//    [self.navigationController pushViewController:chooseStyle animated:YES];

    DiyWordInClothesViewController *diyClothes = [[DiyWordInClothesViewController alloc] init];
    diyClothes.price_type = [NSString stringWithFormat:@"%ld", item + 1];
    diyClothes.price = [buttons objectAtIndex:item];
    diyClothes.class_id = _class_id;
    diyClothes.goodDic = _goodDic;
    [self.navigationController pushViewController:diyClothes animated:YES];
    
}


-(void)clothesDetailClick
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [scrollerClothesDetail setAlpha:1];
    [buttonClose setAlpha:1];
    [lineView setAlpha:1];
    [detailButton setAlpha:0];
    [UIView commitAnimations];
}

-(void)closeClick
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [scrollerClothesDetail setAlpha:0];
    [buttonClose setAlpha:0];
    [lineView setAlpha:0];
    [detailButton setAlpha:1];
    [UIView commitAnimations];
}

-(void)saveClothesClick
{
//    [self showAlertWithTitle:@"提示" message:@"分享成功"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"type"];
    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"cid"];
    [getData postData:URL_AddSave PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        

            if (domain.result == 1) {
                
                 [buttonShare setImage:[UIImage imageNamed:@"fullHeart"] forState:UIControlStateNormal];
            } else if (domain.result == 10001) {
                EnterViewController *enter = [[EnterViewController alloc] init];
                [self presentViewController:enter animated:YES completion:nil];
            } else {
                
                [buttonShare setImage:[UIImage imageNamed:@"Empty"] forState:UIControlStateNormal];
            }
        
        [webPL reload];
        
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
