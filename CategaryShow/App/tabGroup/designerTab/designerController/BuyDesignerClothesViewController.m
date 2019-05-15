//
//  BuyDesignerClothesViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 16/10/13.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "BuyDesignerClothesViewController.h"
#import "CompanySaleModel.h"
#import "sizeAndColorCollectionViewCell.h"
#import "secondPlanToBuyCollectionCollectionViewCell.h"
#import "STAlertView.h"
#import "ClothesFroPay.h"
#import "PayForClothesViewController.h"
#import "ChooseClothesStyleViewController.h"
#define URL_PINLUN @"html/comment.html"

#define URL_WEB @"http://www.cloudworkshop.cn/web/jquery-obj/static/fx/html/youpin_one.html"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "perentOrderViewController.h"
@interface BuyDesignerClothesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate,UIWebViewDelegate>

@end

@implementation BuyDesignerClothesViewController
{
    UICollectionView *colthesCollect;
    NSMutableArray *arrayModel;
    UIButton *toBuyButton;   //立即订购
    UIButton *toSave;     //加入购物车
    UIButton *chatService;  //私人顾问
    UIButton *clothesDetail;  //商品详情
    UIScrollView *scrollerClothesDetail;
    UIButton *buttonClose;
    UIView *lineView;
    UIPageControl *pageCntroller;
    UIScrollView *pinlunScroller;
    UIButton *detailButton;
    UILabel *lowWoringLabel;
    UIView *bgViewAlpha;
    
    BaseDomain *getData;
    BaseDomain *postData;
    NSMutableDictionary *dataDictionary;
    NSMutableArray *sizeList;
    NSMutableDictionary *sizeShowDic;
    UILabel *priceLabel;
    UILabel *numberLabel;
    NSInteger flogSize;
    NSInteger flogSizeShow;
    UICollectionView *sizeCollection;
    UICollectionView *sizeShowCollection;
    NSInteger clothesCount;
    UILabel *countLabel;
    NSString *colorStr;
    NSString *sizeStr;
    NSString *clothesPrice;
    NSString *sizeId;
    UIWebView *webPL;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    flogSize = 0;
    flogSizeShow = 0;
    clothesCount = 1;
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [buttonRight addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    arrayModel = [NSMutableArray array];
    sizeList = [NSMutableArray array];
    sizeShowDic = [NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToOrderAction) name:@"turnToOrder" object:nil];
    [self getDatas];
    
//    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
//    [buttonRight setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
//    [buttonRight addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
    // Do any additional setup after loading the view.
    
    
}

-(void)shareClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _imageURl]]];
    [shareParams SSDKSetupShareParamsByText:[dataDictionary stringForKey:@"content"]
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@&type=2", URL_WEB, _good_Id]]
                                      title:[dataDictionary stringForKey:@"name"]
                                       type:SSDKContentTypeWebPage];
    [ShareCustom shareWithContent:shareParams];    
    
    
    
}



-(void)turnToOrderAction
{
    perentOrderViewController *perentOrder = [[perentOrderViewController alloc] init];
    [self.navigationController pushViewController:perentOrder animated:YES];
}




-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_good_Id forKey:@"goods_id"];
    [getData getData:URL_GetYouPingDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            
            dataDictionary = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
            sizeList = [NSMutableArray arrayWithArray:[dataDictionary arrayForKey:@"size_list"]];
            sizeShowDic = [[[sizeList firstObject] arrayForKey:@"size_list"] firstObject];
            [self createSecondPlanView];
            NSArray *array = [NSArray arrayWithArray:[dataDictionary arrayForKey:@"img_list"]];
            self.title = [dataDictionary stringForKey:@"name"];
            for (int i = 0; i < [array count]; i ++) {
                CompanySaleModel *model = [[CompanySaleModel alloc] init];
                model.clothesUrl = array[i];
                
                [arrayModel addObject:model];
            }
            
            if ([sizeList count] > 0) {
                sizeStr = [NSString stringWithFormat:@"%@:%@", [sizeList[0] stringForKey:@"size_name"],[sizeList[0] stringForKey:@"name"]];
                colorStr = [NSString stringWithFormat:@"%@:%@", [[[sizeList[flogSize] arrayForKey:@"size_list"] firstObject] stringForKey:@"size_name"],[[[sizeList[flogSize] arrayForKey:@"size_list"] firstObject] stringForKey:@"name"]];
                sizeId = [sizeList[0] stringForKey:@"id"];
            }
            
            
            clothesPrice = [sizeShowDic stringForKey:@"price"];
            
            
            self.title = [dataDictionary stringForKey:@"name"];
            [colthesCollect reloadData];
            [sizeCollection reloadData];
            [sizeShowCollection reloadData];
            [self createPage];

        }
    }];
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
    
    
    [self createPinLun];
    [self createDetailButton];
    [self createAlphaView];
    [self lowViewWoringCreate];
    [self createLowView];
    [self createAlphaBuyView];
}




-(void)lowViewWoringCreate
{
    lowWoringLabel = [UILabel new];
    [self.view addSubview:lowWoringLabel];
    
    lowWoringLabel.sd_layout
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view,80)
    .heightIs(20)
    .widthIs(SCREEN_WIDTH);
    [lowWoringLabel setText:@"即将看到商品评论～"];
    [lowWoringLabel setFont:[UIFont systemFontOfSize:14]];
    [lowWoringLabel setTextAlignment:NSTextAlignmentCenter];
    [lowWoringLabel setHidden:YES];
    
}

-(void)createDetailButton
{
    
    detailButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, colthesCollect.frame.origin.y + 20, 30, 233 / 2)];
    
    [detailButton setImage:[UIImage imageNamed:@"clothesDetail"] forState:UIControlStateNormal];
    [detailButton.titleLabel setNumberOfLines:0];
    [self.view addSubview:detailButton];
    [detailButton addTarget:self action:@selector(clothesDetailClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createPinLun
{
    NSString *string = [[dataDictionary arrayForKey:@"price"] componentsJoinedByString:@"/"];
    
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    webPL = [[UIWebView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40)];
    webPL.delegate = self;
    [webPL setBackgroundColor:[UIColor whiteColor]];
    webPL.scrollView.delegate = self;
    [self.view addSubview:webPL];
    NSURLRequest *request;
    request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?id=%@&token=%@&type=2&price=%@",URL_WEBHEADURL, URL_PINLUN, _good_Id, [userd stringForKey:@"token"], string]]];
    [webPL loadRequest:request];
}

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
    
    colthesCollect.pagingEnabled = YES ;
    
    [colthesCollect registerClass:[secondPlanToBuyCollectionCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [colthesCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView1"];
    
    
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == colthesCollect) {
        int index = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
        pageCntroller.currentPage = index;
        
        if (scrollView.contentOffset.y > (SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40) * ([arrayModel count] - 1) + 30) {
            [lowWoringLabel setHidden:NO];
        }
        
        if (scrollView.contentOffset.y > (SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40) * ([arrayModel count] - 1) + 80) {
            [lowWoringLabel setHidden:YES];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [colthesCollect setOrigin:CGPointMake(0, - (SCREEN_HEIGHT - 64 - 49 - 40))];
            [webPL setOrigin:CGPointMake(0, 64 + 40)];
            [detailButton setAlpha:0];
            [UIView commitAnimations];
            
        }
    } else {
        if (scrollView.contentOffset.y < - 80) {
            [lowWoringLabel setHidden:YES];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [colthesCollect setOrigin:CGPointMake(0, 64 + 40)];
            [webPL setOrigin:CGPointMake(0, SCREEN_HEIGHT - 49)];
            [detailButton setAlpha:1];
            [UIView commitAnimations];
        }
    }
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [lowWoringLabel setHidden:YES];
}

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
    
    [detailLabel setNumberOfLines:0];
    
    [detailLabel setFont:[UIFont systemFontOfSize:16]];
    
    detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
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
    toBuyButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:toBuyButton];
    [toBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_bottom).with.offset(-49);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH / 2 - 40));
    }];
    [toBuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [toBuyButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [toBuyButton addTarget:self action:@selector(ClickToBuyBut) forControlEvents:UIControlEventTouchUpInside];
    
    [toBuyButton setBackgroundColor:getUIColor(Color_buyColor)];
    
    toSave = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:toSave];
    [toSave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(toBuyButton.mas_left);
        make.top.equalTo(self.view.mas_bottom).with.offset(-49);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH / 2 - 40));
    }];
    [toSave setTitle:@"加入购物袋" forState:UIControlStateNormal];
    [toSave.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [toSave setBackgroundColor:getUIColor(Color_saveColor)];
    [toSave addTarget:self action:@selector(saveClothesClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    chatService = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:chatService];
    [chatService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(toSave.mas_left);
        make.top.equalTo(self.view.mas_bottom).with.offset(-49);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@80);
    }];
    
    [chatService setImage:[UIImage imageNamed:@"chatLine"] forState:UIControlStateNormal];
    [chatService setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
    [chatService addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)chatClick
{
   
    
    
    
//    QYSource *source = [[QYSource alloc] init];
//    source.title =  @"私人顾问";
//
//    QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];
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
    } else
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
    UICollectionViewCell *recell;
    if (collectionView == sizeCollection) {
        static NSString *identify = @"sizeCell";
        sizeAndColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (indexPath.item == flogSize) {
            [cell.sizeAndColorLabel setBackgroundColor:getUIColor(Color_buyColor)];
        } else {
            [cell.sizeAndColorLabel setBackgroundColor:getUIColor(Color_saveColor)];
        }
        [cell.sizeAndColorLabel setText:[sizeList[indexPath.item] stringForKey:@"name"]];
        [cell sizeToFit];
        recell = cell;

    } else if(collectionView == sizeShowCollection) {
        static NSString *identify = @"sizeShowCell";
        sizeAndColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (indexPath.item == flogSizeShow) {
            [cell.sizeAndColorLabel setBackgroundColor:getUIColor(Color_buyColor)];
        } else {
            [cell.sizeAndColorLabel setBackgroundColor:getUIColor(Color_saveColor)];
        }
        [cell.sizeAndColorLabel setText:[[[sizeList[flogSize] arrayForKey:@"size_list"] objectAtIndex:indexPath.item] stringForKey:@"name"]];
        [cell sizeToFit];
        recell = cell;
    } else {
        static NSString *identify = @"cell";
        secondPlanToBuyCollectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.model = arrayModel[indexPath.item];
        [cell sizeToFit];
        recell = cell;
    }
   
    
    
    return recell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    CGSize resize;
    if (collectionView == colthesCollect) {
        resize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 40);
    } else {
        resize = CGSizeMake((SCREEN_WIDTH - 120) / 5, 25);
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
        
        sizeStr = [NSString stringWithFormat:@"%@:%@", [sizeList[indexPath.item] stringForKey:@"size_name"],[sizeList[indexPath.item] stringForKey:@"name"]];
        sizeId = [sizeList[indexPath.item] stringForKey:@"id"];
        flogSize = indexPath.item;
        flogSizeShow = 0;
        sizeShowDic = [[sizeList[indexPath.item] arrayForKey:@"size_list"] firstObject];
        clothesPrice = [sizeShowDic stringForKey:@"price"];
        
        [self reloadLowViewData];
        [sizeCollection reloadData];
        [sizeShowCollection reloadData];
    }else if (collectionView == sizeShowCollection) {
        colorStr = [NSString stringWithFormat:@"%@:%@", [[[sizeList[flogSize] arrayForKey:@"size_list"]objectAtIndex:indexPath.item] stringForKey:@"size_name"],[[[sizeList[flogSize] arrayForKey:@"size_list"]objectAtIndex:indexPath.item] stringForKey:@"name"]];
        sizeShowDic = [[sizeList[flogSize] arrayForKey:@"size_list"] objectAtIndex:indexPath.item];
        clothesPrice = [sizeShowDic stringForKey:@"price"];
        flogSizeShow = indexPath.item;
        [sizeShowCollection reloadData];
    }
}

-(void)reloadLowViewData
{
    
    clothesCount = 1;
    [countLabel setText:[NSString stringWithFormat:@"%ld",clothesCount]];
    [priceLabel setText:[NSString stringWithFormat:@"价格 ¥%@", [sizeShowDic stringForKey:@"price"]]];
    [numberLabel setText:[NSString stringWithFormat:@"库存%@件",[sizeShowDic stringForKey:@"sku_num"]]];
    
}

#pragma mark - all button click


-(void)clothesDetailClick
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [scrollerClothesDetail setAlpha:1];
    [buttonClose setAlpha:1];
    [lineView setAlpha:1];
    [UIView commitAnimations];
}

-(void)closeClick
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [scrollerClothesDetail setAlpha:0];
    [buttonClose setAlpha:0];
    [lineView setAlpha:0];
    [UIView commitAnimations];
}

-(void)saveClothesClick
{
    [self showBuyChoose];
}

-(void)ClickToBuyBut {
    [self showBuyChoose];
}

-(void)clickCancel
{
    [self hiddenBuyChoose];
}


-(void)createAlphaBuyView
{
    bgViewAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 309, SCREEN_WIDTH, 309)];
    [bgViewAlpha setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgViewAlpha];
    UIImageView *imageHead = [[UIImageView alloc] initWithFrame:CGRectMake(20, -20, 80, 80)];
    [imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HEADURL, [dataDictionary stringForKey:@"thumb"]]]];
    [bgViewAlpha addSubview:imageHead];
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 0, 40, 40)];
    [btnClose addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [btnClose setImage:[UIImage imageNamed:@"CHA"] forState:UIControlStateNormal];
    [bgViewAlpha addSubview:btnClose];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
    [priceLabel setText:[NSString stringWithFormat:@"价格 ¥%@", [sizeShowDic stringForKey:@"price"]]];
    [priceLabel setFont:[UIFont systemFontOfSize:14]];
    [bgViewAlpha addSubview:priceLabel];
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 35, 200, 20)];
    [numberLabel setText:[NSString stringWithFormat:@"库存%@件",[sizeShowDic stringForKey:@"sku_num"]]];
    [numberLabel setFont:[UIFont systemFontOfSize:14]];
    [bgViewAlpha addSubview:numberLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH - 40, 1)];
    [line1 setBackgroundColor:getUIColor(Color_BuyLineColor)];
    [bgViewAlpha addSubview:line1];
    
    UILabel *size = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 40, 20)];
    [size setText:@"尺码"];
    [size setFont:[UIFont systemFontOfSize:14]];
    [bgViewAlpha addSubview:size];

    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 20;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    sizeCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 102, SCREEN_WIDTH, 25) collectionViewLayout:flowLayout];
    //设置代理
    sizeCollection.delegate = self;
    sizeCollection.dataSource = self;
    [bgViewAlpha addSubview:sizeCollection];
    sizeCollection.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    
    sizeCollection.pagingEnabled = YES ;
    
    [sizeCollection registerClass:[sizeAndColorCollectionViewCell class] forCellWithReuseIdentifier:@"sizeCell"];
    [sizeCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView2"];
    
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, 135, SCREEN_WIDTH - 40, 1)];
    [line2 setBackgroundColor:getUIColor(Color_BuyLineColor)];
    [bgViewAlpha addSubview:line2];
    
    UILabel *color = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 40, 20)];
    [color setText:@"颜色"];
    [color setFont:[UIFont systemFontOfSize:14]];
    [bgViewAlpha addSubview:color];
    

    
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout1.minimumInteritemSpacing = 20;

    sizeShowCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 167, SCREEN_WIDTH, 25) collectionViewLayout:flowLayout1];
    //设置代理
    sizeShowCollection.delegate = self;
    sizeShowCollection.dataSource = self;
    [bgViewAlpha addSubview:sizeShowCollection];
    sizeShowCollection.backgroundColor = [UIColor whiteColor];
    //注册cell和ReusableView（相当于头部）
    
    sizeShowCollection.pagingEnabled = YES ;
    
    [sizeShowCollection registerClass:[sizeAndColorCollectionViewCell class] forCellWithReuseIdentifier:@"sizeShowCell"];
    [sizeShowCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView3"];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(20, 205, SCREEN_WIDTH - 40, 1)];
    [line3 setBackgroundColor:getUIColor(Color_BuyLineColor)];
    [bgViewAlpha addSubview:line3];
    
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(20, 225, 40, 20)];
    [count setText:@"数量"];
    [count setFont:[UIFont systemFontOfSize:14]];
    [bgViewAlpha addSubview:count];
    
    
    UIButton *buttonCut = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 140, 222.5, 30, 30)];
    [buttonCut setTitle:@"-" forState:UIControlStateNormal];
    [buttonCut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonCut.layer setBorderWidth:1];
    [buttonCut.layer setBorderColor:getUIColor(Color_myTabIconLineColor).CGColor];
    [bgViewAlpha addSubview:buttonCut];
    [buttonCut setTag:55];
    [buttonCut addTarget:self action:@selector(cutAndAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 222.5, 50, 30)];
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [countLabel setFont:[UIFont systemFontOfSize:12]];
    [countLabel setText:[NSString stringWithFormat:@"%ld",clothesCount]];
    [bgViewAlpha addSubview:countLabel];
    
    UIButton *buttonAdd = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 222.5, 30, 30)];
    [buttonAdd setTitle:@"+" forState:UIControlStateNormal];
    [buttonAdd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonAdd.layer setBorderWidth:1];
    [buttonAdd setTag:56];
    [buttonAdd.layer setBorderColor:getUIColor(Color_myTabIconLineColor).CGColor];
    [buttonAdd addTarget:self action:@selector(cutAndAdd:) forControlEvents:UIControlEventTouchUpInside];
    [bgViewAlpha addSubview:buttonAdd];

    
    
    
    
    UIButton *addBuyBag = [[UIButton alloc] initWithFrame:CGRectMake(0, 260, SCREEN_WIDTH / 2, 49)];
    [addBuyBag.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [addBuyBag setBackgroundColor:getUIColor(Color_saveColor)];
    [bgViewAlpha addSubview:addBuyBag];
    [addBuyBag addTarget:self action:@selector(addToBuyBag) forControlEvents:UIControlEventTouchUpInside];
    [addBuyBag setTitle:@"加入购物袋" forState:UIControlStateNormal];
    
    UIButton *BuyClick = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 260, SCREEN_WIDTH / 2, 49)];
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
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_good_Id forKey:@"goods_id"];
    [params setObject:@"2" forKey:@"goods_type"];
    [params setObject:clothesPrice forKey:@"price"];
    [params setObject:[dataDictionary stringForKey:@"name"] forKey:@"goods_name"];
    [params setObject:[NSString stringWithFormat:@"%@;%@", colorStr,sizeStr] forKey:@"size_content"];
    [params setObject:[NSNumber numberWithInteger:clothesCount] forKey:@"num"];
    [params setObject:[sizeShowDic stringForKey:@"id"] forKey:@"size_ids"];
    [params setObject:[dataDictionary stringForKey:@"thumb"] forKey:@"goods_thumb"];
    [params setObject:@"2" forKey:@"type"];
    [postData postData:URL_AddClothesCar PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:postData]) {
//            [self showAlertWithTitle:@"提示" message:@"加入购物车成功"];
            [self alertViewShowOfTime:@"加入购物车成功" time:1.5];
        }
        
    }];
    
    
}

-(void)buyClickAction
{
    [self hiddenBuyChoose];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_good_Id forKey:@"goods_id"];
    [params setObject:@"2" forKey:@"goods_type"];
    [params setObject:clothesPrice forKey:@"price"];
    [params setObject:[dataDictionary stringForKey:@"name"] forKey:@"goods_name"];
    [params setObject:[NSString stringWithFormat:@"%@;%@", colorStr,sizeStr] forKey:@"size_content"];
    [params setObject:[NSNumber numberWithInteger:clothesCount] forKey:@"num"];
    [params setObject:[sizeShowDic stringForKey:@"id"] forKey:@"size_ids"];
    [params setObject:[dataDictionary stringForKey:@"thumb"] forKey:@"goods_thumb"];
    [params setObject:@"1" forKey:@"type"];
    [postData postData:URL_AddClothesCar PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:postData]) {
            ClothesFroPay *model = [ClothesFroPay new];
//            model.clothesImage = [dataDictionary stringForKey:@"thumb"];
//            model.clothesCount = [NSString stringWithFormat:@"%ld",clothesCount];
//            model.clothesName = [dataDictionary stringForKey:@"name"];
//            model.clothesPrice = clothesPrice;
//            model.clotheMaxCount = [sizeShowDic stringForKey:@"sku_num"];
            NSMutableArray *array = [NSMutableArray arrayWithObjects:model, nil];
            PayForClothesViewController *clothesPay = [[PayForClothesViewController alloc] init];
            clothesPay.arrayForClothes = array;
            clothesPay.carId = [[postData.dataRoot objectForKey:@"data"] stringForKey:@"car_id"];
            clothesPay.allPrice = [NSString stringWithFormat:@"%.2f",[clothesPrice floatValue] * clothesCount];
            [self.navigationController pushViewController:clothesPay animated:YES];
        }
        
    }];
    
    
   
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
