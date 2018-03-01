//
//  mcSaleViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/5.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "mcSaleViewController.h"
#import "messageListModel.h"
#import "mcSaleTableViewCell.h"
#import "MainTabBanerDetailViewController.h"
@interface mcSaleViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation mcSaleViewController
{
    NSMutableArray *modelArray;
    BaseDomain *getData;
    UITableView *MCListTable;
    UILabel *labelCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动精选";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    
   
    
    modelArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    [self.view setBackgroundColor:getUIColor(Color_background)];
    [self getDatas];
    [self createTable];
    
    labelCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [labelCount setTextAlignment:NSTextAlignmentCenter];
    [labelCount setText:@"暂无通知"];
    [labelCount setFont:[UIFont systemFontOfSize:16]];
    [labelCount setTextColor:getUIColor(Color_active)];
    labelCount.center = self.view.center;
    [self.view addSubview:labelCount];
    // Do any additional setup after loading the view.
}


-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_mc_Id forKey:@"type"];
    [getData getData:URL_MessageList PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            NSArray *array = [domain.dataRoot arrayForKey:@"data"];
            if ([array count] > 0) {
                [labelCount setHidden:YES];
            } else {
                [labelCount setHidden:NO];
            }
            for (NSDictionary *dic in array) {
                messageListModel *model = [messageListModel new];
                model.mcTime = [dic stringForKey:@"c_time"];
                model.mcImg = [dic stringForKey:@"img"];
                model.mcContent = [dic stringForKey:@"content"];
                model.mcTitle = [dic stringForKey:@"title"];
                model.mcRead = [dic stringForKey:@"is_read"];
                model.link = [dic stringForKey:@"link"];
                model.shareLink = [dic stringForKey:@"share_link"]; 
                [modelArray addObject:model];
            }
            [MCListTable reloadData];
        }
    }];
}

-(void)createTable
{
    MCListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    MCListTable.dataSource = self;
    MCListTable.delegate = self;
    [MCListTable registerClass:[mcSaleTableViewCell class] forCellReuseIdentifier:@"mcListSale"];
    [MCListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:MCListTable];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    messageListModel *model = modelArray[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [label setText:[self dateToString:model.mcTime]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:[UIColor lightGrayColor]];
    return label;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [modelArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 244;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageListModel *model = modelArray[indexPath.section];
    
    mcSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mcListSale" forIndexPath:indexPath];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageListModel *model = modelArray[indexPath.section];
    MainTabBanerDetailViewController *mainBaner = [[MainTabBanerDetailViewController alloc] init];
    
    mainBaner.titleContent = model.mcTitle;
    mainBaner.imageUrl = model.mcImg;
    mainBaner.webLink = model.link;
    mainBaner.shareLink = model.shareLink;
    [self.navigationController pushViewController:mainBaner animated:YES];
}

-(NSString *)dateToString:(NSString *)dateString
{

    NSTimeInterval time=[dateString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
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
