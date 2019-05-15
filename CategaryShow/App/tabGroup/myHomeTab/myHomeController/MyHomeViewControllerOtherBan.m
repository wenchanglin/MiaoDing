//
//  MyHomeViewControllerOtherBan.m
//  CategaryShow
//
//  Created by APPLE on 16/8/25.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "MyHomeViewControllerOtherBan.h"
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
#import "MCMainViewController.h"
//导入头文件

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
static CGFloat const headViewHeight = 240;



@interface MyHomeViewControllerOtherBan ()<UITableViewDataSource, UITableViewDelegate, MyHomeListTableViewCellDelegate>
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

@implementation QYAppKey
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


@implementation MyHomeViewControllerOtherBan
{
    BaseDomain *getData;
    
    UIImageView *imageHead;
    
    UIButton *rightButton;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self settabTitle:@""];
    
    
    [self.rdv_tabBarController.navigationController setNavigationBarHidden:YES animated:animated];

     [imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [SelfPersonInfo getInstance].avatar]]];
    _countentLabel.text = [SelfPersonInfo getInstance].username;
    [self reloadCound];
    
}

-(void)reloadCound{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    [getData getData:URL_GetUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            _userGade = [NSDictionary dictionaryWithDictionary:[[domain.dataRoot objectForKey:@"data"] dictionaryForKey:@"user_grade"]];
            
            [_vipLevel setTitle:[_userGade stringForKey:@"name"] forState:UIControlStateNormal];
            [_vipIm sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_userGade stringForKey:@"img2"]]]];
            
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
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitNotiFication) name:@"exitLogin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTab) name:@"LookClothes" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMy) name:@"loginSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCound) name:@"roadCound" object:nil];
    
    if ([self userHaveLogin]) {
        [self createDataGet];
        
    } else {
        
        [self createUserHaventLogin];
    }

   

    
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

-(void)exitNotiFication   //退出登录
{
    
    [[userInfoModel getInstance] exitLogin];
    _headImageView = nil;
    [rightButton removeFromSuperview];
    [_mainTabTable removeFromSuperview];
    _mainTabTable = nil;
    [self createUserHaventLogin];
}

//登录完成之前

-(void)createUserHaventLogin
{
    UIImageView *imagebg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imagebg setImage:[UIImage imageNamed:@"haventLoginImage"]];
    [self.view addSubview:imagebg];
    
    
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:rightView];
    rightView.sd_layout
    .topSpaceToView(self.view, 35)
    .rightSpaceToView(self.view,20);
    UIImage *pic = [UIImage imageNamed:@"loginRight"];
    CGFloat scan = pic.size.width / pic.size.height;
    CGFloat scanScreen = 99 / 125;
    
    if (scan > scanScreen) {
        rightView.sd_layout
        .widthIs(99)
        .heightIs(99 / pic.size.width * pic.size.height);
        
    } else {
        rightView.sd_layout
        .heightIs(125)
        .widthIs(125 / pic.size.height * pic.size.width);
    }
    [rightView setImage:[UIImage imageNamed:@"loginRight"]];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:button];
    button.sd_layout
    .heightIs(92)
    .widthIs(92)
    .centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, 100);
    [button setBackgroundImage:[UIImage imageNamed:@"loginBtn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel *labelLow = [UILabel new];
//    [self.view addSubview:labelLow];
//    
//    labelLow.sd_layout
//    .leftEqualToView(self.view)
//    .rightEqualToView(self.view)
//    .heightIs(30)
//    .topSpaceToView(button,10);
//    [labelLow setTextAlignment:NSTextAlignmentCenter];
//    [labelLow setText:@"关于我们 / 定制指南 / 寻找设计师"];
//    [labelLow setFont:[UIFont systemFontOfSize:16]];
//    [labelLow setTextColor:[UIColor blackColor]];
    
}

// login button click
-(void) loginClick
{
    

}


// 登录完成之后

#pragma -mark tableView create To show the baner and anyother thing like today TUIJIAN
-(void)createDataGet
{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"page"];
    
    [getData getData:URL_GetUserInfo PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        
        if (domain.result == 10001) {
            [self createUserHaventLogin];
        } else {
            
            _userGade = [NSDictionary dictionaryWithDictionary:[[domain.dataRoot objectForKey:@"data"] dictionaryForKey:@"user_grade"]];
            
            [[SelfPersonInfo getInstance] setPersonInfoFromJsonData:getData.dataRoot];
            if (_mainTabTable) {
                [_mainTabTable reloadData];
                
            } else {
                 [self createTableView];
            }
           
        }
        
        
    }];
    
}


-(void)createTableView
{
    
    
    _mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
    _mainTabTable.delegate = self;
    _mainTabTable.dataSource = self;
    [_mainTabTable registerClass:[MyHomeListTableViewCell class] forCellReuseIdentifier:@"mainCell"];
    [self.view addSubview:_mainTabTable];
    [_mainTabTable registerClass:[MineListNotForCollectionCell class] forCellReuseIdentifier:@"mainList"];
//    [_mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_mainTabTable setSeparatorColor : getUIColor(Color_myTabIconLineColor)];
    
#pragma - mark myInfo create to show the hot adv
   
    _mainTabTable.tableHeaderView = [self headImageView];
    
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 40, 40)];
    [rightButton setImage:[UIImage imageNamed:@"worning"] forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    [rightButton addTarget:self action:@selector(worningClick) forControlEvents:UIControlEventTouchUpInside];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 23, 15, 15)];
    [_countLabel setBackgroundColor:[UIColor redColor]];
    [_countLabel setFont:[UIFont systemFontOfSize:12]];
    [_countLabel.layer setCornerRadius:7.5];
    [_countLabel setTextAlignment:NSTextAlignmentCenter];
    [_countLabel setText:_countMessage];
    [_countLabel.layer setMasksToBounds:YES];
    [_countLabel setTextColor:[UIColor whiteColor]];
    [_countLabel setHidden:YES];
    [self.view addSubview:_countLabel];
    
}


-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,Main_Screen_Width,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
        [_headImageView setImage:[UIImage imageNamed:@"mine_headImage"]];
        
        imageHead = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-40, 60, 80, 80)];
         [_headImageView addSubview:imageHead];
        imageHead.layer.masksToBounds = YES;
        imageHead.layer.borderWidth = 1;
        imageHead.layer.borderColor =[[UIColor colorWithRed:255/255. green:253/255. blue:253/255. alpha:1.] CGColor];
        imageHead.layer.cornerRadius = 40;
        
        [imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [SelfPersonInfo getInstance].avatar]]];
        _countentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 155, Main_Screen_Width-80, 30)];
        _countentLabel.font = [UIFont systemFontOfSize:12.];
        _countentLabel.textColor = [UIColor whiteColor];
        _countentLabel.textAlignment = NSTextAlignmentCenter;
        _countentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _countentLabel.numberOfLines = 0;
        _countentLabel.text = [SelfPersonInfo getInstance].username;
        [_headImageView addSubview:_countentLabel];
        

        _vipLevel = [UIButton new];
        [_headImageView addSubview:_vipLevel];
        [_vipLevel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headImageView.mas_centerX).with.offset(10);
            make.top.equalTo(_countentLabel.mas_bottom).with.offset(5);
            make.height.equalTo(@20);
        }];
        [_vipLevel.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_vipLevel setTitle:[_userGade stringForKey:@"name"] forState:UIControlStateNormal];
        [_vipLevel addTarget:self action:@selector(vipClick) forControlEvents:UIControlEventTouchUpInside];
        
        
      
        
        _vipIm = [UIImageView new];
        [_headImageView addSubview:_vipIm];
        _vipIm.sd_layout
        .rightSpaceToView(_vipLevel, 2)
        .topSpaceToView(_countentLabel, 7.5)
        .heightIs(15)
        .widthIs(15);
        [_vipIm sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, [_userGade stringForKey:@"img2"]]]];
        
        
    }
    return _headImageView;
}

-(void)vipClick
{
    VipMainViewController *vip = [[VipMainViewController alloc] init];
    [self.navigationController pushViewController:vip animated:YES];
}



#pragma - mark table delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 255;
    } else
        return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    return 0.00001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *recell;
    if (indexPath.section == 0) {
        MyHomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
        cell.delegate = self;
       
        recell = cell;
    } else {
        MineListNotForCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainList" forIndexPath:indexPath];
        [cell.titleName setText:[[getTheIconTitle getInstance].titleNotForCollection objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.titleImage setImage:[UIImage imageNamed:[[getTheIconTitle getInstance].iconNotForCollection objectAtIndex:indexPath.row]]];
        recell = cell;
    }
     [recell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return recell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        myHomeSetViewController *mySet = [[myHomeSetViewController alloc] init];
        [self.navigationController pushViewController:mySet animated:YES];

    } else {
        SuggestViewController *suggest = [[SuggestViewController alloc] init];
        [self.navigationController pushViewController:suggest animated:YES];
    }
    
}

-(void)collectionSelect:(NSArray *)array :(NSInteger)item
{
    
    
    switch (item) {
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
            clothesForSaveViewController *mySave = [[clothesForSaveViewController alloc] init];
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
            
            CustomMainViewController *custom = [[CustomMainViewController alloc] init];
            [self.navigationController pushViewController:custom animated:YES];
            
            
        }
            break;
            case 6:
        {
            joinDesignerViewController *joinD = [[joinDesignerViewController alloc] init];
            [self.navigationController pushViewController:joinD animated:YES];
        }
            break;
            
            case 7:
        {
//            QYSource *source = [[QYSource alloc] init];
//            source.title =  @"17012348908";
//            source.urlString = @"17012348908";
//            QYSessionViewController *vc = [[QYSDK sharedSDK] sessionViewController];
//
//            vc.sessionTitle = @"私人顾问";
//            vc.source = source;
//
//            if (iPadDevice) {
//                UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:vc];
//                navi.modalPresentationStyle = UIModalPresentationFormSheet;
//                [self presentViewController:navi animated:YES completion:nil];
//            }
//            else{
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//            [self alertViewShowOfTime:@"客服不在线哦,请拨打电话:4009901213" time:1];
            //
        }
            break;
            
            case 8:
        {
            EnterViewController *invite = [[EnterViewController alloc] init];
            [self.navigationController pushViewController:invite animated:YES];
        }
            break;
        default:
            break;
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
