//
//  ChooseStyleNewViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/3/6.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "ChooseStyleNewViewController.h"
#import "rightCollectionViewCell.h"
#import "lowCollectionViewCell.h"
@interface ChooseStyleNewViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ChooseStyleNewViewController
{
    BaseDomain *getData;
    NSMutableArray *LowImageArray;
    NSMutableArray *rightNomalArray;
    NSMutableArray *picArray;
    NSMutableArray *clothesPicIdArray;
    UIImageView *frontImage;
    UIButton *buttonFront;
    UIButton *buttonBehind;
    UIButton *buttonIn;
    UICollectionView *rightCollection;
    NSMutableArray *NoOrYesArray;
    NSMutableArray *CantChoose;
    NSMutableArray *rightPicArray;
    UIImageView *bigImg;
    NSInteger touchItem;
    NSMutableDictionary *xiuxiDic;
    BOOL flogXiuxi;
    
    UICollectionView *lowCollection;
    UIView *topChoose;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    flogXiuxi = NO;
    touchItem = 0;
    NoOrYesArray = [NSMutableArray array];
    LowImageArray = [NSMutableArray array];
    clothesPicIdArray = [NSMutableArray array];
    rightNomalArray = [NSMutableArray array];
    picArray = [NSMutableArray array];
    rightPicArray = [NSMutableArray array];
    CantChoose = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    self.title = @"版型";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getDatas];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)getDatas
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [params setObject:@"6" forKey:@"phone_type"];
    [params setObject:_price_Type forKey:@"price_type"];
    [getData getData:URL_GetDingZhiPicNew PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:getData]) {
            LowImageArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"spec_list"]];
            
            rightNomalArray = [NSMutableArray arrayWithArray:[[getData.dataRoot objectForKey:@"data"] arrayForKey:@"spec_ templets_recommend"]];
            picArray = [NSMutableArray arrayWithArray:[LowImageArray valueForKey:@"img"]];
            [picArray removeObjectAtIndex:0];
            [picArray addObject:@""];
            clothesPicIdArray = [NSMutableArray arrayWithArray:[LowImageArray valueForKey:@"img"]];
            for (int i = 0 ; i < [LowImageArray count] ; i ++) {
                [NoOrYesArray addObject:@"no"];
                [CantChoose addObject:@""];
            }
            
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
            
            [self createView];
            [self createLowCollection];
        }
    }];
    
}

#pragma mark -- lowClothes
-(void)createLowCollection
{
    
    topChoose = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 131, SCREEN_WIDTH, 132)];
    [self.view addSubview:topChoose];
    
    
    UIView *lineFirst = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 132, SCREEN_WIDTH, 1)];
    [lineFirst setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
    [self.view addSubview:lineFirst];
    
    
    UIButton *buttonBX = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 65)];
    
    [buttonBX setTitle:@"版型" forState:UIControlStateNormal];
    [topChoose addSubview:buttonBX];
    [buttonBX addTarget:self action:@selector(banXingClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonBX setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *buttonMore = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 65)];
    [buttonMore setTitle:@"更多细节" forState:UIControlStateNormal];
    [topChoose addSubview:buttonMore];
    [buttonMore addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [buttonMore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIView *lineSecond = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 66, SCREEN_WIDTH, 1)];
    [lineSecond setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
    [self.view addSubview:lineSecond];
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    lowCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:lowCollection];
    lowCollection.sd_layout
    .bottomSpaceToView (self.view,66)
    .heightIs(65)
    .widthIs(60 *([LowImageArray count] - 1))
    .centerXEqualToView(self.view);
    lowCollection.showsHorizontalScrollIndicator = NO;
    //设置代理
    lowCollection.delegate = self;
    lowCollection.dataSource = self;
    [lowCollection setHidden:YES];
    //注册cell和ReusableView（相当于头部）
    [lowCollection setBackgroundColor:[UIColor clearColor]];
    [lowCollection registerClass:[lowCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [lowCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout1.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    rightCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout1];
    [self.view addSubview:rightCollection];
    
    if (60 * [rightPicArray count] > SCREEN_WIDTH) {
        [rightCollection setFrame:CGRectMake(0, SCREEN_HEIGHT - 65, SCREEN_WIDTH, 65)];
    } else {
        
        [rightCollection setFrame:CGRectMake(SCREEN_WIDTH / 2 - (60 * [rightPicArray count] / 2), SCREEN_HEIGHT - 65, 60 * [rightPicArray count], 65)];
        
    }
    
    rightCollection.showsHorizontalScrollIndicator = NO;
    
    
    //设置代理
    rightCollection.delegate = self;
    rightCollection.dataSource = self;
    
    rightCollection.backgroundColor = [UIColor clearColor];
    //注册cell和ReusableView（相当于头部）
    
    [rightCollection registerClass:[rightCollectionViewCell class] forCellWithReuseIdentifier:@"cellRight"];
    [rightCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
    
    
}


-(void)banXingClick
{
    self.title = [LowImageArray[0] stringForKey:@"spec_name"];
    //        if ([[[LowImageArray objectAtIndex:indexPath.item] stringForKey:@"position_id"] isEqualToString:@"1"]) {
    //            [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //            for (int i = 0; i < [LowImageArray count]; i ++) {
    //                UIImageView *image = [self.view viewWithTag:100 + i];
    //                if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"1"]) {
    //
    //                    if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
    //                        [image setHidden:NO];
    //                    } else {
    //                        [image setHidden:YES];
    //                    }
    //
    //
    //
    //                } else {
    //                    [image setHidden:YES];
    //                }
    //            }
    //        }else if ([[[LowImageArray objectAtIndex:indexPath.item] stringForKey:@"position_id"] isEqualToString:@"2"]) {
    //            [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //            [buttonBehind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //            for (int i = 0; i < [LowImageArray count]; i ++) {
    //                UIImageView *image = [self.view viewWithTag:100 + i];
    //                if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"2"]) {
    //                    if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
    //                        [image setHidden:NO];
    //                    } else {
    //                        [image setHidden:YES];
    //                    }
    //                } else {
    //                    [image setHidden:YES];
    //                }
    //            }
    //        } else {
    //            [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //            [buttonIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //            for (int i = 0; i < [LowImageArray count]; i ++) {
    //                UIImageView *image = [self.view viewWithTag:100 + i];
    //                if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
    //                    if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
    //                        [image setHidden:NO];
    //                    } else {
    //                        [image setHidden:YES];
    //                    }
    //                } else {
    //                    [image setHidden:YES];
    //                }
    //            }
    //        }
    //        if (!closeType) {
    //            [UIView beginAnimations:nil context:nil];
    //            [UIView setAnimationDuration:0.2];
    //            [rightCollection setAlpha:1];
    //            [UIView commitAnimations];
    //            closeType = YES;
    //        }
    touchItem = 0;
    
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSMutableDictionary *dic in [LowImageArray[0]  arrayForKey:@"list"]) {
        
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
        [rightCollection setFrame:CGRectMake(10, SCREEN_HEIGHT -65 , SCREEN_WIDTH, 65)];
    } else {
        
        [rightCollection setFrame:CGRectMake(SCREEN_WIDTH / 2 - (60 * [rightPicArray count] / 2), SCREEN_HEIGHT - 65 , 60 * [rightPicArray count], 65)];
        
    }
    
    [rightCollection reloadData];
}



-(void)moreClick
{
    [topChoose setHidden:YES];
    [lowCollection setHidden:NO];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == lowCollection) {
        return [picArray count];
    } else
    return [rightPicArray count];
    
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
//        [cell.imageShow.layer setCornerRadius:25];
        if (indexPath.item == [picArray count] - 1) {
            [cell.imageShow setImage:[UIImage imageNamed:@"close"]];
        } else {
            [cell.imageShow sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,picArray[indexPath.item]]]];
        }
    
        [cell sizeToFit];
        reCell = cell;
    } else {
        static NSString *identify = @"cellRight";
        rightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell.bigButoon setTag:indexPath.item + 5];
        [cell.bigButoon addTarget:self action:@selector(bigButonDown:) forControlEvents:UIControlEventTouchDown];
        
        [cell.bigButoon addTarget:self action:@selector(bigButoonUp:) forControlEvents:UIControlEventTouchUpInside];
        [cell.imageShow sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,[rightPicArray[indexPath.item] stringForKey:@"img_a"]]]];
        
        [cell sizeToFit];
        reCell = cell;
    }
    
    return reCell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == lowCollection) {
        flogXiuxi = NO;
        if (indexPath.item == [picArray count] - 1) {
            [topChoose setHidden:NO];
            [lowCollection setHidden:YES];
        } else {
            self.title = [LowImageArray[indexPath.item] stringForKey:@"spec_name"];
            //        if ([[[LowImageArray objectAtIndex:indexPath.item] stringForKey:@"position_id"] isEqualToString:@"1"]) {
            //            [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //            for (int i = 0; i < [LowImageArray count]; i ++) {
            //                UIImageView *image = [self.view viewWithTag:100 + i];
            //                if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"1"]) {
            //
            //                    if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
            //                        [image setHidden:NO];
            //                    } else {
            //                        [image setHidden:YES];
            //                    }
            //
            //
            //
            //                } else {
            //                    [image setHidden:YES];
            //                }
            //            }
            //        }else if ([[[LowImageArray objectAtIndex:indexPath.item] stringForKey:@"position_id"] isEqualToString:@"2"]) {
            //            [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //            [buttonBehind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //            for (int i = 0; i < [LowImageArray count]; i ++) {
            //                UIImageView *image = [self.view viewWithTag:100 + i];
            //                if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"2"]) {
            //                    if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
            //                        [image setHidden:NO];
            //                    } else {
            //                        [image setHidden:YES];
            //                    }
            //                } else {
            //                    [image setHidden:YES];
            //                }
            //            }
            //        } else {
            //            [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //            [buttonIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            for (int i = 0; i < [LowImageArray count]; i ++) {
            //                UIImageView *image = [self.view viewWithTag:100 + i];
            //                if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
            //                    if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
            //                        [image setHidden:NO];
            //                    } else {
            //                        [image setHidden:YES];
            //                    }
            //                } else {
            //                    [image setHidden:YES];
            //                }
            //            }
            //        }
            //        if (!closeType) {
            //            [UIView beginAnimations:nil context:nil];
            //            [UIView setAnimationDuration:0.2];
            //            [rightCollection setAlpha:1];
            //            [UIView commitAnimations];
            //            closeType = YES;
            //        }
            touchItem = indexPath.item + 1;
            
            
            
            NSMutableArray *array = [NSMutableArray array];
            for (NSMutableDictionary *dic in [LowImageArray[indexPath.item + 1]  arrayForKey:@"list"]) {
                
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
                [rightCollection setFrame:CGRectMake(10, SCREEN_HEIGHT -65 , SCREEN_WIDTH, 65)];
            } else {
                
                [rightCollection setFrame:CGRectMake(SCREEN_WIDTH / 2 - (60 * [rightPicArray count] / 2), SCREEN_HEIGHT - 65 , 60 * [rightPicArray count], 65)];
                
            }
            
            [rightCollection reloadData];
        }
        
        
    } else {
        
        
        
    }
}



#pragma mark -- clothesShow

-(void)createView
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

    
    for (int i = 0; i < [LowImageArray count]; i ++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 325)];
        [image setTag:100 + i];
        [image setUserInteractionEnabled:YES];
        [image setContentMode:UIViewContentModeScaleAspectFill];
        [image.layer setMasksToBounds:YES];
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[[LowImageArray[i] arrayForKey:@"list"] firstObject] stringForKey:@"img_c"]]]];
        image.center = CGPointMake(self.view.centerX, self.view.centerY - 20);
        
        
        [self.view addSubview:image];
    }
    
    
    for (int i = 0; i < [LowImageArray count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"2"]) {
            [image setHidden:YES];
        }else if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
            [image setHidden:YES];
        } else {
            [image setHidden:NO];
        }
    }
    
    
    
    frontImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:frontImage];
    [frontImage setImage:[UIImage imageNamed:@"BGALPHA"]];
    [frontImage setHidden:YES];
}





#pragma mark -- buttonClickTop


-(void)bigButonDown:(UIButton *)sender
{
    
    if (!flogXiuxi) {
        [bigImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [rightPicArray[sender.tag - 5] stringForKey:@"img_b"]]]];
        
        
        UIImageView *image = [self.view viewWithTag:touchItem + 100];
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [rightPicArray[sender.tag - 5] stringForKey:@"img_c"]]]];
        
        
        
//        if ([[rightPicArray[sender.tag - 5] stringForKey:@"name"] rangeOfString:@"法式"].location == NSNotFound) {
//            [flameAnimation setHidden:YES];;
//            [flameAnimation1 setHidden:YES];
//            [flameAnimation2 setHidden:YES];
//            xiuxiDic = nil;
//            [buttonXiuXi setHidden:YES];
//            
//        }else {
//            [flameAnimation setHidden:NO];
//            [flameAnimation1 setHidden:NO];
//            [flameAnimation2 setHidden:NO];
//            [buttonXiuXi setHidden:NO];
//        }
//        
//        arrayForXiuxi = [NSMutableArray arrayWithArray:[rightPicArray[sender.tag - 5] arrayForKey:@"child_list"]];
    }
    
    [bigImg setHidden:NO];
    
    [frontImage setHidden:NO];
    
    
    
    
}

-(void)bigButoonUp:(UIButton *)sender
{
    if (!flogXiuxi) {
        
//        [picArray replaceObjectAtIndex:touchItem withObject:[rightPicArray[sender.tag - 5] stringForKey:@"img_a"]];
        
        [clothesPicIdArray replaceObjectAtIndex:touchItem withObject:rightPicArray[sender.tag - 5] ];
        
        [CantChoose replaceObjectAtIndex:touchItem withObject:[rightPicArray[sender.tag - 5] stringForKey:@"notmatch_spec_ids"]];
        [NoOrYesArray replaceObjectAtIndex:touchItem withObject:@"yes"];
        
        
        
//        if ([[[LowImageArray objectAtIndex:touchItem] stringForKey:@"position_id"] isEqualToString:@"1"]) {
//            [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            for (int i = 0; i < [LowImageArray count]; i ++) {
//                UIImageView *image = [self.view viewWithTag:100 + i];
//                if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"1"]) {
//                    
//                    if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
//                        [image setHidden:NO];
//                    } else {
//                        [image setHidden:YES];
//                    }
//                    
//                    
//                    
//                } else {
//                    [image setHidden:YES];
//                }
//            }
//        }else if ([[[LowImageArray objectAtIndex:touchItem] stringForKey:@"position_id"] isEqualToString:@"2"]) {
//            [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [buttonBehind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            for (int i = 0; i < [LowImageArray count]; i ++) {
//                UIImageView *image = [self.view viewWithTag:100 + i];
//                if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"2"]) {
//                    if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
//                        [image setHidden:NO];
//                    } else {
//                        [image setHidden:YES];
//                    }
//                } else {
//                    [image setHidden:YES];
//                }
//            }
//        } else {
//            [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [buttonIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            for (int i = 0; i < [LowImageArray count]; i ++) {
//                UIImageView *image = [self.view viewWithTag:100 + i];
//                if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
//                    if ([NoOrYesArray[i] isEqualToString:@"yes"]) {
//                        [image setHidden:NO];
//                    } else {
//                        [image setHidden:YES];
//                    }
//                } else {
//                    [image setHidden:YES];
//                }
//            }
//        }
        
        
        NSInteger i = 0;
        for (NSString *str in NoOrYesArray) {
            if ([str isEqualToString:@"no"]) {
                i ++;
            }
        }
//        if ( i > 0) {
//            [buttonRightBarButton setHidden:YES];
//        } else {
//            [buttonRightBarButton setHidden:NO];
//        }
        
        NSInteger j = 0;
        for (NSString *str in NoOrYesArray) {
            if ([str isEqualToString:@"yes"]) {
                j ++;
            }
        }
//        if ( j > 0) {
//            [resetButton setHidden:NO];
//        } else {
//            [resetButton setHidden:YES];
//        }
        
    } else {
        xiuxiDic = [NSMutableDictionary dictionaryWithDictionary:rightPicArray[sender.tag - 5]];
    }
    [bigImg setHidden:YES];
    [frontImage setHidden:YES];
    
    
    
    
    
}



-(void)FrontClick{
    [buttonFront setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonIn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [LowImageArray count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"2"]) {
            [image setHidden:YES];
        }else if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
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
        UIImageView *image = [self.view viewWithTag:100 + i];
        if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"1"]) {
            [image setHidden:YES];
        }else if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
            [image setHidden:YES];
        } else {
            [image setHidden:NO];
        }
    }
}

-(void)InClick
{
    [buttonFront setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonBehind setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    for (int i = 0; i < [LowImageArray count]; i ++) {
        UIImageView *image = [self.view viewWithTag:100 + i];
        if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"1"]) {
            [image setHidden:YES];
        }else if ([[[LowImageArray objectAtIndex:i] stringForKey:@"position_id"] isEqualToString:@"3"]) {
            [image setHidden:NO];
        } else {
            [image setHidden:YES];
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
