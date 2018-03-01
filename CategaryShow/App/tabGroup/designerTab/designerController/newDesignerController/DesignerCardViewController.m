//
//  DesignerCardViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/9/25.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "DesignerCardViewController.h"
#import "designerModel.h"
#import "XLCardSwitch.h"
#import "designerHomeViewController.h"
@interface DesignerCardViewController()<XLCardSwitchDelegate> {
    
    XLCardSwitch *_cardSwitch;
    
    UIImageView *_imageView;
    UIPageControl *page;
}

@end

@implementation DesignerCardViewController
{
    BaseDomain *getData;
    NSMutableArray *designerArray;
    NSMutableArray *modelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:getUIColor(Color_DesignerBack)];
    getData = [BaseDomain getInstance:NO];
    modelArray = [NSMutableArray array];
    designerArray = [NSMutableArray array];
    [self getDatas];
    
    // Do any additional setup after loading the view.
}

-(void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [getData getData:URL_GetDesigner PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ([self checkHttpResponseResultStatus:domain]) {
            designerArray = [NSMutableArray arrayWithArray:[domain.dataRoot arrayForKey:@"data"]];
            for (NSDictionary *dic  in designerArray) {
                XLCardItem *model = [XLCardItem new];
                model.avatar = [dic stringForKey:@"avatar"];
                model.name = [dic stringForKey:@"name"];
                model.tag = [dic stringForKey:@"tag"];
                model.idStr = [dic stringForKey:@"id"];
                [modelArray addObject:model];
            }
            
            
            [self addCardSwitch];
            [self addImageView];
        }
    }];
}

- (void)addImageView {
    page = [[UIPageControl alloc] initWithFrame:CGRectMake(10, self.view.bounds.size.height - 64 - 49 - 40, self.view.bounds.size.width - 20, 15)];
    [self.view addSubview:page];
    ;
    page.numberOfPages = [modelArray count];//指定页面个数
    page.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    page.pageIndicatorTintColor = [UIColor grayColor];// 设置非选中页的圆点颜色
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
}

- (void)addCardSwitch {
    //初始化数据源
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DataPropertyList" ofType:@"plist"];
//    NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
//    NSMutableArray *items = [NSMutableArray new];
//    for (NSDictionary *dic in arr) {
//        XLCardItem *item = [[XLCardItem alloc] init];
//        [item setValuesForKeysWithDictionary:dic];
//        [items addObject:item];
//    }
    
    //设置卡片浏览器
    _cardSwitch = [[XLCardSwitch alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49)];
    _cardSwitch.items = modelArray;
    _cardSwitch.delegate = self;
    //分页切换
    _cardSwitch.pagingEnabled = true;
    //设置初始位置，默认为0
    _cardSwitch.selectedIndex = 0;
    [self.view addSubview:_cardSwitch];
}

#pragma mark -
#pragma mark CardSwitchDelegate

-(void)getPageIndex:(NSInteger)index{
    page.currentPage = index;
}

- (void)XLCardSwitchDidSelectedAt:(NSInteger)index {
    NSLog(@"选中了：%zd",index);
    
    //更新背景图
    XLCardItem *item = _cardSwitch.items[index];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, item.avatar]]];
    
    if (index == designerArray.count - 1) {
        [self alertViewShowOfTime:@"虚位以待" time:1];
    } else {
        designerHomeViewController *designer = [[designerHomeViewController alloc] init];
        designer.desginerId = [designerArray[index] stringForKey:@"id"];
        designer.designerImage = [designerArray[index] stringForKey:@"avatar"];
        designer.designerName = [designerArray[index] stringForKey:@"name"];
        designer.remark = [designerArray[index] stringForKey:@"tag"];
        designer.designerStory = [designerArray[index] stringForKey:@"story"];
        
        designer.designerDic = designerArray[index];
        [self.navigationController pushViewController:designer animated:YES];
    }
    
}


- (void)switchPrevious {
    
    NSInteger index = _cardSwitch.selectedIndex - 1;
    index = index < 0 ? 0 : index;
    [_cardSwitch switchToIndex:index animated:true];
}

- (void)switchNext {
    NSInteger index = _cardSwitch.selectedIndex + 1;
    index = index > _cardSwitch.items.count - 1 ? _cardSwitch.items.count - 1 : index;
    [_cardSwitch switchToIndex:index animated:true];
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
