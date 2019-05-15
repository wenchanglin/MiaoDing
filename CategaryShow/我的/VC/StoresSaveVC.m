//
//  StoresSaveVC.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/14.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "StoresSaveVC.h"
#import "StoreSaveModel.h"
#import "StoreSaveCell.h"
#import "StoresSaveDetailVC.h"
@interface StoresSaveVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation StoresSaveVC
{
    NSMutableArray *modelArray;
    UITableView *mainTabTable;
    NSInteger page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    modelArray = [NSMutableArray array];
    page = 1;
    [self createGetData];

}
-(void)createGetData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(MyCollectTypeStore) forKey:@"type"];
    [params setObject:@"1" forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_MyCollect_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
            if ([responseObject[@"data"][@"collections"]count]>0) {
                modelArray = [StoreSaveModel mj_objectArrayWithKeyValuesArray:responseObject [@"data"][@"collections"]];
                [self createView];
            }
            else
            {
                [mainTabTable removeFromSuperview];
                [self createNoSave];
            }
        }
    }];

}
-(void)reloadAddData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(MyCollectTypeStore) forKey:@"type"];
    [params setObject:@(page) forKey:@"page"];
    [[wclNetTool sharedTools]request:POST urlString:[MoreUrlInterface URL_MyCollect_String] parameters:params finished:^(id responseObject, NSError *error) {
        if ([self checkHttpResponseResultStatus:responseObject]) {
//            if ([responseObject[@"data"]count]>0&&page>1) {
                NSMutableArray*arr = [StoreSaveModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"collections"]];
                [modelArray addObjectsFromArray:arr];
                [mainTabTable reloadData];
//            }
//            else
//            {
//                [mainTabTable removeFromSuperview];
//                [self createNoSave];
//            }
        }
    }];

}
-(void)createNoSave
{
    UIView *bgNoDingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgNoDingView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgNoDingView];
    
    UIImageView *NoDD = [UIImageView new];
    [bgNoDingView addSubview:NoDD];
    NoDD.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(bgNoDingView, (SCREEN_HEIGHT - 64 - 50 ) / 2 - 110  - 35)
    .widthIs(211)
    .heightIs(220);
    [NoDD setImage:[UIImage imageNamed:@"haveNoSave"]];
    
    UIButton *clickToLookOther = [UIButton new];
    [bgNoDingView addSubview:clickToLookOther];
    
    clickToLookOther.sd_layout
    .centerXEqualToView(bgNoDingView)
    .topSpaceToView(NoDD, 20)
    .widthIs(80)
    .heightIs(35);
    [clickToLookOther.layer setCornerRadius:3];
    [clickToLookOther.layer setMasksToBounds:YES];
    [clickToLookOther addTarget:self action:@selector(goToLookClothes) forControlEvents:UIControlEventTouchUpInside];
    [clickToLookOther.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [clickToLookOther setBackgroundColor:[UIColor blackColor]];
    [clickToLookOther setTitle:@"去逛逛" forState:UIControlStateNormal];
    
}
-(void)goToLookClothes
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LookZixun" object:nil];
}
-(void)createView
{
    mainTabTable = [[UITableView alloc] initWithFrame:CGRectMake(0,NavHeight, SCREEN_WIDTH, [ShiPeiIphoneXSRMax isIPhoneX]?SCREEN_HEIGHT  - 88 - 60:SCREEN_HEIGHT  - 64 - 40) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        mainTabTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [mainTabTable setBackgroundColor:[UIColor whiteColor]];
    mainTabTable.estimatedSectionHeaderHeight =0;
    mainTabTable.delegate = self;
    mainTabTable.dataSource = self;
    [self.view addSubview:mainTabTable];
    [mainTabTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [WCLMethodTools footerAutoGifRefreshWithTableView:mainTabTable completion:^{
        page+=1;
        [self reloadAddData];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreSaveModel * models = modelArray[indexPath.row];
    StoreSaveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mendiansave"];
    if (!cell) {
        cell = [[StoreSaveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mendiansave"];
    }
    cell.model =models;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoresSaveDetailVC * vc = [[StoresSaveDetailVC alloc]init];
    vc.model = modelArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
