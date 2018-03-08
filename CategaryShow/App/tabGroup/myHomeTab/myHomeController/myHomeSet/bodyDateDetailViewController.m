//
//  bodyDateDetailViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/3/1.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "bodyDateDetailViewController.h"
#import "dateForBodyTableViewCell.h"
@interface bodyDateDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation bodyDateDetailViewController

{
    BaseDomain *getDate;
    UITableView *nameTable;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self settabTitle:@"量体数据"];
    getDate = [BaseDomain getInstance:NO];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createTable];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)createTable
{
    nameTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    nameTable.delegate = self;
    nameTable.dataSource = self;
    [nameTable registerClass:[dateForBodyTableViewCell class] forCellReuseIdentifier:@"name"];
    [nameTable setSeparatorColor : getUIColor(Color_myTabIconLineColor)];
    [self.view addSubview:nameTable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dateArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dateForBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.titleLabel.text = [_dateArray[indexPath.row]  stringForKey:@"name"];
    
    cell.detailLabel.text = [_dateArray[indexPath.row]  stringForKey:@"value"];
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
