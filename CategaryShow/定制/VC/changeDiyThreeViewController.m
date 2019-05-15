//
//  changeDiyThreeViewController.m
//  CategaryShow
//
//  Created by 文长林 on 2019/4/25.
//  Copyright © 2019 Mr.huang. All rights reserved.
//

#import "changeDiyThreeViewController.h"
#import "XXPageTabView.h"

#import "changeDiySecondViewController.h"
@interface changeDiyThreeViewController ()<XXPageTabViewDelegate>
@property (nonatomic, strong) XXPageTabView *pageTabView;

@end

@implementation changeDiyThreeViewController
{
    NSMutableArray *FLArray;
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.rdv_tabBarController.tabBarHidden=NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    FLArray=[NSMutableArray array];
    NSMutableArray*VCS= [NSMutableArray array];
    NSMutableArray*titleS= [NSMutableArray array];
    
    [[wclNetTool sharedTools]request:GET urlString:[MoreUrlInterface URL_FenLeiForNamed_String] parameters:@{@"type":self.feileiString}.mutableCopy finished:^(id responseObject, NSError *error) {
        NSMutableArray*arrays = [responseObject[@"data"]mutableCopy];
        [arrays insertObject:@"全部" atIndex:0];
        [FLArray addObjectsFromArray:arrays];
        for (NSString*string2 in FLArray) {
            changeDiySecondViewController*svc = [[changeDiySecondViewController alloc]init];
            svc.shopID = self.shopID;
            if([string2 isEqualToString:@"全部"])
            {
                svc.feileiString=@"";
            }
            else
            {
            svc.feileiString=string2;
            }
            UINavigationController*vc = [[UINavigationController alloc]initWithRootViewController:svc];
            [VCS addObject:vc];
            [titleS addObject:string2];

        }
        self.pageTabView = [[XXPageTabView alloc]initWithChildControllers:VCS childTitles:titleS];
        self.pageTabView.delegate = self;
        self.pageTabView.indicatorHeight = 3;
        self.pageTabView.indicatorWidth=30;
        self.pageTabView.unSelectedColor = [UIColor blackColor];
        self.pageTabView.tabItemFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        self.pageTabView.selectedIndiactorColor = [UIColor blackColor];
        self.pageTabView.selectedColor = [UIColor colorWithHexString:@"#202020"];
        self.pageTabView.titleStyle = XXPageTabTitleStyleGradient;
        self.pageTabView.indicatorStyle = XXPageTabIndicatorStyleDefault;
        self.pageTabView.bodyBounces = NO;
        [self.view addSubview:self.pageTabView];
        [self.pageTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        }];
    

 
    
}
-(void)pageTabViewDidEndChange
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fangun" object:nil];
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
