//
//  SuggestViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/9/14.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "SuggestViewController.h"
#import "SuggestClassListViewController.h"
#import "UserFeedBackViewController.h"
@interface SuggestViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SuggestViewController
{
    UITableView *suggestTable;
    NSMutableArray *titleArray;
    NSMutableArray *titleImgArray;
    NSMutableArray *arrayClassId;
    BaseDomain *getData;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSuggestView];
    getData = [BaseDomain getInstance:NO];
    arrayClassId = [NSMutableArray array];
    self.title = @"意见反馈";
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"相关问题", nil];
    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"客服热线         %@", [userd stringForKey:@"kf_tel"]], @"在线客服", nil];
    titleArray = [NSMutableArray arrayWithObjects:array1,array2, nil];
    
    
    NSArray  *array3 = [NSArray arrayWithObjects:@"xiangguang",@"alphaTitleImg",@"alphaTitleImg",@"alphaTitleImg",@"alphaTitleImg", nil];
    NSArray *array4 = [NSArray arrayWithObjects:@"kefu", @"zaixian", nil];
    titleImgArray = [NSMutableArray arrayWithObjects:array3,array4, nil];
    [self getDatas];
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_HelpType PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            for (NSDictionary *dic in [domain.dataRoot arrayForKey:@"data"]) {
                [[titleArray firstObject] addObject:[dic stringForKey:@"name"]];
                [arrayClassId addObject:[dic stringForKey:@"id"]];
            }
            [suggestTable reloadData];
        }
    }];
}

-(void)createSuggestView
{
    suggestTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    suggestTable.dataSource = self;
    suggestTable.delegate = self;
    [suggestTable setSeparatorColor : getUIColor(Color_myTabIconLineColor)];
    [self.view addSubview:suggestTable];
    [suggestTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"suggestList"];
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [footView setUserInteractionEnabled:YES];
        [footView setBackgroundColor:[UIColor clearColor]];
        UIButton *Suggest = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 40)];
        [Suggest setBackgroundColor:[UIColor whiteColor]];
        [Suggest setTitle:@"意见反馈" forState:UIControlStateNormal];
        [Suggest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [Suggest.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [Suggest.layer setCornerRadius:1];
        [Suggest.layer setMasksToBounds:YES];
        [Suggest addTarget:self action:@selector(suggestClick) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:Suggest];
        
        
        return footView;
    } else return nil;
}

-(void)suggestClick
{
    UserFeedBackViewController *userFeed = [[UserFeedBackViewController alloc] init];
    [self.navigationController pushViewController:userFeed animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [titleArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[titleArray objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0 && indexPath.row == 0) || indexPath.section == 1) {
        return 44;
    } else return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    } else
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"suggestList" forIndexPath:indexPath];
    [cell.textLabel setText:[[titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [cell.imageView setImage:[UIImage imageNamed:[[titleImgArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]];
    if ((indexPath.section == 0 && indexPath.row == 0) || indexPath.section == 1) {
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:getUIColor(Color_suggestLargeTitle)];
        
    }else {
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.textLabel setTextColor:getUIColor(Color_suggestSmallTitle)];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            SuggestClassListViewController *suggestList = [[SuggestClassListViewController alloc] init];
            suggestList.classId = arrayClassId[indexPath.row - 1];
            [self.navigationController pushViewController:suggestList animated:YES];
        }
       
    } else {
        if ( indexPath.row == 0) {
            NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[userd stringForKey:@"kf_tel"]]];
            [[UIApplication sharedApplication] openURL:url];
        } else {
            {
                QYSource *source = [[QYSource alloc] init];
                source.title =  @"私人顾问";
                source.urlString = @"https://8.163.com/";


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
//                [self alertViewShowOfTime:@"客服不在线哦,请拨打电话:4009901213" time:1];
            }
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
