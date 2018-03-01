//
//  ThirdViewCollectionViewController.m
//  HeaderViewAndPageView
//
//  Created by su on 16/8/8.
//  Copyright © 2016年 susu. All rights reserved.
//

#import "ThirdViewCollectionViewController.h"


@interface ThirdViewCollectionViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>


@end

@implementation ThirdViewCollectionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createScrollerView];

}

-(void)createScrollerView
{
    
    
//    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64)];
//    [self.view addSubview:scroller];
//    scroller.delegate = self;
    
    UIImageView *imageDetailDes = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    if (_designerStory.length > 0) {
        [imageDetailDes sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PIC_HEADURL, _designerStory]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            CGFloat scan =imageDetailDes.image.size.width / imageDetailDes.image.size.height;
//            scroller.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
            [imageDetailDes setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / scan)];
//            [scroller addSubview:imageDetailDes];
            
            
            
            
            
            UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
            [self.view addSubview:table];
            table.delegate = self;
            table.dataSource = self;
            [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
            table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            table.tableHeaderView = imageDetailDes;
        }];

    } else {
        UIView *noDesiback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (392 / 2 + 40))];
        //    [noDesiback setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:noDesiback];
        
        UIImageView *noDes = [UIImageView new];
        [noDesiback addSubview:noDes];
        
        noDes.sd_layout
        .centerXEqualToView(noDesiback)
        .centerYEqualToView(noDesiback)
        .heightIs(442 / 2)
        .widthIs(422 / 2);
    
        [noDes setImage:[UIImage imageNamed:@"noDes"]];
        
        
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        [self.view addSubview:table];
        table.delegate = self;
        table.dataSource = self;
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
        table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        table.tableHeaderView = noDesiback;
    }
    
    
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
