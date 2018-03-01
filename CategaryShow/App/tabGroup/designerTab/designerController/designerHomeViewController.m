//
//  designerHomeViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/6.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//
#import "OneViewTableTableViewController.h"
#import "SecondViewTableViewController.h"
#import "ThirdViewCollectionViewController.h"
#import "MainTouchTableTableView.h"
#import "MySegMentViewNew.h"
#import "designerProductViewController.h"
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
static CGFloat const headViewHeight = 320;
#import "designerHomeViewController.h"


#define URL_DESIGNERWEB @"html/jiangxin.html"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#define URL_SHARE @"http://www.cloudworkshop.cn/web/jquery-obj/static/fx/html/jiangxin.html"
#import "designerInfoTableViewCell.h"
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface designerHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property (nonatomic, strong) MySegMentViewNew * RCSegView;
@property(nonatomic,strong)UIImageView *headImageView;//头部图片
@property(nonatomic,strong)UIImageView * avatarImage;
@property(nonatomic,strong)UILabel *countentLabel;
@property (nonatomic, retain) UIView *alpha;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;

@end

@implementation designerHomeViewController
@synthesize mainTableView;

-(void)viewWillAppear:(BOOL)animated
{
    [self settabTitle:@""];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView addSubview:self.headImageView];
    
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(12, 26, 33, 33)];
    
    [buttonBack.layer setCornerRadius:33 / 2];
    [buttonBack.layer setMasksToBounds:YES];
    [buttonBack setImage:[UIImage imageNamed:@"baiBack"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonBack];
    
    [self.view bringSubviewToFront:buttonBack];
    
    
    
    UIButton *rightShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, 26, 33, 33)];
    
    [rightShare.layer setCornerRadius:33 / 2];
    [rightShare.layer setMasksToBounds:YES];
    [rightShare setImage:[UIImage imageNamed:@"shareRight"] forState:UIControlStateNormal];
    [rightShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightShare];
     
    [self.view bringSubviewToFront:rightShare];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    // Do any additional setup after loading the view.
}

-(void)shareClick
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _designerImage]]];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    [shareParams SSDKSetupShareParamsByText:_remark
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@?id=%@", URL_SHARE, _desginerId]]
                                      title:_designerName
                                       type:SSDKContentTypeWebPage];
    
    [ShareCustom shareWithContent:shareParams];
    
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)acceptMsg : (NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     * 处理联动
     */
    
    //获取滚动视图y值的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    
    CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
    
    
    /**
     * 处理头部视图
     */
    if(yOffset < -headViewHeight) {
        
        CGRect f = self.headImageView.frame;
        f.origin.y= yOffset ;
        f.size.height=  -yOffset;
        f.origin.y= yOffset;
        
        //改变头部视图的fram
        self.headImageView.frame= f;
//        self.alpha.frame = CGRectMake(0, 0, f.size.width, f.size.height);
//        CGRect avatarF = CGRectMake(f.size.width/2-25, (f.size.height-headViewHeight)+69, 50, 50);
//        _avatarImage.frame = avatarF;
//        _countentLabel.frame = CGRectMake((f.size.width-Main_Screen_Width)/2+40, (f.size.height-headViewHeight)+172, Main_Screen_Width-80, 36);
    }
    
}

-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,Main_Screen_Width,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
        [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_headImageView.layer setMasksToBounds:YES];

        
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2-(65 / 2), 69, 65, 65)];
        [_headImageView addSubview:_avatarImage];
        _avatarImage.userInteractionEnabled = YES;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.borderWidth = 3;
        _avatarImage.layer.borderColor =[[UIColor blackColor] CGColor];
        _avatarImage.layer.cornerRadius = 65 / 2;
        [_avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _designerImage]]];
        
    
        _countentLabel = [UILabel new];
         [_headImageView addSubview:_countentLabel];
        
        [_countentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headImageView.mas_centerX);
            make.top.equalTo(_avatarImage.mas_bottom).with.offset(14);
            make.height.equalTo(@20);
            
        }];
        _countentLabel.font = Font_18;
        _countentLabel.textColor = [UIColor blackColor];
        _countentLabel.textAlignment = NSTextAlignmentCenter;
        _countentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _countentLabel.numberOfLines = 0;
        _countentLabel.text = _designerName;
       
        
        UIImageView *DWImg = [UIImageView new];
        [_headImageView addSubview:DWImg];
        DWImg.sd_layout
        .rightSpaceToView(_countentLabel, 7)
        .topSpaceToView(_avatarImage, 17)
        .heightIs(21 * 4 / 5)
        .widthIs(15 * 4 / 5);
        [DWImg setImage:[UIImage imageNamed:@"DWImg"]];
        
        
        
        UILabel *tagLable = [UILabel new];
        [_headImageView addSubview:tagLable];
        
        [tagLable mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(_headImageView.mas_centerX);
            make.top.equalTo(_countentLabel.mas_bottom).with.offset(10);
            make.height.equalTo(@15);
        }];
        [tagLable setFont:[UIFont systemFontOfSize:12]];
        [tagLable setTextColor:getUIColor(Color_grayColorForDesigner)];
        [tagLable setText:[_designerDic stringForKey:@"tag"]];
        
        
        UILabel *me = [UILabel new];
        [_headImageView addSubview:me];
        me.sd_layout
        .leftSpaceToView(_headImageView, 30)
        .topSpaceToView(tagLable, 36)
        .autoHeightRatio(0)
        .widthIs(40);
        [me setText:@"Me"];
        [me setFont:Font_20];
        
        UILabel *introduce = [UILabel new];
        [_headImageView addSubview:introduce];
        [introduce mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(me.mas_right).with.offset(13);
            make.top.equalTo(tagLable.mas_bottom).with.offset(36);
            make.right.equalTo(_headImageView.mas_right).with.offset(-83);
            make.bottom.lessThanOrEqualTo(_headImageView.mas_bottom).with.offset(-5);
            
        }];
        [introduce setNumberOfLines:0];
        [introduce setTextAlignment:NSTextAlignmentCenter];
        [introduce setFont:[UIFont systemFontOfSize:15]];
        [introduce setText:[_designerDic stringForKey:@"introduce"]];
        [introduce setTextColor:getUIColor(Color_introduce)];
        
        
        UIView *lineGray = [UIView new];
        [_headImageView addSubview:lineGray];
        [lineGray setBackgroundColor:getUIColor(Color_background)];
        lineGray.sd_layout
        .leftEqualToView(_headImageView)
        .rightEqualToView(_headImageView)
        .bottomEqualToView(_headImageView)
        .heightIs(1);
        
    }
    return _headImageView;
}


-(UITableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,Main_Screen_Width,Main_Screen_Height)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
    }
    return mainTableView;
}

#pragma marl -tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Main_Screen_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //添加pageView
    [cell.contentView addSubview:self.setPageViewControllers];
    
    return cell;
}

/*
 * 这里可以任意替换你喜欢的pageView
 */
-(UIView *)setPageViewControllers
{
    if (!_RCSegView) {
        
        
        
        designerProductViewController *introduce = [[designerProductViewController alloc] init];
        introduce.desginerId = _desginerId;
        introduce.designerImage = _designerImage;
        introduce.designerName = _designerName;
        introduce.remark = _remark;
        
        
        //        SecondViewTableViewController * Second=[[SecondViewTableViewController alloc]init];
        
        ThirdViewCollectionViewController * Third=[[ThirdViewCollectionViewController alloc]init];
        Third.designerStory = _designerStory;
        
        NSArray *controllers=@[Third,introduce];
        
        NSArray *titleArray =@[@"故事",@"作品"];
        
        MySegMentViewNew * rcs=[[MySegMentViewNew alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) controllers:controllers titleArray:titleArray ParentController:self lineWidth:25 lineHeight:2.0 butHeight:40 viewHeight:64 showLine:YES];
        
        _RCSegView = rcs;
    }
    return _RCSegView;
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
