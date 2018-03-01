//
//  haveOverduedViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2016/12/19.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "haveOverduedViewController.h"
#import "couponTableViewCell.h"
#import "couponModel.h"
@interface haveOverduedViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation haveOverduedViewController
{
    UITableView *canUse;
    NSMutableArray *modelArray;
    BaseDomain *getData;
    BaseDomain *postData;
    UITextField *CouponNumber;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    getData = [BaseDomain getInstance:NO];
    postData = [BaseDomain getInstance:NO];
    // Do any additional setup after loading the view.
    [self getDatas];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"-1" forKey:@"status"];
    
    [getData getData:URL_Coupon PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:domain]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            for (NSDictionary *dic in array) {
                couponModel *model = [[couponModel alloc] init];
                model.price = [NSString stringWithFormat:@"%.f", [[dic stringForKey:@"money"] floatValue]];
                model.useType = [dic stringForKey:@"title"];
                model.typeRemark = [dic stringForKey:@"sub_title"];
                model.imageName = @"grayJuXIng";
                model.rightImg = @"haveOverd";
                model.time = [NSString stringWithFormat:@"有效期:%@至%@",[self dateToString:[dic stringForKey:@"s_time"]], [self dateToString:[dic stringForKey:@"e_time"]]];
                [modelArray addObject:model];
            }
            
            [self createTable];
        }
        
    }];
}

-(void)createTable
{
    
    
    canUse = [[UITableView alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - 16, SCREEN_HEIGHT - 41 - 64) style:UITableViewStyleGrouped];
    canUse.delegate = self;
    canUse.dataSource = self;
    canUse.showsVerticalScrollIndicator =NO;
    [canUse setBackgroundColor:[UIColor whiteColor]];
    [canUse setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [canUse registerClass:[couponTableViewCell class] forCellReuseIdentifier:@"haveOver"];
    [self.view addSubview:canUse];
    
}



-(NSString *)dateToString:(NSString *)dateString
{
    

    NSTimeInterval time=[dateString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [modelArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    couponModel *model = modelArray[indexPath.section];
    couponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"haveOver" forIndexPath:indexPath];
    cell.model = model;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
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
