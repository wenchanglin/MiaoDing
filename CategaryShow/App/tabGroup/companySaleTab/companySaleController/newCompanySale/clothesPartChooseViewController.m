//
//  clothesPartChooseViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/28.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "clothesPartChooseViewController.h"
#import "partDetailCollectionViewCell.h"
#import "DiyWordInClothesViewController.h"
@interface clothesPartChooseViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation clothesPartChooseViewController
{
    BaseDomain *getData;
    UICollectionView *partDetailCollection;
    UICollectionView *partCollection;
    NSMutableArray *BanXingArray;
    NSMutableArray *MianLiaoArray;
    UIImageView *lowBack;
    NSMutableArray *partDetailArray;
    NSMutableArray *partArray;
    BOOL ifBanX;
    BOOL ifML;
    
    NSInteger partFlog;
    NSMutableArray *contentIdArray;
    NSMutableArray *contentArray;

    NSString *mianId;
    NSString *banXingId;
    
    NSMutableDictionary *goodParams;
    NSMutableArray *goodArray;
    
    NSInteger chooseItem;
    NSInteger banXItem;
    NSInteger MainItem;
    
    UIView *lowShowpView;
    UIButton *MLBtn;
    UIButton *BXBtn;
    UIButton *MoreBtn;
    
    UIButton *buttonFront;
    UIButton *buttonBehind;
    UIButton *buttonIn;
    
    UIImageView *imageAlpha;
    UIImageView *imageBackIntoduce;
    UIImageView *imageBig;
    UILabel *imageName;
    UILabel *imageIntro;
    
    NSMutableDictionary *banMain;
    NSString *MianLiaoImg;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    chooseItem = 0;
    MainItem = 0;
    contentArray = [NSMutableArray array];
    contentIdArray = [NSMutableArray array];
    goodArray = [NSMutableArray array];
    goodParams = [NSMutableDictionary dictionary];
    banMain = [NSMutableDictionary dictionary];
    ifBanX = NO;
    ifML = YES;
    partFlog = 0;
    self.title = @"面料";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    MianLiaoArray = [NSMutableArray array];
    BanXingArray = [NSMutableArray array];
    partDetailArray = [NSMutableArray array];
    partArray = [NSMutableArray array];
    
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
    [right setTitle:@"下一步" forState:UIControlStateNormal];
    [right.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [back setImage:[UIImage imageNamed:@"backLeft"] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backStep) forControlEvents:UIControlEventTouchUpInside];
    
    
    getData = [BaseDomain getInstance:NO];
    [self getDatas];
    // Do any additional setup after loading the view.
}

-(void)backStep
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_dateId forKey:@"id"];
    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [params setObject:[_goodDic stringForKey:@"name"] forKey:@"goods_name"];
    [params setObject:@"1" forKey:@"click_dingzhi"];
    [params setObject:@"0" forKey:@"click_pay"];
    [self getDateDingZhi:params beginDate:_dateDing ifDing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextStep
{
    [goodParams setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [goodParams setObject:[_goodDic stringForKey:@"name"] forKey:@"goods_name"];
    [goodParams setObject:[_goodDic stringForKey:@"thumb"] forKey:@"goods_thumb"];
    [goodParams setObject:[_goodDic stringForKey:@"type"] forKey:@"type"];
    [goodParams setObject:[_price stringForKey:@"price"] forKey:@"price"];
    [goodParams setObject:mianId forKey:@"mianliao_id"];
    [goodParams setObject:MianLiaoImg forKey:@"mian_img"];
    [goodParams setObject:banXingId forKey:@"banxing_id"];
    [goodParams setObject:_price_Type forKey:@"price_id"];
    NSString *idString = [contentIdArray componentsJoinedByString:@","];
    NSString *contentString = [contentArray componentsJoinedByString:@";"];
    
   ;
    NSString *string = [NSString stringWithFormat:@"面料:%@;版型:%@",  [banMain objectForKey:@"mianliao"],[banMain objectForKey:@"banxing"]];
    [goodParams setObject:idString forKey:@"spec_ids"];
    [goodParams setObject:[NSString stringWithFormat:@"%@;%@", contentString, string] forKey:@"spec_content"];
    
    
    
    
    
    DiyWordInClothesViewController *diy = [[DiyWordInClothesViewController alloc] init];
    diy.paramsDic = goodParams;
    diy.price = _price;
    diy.class_id = _class_id;
    diy.goodDic = _goodDic;
    diy.goodArray = goodArray;
    diy.dingDate = _dateDing;
    diy.dateId = _dateId;
    diy.banexingId = banXingId;
    diy.banMain = banMain;
    [self.navigationController pushViewController:diy animated:YES];
    
    
}


-(void)getDatas
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [params setObject:@"6" forKey:@"phone_type"];
    [params setObject:_price_Type forKey:@"price_type"];
    [getData getData:URL_GetDingZhiPicNew PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            
            BanXingArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"banxin"]];
            MianLiaoArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"mianliao"]];
            
            
            partDetailArray = [NSMutableArray arrayWithArray:MianLiaoArray];
            partArray = [NSMutableArray arrayWithArray:[BanXingArray[0] arrayForKey:@"peijian"]];
            mianId = [MianLiaoArray[0] stringForKey:@"id"];
            MianLiaoImg = [MianLiaoArray[0] stringForKey:@"goods_img"];
            
            banXingId = [BanXingArray [0] stringForKey:@"id"];
            
            [banMain setObject:[MianLiaoArray[0] stringForKey:@"name"] forKey:@"mianliao"];
            [banMain setObject:[BanXingArray[0] stringForKey:@"name"] forKey:@"banxing"];
            for (int i = 0; i < [partArray count]; i ++) {
                for (NSDictionary *dic in [partArray[i] arrayForKey:@"spec_list"]) {
                    if ([dic integerForKey:@"mianliao_id"] == [mianId integerValue]) {
                        [contentIdArray addObject:[dic stringForKey:@"id"]];
                        [contentArray addObject:[NSString stringWithFormat:@"%@:%@", [partArray[i] stringForKey:@"name"], [dic objectForKey:@"name"]]];
                        [goodArray addObject:dic];
                        break;
                    }
                }
                
            }
            
            
            
            
            
            
            
            [self createView];
            [self createClothesimg];
            [self InBeindFont];
        }
    }];
    
}


-(void)InBeindFont
{
    
    if ([_class_id integerValue] != 15) {
        buttonFront = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 90, 40, 20)];
        [buttonFront addTarget:self action:@selector(FrontClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonFront.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonFront setTitle:@"正面" forState:UIControlStateNormal];
        [self.view addSubview:buttonFront];
        [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        buttonBehind = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 10, 90, 40, 20)];
        [buttonBehind.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonBehind addTarget:self action:@selector(behindClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonBehind setTitle:@"反面" forState:UIControlStateNormal];
        [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.view addSubview:buttonBehind];
    } else {
        buttonFront = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 -80, 90, 40, 20)];
        [self.view addSubview:buttonFront];
        [buttonFront addTarget:self action:@selector(FrontClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonFront.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonFront setTitle:@"正面" forState:UIControlStateNormal];
        
        [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        buttonBehind = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 20, 90, 40, 20)];
        [buttonBehind.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonBehind addTarget:self action:@selector(behindClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonBehind setTitle:@"反面" forState:UIControlStateNormal];
        [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.view addSubview:buttonBehind];
        
        buttonIn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 40, 90, 40, 20)];
        [buttonIn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonIn addTarget:self action:@selector(InClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonIn setTitle:@"里子" forState:UIControlStateNormal];
        [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.view addSubview:buttonIn];
        
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - 142 - 50, 30, 30)];
    [button setImage:[UIImage imageNamed:@"resetButton"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    imageAlpha = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageAlpha setImage:[UIImage imageNamed:@"BGALPHA"]];
    [imageAlpha setAlpha:0];
    [self.view addSubview:imageAlpha];
    
    imageBackIntoduce = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 596 / 2, 806 / 2)];
    [self.view addSubview:imageBackIntoduce];
    imageBackIntoduce.centerX = self.view.centerX - 13;
    imageBackIntoduce.centerY = self.view.centerY - 10;
    [imageBackIntoduce setImage:[UIImage imageNamed:@"introduceBack"]];
    [imageBackIntoduce setAlpha:0];
    [self.view bringSubviewToFront:imageBackIntoduce];
    
    imageBig = [UIImageView new];
    [imageBackIntoduce addSubview:imageBig];
    
    imageBig.sd_layout
    .leftSpaceToView(imageBackIntoduce, 98)
    .topSpaceToView(imageBackIntoduce, 47)
    .widthIs(126)
    .heightIs(126);
    [imageBig setAlpha:0];
    [imageBig.layer setCornerRadius:63];
    [imageBig.layer setMasksToBounds:YES];
    
    
    
    
    imageName = [UILabel new];
    [imageBackIntoduce addSubview:imageName];
    imageName.sd_layout
    .topSpaceToView(imageBig, 50)
    .centerXEqualToView(imageBig)
    .widthIs(400)
    .heightIs(25);
    [imageName setFont:Font_16];
    [imageName setTextAlignment:NSTextAlignmentCenter];
    [imageName setTextColor:[UIColor blackColor]];
    [imageName setAlpha:0];
    
    imageIntro = [UILabel new];
    [imageBackIntoduce addSubview:imageIntro];
    [imageIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageName.mas_centerX);
        make.top.equalTo(imageName.mas_bottom).with.offset(10);
        make.width.equalTo(@200);
    }];
    [imageIntro setFont:Font_14];
    [imageIntro setTextAlignment:NSTextAlignmentCenter];
    [imageIntro setTextColor:getUIColor(Color_DZClolor)];
    [imageIntro setNumberOfLines:0];
    [imageIntro setAlpha:0];
    
    
    
}

-(void) resetClick
{
    chooseItem = 0;
    MainItem = 0;
    ifBanX = NO;
    ifML = YES;
    partFlog = 0;
    self.title = @"面料";
    [contentIdArray removeAllObjects];
    [contentArray removeAllObjects];
    [goodArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [params setObject:@"6" forKey:@"phone_type"];
    [params setObject:_price_Type forKey:@"price_type"];
    [getData getData:URL_GetDingZhiPicNew PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            
            BanXingArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"banxin"]];
            MianLiaoArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"mianliao"]];
            
            
            partDetailArray = [NSMutableArray arrayWithArray:MianLiaoArray];
            partArray = [NSMutableArray arrayWithArray:[BanXingArray[0] arrayForKey:@"peijian"]];
            mianId = [MianLiaoArray[0] stringForKey:@"id"];
            MianLiaoImg = [MianLiaoArray[0] stringForKey:@"goods_img"];
            banXingId = [BanXingArray [0] stringForKey:@"id"];
            [banMain setObject:[MianLiaoArray[0] stringForKey:@"name"] forKey:@"mianliao"];
            [banMain setObject:[BanXingArray[0] stringForKey:@"name"] forKey:@"banxing"];
            for (int i = 0; i < [partArray count]; i ++) {
                
                for (NSDictionary *dic in [partArray[i] arrayForKey:@"spec_list"]) {
                    if ([dic integerForKey:@"mianliao_id"] == [mianId integerValue]) {
                        [contentIdArray addObject:[dic stringForKey:@"id"]];
                        [contentArray addObject:[NSString stringWithFormat:@"%@:%@", [partArray[i] stringForKey:@"name"], [dic objectForKey:@"name"]]];
                        [goodArray addObject:dic];
                        break;
                    }
                }
                
               
                
                
            }
            
            
            
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [partCollection setAlpha:0];
            [lowBack setAlpha:1];
            [UIView commitAnimations];
            
            
            [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            for (int i = 0; i < [goodArray count]; i ++) {
                UIImageView *image = [self.view viewWithTag:100 + i];
                [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [goodArray[i] stringForKey:@"img_c"]]]];
                if ([[goodArray[i] stringForKey:@"position_id"] integerValue] == 1) {
                    [image setHidden:NO];
                } else{
                    [image setHidden:YES];
                }
                
                
            }
            
            
            [partDetailCollection reloadData];
        }
    }];
}

-(void)FrontClick
{
    [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [goodArray count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        
        if ([[goodArray[i] stringForKey:@"position_id"] integerValue] == 1) {
            [image setHidden:NO];
        } else{
            [image setHidden:YES];
        }
        
        
    }
}

-(void)behindClick
{
    [buttonBehind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [goodArray count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        
        if ([[goodArray[i] stringForKey:@"position_id"] integerValue] == 2) {
            [image setHidden:NO];
        } else{
            [image setHidden:YES];
        }
        
        
    }
}

-(void)InClick
{
    [buttonIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [goodArray count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        
        if ([[goodArray[i] stringForKey:@"position_id"] integerValue] == 3) {
            [image setHidden:NO];
        } else{
            [image setHidden:YES];
        }
        
        
    }
}


-(void)createClothesimg
{
    for (int i = 0; i < [goodArray count]; i ++) {
        
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 325)];
        [image setTag:100 + i];
        [image setUserInteractionEnabled:YES];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [image.layer setMasksToBounds:YES];
        
        image.center = CGPointMake(self.view.centerX, self.view.centerY - 40);
        
        
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [goodArray[i] stringForKey:@"img_c"]]]];
       
        if ([[goodArray[i] stringForKey:@"position_id"] integerValue] == 1) {
            [image setHidden:NO];
        } else{
            [image setHidden:YES];
        }
        
        [self.view addSubview:image];
    }
    
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 410)];
//    
//    [image setUserInteractionEnabled:YES];
//    [image setContentMode:UIViewContentModeScaleAspectFill];
//    [image.layer setMasksToBounds:YES];
//    [image setImage:[UIImage imageNamed:@"renren"]];
//    image.center = CGPointMake(self.view.centerX, self.view.centerY - 20);
//    
//    
//    [self.view addSubview:image];
}

-(void)createView
{
    
    
    
    lowShowpView = [UIView new];
    [lowBack setUserInteractionEnabled:YES];
    [self.view addSubview:lowShowpView];
    [lowShowpView setBackgroundColor:[UIColor whiteColor]];
    lowShowpView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 71)
    .heightIs(71);
    [[lowShowpView layer] setShadowOffset:CGSizeMake(0, -3)]; // 阴影的范围
    [[lowShowpView layer] setShadowRadius:3];                // 阴影扩散的范围控制
    [[lowShowpView layer] setShadowOpacity:0.5];               // 阴影透明度
    [[lowShowpView layer] setShadowColor:[UIColor grayColor].CGColor];
    
    
    lowBack = [UIImageView new];
    [lowBack setUserInteractionEnabled:YES];
    [self.view addSubview:lowBack];
    [lowBack setBackgroundColor:[UIColor whiteColor]];
    lowBack.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 71)
    .heightIs(71);
//    [[lowBack layer] setShadowOffset:CGSizeMake(0, -3)]; // 阴影的范围
//    [[lowBack layer] setShadowRadius:3];                // 阴影扩散的范围控制
//    [[lowBack layer] setShadowOpacity:0.5];               // 阴影透明度
//    [[lowBack layer] setShadowColor:[UIColor grayColor].CGColor];
    
    MLBtn = [UIButton new];
    [lowBack addSubview:MLBtn];
    MLBtn.sd_layout
    .leftSpaceToView(lowBack, SCREEN_WIDTH / 3 / 2 - 25)
    .centerYEqualToView(lowBack)
    .heightIs(50)
    .widthIs(50);
    [MLBtn setTitle:@"面料" forState:UIControlStateNormal];
    [MLBtn setBackgroundColor:[UIColor blackColor]];
    [MLBtn.layer setCornerRadius:25];
    [MLBtn.layer setMasksToBounds:YES];
    [MLBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [MLBtn addTarget:self action:@selector(MLBClick) forControlEvents:UIControlEventTouchUpInside];
    [MLBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [MLBtn.layer setBorderWidth:1];
    
    
    
    BXBtn = [UIButton new];
    [lowBack addSubview:BXBtn];
    BXBtn.sd_layout
    .centerXEqualToView(lowBack)
    .centerYEqualToView(lowBack)
    .heightIs(50)
    .widthIs(50);
    [BXBtn setTitle:@"版型" forState:UIControlStateNormal];
    [BXBtn.layer setCornerRadius:25];
    [BXBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [BXBtn setBackgroundColor:[UIColor whiteColor]];
    [BXBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [BXBtn.layer setMasksToBounds:YES];
    [BXBtn addTarget:self action:@selector(BXBClick) forControlEvents:UIControlEventTouchUpInside];
    [BXBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [BXBtn.layer setBorderWidth:1];
    
    MoreBtn = [UIButton new];
    [lowBack addSubview:MoreBtn];
    MoreBtn.sd_layout
    .rightSpaceToView(lowBack, SCREEN_WIDTH / 3 / 2 - 25)
    .centerYEqualToView(lowBack)
    .heightIs(50)
    .widthIs(50);
    [MoreBtn setTitle:@"细节" forState:UIControlStateNormal];
    [MoreBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [MoreBtn.layer setCornerRadius:25];
    [MoreBtn setBackgroundColor:[UIColor whiteColor]];
    [MoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [MoreBtn.layer setMasksToBounds:YES];
    [MoreBtn addTarget:self action:@selector(MOREBClick) forControlEvents:UIControlEventTouchUpInside];
    [MoreBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [MoreBtn.layer setBorderWidth:1];
    
    
 // partDetailCollection
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    partDetailCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - 71, SCREEN_WIDTH, 71) collectionViewLayout:flowLayout];
    [self.view addSubview:partDetailCollection];
    
    partDetailCollection.showsHorizontalScrollIndicator = NO;
    //设置代理
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(myHandleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 0.5;
    //将长按手势添加到需要实现长按操作的视图里
    [partDetailCollection addGestureRecognizer:longPress];
    
    partDetailCollection.delegate = self;
    partDetailCollection.dataSource = self;
//    [partDetailCollection setHidden:YES];
    //注册cell和ReusableView（相当于头部）
    [partDetailCollection setBackgroundColor:[UIColor clearColor]];
    [partDetailCollection registerClass:[partDetailCollectionViewCell class] forCellWithReuseIdentifier:@"partDetail"];
    [partDetailCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
   
    
 // partCollection
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout1.minimumLineSpacing = 0;
//    flowLayout1.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    partCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - 142, SCREEN_WIDTH, 71) collectionViewLayout:flowLayout1];
    [partCollection setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:partCollection];
    [partCollection setAlpha:0];
    partCollection.backgroundColor = [UIColor whiteColor];
   
    partCollection.showsHorizontalScrollIndicator = NO;
    //设置代理
    partCollection.delegate = self;
    partCollection.dataSource = self;
    //    [partDetailCollection setHidden:YES];
    //注册cell和ReusableView（相当于头部）
    [partCollection setBackgroundColor:[UIColor clearColor]];
    [partCollection registerClass:[partDetailCollectionViewCell class] forCellWithReuseIdentifier:@"part"];
    [partCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
    
    
    
}

- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    
    CGPoint pointTouch = [gestureRecognizer locationInView:partDetailCollection];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        
        NSIndexPath *indexPath = [partDetailCollection indexPathForItemAtPoint:pointTouch];
        if (indexPath == nil) {
            
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.3];
//            [imageBig setAlpha:0];
//            [imageAlpha setAlpha:0];
//            [UIView commitAnimations];
            
            
        }else{
            
            [imageBig sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [partDetailArray[indexPath.row] stringForKey:@"img_b"]]]];
            [imageName setText:[partDetailArray[indexPath.row] stringForKey:@"name"]];
            [imageIntro setText:[partDetailArray[indexPath.row] stringForKey:@"introduce"]];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [imageBig setAlpha:1];
            [imageAlpha setAlpha:1];
            [imageIntro setAlpha:1];
            [imageBackIntoduce setAlpha:1];
            [imageName setAlpha:1];
            [UIView commitAnimations];
            
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.3];
//        [imageBig setAlpha:0];
//        [imageAlpha setAlpha:0];
//        [UIView commitAnimations];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [imageBig setAlpha:0];
        [imageAlpha setAlpha:0];
        [imageIntro setAlpha:0];
        [imageName setAlpha:0];
        [imageBackIntoduce setAlpha:0];
        [UIView commitAnimations];
        
    }
}

#pragma mark -- lowBtnClick
-(void)MLBClick
{
    ifBanX = NO;
    ifML = YES;
    partDetailArray = [NSMutableArray arrayWithArray:MianLiaoArray];
    self.title = @"面料";
    [MLBtn setBackgroundColor:[UIColor blackColor]];
    [MLBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [BXBtn setBackgroundColor:[UIColor whiteColor]];
    [BXBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [MoreBtn setBackgroundColor:[UIColor whiteColor]];
    [MoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    chooseItem = MainItem;
    [partDetailCollection reloadData];
}

-(void)BXBClick
{
    ifBanX = YES;
    ifML = NO;
    self.title = @"版型";
    chooseItem = banXItem;
    partDetailArray = [NSMutableArray arrayWithArray:BanXingArray];
    [partDetailCollection reloadData];
    
    [BXBtn setBackgroundColor:[UIColor blackColor]];
    [BXBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [MLBtn setBackgroundColor:[UIColor whiteColor]];
    [MLBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [MoreBtn setBackgroundColor:[UIColor whiteColor]];
    [MoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}

-(void)MOREBClick
{
    ifBanX = NO;
    ifML = NO;
//    [partCollection setHidden:NO];
    self.title = [partArray[0] stringForKey:@"name"];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [partCollection setAlpha:1];
    [lowBack setAlpha:0];
    [UIView commitAnimations];
    [partDetailArray removeAllObjects];
    
    for (NSDictionary *dic in [partArray[0] arrayForKey:@"spec_list"]) {
        if ([dic integerForKey:@"mianliao_id"]== [mianId integerValue]) {
            [partDetailArray addObject:dic];
        }
    }
    
    chooseItem = 0;
    
    [partDetailCollection reloadData];
    
    [partCollection reloadData];
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == partCollection) {
        return  [partArray count] + 1;
    }
    return [partDetailArray count];
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *reCell;
    if (collectionView == partDetailCollection) {
        partDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"partDetail" forIndexPath:indexPath];
//        [cell.nameLabel setText:[partDetailArray[indexPath.item] stringForKey:@"name"]];
        [cell.partImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [partDetailArray[indexPath.item] stringForKey:@"img_a"]]]];
        if (indexPath.item == chooseItem) {
            [cell.imageChoose setImage:[UIImage imageNamed:@"JuXC"]];
        } else {
            [cell.imageChoose setImage:[UIImage imageNamed:@""]];
        }
        
        reCell = cell;
    } else {
        partDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"part" forIndexPath:indexPath];
        
        
        if (indexPath.item == [partArray count]) {
            [cell.partImgView setImage:[UIImage imageNamed:@"close"]];
        } else {
//            [cell.nameLabel setText:[partArray[indexPath.item] stringForKey:@"name"]];
            [cell.partImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [partArray[indexPath.item] stringForKey:@"img_a"]]]];
            if (indexPath.item == chooseItem) {
                [cell.imageChoose setImage:[UIImage imageNamed:@"colorChoose"]];
            } else {
                [cell.imageChoose setImage:[UIImage imageNamed:@""]];
            }
        }
        reCell = cell;
    }
    [reCell setBackgroundColor:[UIColor whiteColor]];
    return reCell;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(SCREEN_WIDTH / 6, 71);
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
    
    if (collectionView == partCollection) {
        if (indexPath.item == [partArray count]) {
            partDetailArray = [NSMutableArray arrayWithArray:MianLiaoArray];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [partCollection setAlpha:0];
            [lowBack setAlpha:1];
            [UIView commitAnimations];
            
            chooseItem  = MainItem;
            [partDetailCollection reloadData];
           
            
            [MLBtn setBackgroundColor:[UIColor blackColor]];
            [MLBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [BXBtn setBackgroundColor:[UIColor whiteColor]];
            [BXBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [MoreBtn setBackgroundColor:[UIColor whiteColor]];
            [MoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            partFlog = 0;
            ifML = YES;
            [self clothesChageSide:@"1"];
            self.title = @"面料";
        } else {
            
            [partDetailArray removeAllObjects];
            for (NSDictionary *dic in [partArray[indexPath.item] arrayForKey:@"spec_list"]) {
                if ([dic integerForKey:@"mianliao_id"]== [mianId integerValue]) {
                    [partDetailArray addObject:dic];
                }
            }
            
            chooseItem = indexPath.item;
            [partDetailCollection reloadData];
            partFlog = indexPath.item;
            
            [self clothesChageSide:[partArray[indexPath.item] stringForKey:@"position_id"]];
        }
    } else {
        
        
        
        
        if (ifBanX) {
            partArray = [NSMutableArray arrayWithArray:[partDetailArray[indexPath.item] arrayForKey:@"peijian"]];
            banXItem = indexPath.item;
            chooseItem = indexPath.item;
            banXingId = [BanXingArray [banXItem] stringForKey:@"id"];
            
            [banMain setObject:[BanXingArray[banXItem] stringForKey:@"name"] forKey:@"banxing"];
            [partCollection reloadData];
            
            [self clothesChageSide:@"1"];
            
            [goodArray removeAllObjects];
            
            for (int i = 0; i < [partArray count]; i ++) {
                
                for (NSDictionary *dic in [partArray[i] arrayForKey:@"spec_list"]) {
                    if ([dic integerForKey:@"mianliao_id"] == [mianId integerValue]) {
                        [contentIdArray addObject:[dic stringForKey:@"id"]];
                        [contentArray addObject:[NSString stringWithFormat:@"%@:%@", [partArray[i] stringForKey:@"name"], [dic objectForKey:@"name"]]];
                        [goodArray addObject:dic];
                        break;
                    }
                }
            }
            self.title = [partDetailArray[indexPath.row]stringForKey:@"name"];
            
            [partDetailCollection reloadData];
            [self clothesChange];
            
        } else {
            
            
            if (!ifML) {
                
                 [self clothesPartChage:indexPath.item];
            } else {
                MainItem = indexPath.item;
                [goodArray removeAllObjects];
                [contentIdArray removeAllObjects];
                [contentArray removeAllObjects];
                if ([mianId integerValue] != [[MianLiaoArray[indexPath.item] stringForKey:@"id"] integerValue]) {
                    mianId = [MianLiaoArray[indexPath.item] stringForKey:@"id"];
                    MianLiaoImg = [MianLiaoArray[indexPath.item] stringForKey:@"goods_img"];
                    [banMain setObject:[MianLiaoArray[indexPath.item] stringForKey:@"name"] forKey:@"mianliao"];
                    
                    
                    for (int i = 0; i < [partArray count]; i ++) {
                        
                        for (NSDictionary *dic in [partArray[i] arrayForKey:@"spec_list"]) {
                            if ([dic integerForKey:@"mianliao_id"] == [mianId integerValue]) {
                                [contentIdArray addObject:[dic stringForKey:@"id"]];
                                [contentArray addObject:[NSString stringWithFormat:@"%@:%@", [partArray[i] stringForKey:@"name"], [dic objectForKey:@"name"]]];
                                [goodArray addObject:dic];
                                break;
                            }
                        }
                        
                        
                        
                        
                    }
                    
                    for (int i = 0; i < [goodArray count]; i ++) {
                        UIImageView *image = [self.view viewWithTag:100 + i];
                        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [goodArray[i] stringForKey:@"img_c"]]]];
                        if ([[goodArray[i] stringForKey:@"position_id"] integerValue] == 1) {
                            [image setHidden:NO];
                        } else{
                            [image setHidden:YES];
                        }
                        
                        
                    }

                    
                    
                    
                }
                
                
                
                
                
                
            }
            
            chooseItem = indexPath.item;
            [partDetailCollection reloadData];
           
        }
    }
    
}


-(void)clothesChageSide:(NSString *)position
{
    for (int i = 0; i < [goodArray count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        if ([position isEqualToString:[goodArray[i] stringForKey:@"position_id"]]) {
            [image setHidden:NO];
        } else {
            [image setHidden:YES];
        }
    }
    
    self.title = [partArray[partFlog] stringForKey:@"name"];
}

-(void)clothesPartChage:(NSInteger)item
{
    UIImageView *image = [self.view viewWithTag:100 + partFlog];
     [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [partDetailArray[item] stringForKey:@"img_c"]]]];

    [contentIdArray replaceObjectAtIndex:partFlog withObject:[partDetailArray[item] stringForKey:@"id"]];
    [contentArray replaceObjectAtIndex:partFlog withObject:[NSString stringWithFormat:@"%@:%@", [partArray[partFlog] stringForKey:@"name"], [partDetailArray[item] stringForKey:@"name"]]];
    [goodArray replaceObjectAtIndex:partFlog withObject:partDetailArray[item]];
    
    self.title = [partDetailArray[item] stringForKey:@"name"];
}

-(void)clothesChange
{
    for (int i = 0; i < [goodArray count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [goodArray[i]  stringForKey:@"img_c"]]]];
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
