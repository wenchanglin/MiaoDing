//
//  MCListViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/1/4.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "MCListViewController.h"
#import "messageListModel.h"
#import "systemMCTableViewCell.h"
@interface MCListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MCListViewController
{
    NSMutableArray *modelArray;
    BaseDomain *getData;
    UITableView *MCListTable;
    UILabel *labelCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统通知";
    
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
            NSLog(@"%@", array);
            for (NSDictionary *dic in array) {
                messageListModel *model = [messageListModel new];
                model.mcTime = [dic stringForKey:@"c_time"];
                model.mcImg = [dic stringForKey:@"img"];
                model.mcContent = [dic stringForKey:@"content"];
                model.mcTitle = [dic stringForKey:@"title"];
                model.mcRead = [dic stringForKey:@"is_read"];
                [modelArray addObject:model];
            }
            [MCListTable reloadData];
        }
    }];
}

-(void)createTable
{
    MCListTable = [[UITableView alloc] initWithFrame:CGRectMake(9, 64, SCREEN_WIDTH - 18, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    MCListTable.dataSource = self;
    MCListTable.delegate = self;
    MCListTable.showsVerticalScrollIndicator = NO;
    [MCListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [MCListTable registerClass:[systemMCTableViewCell class] forCellReuseIdentifier:NSStringFromClass([systemMCTableViewCell class])];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
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
    CGFloat x;
    messageListModel *model = modelArray[indexPath.section];
    Class currentClass = [systemMCTableViewCell class];
    
    x =  [MCListTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    return x;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    messageListModel *model = modelArray[indexPath.section];
    Class currentClass = [systemMCTableViewCell class];
    systemMCTableViewCell *cell = nil;
    
   
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    cell.model = model;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    return cell;
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
