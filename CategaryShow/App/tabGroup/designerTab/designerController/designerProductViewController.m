//
//  designerProductViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/6/6.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "designerProductViewController.h"
#import "designerModel.h"
#import "designerInfoTableViewCell.h"
#import "DesignerClothesDetailViewController.h"
#import "designerinfoNewTableViewCell.h"
@interface designerProductViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation designerProductViewController
{
    UITableView *desinger;
    BaseDomain *getData;
    NSMutableDictionary *designerDic;
    NSMutableArray *modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    designerDic = [NSMutableDictionary dictionary];
    modelArray = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self getDatas];
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_desginerId forKey:@"uid"];
    [getData getData:URL_GetDesignerDeetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            
            designerDic = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
            
            
            for (NSDictionary *dic in [designerDic arrayForKey:@"goods_list"]) {
                designerModel *model = [designerModel new];
                model.designerName = _designerName;
                model.designerHead = _designerImage;
                model.p_time = [dic stringForKey:@"c_time"];
                model.clothesImage =[dic stringForKey:@"thumb"];
                model.titlename = [dic stringForKey:@"name"];
                model.good_Id = [dic stringForKey:@"id"];
                model.desginer_Id = _desginerId;
                model.detailClothesImg = [dic stringForKey:@"thumb"];

                model.remark = [dic stringForKey:@"remark"];
                
                
                model.tag = [dic stringForKey:@"tag"];
                model.introduce = [dic stringForKey:@"introduce"];
                
                [modelArray addObject:model];
            }
            
            [self createDeisgner];
        }
    }];
}

-(void)createDeisgner
{
    desinger = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    desinger.delegate = self;
    desinger.dataSource = self;
    [desinger registerClass:[designerinfoNewTableViewCell class] forCellReuseIdentifier:@"designer"];
    [self.view addSubview:desinger];
    [desinger setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    
    if ([modelArray count] > 0) {
        desinger.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    } else {
        [self footBack];
    }
    
    
    
}

-(void)footBack
{
    UIView *noDesiback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (392 / 2 + 40))];
    //    [noDesiback setBackgroundColor:[UIColor blackColor]];
    desinger.tableFooterView = noDesiback;
    
    UIImageView *noDes = [UIImageView new];
    [noDesiback addSubview:noDes];
    
    noDes.sd_layout
    .centerXEqualToView(noDesiback)
    .centerYEqualToView(noDesiback)
    .heightIs(442 / 2)
    .widthIs(422 / 2);
    
    [noDes setImage:[UIImage imageNamed:@"noDes"]];
    
}

-(void)backClickAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 526.0 / 667.0 * SCREEN_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    designerinfoNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"designer" forIndexPath:indexPath];
    cell.model = modelArray[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DesignerClothesDetailViewController *designerClothes = [[DesignerClothesDetailViewController alloc] init];
    designerClothes.goodDic = [[designerDic arrayForKey:@"goods_list"] objectAtIndex:indexPath.row];
    designerClothes.good_id = [[[designerDic arrayForKey:@"goods_list"] objectAtIndex:indexPath.row] stringForKey:@"id"];
    designerClothes.model = modelArray[indexPath.item];
    [self.navigationController pushViewController:designerClothes animated:YES];
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
