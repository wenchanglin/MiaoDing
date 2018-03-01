//
//  VipMainViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/15.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "VipMainViewController.h"
#import "LXGradientProcessView.h"
#import "VipDetailViewController.h"
#import "vipRuleViewController.h"
#import "vipQuanYiCollectionViewCell.h"
#import "vipListItemCollectionViewCell.h"
#import "myHomeSetViewController.h"
@interface VipMainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate,vipQuanYiCollectionViewCellDelegate>
@property (nonatomic, strong) LXGradientProcessView *processView;

@end

@implementation VipMainViewController
{
    BaseDomain *getData;
    BaseDomain *postData;
    NSMutableDictionary *userInfo;
    NSMutableArray *userGrade;
    NSMutableArray *userPrivilege;
    UIView *pageFlog;
    UICollectionView *ruleCollection;
    UIView *alphaView;
    UIImageView *alphaImg;
    UILabel *alphaTitle;
    UILabel *alphaDetail;
    UIImageView *alphaBgview;
    UIButton *closeButton;
    NSInteger isGift;
    NSMutableArray *showArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    showArray = [NSMutableArray array];
    userGrade = [NSMutableArray array];
    
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [buttonRight setImage:[UIImage imageNamed:@"RuleImg"] forState:UIControlStateNormal];
    [buttonRight addTarget:self action:@selector(ruleClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
    
    
    self.title = @"会员俱乐部";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)ruleClick
{
    vipRuleViewController *vipRule = [[vipRuleViewController alloc] init];
    [self.navigationController pushViewController:vipRule animated:YES];
}

-(void)getData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData postData:URL_VIPUSERPRIVILEGE PostParams:params finish:^(BaseDomain *domain, Boolean success) {
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
            [self createHeadView];
            [self createPageController];
            [self alphaView];
            
        }
    }];
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
    
//    if (isGift != 1) {
//        
//        
//        switch (isGift) {
//            case 2:
//                url_Type = URL_GetBirthday;
//                break;
//            case 3:
//                url_Type = URL_GetVipUp;
//                break;
//            default:
//                break;
//        }
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        [postData postData:url_Type PostParams:params finish:^(BaseDomain *domain, Boolean success) {
//            
//            if ([self checkHttpResponseResultStatus:domain]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"领取成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }];
//    }
    
    
    
}


-(void)closeTap
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [alphaView setAlpha:0];
    [alphaBgview setAlpha:0];
    [UIView commitAnimations];
}

-(void)createHeadView
{
    UIView *BGVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    [BGVIew setBackgroundColor:getUIColor(Color_Share)];
    [self.view addSubview:BGVIew];
    
    UIImageView *BGIMG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 166)];
    [BGIMG setImage:[UIImage imageNamed:@"vipHeadBg"]];
    [BGIMG setContentMode:UIViewContentModeScaleAspectFill];
    [BGIMG.layer setMasksToBounds:YES];
    [BGVIew addSubview:BGIMG];
    [BGIMG setUserInteractionEnabled:YES];
    UIImageView *imageHead = [UIImageView new];
    [BGIMG addSubview:imageHead];
    imageHead.sd_layout
    .leftSpaceToView(BGIMG,25)
    .centerYEqualToView(BGIMG)
    .widthIs(80)
    .heightIs(80);
    [imageHead.layer setCornerRadius:40];
    [imageHead.layer setMasksToBounds:YES];
    [imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [SelfPersonInfo getInstance].personImageUrl]]];
    
    _processView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(120, BGIMG.frame.size.height / 2 - 1.5, SCREEN_WIDTH - 170, 3)];
    [BGIMG addSubview:_processView];
    
    self.processView.percent = [[userInfo stringForKey:@"credit"] floatValue] / [[[userInfo objectForKey:@"user_grade"] stringForKey:@"max_credit"] floatValue] * 100;
    
//    self.processView.percent = 88;
    
    UILabel *nameLabel = [UILabel new];
    [BGIMG addSubview:nameLabel];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    nameLabel.sd_layout
    .leftSpaceToView(imageHead, 20)
    .bottomSpaceToView(_processView,3)
    .widthIs(80)
    .heightIs(20);
    [nameLabel setText:[SelfPersonInfo getInstance].cnPersonUserName];
    
    
    UIImageView *vipImg = [UIImageView new];
    [BGIMG addSubview:vipImg];
    vipImg.sd_layout
    .leftSpaceToView(nameLabel, 5)
    .bottomSpaceToView(_processView,8)
    .widthIs(25)
    .heightIs(11);
    [vipImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[userInfo objectForKey:@"user_grade"] stringForKey:@"img2"]]]];
    UILabel *vipName = [UILabel new];
    [BGIMG addSubview:vipName];
    vipName.sd_layout
    .leftSpaceToView(vipImg, 3)
    .bottomSpaceToView(_processView,3)
    .widthIs(100)
    .heightIs(20);
    [vipName setFont:[UIFont systemFontOfSize:12]];
    [vipName setTextColor:[UIColor whiteColor]];
    [vipName setText:[[userInfo objectForKey:@"user_grade"] stringForKey:@"name"]];
    
    
    UILabel *grow = [UILabel new];
    [BGIMG addSubview:grow];
    grow.sd_layout
    .leftSpaceToView(imageHead, 20)
    .topSpaceToView(_processView,3)
    .heightIs(20)
    .widthIs(50);
    [grow setTextColor:[UIColor whiteColor]];
    [grow setFont:[UIFont systemFontOfSize:12]];
    [grow setText:@"成长值"];
    
    UILabel *vipCountLeft = [UILabel new];
    [BGIMG addSubview:vipCountLeft];
    [vipCountLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grow.mas_right);
        make.top.equalTo(grow.mas_top);
        make.bottom.equalTo(grow.mas_bottom);
    }];
    [vipCountLeft setText:[NSString stringWithFormat:@"%.f", [[userInfo stringForKey:@"credit"] floatValue]]];
    [vipCountLeft setFont:[UIFont systemFontOfSize:12]];
    [vipCountLeft setTextColor:getUIColor(COLOR_VipLeft)];
    
    UILabel *vipCountright = [UILabel new];
    [BGIMG addSubview:vipCountright];
    [vipCountright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vipCountLeft.mas_right);
        make.top.equalTo(grow.mas_top);
        make.bottom.equalTo(grow.mas_bottom);
    }];
    [vipCountright setText:[NSString stringWithFormat:@"/%.f", [[[userInfo objectForKey:@"user_grade"] stringForKey:@"max_credit"] floatValue]]];
    [vipCountright setFont:[UIFont systemFontOfSize:12]];
    [vipCountright setTextColor:[UIColor whiteColor]];
    
    
    UIButton *buttonLookIn = [UIButton new];
    [BGIMG addSubview:buttonLookIn];
    buttonLookIn.sd_layout
    .rightEqualToView(_processView)
    .topSpaceToView(_processView,3)
    .heightIs(20)
    .widthIs(40);
    [buttonLookIn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [buttonLookIn setTitle:@"查看 >" forState:UIControlStateNormal];
    [buttonLookIn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [buttonLookIn addTarget:self action:@selector(enterIn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *VipQY = [UILabel new];
    [BGVIew addSubview:VipQY];
    VipQY.sd_layout
    .leftSpaceToView(BGVIew, 20)
    .topSpaceToView(BGIMG, 0)
    .bottomEqualToView(BGVIew)
    .rightEqualToView(BGVIew);
    [VipQY setText:@"会员权益"];
    [VipQY setFont:[UIFont systemFontOfSize:15]];
    
}

-(void)createPageController
{
    for (int i = 0; i < [userGrade count]; i ++) {
        UIButton *buttonGrade = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/[userGrade count] * i, 270, SCREEN_WIDTH / [userGrade count], 60)];
        buttonGrade.tag = i + 5;
       
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(buttonGrade.frame.size.width / 2 - 7.5, 13, 25, 11)];
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,[[userGrade objectAtIndex:i] stringForKey:@"img"]]] ];
        [buttonGrade addSubview:image];
        [buttonGrade addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, buttonGrade.frame.size.width, 20)];
        [label setText:[[userGrade objectAtIndex:i] stringForKey:@"name"]];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTag:100+i];
        if (i == 0) {
            [label setTextColor:[UIColor blackColor]];
        } else {
            [label setTextColor:getUIColor(Color_loginNoUserName)];

        }
        [label setTextAlignment:NSTextAlignmentCenter];
        [buttonGrade addSubview:label];
        [self.view addSubview:buttonGrade];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,330, SCREEN_WIDTH, 1)];
    [lineView setBackgroundColor:getUIColor(Color_myTabIconLineColor)];
    [self.view addSubview:lineView];
    
    pageFlog = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / [userGrade count] / 2 )- 30, 330, 60, 1)];
    [pageFlog setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:pageFlog];
    
    
    UICollectionViewFlowLayout *flowLayout1=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout1.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    ruleCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 331, SCREEN_WIDTH, SCREEN_HEIGHT-331) collectionViewLayout:flowLayout1];
    
    ruleCollection.showsHorizontalScrollIndicator = NO;
    //设置代理
    ruleCollection.delegate = self;
    ruleCollection.dataSource = self;
    [ruleCollection setBackgroundColor:[UIColor whiteColor]];
//    ruleCollection.pagingEnabled = YES ;
    
    [self.view addSubview:ruleCollection];
    
    //注册cell和ReusableView（相当于头部）
    
    [ruleCollection registerClass:[vipListItemCollectionViewCell class] forCellWithReuseIdentifier:@"vipRuleCollection"];
    [ruleCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
   
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
    

    static NSString *identify = @"vipRuleCollection";
    vipListItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [[showArray objectAtIndex:indexPath.item] stringForKey:@"img"]]]];
    cell.text.text = [[showArray objectAtIndex:indexPath.item] stringForKey:@"name"];
    
    return cell;

}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [alphaView setAlpha:1];
    [alphaBgview setAlpha:1];
    [UIView commitAnimations];
    
    CGFloat height =  [self calculateTextHeight:[UIFont systemFontOfSize:14] givenText:[[showArray objectAtIndex:indexPath.item] stringForKey:@"desc"] givenWidth:270];
    [alphaView setSize:CGSizeMake(300, 120 + height)];
    
    
    
    [alphaImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [showArray[indexPath.item] stringForKey:@"img"]]]];

    
    isGift = [[showArray[indexPath.item] stringForKey:@"is_get"] integerValue];
    
    if (isGift == 2) {
        
        if ([[SelfPersonInfo getInstance].personAge isEqualToString:@"0"]) {
            CGFloat height =  [self calculateTextHeight:[UIFont systemFontOfSize:14] givenText:@"· 完善生日资料后，过生日时可获得惊喜生日礼包一份\n· 礼包领取有效期：生日前三天及后四天" givenWidth:270];
            [alphaView setSize:CGSizeMake(300, 120 + height)];
            [closeButton setTitle:@"去设置" forState:UIControlStateNormal];
            
            [alphaDetail setText:@"· 完善生日资料后，过生日时可获得惊喜生日礼包一份\n· 礼包领取有效期：生日前三天及后四天"];
        } else {
             [closeButton setTitle:@"领取" forState:UIControlStateNormal];
            [alphaDetail setText:[showArray[indexPath.item] stringForKey:@"desc"]];
        }
        
    } else if (isGift == 3) {
        [closeButton setTitle:@"领取" forState:UIControlStateNormal];
        [alphaDetail setText:[showArray[indexPath.item] stringForKey:@"desc"]];
    } else {
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [alphaDetail setText:[showArray[indexPath.item] stringForKey:@"desc"]];
    }
    
    
}




#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    
    return CGSizeMake(SCREEN_WIDTH/ 4, 100);
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




-(void)pageClick:(UIButton *)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [pageFlog setFrame:CGRectMake((SCREEN_WIDTH / [userGrade count] / 2 )- 30 + (SCREEN_WIDTH / [userGrade count] * (sender.tag - 5)), 330, 60, 1)];
    [UIView commitAnimations];
    for (int i = 0 ; i < [userGrade count]; i ++) {
        UILabel *label = [self.view viewWithTag:i + 100];

        if (i == sender.tag - 5) {
            [label setTextColor:[UIColor blackColor]];
        } else {
            [label setTextColor:getUIColor(Color_loginNoUserName)];
        }
    }

     showArray  = [NSMutableArray arrayWithArray:[[userGrade objectAtIndex:sender.tag - 5] arrayForKey:@"listOfDetail"]];
    [ruleCollection reloadData];
    
}



-(void)enterIn
{
    VipDetailViewController *vipDetail = [[VipDetailViewController alloc] init];
    vipDetail.vipCount = [userInfo stringForKey:@"credit"];
    [self.navigationController pushViewController:vipDetail animated:YES];
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
