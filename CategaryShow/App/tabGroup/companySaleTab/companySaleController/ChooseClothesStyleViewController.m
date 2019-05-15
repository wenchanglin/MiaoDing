
//
//  ChooseClothesStyleViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/26.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//



#import "ChooseClothesStyleViewController.h"
#import "FoldStyleButton.h"
#import "LGSelectView.h"
#import "STAlertView.h"
#import "ChooseClothesResultViewController.h"
#import "lowCollectionViewCell.h"
#import "rightCollectionViewCell.h"
#import "DiyWordInClothesViewController.h"
#import "newDiyAllDataModel.h"
@interface ChooseClothesStyleViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>


@end

@implementation ChooseClothesStyleViewController
{
    UIImageView *imageBanXing;
    UIImageView *imageXiuzihou;
    UIImageView *imageXiuziqian;
    UIImageView *imageLingziqian;
    UIImageView *imageLingzihou;
    UIImageView *imageXiaBai;
    UIImageView *imageKouDai;
    UIImageView *imageMengJing;
    NSMutableArray *pinImageArray;
    UIImageView *frontImage;
    NSMutableDictionary*AllDict;
    NSMutableDictionary*contentDict;
    UICollectionView *lowCollection;
    NSString *ClickWhat;
    NSMutableArray *picArray;
    NSMutableArray *tempArray;
    
    NSMutableArray *detailPicarray;
    NSMutableArray *rightPicArray;
    BOOL closeType;
    UICollectionView *rightCollection;
    NSMutableArray *NoOrYesArray;
    UIButton *buttonRightBarButton;
    NSMutableArray *detailArrayArray;
    
    UIButton *butXiuSheng;
    UIButton *butShangWu;
    UIButton *butXiuXiang;
    
    
    UIImageView *bigImg;
    NSInteger touchItem;
    NSInteger touchItemResult;
    BaseDomain *getData;
    NSMutableArray *rightNomalArray;
    NSMutableArray *clothesPicIdArray;
    UIImageView *flameAnimation;
    UIImageView *flameAnimation1;
    UIImageView *flameAnimation2;
    UIButton *buttonFront;
    UIButton *buttonBehind;
    UIButton *buttonIn;
    UIButton *buttonXiuXi;
    NSMutableArray *arrayForXiuxi;
    NSMutableDictionary *xiuxiDic;
    NSMutableArray*LowImageArray;
    NSMutableArray *CantChoose;
    UIButton *resetButton;
    BOOL flogXiuxi;
    BaseDomain *getYingDao;
    NSMutableArray *YDImgArray;
    UIImageView *Yingdao;
    NSInteger flogTouch;
    NSMutableArray *contentIdArray;
    NSMutableArray *contentArr;
    NSMutableArray *goodArray;
    NSMutableArray *flogDetailTouch;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self settabTitle:@"私人定制"];
    flogXiuxi = NO;
    getYingDao = [BaseDomain getInstance:NO];
    getData = [BaseDomain getInstance:NO];
    contentIdArray = [NSMutableArray array];
    goodArray = [NSMutableArray array];
    contentArr = [NSMutableArray array];
    NoOrYesArray = [NSMutableArray array];
    LowImageArray = [NSMutableArray array];
    clothesPicIdArray = [NSMutableArray array];
    rightNomalArray = [NSMutableArray array];
    contentDict = [NSMutableDictionary dictionary];
    picArray = [NSMutableArray array];
    arrayForXiuxi = [NSMutableArray array];
    pinImageArray = [NSMutableArray array];
    rightPicArray = [NSMutableArray array];
    CantChoose = [NSMutableArray array];
    flogDetailTouch= [NSMutableArray array];
    AllDict = [NSMutableDictionary dictionary];
    closeType = NO;
    buttonRightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 65,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-184-154:SCREEN_HEIGHT -130-175, 60, 60)];
    [buttonRightBarButton setImage:[UIImage imageNamed:@"下一步"] forState:UIControlStateNormal];
    //    [buttonRightBarButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:buttonRightBarButton];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRightBarButton];
    //    [buttonRightBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [buttonRightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonRightBarButton addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonRightBarButton setHidden:YES];
    
    
    resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-184-154:SCREEN_HEIGHT -130-175,60,60)];
    [resetButton setImage:[UIImage imageNamed:@"resetButton"] forState:UIControlStateNormal];
    [resetButton setHidden:YES];
    [self.view addSubview:resetButton];
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetImage) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    [self createCloteesPic];
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    if ( [[userd stringForKey:@"firstEnterDetail"] isEqualToString:@""]) {
        flogTouch = 1;
        [self getYingDao];
    }
    
    [self getDatas];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(addLoop) userInfo:nil repeats:NO];
    
    if (self.loop == nil) {
        self.loop = [[MagnifierView alloc] init];
        self.loop.viewToMagnify = self.view;
    }
    
    UITouch* touch = [touches anyObject];
    self.loop.touchPoint = [touch locationInView:self.view];
    [self.loop setNeedsDisplay];
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleAction:touches];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.touchTimer invalidate];
    self.touchTimer = nil;
    
    self.loop = nil;
}

- (void)handleAction:(id)timerObj {
    NSSet *touches = timerObj;
    UITouch *touch = [touches anyObject];
    self.loop.touchPoint = [touch locationInView:self.view];
    [self.loop setNeedsDisplay];
}

- (void)addLoop {
    // add the loop to the superview.  if we add it to the view it magnifies, it'll magnify itself!
    //[self.superview addSubview:loop];
    [self.loop makeKeyAndVisible];
    // here, we could do some nice animation instead of just adding the subview...
}

-(void)getYingDao
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"4" forKey:@"id"];
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_GetYinDaoForID_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            YDImgArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"data"] arrayForKey:@"img_urls"]];
            [self createYingDao];
        }
    }];
    
}

-(void)createYingDao
{
    Yingdao = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [Yingdao setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yingDaoClick:)];
    [Yingdao addGestureRecognizer:tap];
    
    [Yingdao sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [YDImgArray firstObject]]]];
    [self.view addSubview:Yingdao];
    
    
}

-(void)yingDaoClick:(UITapGestureRecognizer *)tap
{
    
    
    if (flogTouch < [YDImgArray count]) {
        if (flogTouch == 1) {
            flogXiuxi = NO;
            
            [self settabTitle:[LowImageArray[0] stringForKey:@"spec_name"]];
            if ([[[LowImageArray objectAtIndex:0] stringForKey:@"position_id"] isEqualToString:@"1"]) {
                [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                for (int i = 0; i < [LowImageArray count]; i ++) {
                    UIImageView *image = [self.view viewWithTag:100 + i];
                    if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"1"]) {
                        
                        if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
                            [image setHidden:NO];
                        } else {
                            [image setHidden:YES];
                        }
                        
                        
                        
                    } else {
                        [image setHidden:YES];
                    }
                }
            }else if ([[[LowImageArray objectAtIndex:0] stringForKey:@"position_id"] isEqualToString:@"2"]) {
                [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [buttonBehind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                for (int i = 0; i < [LowImageArray count]; i ++) {
                    UIImageView *image = [self.view viewWithTag:100 + i];
                    if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"2"]) {
                        if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
                            [image setHidden:NO];
                        } else {
                            [image setHidden:YES];
                        }
                    } else {
                        [image setHidden:YES];
                    }
                }
            } else {
                [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [buttonIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                for (int i = 0; i < [LowImageArray count]; i ++) {
                    UIImageView *image = [self.view viewWithTag:100 + i];
                    if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
                        if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
                            [image setHidden:NO];
                        } else {
                            [image setHidden:YES];
                        }
                    } else {
                        [image setHidden:YES];
                    }
                }
            }
            if (!closeType) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                [rightCollection setAlpha:1];
                [UIView commitAnimations];
                closeType = YES;
            }
            touchItem = 0;
            
            
            
            NSMutableArray *array = [NSMutableArray array];
            for (NSMutableDictionary *dic in [LowImageArray[0] arrayForKey:@"list"]) {
                
                NSString *string = [CantChoose componentsJoinedByString:@","];
                NSArray *tempArrayCant = [string componentsSeparatedByString:@","];
                NSInteger temp = 0;
                for (int i = 0 ; i < [tempArrayCant count]; i ++) {
                    NSString *str = tempArrayCant[i];
                    if ([str isEqualToString:[dic stringForKey:@"id"]]) {
                        temp ++;
                    }
                }
                if (temp == 0) {
                    [array addObject:dic];
                }
                
            }
            
            rightPicArray = [NSMutableArray arrayWithArray:array];
            
            if (60 * [rightPicArray count] > SCREEN_WIDTH) {
                [rightCollection setFrame:CGRectMake(10, [ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-84-80: SCREEN_HEIGHT - 120 -85, SCREEN_WIDTH, 65)];
            } else {
                
                [rightCollection setFrame:CGRectMake(SCREEN_WIDTH / 2 - (60 * [rightPicArray count] / 2), [ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-84-80: SCREEN_HEIGHT - 120-85, 60 * [rightPicArray count], 65)];
            }
            
            [rightCollection reloadData];
        }
        
        [Yingdao sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [YDImgArray objectAtIndex:flogTouch]]]];
        flogTouch ++;
    } else {
        
        [Yingdao removeFromSuperview];
        NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
        [userd setObject:@"yes" forKey:@"firstEnterDetail"];
    }
    
    [self.touchTimer invalidate];
    self.touchTimer = nil;
    self.loop = nil;
}


-(void)getDatas
{
    LowImageArray = _diyArray;
    NSMutableArray*imageArr=[NSMutableArray array];
    for (secondDataModel *twoModel in LowImageArray) {
        rightPicArray =twoModel.son.mutableCopy;
        [contentIdArray addObject: @(twoModel.type_id)];
//        [goodArray addObject:twoModel.son];
        [imageArr addObject:twoModel.android_min];
        for (threeDataModel*threeModel in twoModel.son) {
            [contentArr addObject:[NSString stringWithFormat:@"%@:%@",twoModel.type_name ,threeModel.part_name]];
        }
    }
    
    
    for (int i = 0; i < LowImageArray.count ; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"0" forKey:@"flog"];
        [flogDetailTouch addObject:dic];
    }
    
    
    picArray = imageArr;
    clothesPicIdArray = imageArr;
    
    for (int i = 0 ; i < [LowImageArray count] ; i ++) {
        [NoOrYesArray addObject:@"no"];
        [CantChoose addObject:@""];
    }
    
    [self createCloteesPic];
    [self createLowCollection];
    
    
    
}


-(void)resetImage
{
    [self settabTitle:@"私人定制"];
    [NoOrYesArray removeAllObjects];
    [clothesPicIdArray removeAllObjects];
    [rightNomalArray removeAllObjects];
    [flogDetailTouch removeAllObjects];
    [contentArr removeAllObjects];
    [picArray removeAllObjects];
    [arrayForXiuxi removeAllObjects];
    [pinImageArray removeAllObjects];
    [rightPicArray removeAllObjects];
    [CantChoose removeAllObjects];
    closeType = NO;
    NSMutableArray*imageArr=[NSMutableArray array];
    for (secondDataModel *twoModel in LowImageArray) {
        rightPicArray =twoModel.son.mutableCopy;
        [contentIdArray addObject: @(twoModel.type_id)];
//        [goodArray addObject:twoModel.son];
        [imageArr addObject:twoModel.android_min];
        for (threeDataModel*threeModel in twoModel.son) {
//            [contentArr addObject:[NSString stringWithFormat:@"%@:%@",twoModel.type_name ,threeModel.part_name]];
        }
    }
    
    
    for (int i = 0; i < LowImageArray.count ; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"0" forKey:@"flog"];
        [flogDetailTouch addObject:dic];
    }
    
    
    picArray = imageArr;
    clothesPicIdArray = imageArr;
    for (int i = 0 ; i < [LowImageArray count] ; i ++) {
        [NoOrYesArray addObject:@"no"];
        [CantChoose addObject:@""];
    }
    [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [LowImageArray count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        secondDataModel*smodle = LowImageArray[i];
        if (smodle.img_mark==2) {
            [image setHidden:YES];
        }else if (smodle.img_mark==3) {
            [image setHidden:YES];
        } else {
            [image setHidden:NO];
        }
    }
    [resetButton setHidden:YES];
    [buttonRightBarButton setHidden:YES];
    [lowCollection reloadData];
    rightCollection.hidden=YES;
//    [rightCollection reloadData];
}


-(void)nextStepClick   //完成
{
    //停止下载所有图片
    [[SDWebImageManager sharedManager] cancelAll];
    //清除内存中的图片
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    NSMutableString*idString = [[NSMutableString alloc]init];
    [AllDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, threeDataModel* obj, BOOL * _Nonnull stop) {
        secondDataModel*model9=LowImageArray[[key integerValue]];
        [idString appendString:[NSString stringWithFormat:@"%@,",@(obj.part_id)]];
        [contentDict setObject:obj forKey:model9.type_name];
    }];
    [idString deleteCharactersInRange:NSMakeRange(idString.length-1, 1)];
    [_paramsClothes setObject:idString forKey:@"must_display_part_ids"];
    ChooseClothesResultViewController *result = [[ChooseClothesResultViewController alloc] init];
    result.paramsClothes = _paramsClothes;
    result.goodArray = LowImageArray;
    result.goodDic = contentDict;
    result.price = _price;
//    result.xiuZiDic = _xiuZiDic;
//    result.dateId = _dateId;
//    result.dingDate = _dingDate;
//    result.banxingid = [_banxing objectForKey:@"id"];
    result.ifTK = NO;
    //        result.defaultImg = _defaultImg;
    result.diyArray = _diyArray;
//    result.diyDetailArray = _diydetailArray;
    [self.navigationController pushViewController:result animated:YES];
    
    //    [self.navigationController pushViewController:result animated:YES];
    //    DiyWordInClothesViewController *diyClothes = [[DiyWordInClothesViewController alloc] init];
    //    diyClothes.goodDic = _goodDic;
    //    diyClothes.goodArray = goodArray;
    //    diyClothes.price = _price;
    //    diyClothes.xiuZiDic = xiuxiDic;
    //    diyClothes.class_id = _class_id;
    //    diyClothes.paramsDic = goodParams;
    //    [self.navigationController pushViewController:diyClothes animated:YES];
    
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    if (xiuxiDic) {
    //         [dic setObject:xiuxiDic forKey:@"xiuzi"];
    //    } else {
    //         [dic setObject:[NSMutableDictionary dictionary] forKey:@"xiuzi"];
    //    }
    //
    //    [dic setObject:clothesPicIdArray forKey:@"clothes"];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil userInfo:dic];
    //    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)createCloteesPic
{
    
     if ([_class_id integerValue] == 280||[_class_id integerValue]==302) {//280风衣,302大衣
        buttonFront = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 -80, 26+NavHeight, 40, 20)];
        [self.view addSubview:buttonFront];
        [buttonFront addTarget:self action:@selector(FrontClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonFront.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonFront setTitle:@"正面" forState:UIControlStateNormal];
        
        [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        buttonBehind = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 20, 26+NavHeight, 40, 20)];
        [buttonBehind.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonBehind addTarget:self action:@selector(behindClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonBehind setTitle:@"反面" forState:UIControlStateNormal];
        [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.view addSubview:buttonBehind];
        
        buttonIn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 40, 26+NavHeight, 40, 20)];
        [buttonIn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonIn addTarget:self action:@selector(InClick) forControlEvents:UIControlEventTouchUpInside];
        [buttonIn setTitle:@"里子" forState:UIControlStateNormal];
        [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.view addSubview:buttonIn];
        
    }
    else {
    buttonFront = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 26+NavHeight, 40, 20)];
    [buttonFront addTarget:self action:@selector(FrontClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonFront.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonFront setTitle:@"正面" forState:UIControlStateNormal];
    [self.view addSubview:buttonFront];
    [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    buttonBehind = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 10, 26+NavHeight, 40, 20)];
    [buttonBehind.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonBehind addTarget:self action:@selector(behindClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonBehind setTitle:@"反面" forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.view addSubview:buttonBehind];
    }
    
    for (int i = 0; i < [LowImageArray count]; i ++) {
        @autoreleasepool {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 325)];
            [image setTag:100 + i];
            [image setUserInteractionEnabled:YES];
            [image setContentMode:UIViewContentModeScaleAspectFill];
            [image.layer setMasksToBounds:YES];
            secondDataModel*model2 = LowImageArray[i];
            threeDataModel*model3= [model2.son firstObject];
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model3.android_max]]];
            image.center = CGPointMake(self.view.centerX, [ShiPeiIphoneXSRMax isIPhoneX]?self.view.centerY-104:self.view.centerY - 20-84);
            [self.view addSubview:image];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < [LowImageArray count]; i ++) {
            @autoreleasepool {
                UIImageView *image = [self.view viewWithTag:100 + i];
                secondDataModel*model4 = LowImageArray[i];
                if (model4.img_mark==2) {
                    [image setHidden:YES];
                }else if (model4.img_mark==3) {
                    [image setHidden:YES];
                } else {
                    [image setHidden:NO];
                }
            }
        }
    });
    
    
    
    frontImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:frontImage];
    [frontImage setImage:[UIImage imageNamed:@"BGALPHA"]];
    [frontImage setHidden:YES];
    
    
    
}

-(void)xiuxiClick
{
    flogXiuxi = YES;
    rightPicArray = arrayForXiuxi;
    [rightCollection reloadData];
}

-(void)FrontClick{
    [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [LowImageArray count]; i ++) {
        secondDataModel*model4 = LowImageArray[i];
        
        UIImageView *image = [self.view viewWithTag:100 + i];
        if (model4.img_mark==2) {
            [image setHidden:YES];
        }else if(model4.img_mark==3) {
            [image setHidden:YES];
        } else {
            [image setHidden:NO];
        }
    }
    
}

-(void)behindClick
{
    [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [LowImageArray count]; i ++) {
        @autoreleasepool {
            UIImageView *image = [self.view viewWithTag:100 + i];
            secondDataModel*model4 = LowImageArray[i];
            
            if (model4.img_mark==1) {
                [image setHidden:YES];
            }else if(model4.img_mark==3) {
                [image setHidden:YES];
            } else {
                [image setHidden:NO];
            }
        }
    }
}

-(void)InClick
{
    [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [LowImageArray count]; i ++) {
        @autoreleasepool {
            UIImageView *image = [self.view viewWithTag:100 + i];
            secondDataModel*model4 = LowImageArray[i];
            if (model4.img_mark==1) {
                [image setHidden:YES];
            }else if(model4.img_mark==3) {
                [image setHidden:NO];
            } else {
                [image setHidden:YES];
            }
        }
    }
}





-(void)hideRightCollection
{
    if (closeType) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [rightCollection setAlpha:0];
        [UIView commitAnimations];
        closeType = NO;
    }
}


-(void)createLowCollection
{
    if (@available(iOS 11.0, *)) {
        lowCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    lowCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:lowCollection];
    if (60 * [LowImageArray count] >SCREEN_WIDTH) {
        lowCollection.sd_layout
        .bottomSpaceToView(self.view, 20)
        .heightIs(65)
        .widthIs(SCREEN_WIDTH)
        .centerXEqualToView(self.view);
        lowCollection.showsHorizontalScrollIndicator = NO;
        //设置代理
        lowCollection.delegate = self;
        lowCollection.dataSource = self;
    } else {
        
        lowCollection.sd_layout
        .bottomSpaceToView(self.view, 20)
        .heightIs(65)
        .widthIs(60 *[LowImageArray count])
        .centerXEqualToView(self.view);
        lowCollection.showsHorizontalScrollIndicator = NO;
        //设置代理
        lowCollection.delegate = self;
        lowCollection.dataSource = self;
    }
    
    
    
    //注册cell和ReusableView（相当于头部）
    [lowCollection setBackgroundColor:[UIColor clearColor]];
    [lowCollection registerClass:[lowCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [lowCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    if (@available(iOS 11.0, *)) {
        rightCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout1.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    rightCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout1];
    [self.view addSubview:rightCollection];
    
    rightCollection.sd_layout
    .bottomSpaceToView(lowCollection, 20)
    .centerXEqualToView(self.view)
    .heightIs(65)
    .widthIs(SCREEN_WIDTH);
    
    rightCollection.showsHorizontalScrollIndicator = NO;
    
    [rightCollection setAlpha:0];
    //设置代理
    rightCollection.delegate = self;
    rightCollection.dataSource = self;
    
    rightCollection.backgroundColor = [UIColor clearColor];
    //注册cell和ReusableView（相当于头部）
    
    [rightCollection registerClass:[rightCollectionViewCell class] forCellWithReuseIdentifier:@"cellRight"];
    [rightCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
    [self createBigImage];
}



-(void)createBigImage
{
    bigImg = [UIImageView new];
    [self.view addSubview:bigImg];
    
    bigImg.sd_layout
    .bottomSpaceToView(rightCollection,30)
    .centerXEqualToView(self.view)
    .heightIs(52 * 4)
    .widthIs(52 * 4);
    [bigImg setHidden:YES];
    
    
    [self.view bringSubviewToFront:Yingdao];
    
}





-(void)showNextStep :(NSMutableArray *)array

{
    picArray = array;
    [lowCollection reloadData];
    [buttonRightBarButton setHidden:NO];
    
    for (int i = 0; i < [NoOrYesArray count]; i ++) {
        [NoOrYesArray replaceObjectAtIndex:i withObject:@"yes"];
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == lowCollection) {
        return [LowImageArray count];//picArray
    } else return [rightPicArray count];
    
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
    
    if (collectionView == lowCollection) {
        static NSString *identify = @"cell";
        lowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell.imageShow sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,picArray[indexPath.item]]]];
        if ([NoOrYesArray[indexPath.row] isEqualToString:@"yes"]) {
            [cell.Alhpa setHidden:NO];
        } else {
            [cell.Alhpa setHidden:YES];
        }
        [cell sizeToFit];
        reCell = cell;
    } else {
        static NSString *identify = @"cellRight";
        threeDataModel*model2=rightPicArray[indexPath.item];
        rightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell.bigButoon setTag:indexPath.item + 5];
//        [cell.bigButoon addTarget:self action:@selector(bigButonDown:) forControlEvents:UIControlEventTouchDown];
          UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bigButonDown:)];
        [cell addGestureRecognizer:longPress];

        [cell.bigButoon addTarget:self action:@selector(bigButoonUp:) forControlEvents:UIControlEventTouchUpInside];
        [cell.imageShow sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,model2.android_middle]]];
        NSMutableDictionary *dic = flogDetailTouch[touchItem];
        if (indexPath.row == [dic integerForKey:@"flog"]) {
            [cell.Alhpa setHidden:NO];
//
        } else {
            [cell.Alhpa setHidden:YES];
        }
        
        [cell sizeToFit];
        reCell = cell;
    }
    
    return reCell;
}


-(void)bigButonDown:(UILongPressGestureRecognizer*)longpressgesture//(UIButton *)sender
{
    NSInteger sender = longpressgesture.view.tag;
    if (longpressgesture.state == UIGestureRecognizerStateBegan) {
        if (!flogXiuxi) {
            threeDataModel*model = rightPicArray[sender];//sender.tag-5
            [bigImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.android_min]]];
            
            
            UIImageView *image = [self.view viewWithTag:touchItem + 100];
            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, model.android_max]]];
            
            
            
            if ([model.part_name rangeOfString:@"法式"].location == NSNotFound) {
                [flameAnimation setHidden:YES];;
                [flameAnimation1 setHidden:YES];
                [flameAnimation2 setHidden:YES];
                xiuxiDic = nil;
                [buttonXiuXi setHidden:YES];
                
            }else {
                [flameAnimation setHidden:NO];
                [flameAnimation1 setHidden:NO];
                [flameAnimation2 setHidden:NO];
                [buttonXiuXi setHidden:NO];
            }
            
            arrayForXiuxi = model.child_list.count>0?model.child_list:@[].mutableCopy;//[NSMutableArray arrayWithArray:[rightPicArray[sender.tag - 5] arrayForKey:@"child_list"]];
        }
        
        [bigImg setHidden:NO];
        
        [frontImage setHidden:NO];
    }
    else if (longpressgesture.state == UIGestureRecognizerStateEnded) {
        //长按结束
        bigImg.hidden=YES;
        [frontImage setHidden:YES];

    }
   
    
    
    
    
}

-(void)bigButoonUp:(UIButton *)sender
{
    if (!flogXiuxi) {
        threeDataModel*model = rightPicArray[sender.tag-5];
        secondDataModel*model2= LowImageArray[touchItem];
        NSMutableDictionary *dic = [flogDetailTouch objectAtIndex:touchItem];
        [dic setObject:[NSString stringWithFormat:@"%ld", sender.tag - 5] forKey:@"flog"];
        
        [picArray replaceObjectAtIndex:touchItem withObject:model.android_min];
        
        [clothesPicIdArray replaceObjectAtIndex:touchItem withObject:model ];
        
        //        [CantChoose replaceObjectAtIndex:touchItem withObject:[rightPicArray[sender.tag - 5] stringForKey:@"notmatch_spec_ids"]];
        [NoOrYesArray replaceObjectAtIndex:touchItem withObject:@"yes"];
        [lowCollection reloadData];
        [AllDict setObject:model forKey:@(touchItem)];
        if (model2.img_mark==1) {
            [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            if (touchItem != 0) {
                for (int i = 0; i < [LowImageArray count]; i ++) {
                    @autoreleasepool {
                        secondDataModel *model3 =LowImageArray[i];
                        UIImageView *image = [self.view viewWithTag:100 + i];
                        if (model3.img_mark==1) {
                            
                            if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
                                [image setHidden:NO];
                            } else {
                                [image setHidden:YES];
                            }
                            
                        } else if(model3.img_mark==2) {
                            [image setHidden:YES];
                        }
                        else if(model3.img_mark==3) {
                            [image setHidden:YES];
                        }
                    }
                }
//            }
            
        }else if (model2.img_mark==2) {
            [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonBehind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            for (int i = 0; i < [LowImageArray count]; i ++) {
                @autoreleasepool {
                    UIImageView *image = [self.view viewWithTag:100 + i];
                    secondDataModel *model3 =LowImageArray[i];
                    
                    if (model3.img_mark==2) {
                        if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
                            [image setHidden:NO];
                        } else {
                            [image setHidden:YES];
                        }
                    } else if(model3.img_mark==1) {
                        [image setHidden:YES];
                    }
                    else if(model3.img_mark==3) {
                        [image setHidden:YES];
                    }
                }
            }
        } else {
            [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            for (int i = 0; i < [LowImageArray count]; i ++) {
                @autoreleasepool {
                    UIImageView *image = [self.view viewWithTag:100 + i];
                    secondDataModel *model3 =LowImageArray[i];
                    
                    if (model3.img_mark==3) {
                        if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
                            [image setHidden:NO];
                        } else {
                            [image setHidden:YES];
                        }
                    } else if(model3.img_mark==2) {
                        [image setHidden:YES];
                    }
                    else if(model3.img_mark==1) {
                        [image setHidden:YES];
                    }
                }
            }
        }
        
        
        NSInteger i = 0;
        for (NSString *str in NoOrYesArray) {
            if ([str isEqualToString:@"no"]) {
                i ++;
            }
        }
        if ( i > 0) {
            [buttonRightBarButton setHidden:YES];
        } else {
            [buttonRightBarButton setHidden:NO];
        }
        
        NSInteger j = 0;
        for (NSString *str in NoOrYesArray) {
            if ([str isEqualToString:@"yes"]) {
                j ++;
            }
        }
        if ( j > 0) {
            [resetButton setHidden:NO];
        } else {
            [resetButton setHidden:YES];
        }
        
    } else {
#warning  待修改
        //        xiuxiDic = [NSMutableDictionary dictionaryWithDictionary:rightPicArray[sender.tag - 5]];
    }
    [bigImg setHidden:YES];
    [frontImage setHidden:YES];
    
    
    [rightCollection reloadData];
    
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    CGSize reSize;
    if (collectionView == lowCollection) {
        reSize = CGSizeMake(60, 60);
    } else {
        reSize = CGSizeMake(60, 60);
    }
    return reSize;
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
//    if (collectionView == lowCollection) {
        rightCollection.hidden=NO;
        flogXiuxi = NO;
        secondDataModel *model =LowImageArray[indexPath.item];
        [self settabTitle: model.type_name];
        if (model.img_mark==1) {
            [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

//            if (indexPath.item != 0) {
                for (int i = 0; i < [LowImageArray count]; i ++) {
                    @autoreleasepool {
                        UIImageView *image = [self.view viewWithTag:100 + i];
                        secondDataModel *model2 =LowImageArray[i];
                        if (model2.img_mark==1) {
                            if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
                                [image setHidden:NO];
                                
                            } else {
                                [image setHidden:YES];
                            }
                            
                            
                        } else if(model2.img_mark==2) {
                            [image setHidden:YES];
                        }
                        else if (model2.img_mark==3)
                        {
                            image.hidden=YES;
                        }
                    }
                }
//            }
        }else if (model.img_mark==2) {

            [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonBehind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            for (int i = 0; i < [LowImageArray count]; i ++) {
                @autoreleasepool {
                    UIImageView *image = [self.view viewWithTag:100 + i];
                    secondDataModel *model2 =LowImageArray[i];
                    if (model2.img_mark==2) {
                        if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
                            [image setHidden:NO];
                        } else {
                            [image setHidden:YES];
                        }
                    } else if(model2.img_mark==1){
                        [image setHidden:YES];
                    }
                    else if (model2.img_mark==3)
                    {
                        image.hidden=YES;
                    }
                }
            }
        } else {
            [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [buttonIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            for (int i = 0; i < [LowImageArray count]; i ++) {
                @autoreleasepool {
                    UIImageView *image = [self.view viewWithTag:100 + i];
                    secondDataModel *model2 =LowImageArray[i];
                    
                    if (model2.img_mark==3) {
                        if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
                            [image setHidden:NO];
                        } else {
                            [image setHidden:YES];
                        }
                    } else if(model2.img_mark==1) {
                        [image setHidden:YES];
                    }
                    else if (model2.img_mark==2)
                    {
                        image.hidden=YES;
                    }
                }
            }
        }
        if (!closeType) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            [rightCollection setAlpha:1];
            [UIView commitAnimations];
            closeType = YES;
        }
        touchItem = indexPath.item;
        
        
        
        NSMutableArray *array = [NSMutableArray array];
        for (threeDataModel*model6 in model.son) {
            
            NSString *string = [CantChoose componentsJoinedByString:@","];
            NSArray *tempArrayCant = [string componentsSeparatedByString:@","];
            NSInteger temp = 0;
            for (int i = 0 ; i < [tempArrayCant count]; i ++) {
                NSString *str = tempArrayCant[i];
                if ([str integerValue]== model6.part_id) {
                    temp ++;
                }
            }
            if (temp == 0) {
                [array addObject:model6];
            }
            
        }
        
        rightPicArray = [NSMutableArray arrayWithArray:array];
        
        if (60 * [rightPicArray count] > SCREEN_WIDTH) {
            [rightCollection setFrame:CGRectMake(10,[ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-94-80: SCREEN_HEIGHT - 120-95, SCREEN_WIDTH, 65)];
        } else {
            
            [rightCollection setFrame:CGRectMake(SCREEN_WIDTH / 2 - (60 * [rightPicArray count] / 2), [ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT-64-94-80: SCREEN_HEIGHT - 120-95, 60 * [rightPicArray count], 65)];
            
        }
        
        [rightCollection reloadData];
        
//    } else {
//
//        WCLLog(@"你走到这里了");
//
//    }
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
