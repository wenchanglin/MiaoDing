//
//  moreVipQYViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/5/8.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "moreVipQYViewController.h"
#import "moreQYTableViewCell.h"
@interface moreVipQYViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation moreVipQYViewController
{
    UITableView *vipQYList;
    BaseDomain *getData;
    NSMutableArray *QYArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员俱乐部";
    getData = [BaseDomain getInstance:NO];
    QYArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)getData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_USEGRADE PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            
            QYArray = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            [self createView];
//            NSLog(@"%@", domain.dataRoot);
        }
    }];
    
}


-(void)createView
{
    vipQYList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [self.view addSubview:vipQYList];
    vipQYList.delegate = self;
    vipQYList.dataSource = self;
    [vipQYList setBackgroundColor:[UIColor whiteColor]];
    vipQYList.showsVerticalScrollIndicator = NO;
    [vipQYList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [vipQYList registerClass:[moreQYTableViewCell class] forCellReuseIdentifier:@"list"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    vipQYList.tableHeaderView = view;
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 158;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [QYArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    moreQYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.titleLabel setText:[[QYArray objectAtIndex:indexPath.row] stringForKey:@"name"]];
    cell.collectionArray = [NSMutableArray arrayWithArray:[[QYArray objectAtIndex:indexPath.row] arrayForKey:@"grade_privilege"]];
    
    
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
