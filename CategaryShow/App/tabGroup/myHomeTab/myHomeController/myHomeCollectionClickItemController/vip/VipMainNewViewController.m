//
//  VipMainNewViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/5/8.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "VipMainNewViewController.h"
#import "LXGradientProcessView.h"
#import "VipDetailViewController.h"
#import "vipListItemCollectionViewCell.h"
#import "moreVipQYViewController.h"
#import "myHomeSetViewController.h"
@interface VipMainNewViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation VipMainNewViewController
{
    UIView *firstBack;
    UIView *secondBack;
    UIImageView *headImg;
    UILabel *nameLabel;
    UIImageView *vipImg;
    LXGradientProcessView *processView;
    BaseDomain *getData;
    NSMutableDictionary *userInfo;
    NSMutableArray *userGrade;
    NSMutableArray *userPrivilege;
    NSMutableArray *showArray;
    UICollectionView *collection;
    UIImageView *alphaBgview;
    UIView *alphaView;
    UIImageView *alphaImg;
    UILabel *alphaTitle;
    UILabel *alphaDetail;
    BaseDomain *postData;
    UIButton *closeButton;
    NSInteger isGift;
    UIView *pageFlog;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    userInfo = [NSMutableDictionary dictionary];
    userGrade = [NSMutableArray array];
    userPrivilege = [NSMutableArray array];
    showArray = [NSMutableArray array];
    [self settabTitle:@"会员俱乐部"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self getData];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)alphaView
{
    
    alphaBgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [alphaBgview setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
    [alphaBgview addGestureRecognizer:tap];
    [alphaBgview setImage:[UIImage imageNamed:@"BGALPHA"]];
    [self.view addSubview:alphaBgview];
    [alphaBgview setAlpha:0];
    
    
    alphaView = [UIView new];
    [self.view addSubview:alphaView];
    alphaView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .heightIs(170)
    .widthIs(300);
    [alphaView.layer setCornerRadius:2];
    [alphaView.layer setMasksToBounds:YES];
    [alphaView setBackgroundColor:[UIColor whiteColor]];
    
    
    alphaImg = [UIImageView new];
    [alphaView addSubview:alphaImg];
    alphaImg.sd_layout
    .leftSpaceToView(alphaView, 20)
    .topSpaceToView(alphaView, 25)
    .widthIs(25)
    .heightIs(25);
    
    alphaTitle = [UILabel new];
    [alphaView addSubview:alphaTitle];
    alphaTitle.sd_layout
    .leftSpaceToView(alphaImg, 8)
    .topSpaceToView(alphaView, 30)
    .heightIs(15)
    .widthIs(100);
    [alphaTitle setText:@"特权说明"];
    [alphaTitle setFont:[UIFont systemFontOfSize:15]];
    
    alphaDetail = [UILabel new];
    [alphaView addSubview:alphaDetail];
    alphaDetail.sd_layout
    .leftSpaceToView(alphaImg, 8)
    .topSpaceToView(alphaTitle, 3)
    .rightSpaceToView(alphaView, 22)
    .bottomSpaceToView(alphaView, 50);
    [alphaDetail setNumberOfLines:0];
    [alphaDetail setTextColor:getUIColor(Color_RuleDetail)];
    [alphaDetail setFont:[UIFont systemFontOfSize:14]];
    
    [alphaView setAlpha:0];
    
    
    UIView *line = [UIView new];
    [alphaView addSubview:line];
    line.sd_layout
    .leftEqualToView(alphaView)
    .topSpaceToView(alphaDetail, 0)
    .rightEqualToView(alphaView)
    .heightIs(1);
    [line setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
    
    closeButton = [UIButton new];
    [alphaView addSubview:closeButton];
    
    closeButton.sd_layout
    .leftEqualToView(alphaView)
    .topSpaceToView(alphaDetail, 1)
    .rightEqualToView(alphaView)
    .bottomEqualToView(alphaView);
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [closeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
}

-(void)closeClick
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [alphaView setAlpha:0];
    [alphaBgview setAlpha:0];
    [UIView commitAnimations];
    
    
    
    if (isGift == 2) {
        if ([[SelfPersonInfo getInstance].personAge isEqualToString:@"0"]) {
            myHomeSetViewController *set = [[myHomeSetViewController alloc] init];
            [self.navigationController pushViewController:set animated:YES];
        } else {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [postData postData:URL_GetBirthday PostParams:params finish:^(BaseDomain *domain, Boolean success) {
                
                if ([self checkHttpResponseResultStatus:domain]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"领取成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
            
        }
    } else if (isGift == 3) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [postData postData:URL_GetVipUp PostParams:params finish:^(BaseDomain *domain, Boolean success) {
            
            if ([self checkHttpResponseResultStatus:domain]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"领取成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }
  
    
    
}


-(void)closeTap
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [alphaView setAlpha:0];
    [alphaBgview setAlpha:0];
    [UIView commitAnimations];
}


-(void)getData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_VIPUSERPRIVILEGE PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            userInfo = [NSMutableDictionary dictionaryWithDictionary:[[domain.dataRoot objectForKey:@"data"] dictionaryForKey:@"user_info"]];
            for (NSDictionary *dic in [[domain.dataRoot objectForKey:@"data"] arrayForKey:@"user_grade"]) {
                NSMutableDictionary *dice = [NSMutableDictionary dictionaryWithDictionary:dic];
                [userGrade addObject:dice];
            }
            
            userPrivilege = [NSMutableArray arrayWithArray:[[domain.dataRoot objectForKey:@"data"] arrayForKey:@"user_privilege"]];
            
            
            
            
            
            for (int i = 0; i < [userGrade count]; i ++) {
                NSArray *idArray = [[[userGrade objectAtIndex:i] stringForKey:@"user_privilege_ids"] componentsSeparatedByString:@","];
                NSMutableArray *detailArray = [NSMutableArray array];
                for (int j = 0 ; j < [idArray count]; j ++) {
                    for (NSDictionary *dic in userPrivilege) {
                        if ([[idArray objectAtIndex:j] integerValue] == [[dic stringForKey:@"id"] integerValue]) {
                            [detailArray addObject:dic];
                        }
                    }
                }
                
                [[userGrade objectAtIndex:i] setObject:detailArray forKey:@"listOfDetail"];
                
                
            }
            
            
            showArray  = [NSMutableArray arrayWithArray:[[userGrade firstObject] arrayForKey:@"listOfDetail"]];
            
            [self createView];
            [self createSecondBack];
            [self alphaView];
        }
    }];
}

-(void)createView
{
    firstBack = [UIView new];
    [self.view addSubview:firstBack];
    [firstBack setBackgroundColor:[UIColor whiteColor]];
    firstBack.sd_layout
    .leftSpaceToView(self.view, 13)
    .rightSpaceToView(self.view, 13)
    .topSpaceToView(self.view, NavHeight + 48)
    .heightIs(176.0 / 667.0 * SCREEN_HEIGHT);
    firstBack.backgroundColor = [UIColor whiteColor];
    firstBack.layer.masksToBounds = NO;
    [[firstBack layer] setShadowOffset:CGSizeMake(0, 2)]; // 阴影的范围
    [[firstBack layer] setShadowRadius:4];                // 阴影扩散的范围控制
    [[firstBack layer] setShadowOpacity:0.5];               // 阴影透明度
    [[firstBack layer] setShadowColor:[UIColor lightGrayColor].CGColor];
    
    headImg = [UIImageView new];
    [firstBack addSubview:headImg];
    headImg.sd_layout
    .centerXEqualToView(firstBack)
    .topSpaceToView(firstBack, - 34)
    .heightIs(68)
    .widthIs(68);
    [headImg.layer setCornerRadius:34];
    [headImg.layer setMasksToBounds:YES];
    if ([[SelfPersonInfo getInstance].personImageUrl hasPrefix:@"http"]) {
        [headImg sd_setImageWithURL:[NSURL URLWithString:[SelfPersonInfo getInstance].personImageUrl ]];
    }
    else
    {
    [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [SelfPersonInfo getInstance].personImageUrl]]];
    }
    nameLabel = [UILabel new];
    [firstBack addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(firstBack.mas_centerX);
        make.top.equalTo(headImg.mas_bottom).with.offset(9);
        make.height.equalTo(@25);
    }];
    
    [nameLabel setFont:Font_20];
    [nameLabel setText:[SelfPersonInfo getInstance].cnPersonUserName];
    [nameLabel setTextColor:[UIColor blackColor]];

    vipImg = [UIImageView new];
    [firstBack addSubview:vipImg];
    [vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(nameLabel.mas_right);
        make.bottom.equalTo(nameLabel.mas_top);
        make.width.equalTo(@25);
        make.height.equalTo(@11);

    }];
    [vipImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[userInfo dictionaryForKey:@"user_grade"] stringForKey:@"img2"]]]];
    
    
    processView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(25,88, self.view.frame.size.width - 13 * 2 - 25 * 2, 4)];
    [firstBack addSubview:processView];
//    [processView setBackgroundColor:[UIColor lightGrayColor]];
    processView.percent = [[userInfo stringForKey:@"credit"] floatValue] / [[[userInfo objectForKey:@"user_grade"] stringForKey:@"max_credit"] floatValue] * 100;
    
    UILabel *vipCountright = [UILabel new];
    [firstBack addSubview:vipCountright];
    [vipCountright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(processView.mas_right);
        make.top.equalTo(processView.mas_bottom).with.offset(4);
        make.height.equalTo(@10);
    }];
    [vipCountright setText:[NSString stringWithFormat:@"/%.f", [[[userInfo objectForKey:@"user_grade"] stringForKey:@"max_credit"] floatValue]]];
    [vipCountright setFont:[UIFont systemFontOfSize:13]];
    [vipCountright setTextColor:[UIColor lightGrayColor]];
    
    UILabel *vipCountLeft = [UILabel new];
    [firstBack addSubview:vipCountLeft];
    [vipCountLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(vipCountright.mas_left);
        make.top.equalTo(processView.mas_bottom).with.offset(4);
        make.height.equalTo(@10);
    }];
    [vipCountLeft setText:[NSString stringWithFormat:@"%.f", [[userInfo stringForKey:@"credit"] floatValue]]];
    [vipCountLeft setFont:Font_12];
    [vipCountLeft setTextColor:[UIColor blackColor]];
    
    
    
    UIButton *MoreBtn = [UIButton new];
    [firstBack addSubview:MoreBtn];
    
    MoreBtn.sd_layout
    .bottomSpaceToView(firstBack, 20)
    .centerXEqualToView(firstBack)
    .heightIs(20)
    .widthIs(60);
    [MoreBtn setTitle:@"MORE >>" forState:UIControlStateNormal];
    [MoreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [MoreBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [MoreBtn addTarget:self action:@selector(MoreAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)createSecondBack
{
    secondBack = [UIView new];
    [self.view addSubview:secondBack];
    [secondBack setBackgroundColor:[UIColor whiteColor]];
    secondBack.sd_layout
    .leftSpaceToView(self.view, 13)
    .rightSpaceToView(self.view, 13)
    .topSpaceToView(firstBack, 10)
    .heightIs(287.0 / 667.0 * SCREEN_HEIGHT);
    secondBack.backgroundColor = [UIColor whiteColor];
    secondBack.layer.masksToBounds = NO;
    [[secondBack layer] setShadowOffset:CGSizeMake(0, 2)]; // 阴影的范围
    [[secondBack layer] setShadowRadius:4];                // 阴影扩散的范围控制
    [[secondBack layer] setShadowOpacity:0.5];               // 阴影透明度
    [[secondBack layer] setShadowColor:[UIColor lightGrayColor].CGColor];
    
//    UILabel *titleName = [UILabel new];
//    [secondBack addSubview:titleName];
//    
//    titleName.sd_layout
//    .leftSpaceToView(secondBack, 25)
//    .topSpaceToView(secondBack, 25)
//    .heightIs(20)
//    .rightSpaceToView(secondBack, 25);
//    [titleName setText:[NSString stringWithFormat:@"当前所享受权益（%@）",[[userInfo dictionaryForKey:@"user_grade"] stringForKey:@"name"]]];
//    [titleName setFont:Font_16];
    
    for (int i = 0; i < [userGrade count]; i ++) {
        UIButton *buttonGrade = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 26)/[userGrade count] * i, 21, (SCREEN_WIDTH - 26) / [userGrade count], 30)];
        buttonGrade.tag = i + 5;
        [buttonGrade setTitle:[NSString stringWithFormat:@"%@权益",[[userGrade objectAtIndex:i] stringForKey:@"name"] ]forState:UIControlStateNormal];
        
        [buttonGrade.titleLabel setFont:Font_14];
//        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(buttonGrade.frame.size.width / 2 - 7.5, 13, 25, 11)];
//        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,[[userGrade objectAtIndex:i] stringForKey:@"img"]]] ];
//        [buttonGrade addSubview:image];
        [buttonGrade addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventTouchUpInside];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, buttonGrade.frame.size.width, 20)];
//        [label setText:[[userGrade objectAtIndex:i] stringForKey:@"name"]];
//        [label setFont:[UIFont systemFontOfSize:12]];
//        [label setTag:100+i];
        if (i == 0) {
            [buttonGrade setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            [buttonGrade setTitleColor:getUIColor(Color_loginNoUserName) forState:UIControlStateNormal];
            
            
        }
//        [label setTextAlignment:NSTextAlignmentCenter];
//        [buttonGrade addSubview:label];
        [secondBack addSubview:buttonGrade];
    }
    
    pageFlog = [[UIView alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH - 26) / [userGrade count] / 2 )- 25, 51, 50, 2)];
    [pageFlog setBackgroundColor:[UIColor blackColor]];
    [secondBack addSubview:pageFlog];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:0];
    collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [secondBack addSubview:collection];
    collection.sd_layout
    .leftEqualToView(secondBack)
    .topSpaceToView(secondBack, 60)
    .rightEqualToView(secondBack)
    .bottomEqualToView(secondBack);
    
    
    
    collection.delegate = self;
    collection.dataSource = self;
    collection.showsHorizontalScrollIndicator = NO;
    [collection setBackgroundColor:[UIColor whiteColor]];
    [collection registerClass:[vipListItemCollectionViewCell class] forCellWithReuseIdentifier:@"vipItem"];
    [collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
    
    
//    UIButton *buttonMore = [UIButton new];
//    [self.view addSubview:buttonMore];
//    buttonMore.sd_layout
//    .centerXEqualToView(self.view)
//    .topSpaceToView(secondBack, 25)
//    .heightIs(15)
//    .widthIs(200);
//    [buttonMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [buttonMore setTitle:@"查看更多权益 >>" forState:UIControlStateNormal];
//    [buttonMore.titleLabel setFont:[UIFont systemFontOfSize:10]];
//    [buttonMore addTarget:self action:@selector(QYClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)pageClick:(UIButton *)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [pageFlog setFrame:CGRectMake(((SCREEN_WIDTH - 26) / [userGrade count] / 2 )- 25 + ((SCREEN_WIDTH - 26) / [userGrade count] * (sender.tag - 5)), 51, 50, 2)];
    [UIView commitAnimations];
    for (int i = 0 ; i < [userGrade count]; i ++) {
        UIButton *btn = [self.view viewWithTag:i + 5];
        
        if (i == sender.tag - 5) {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:getUIColor(Color_loginNoUserName) forState:UIControlStateNormal];
            
            
        }
    }
    
    showArray  = [NSMutableArray arrayWithArray:[[userGrade objectAtIndex:sender.tag - 5] arrayForKey:@"listOfDetail"]];
    [collection reloadData];
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [showArray count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"vipItem";
    vipListItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[showArray objectAtIndex:indexPath.item] stringForKey:@"img"]]]];
    cell.text.text = [[showArray objectAtIndex:indexPath.item] stringForKey:@"name"];

    
    [cell sizeToFit];
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((SCREEN_WIDTH - 26) / 3, (287.0 / 667.0 * SCREEN_HEIGHT - 60) / 2);
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [alphaView setAlpha:1];
    [alphaBgview setAlpha:1];
    [UIView commitAnimations];
    WCLLog(@"%@",[[userPrivilege objectAtIndex:indexPath.item] stringForKey:@"desc"]);
    CGFloat height =  [self calculateTextHeight:[UIFont systemFontOfSize:14] givenText:[[userPrivilege objectAtIndex:indexPath.item] stringForKey:@"desc"] givenWidth:270];
    [alphaView setSize:CGSizeMake(300, 120 + height)];
    
    
    
    [alphaImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [userPrivilege[indexPath.item] stringForKey:@"img"]]]];
    
    
    isGift = [[userPrivilege[indexPath.item] stringForKey:@"is_get"] integerValue];
    
    if (isGift == 2) {
        
        if ([[SelfPersonInfo getInstance].personAge isEqualToString:@"0"]) {
            CGFloat height =  [self calculateTextHeight:[UIFont systemFontOfSize:14] givenText:@"· 完善生日资料后，过生日时可获得惊喜生日礼包一份\n· 礼包领取有效期：生日前三天及后四天" givenWidth:270];
            [alphaView setSize:CGSizeMake(300, 120 + height)];
            [closeButton setTitle:@"去设置" forState:UIControlStateNormal];
            
            [alphaDetail setText:@"· 完善生日资料后，过生日时可获得惊喜生日礼包一份\n· 礼包领取有效期：生日前三天及后四天"];
        } else {
            [closeButton setTitle:@"领取" forState:UIControlStateNormal];
            [alphaDetail setText:[userPrivilege[indexPath.item] stringForKey:@"desc"]];
        }
        
    } else if (isGift == 3) {
        [closeButton setTitle:@"领取" forState:UIControlStateNormal];
        [alphaDetail setText:[userPrivilege[indexPath.item] stringForKey:@"desc"]];
    } else {
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [alphaDetail setText:[userPrivilege[indexPath.item] stringForKey:@"desc"]];
    }
    
    
}


-(void)MoreAction
{
    VipDetailViewController *vipDetail = [[VipDetailViewController alloc] init];
    vipDetail.vipCount = [userInfo stringForKey:@"credit"];
    [self.navigationController pushViewController:vipDetail animated:YES];
}

//-(void)QYClick
//{
//    moreVipQYViewController *moreV = [[moreVipQYViewController alloc] init];
//    [self.navigationController pushViewController:moreV animated:YES];
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
