//
//  homeNewViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/4/20.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//
#import "sys/utsname.h"
#import "putInUserInfoViewController.h"
#import "homeNewViewController.h"
#import "YYCycleScrollView.h"
#import "MainTabViewCellForBanerDownCell.h"

#import "MyHomeListTableViewCell.h"
#import "MineListNotForCollectionCell.h"
#import "UserFeedBackViewController.h"

#import "myClothesBagViewController.h"
#import "mySaveViewController.h"
#import "CustomMainViewController.h"

#import "joinDesignerViewController.h"

#import "myHomeSetViewController.h"
#import "SuggestViewController.h"
#import "perentOrderViewController.h"


#import "clothesForSaveViewController.h"
#import "YuYueViewController.h"
#import "couPonParentViewController.h"
#import "VipMainViewController.h"
#import "VipMainNewViewController.h"
#import "MCMainViewController.h"
#import "saleCardViewController.h"
#import "inviteNewViewController.h"
#import "NewPototUserInfoViewController.h"
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
static CGFloat const headViewHeight = 240;



@interface homeNewViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, MyHomeListTableViewCellDelegate>
@property (nonatomic, retain) UITableView *mainTabTable;  //首页的table
@property (nonatomic, retain) NSMutableArray *ListArray;  //list content array
@property(nonatomic,strong)UIImageView *headImageView;//头部图片
@property(nonatomic,strong)UIButton * avatarImage;
@property(nonatomic,strong)UILabel *countentLabel;
@property (nonatomic, retain) UIView *alpha;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, retain) UIButton *vipLevel;
@property (nonatomic, retain) UIImageView *vipIm;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) NSString *countMessage;
@property (nonatomic, retain) NSDictionary *userGade;

@end

@implementation QYAppKeyConfig
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_appKey
                  forKey:@"appkey"];
    [aCoder encodeObject:@(_useDevEnvironment)
                  forKey:@"dev"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _appKey             = [aDecoder decodeObjectForKey:@"appkey"];
        _useDevEnvironment  = [[aDecoder decodeObjectForKey:@"dev"] boolValue];
    }
    return self;
}
@end

@implementation homeNewViewController
{
    BaseDomain *getData;
    
    UIImageView *imageHead;
    
    UIButton *rightButton;
    
    UIImageView *imageBack;
    
    UIButton *labelName;
    
    UILabel *vipLabel;
    
    NSMutableArray *titleArray;
    
    NSMutableArray *imageArray;
    
    UICollectionView *collect;
    
    NSDate *datBegin;
    
    NSArray *iconArray;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self settabTitle:@""];
    
    
    [self.rdv_tabBarController.navigationController setNavigationBarHidden:YES animated:animated];
    
    UIButton *buttonRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [buttonRight setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [buttonRight setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
   
    
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    
    [imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [SelfPersonInfo getInstance].personImageUrl]]];
    _countentLabel.text = [SelfPersonInfo getInstance].cnPersonUserName;
    
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
    
    [self reloadCound];
    
    if ([self userHaveLogin]) {
        [self createDataGet];
        
    } else {
        
        [self createUserHaventLogin];
    }
    
    
    
}

-(void)reloadCound{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_GetUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if (domain.result == 10001) {
            
        } else {
            
            _userGade = [NSDictionary dictionaryWithDictionary:[[domain.dataRoot objectForKey:@"data"] dictionaryForKey:@"user_grade"]];
            
            [_vipLevel setTitle:[_userGade stringForKey:@"name"] forState:UIControlStateNormal];
            [_vipIm sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_userGade stringForKey:@"img"]]]];
            
            [labelName setTitle:[SelfPersonInfo getInstance].cnPersonUserName forState:UIControlStateNormal];
            if (_countLabel) {
                [_countLabel setText:[[domain.dataRoot dictionaryForKey:@"data"] stringForKey:@"unread_message_num"]];
            } else {
                
                _countMessage = [[domain.dataRoot dictionaryForKey:@"data"] stringForKey:@"unread_message_num"];
            }
            
            if ([[domain.dataRoot dictionaryForKey:@"data"] integerForKey:@"unread_message_num"] == 0) {
                [_countLabel setHidden:YES];
            } else {
                [_countLabel setHidden:NO];
            }
        }
        
        
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.rdv_tabBarController.navigationController setNavigationBarHidden:NO animated:animated];
}


-(void)worningClick
{
    MCMainViewController *mcMain = [[MCMainViewController alloc] init];
    [self.navigationController pushViewController:mcMain animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    getData = [BaseDomain getInstance:NO];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exitLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitNotiFication) name:@"exitLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LookClothes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTab) name:@"LookClothes" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LookZixun" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLogin) name:@"LookZixun" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMy) name:@"loginSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"roadCound" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCound) name:@"roadCound" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLogin) name:@"cancelLogin" object:nil];
    
    
    
    
    _ListArray = [NSMutableArray arrayWithObjects: @"设置", nil];
    
    
}

-(void)reloadMy
{
    [self createDataGet];
}

-(void)changeTab
{
    [self.rdv_tabBarController setSelectedIndex:1];
}



-(void)cancelLogin
{
    [self.rdv_tabBarController setSelectedIndex:0];
}

-(void)exitNotiFication   //退出登录
{
    iconArray = nil;
    [[userInfoModel getInstance] exitLogin];
    [imageBack removeFromSuperview];
    imageBack = nil;
    _headImageView = nil;
    [rightButton removeFromSuperview];
    [_mainTabTable removeFromSuperview];
    _mainTabTable = nil;
    [collect removeFromSuperview];
    collect = nil;
//    [self createUserHaventLogin];
    [self cancelLogin];
    
}

//登录完成之前

-(void)createUserHaventLogin
{
//    UIImageView *imagebg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [imagebg setImage:[UIImage imageNamed:@"haventLoginImage"]];
//    [self.view addSubview:imagebg];
//    
//    
//    
//    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:rightView];
//    rightView.sd_layout
//    .topSpaceToView(self.view, 35)
//    .rightSpaceToView(self.view,20);
//    UIImage *pic = [UIImage imageNamed:@"loginRight"];
//    CGFloat scan = pic.size.width / pic.size.height;
//    CGFloat scanScreen = 99 / 125;
//    
//    if (scan > scanScreen) {
//        rightView.sd_layout
//        .widthIs(99)
//        .heightIs(99 / pic.size.width * pic.size.height);
//        
//    } else {
//        rightView.sd_layout
//        .heightIs(125)
//        .widthIs(125 / pic.size.height * pic.size.width);
//    }
//    [rightView setImage:[UIImage imageNamed:@"loginRight"]];
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:button];
//    button.sd_layout
//    .heightIs(92)
//    .widthIs(92)
//    .centerXEqualToView(self.view)
//    .bottomSpaceToView(self.view, 100);
//    [button setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
//    
//    [button addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self loginClick];
    
    
}


// login button click
-(void) loginClick
{
    
    [self getDateBeginHaveReturn:datBegin fatherView:@"我的"];
}


// 登录完成之后

#pragma -mark tableView create To show the baner and anyother thing like today TUIJIAN
-(void)createDataGet
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [getData getData:URL_GetUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        
        if (domain.result == 10001) {
            [self createUserHaventLogin];
        } else {
            
            
            if (!iconArray) {
                _userGade = [NSDictionary dictionaryWithDictionary:[[domain.dataRoot objectForKey:@"data"] dictionaryForKey:@"user_grade"]];
                iconArray = [NSArray arrayWithArray:[domain.dataRoot arrayForKey:@"icon_list"]];
                [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:getData.dataRoot];
                if (_mainTabTable) {
                    [_mainTabTable reloadData];
                    
                } else {
                    [self createTableView];
                }
            }
            
            
            
        }
        
        
    }];
    
}


-(void)createTableView
{
    
    imageBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageBack setImage:[UIImage imageNamed:@"mineBackImage"]];
    [self.view addSubview:imageBack];
    
    [imageBack setUserInteractionEnabled:YES];
    UIButton *setBtn = [UIButton new];
    [imageBack addSubview:setBtn];
    setBtn.sd_layout
    .leftSpaceToView(imageBack, 12)
    .topSpaceToView(imageBack, 27)
    .widthIs(20)
    .heightIs(20);
    [setBtn setImage:[UIImage imageNamed:@"leftSet"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(leftSetClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    imageHead = [UIImageView new];
    [imageBack addSubview:imageHead];
    imageHead.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(imageBack, 67)
    .heightIs(75)
    .widthIs(75);
    
    
    imageHead.layer.masksToBounds = YES;
    
    imageHead.layer.cornerRadius = 37.5;

    [imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [SelfPersonInfo getInstance].personImageUrl]]];
    
    
    labelName = [UIButton new];
    [imageBack addSubview:labelName];
//    labelName.sd_layout
//    .leftSpaceToView(imageBack,  100)
//    .rightSpaceToView(imageBack, 100)
//    .topSpaceToView(imageHead, 15)
//    .heightIs(15);
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageBack.mas_centerX);
        make.top.equalTo(imageBack.mas_top).with.offset(67 + 75 + 15);
        make.height.equalTo(@15);
        make.width.greaterThanOrEqualTo(@40);
    }];
    
    [labelName.titleLabel setFont:Font_20];
    [labelName setTitle:[SelfPersonInfo getInstance].cnPersonUserName forState:UIControlStateNormal];
    [labelName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [labelName addTarget:self action:@selector(vipClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _vipIm = [UIImageView new];
    [self.view addSubview:_vipIm];
    [_vipIm mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(labelName.mas_right);
        make.bottom.equalTo(labelName.mas_top);
        make.width.equalTo(@25);
        make.height.equalTo(@11);
        
    }];
//    _vipIm.sd_layout
//    .leftSpaceToView(imageHead,-20)
//    .bottomSpaceToView(labelName, 0)
//    .heightIs(15)
//    .widthIs(15);
    [_vipIm sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_userGade stringForKey:@"img"]]]];
    
    
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 12 - 20, 27, 20, 20)];
    [rightButton setImage:[UIImage imageNamed:@"worning"] forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    [rightButton addTarget:self action:@selector(worningClick) forControlEvents:UIControlEventTouchUpInside];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 3 - 20, 24, 15, 15)];
    [_countLabel setBackgroundColor:[UIColor redColor]];
    [_countLabel setFont:[UIFont systemFontOfSize:12]];
    [_countLabel.layer setCornerRadius:7.5];
    [_countLabel setTextAlignment:NSTextAlignmentCenter];
    [_countLabel setText:_countMessage];
    [_countLabel.layer setMasksToBounds:YES];
    [_countLabel setTextColor:[UIColor whiteColor]];
    [_countLabel setHidden:YES];
    [self.view addSubview:_countLabel];

    
    
    titleArray = [NSMutableArray arrayWithArray:[iconArray valueForKey:@"name"]];
    imageArray = [NSMutableArray arrayWithArray:[iconArray valueForKey:@"img"]];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumLineSpacing = 0;
    //        flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 0);//头部
    collect = [[UICollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - (SCREEN_WIDTH * 350 / 375) / 2, 194, (SCREEN_WIDTH * 350 / 375), SCREEN_HEIGHT * 328 / 667) collectionViewLayout:flowLayout];
    
    //设置代理
    collect.delegate = self;
    collect.dataSource = self;
    [self.view addSubview:collect];
    
    collect.backgroundColor = [UIColor whiteColor];
    collect.layer.masksToBounds = NO;
    [[collect layer] setShadowOffset:CGSizeMake(0, 3)]; // 阴影的范围
    [[collect layer] setShadowRadius:3];                // 阴影扩散的范围控制
    [[collect layer] setShadowOpacity:0.5];               // 阴影透明度
    [[collect layer] setShadowColor:[UIColor grayColor].CGColor];
    //注册cell和ReusableView（相当于头部）
    [collect registerClass:[MianTabFourCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    [collect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    
    
    
}

-(void)vipClick
{
    VipMainNewViewController *vip = [[VipMainNewViewController alloc] init];
    [self.navigationController pushViewController:vip animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [titleArray count];
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
    MianTabFourCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    if (indexPath.item < 3) {
        [cell.topView setHidden:YES];
    } else {
        [cell.topView setHidden:NO];
    }
    
    if (indexPath.item == 0 || indexPath.item % 3 == 0) {
        [cell.leftView setHidden:YES];
    } else {
        [cell.leftView setHidden:NO];
    }
    
    if (indexPath.item == 8) {
        [cell.YJXImage setHidden:NO];
    } else {
        [cell.YJXImage setHidden:YES];
        
    }
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL,[imageArray objectAtIndex:indexPath.item]]]];;
    cell.text.text = [titleArray objectAtIndex:indexPath.item];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((SCREEN_WIDTH * 350 / 375) / 3, SCREEN_HEIGHT * 328 / 667 / 3);
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
    switch (indexPath.item) {
        case 0:
        {
            perentOrderViewController *myOrder = [[perentOrderViewController alloc] init];
            [self.navigationController pushViewController:myOrder animated:YES];
        }
            break;
        case 1:
        {
            myClothesBagViewController *myBag = [[myClothesBagViewController alloc] init];
            [self.navigationController pushViewController:myBag animated:YES];
        }
            break;
        case 2:
        {
            couPonParentViewController *couPon = [[couPonParentViewController alloc] init];
            [self.navigationController pushViewController:couPon animated:YES];
        }
            break;
        case 3:
        {
            mySaveViewController *mySave = [[mySaveViewController alloc] init];
            [self.navigationController pushViewController:mySave animated:YES];
            
            
        }
            break;
        case 4:
        {
            
            YuYueViewController *yuyue = [[YuYueViewController alloc] init];
            [self.navigationController pushViewController:yuyue animated:YES];
            
            
            
        }
            break;
        case 5:
        {
            
//            CustomMainViewController *custom = [[CustomMainViewController alloc] init];
//            [self.navigationController pushViewController:custom animated:YES];

            saleCardViewController* sale = [[saleCardViewController alloc] init];
            [self.navigationController pushViewController:sale animated:YES];
            
        }
            break;
        case 6:
        {
//            joinDesignerViewController *joinD = [[joinDesignerViewController alloc] init];
//            [self.navigationController pushViewController:joinD animated:YES];
            
            if ([[[self deviceVersion] substringWithRange:NSMakeRange(0,1)] integerValue] > 5 ) {
                NewPototUserInfoViewController *put = [[NewPototUserInfoViewController alloc] init];
                [self.navigationController pushViewController:put animated:YES];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的机型暂时不支持该拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }
            break;
            
        case 7:
        {
            QYSource *source = [[QYSource alloc] init];
            source.title =  @"17012348908";
            source.urlString = @"17012348908";
            QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];

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
//            [self alertViewShowOfTime:@"客服不在线哦,请拨打电话:4009901213" time:1];
            
            //
        }
            break;
            
        case 8:
        {
            inviteNewViewController *invite = [[inviteNewViewController alloc] init];
            [self.navigationController pushViewController:invite animated:YES];
        }
            break;
        default:
            break;
    }
}

- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"6P";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"6SP";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"7P";
    return deviceString;
}

-(void)leftSetClickAction
{
    myHomeSetViewController *mySet = [[myHomeSetViewController alloc] init];
    [self.navigationController pushViewController:mySet animated:YES];
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
