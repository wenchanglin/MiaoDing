//
//  ToBuyCompanyClothesViewController.m
//  CategaryShow
//
//  Created by APPLE on 16/8/26.
//  Copyright © 2016年 Mr.huang. All rights reserved.
//

#import "ToBuyCompanyClothesViewController.h"
#import "LXPaperCollectionLayout.h"
#import "STAlertView.h"
#import "ChooseClothesStyleViewController.h"
//#import <AwAlertViewlib/AwAlertView.h>
static const CGFloat kCellSpacing = 20; // cell之间的间隙
@interface ToBuyCompanyClothesViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) BOOL canceled;
@property (nonatomic, strong) UICollectionView *paperCollectionView;
@property (nonatomic, strong) UILabel *numberLabel; // 页码Label
@property (nonatomic, assign) CGFloat itemWidth; // Cell宽度
@property (nonatomic, assign) CGFloat itemHeight; // Cell高度
@property (nonatomic, assign) NSInteger allCount; // 所有Cell数量
@property (nonatomic, assign) NSInteger currentItemIndex; // 当前Cell位置

@end

@implementation ToBuyCompanyClothesViewController
{
    UIButton *toBuyButton;   //立即订购
    UIButton *toSave;     //加入购物车
    UIButton *chatService;  //私人顾问
    UIButton *clothesDetail;  //商品详情
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self commonInit];
    [self createLowView];  //创建底部视图
    [self createDetailClothesButton];
    
    // Do any additional setup after loading the view.
}

#pragma -mark all view to create

- (void)commonInit {
    
    self.allCount = 9;
    self.itemWidth = SCREEN_WIDTH - 2 * kEdgeInsetSize;
    self.itemHeight = SCREEN_HEIGHT - 49 - 64 - 50;
    LXPaperCollectionLayout *paperLayout = [[LXPaperCollectionLayout alloc] initWithItemSize:CGSizeMake(self.itemWidth, self.itemHeight)];
    self.paperCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - self.itemHeight) / 2, SCREEN_WIDTH, self.itemHeight) collectionViewLayout:paperLayout];
    self.paperCollectionView.dataSource = self;
    self.paperCollectionView.backgroundColor = [UIColor clearColor];
    self.paperCollectionView.delegate = self;
    self.paperCollectionView.scrollEnabled = YES;
    self.paperCollectionView.pagingEnabled = NO;
    self.paperCollectionView.alwaysBounceHorizontal = YES;
    self.paperCollectionView.showsHorizontalScrollIndicator = NO;
    self.paperCollectionView.decelerationRate = 0.5; // 设置scroll更快减速
    
    [self.view addSubview:self.paperCollectionView];
    
    [self.paperCollectionView registerNib:[UINib nibWithNibName:@"PaperCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PaperCollectionCell"];
    
    [self.view addSubview:self.numberLabel];
    
    
   

}

-(void)createDetailClothesButton{
    clothesDetail = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:clothesDetail];
    [clothesDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.height.equalTo(@35);
        make.width.equalTo(@130);
    }];
    
    [clothesDetail setTitle:@"商品详情" forState:UIControlStateNormal];
    [clothesDetail.titleLabel setFont:[UIFont systemFontOfSize:14]];

    [clothesDetail setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    [clothesDetail.titleLabel setTextAlignment:NSTextAlignmentRight];
    [clothesDetail setBackgroundImage:[UIImage imageNamed:@"flog"] forState:UIControlStateNormal];
    [clothesDetail addTarget:self action:@selector(clothesDetailClick) forControlEvents:UIControlEventTouchUpInside];

}

-(void)createLowView
{
    toBuyButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:toBuyButton];
    [toBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_bottom).with.offset(-50);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH / 2 - 40));
    }];
    [toBuyButton setTitle:@"立即订购" forState:UIControlStateNormal];
    [toBuyButton addTarget:self action:@selector(ClickToBuyBut) forControlEvents:UIControlEventTouchUpInside];
    
    [toBuyButton setBackgroundColor:getUIColor(Color_buyColor)];
    
    toSave = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:toSave];
    [toSave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(toBuyButton.mas_left);
        make.top.equalTo(self.view.mas_bottom).with.offset(-50);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH / 2 - 40));
    }];
    [toSave setTitle:@"加入购物车" forState:UIControlStateNormal];
    
    [toSave setBackgroundColor:getUIColor(Color_saveColor)];
    
    chatService = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:chatService];
    [chatService mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(toSave.mas_left);
        make.top.equalTo(self.view.mas_bottom).with.offset(-50);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(@80);
    }];

    [chatService setImage:[UIImage imageNamed:@"Siren"] forState:UIControlStateNormal];
    [chatService setBackgroundColor:getUIColor(Color_saveColor)];
}


#pragma mark - delegate and datasoure

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PaperCollectionCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 1.f;
    UIImageView *imageView = [cell viewWithTag:666];
    imageView.image = [UIImage imageNamed:@"NanZhuang1"];
    [cell addSubview:imageView];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Click picture index : %ld",indexPath.row);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger count = scrollView.contentOffset.x / (self.itemWidth + kCellSpacing) + 1;
    if (count == 0) {
        count = 1;
    }
    self.currentItemIndex = count - 1;
    [self updateNumberLabelWithCurrentIndex:count allCount:self.allCount];
}

// 仿系统的pageEnable 的效果
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView == self.paperCollectionView) {
        if (0 == velocity.x) {
            return;
        }
        
        CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
        //        CGFloat targetIndex = round(targetX / (kCellWidth + kCellSpacing));
        CGFloat targetIndex;
        if (velocity.x > 0) {
            targetIndex = ceil(targetX / (self.itemWidth + kCellSpacing));
        } else {
            targetIndex = floor(targetX / (self.itemWidth + kCellSpacing));
        }
        if (targetIndex < 0) {
            targetIndex = 0;
        }
        if (targetIndex > self.allCount - 1) {
            targetIndex = self.allCount - 1;
        }
        if (targetIndex == self.allCount - 1) {
            targetContentOffset->x = targetIndex * (self.itemWidth + kCellSpacing);
        } else {
            targetContentOffset->x = targetIndex * (self.itemWidth + kCellSpacing);
        }
        self.currentItemIndex = targetIndex;
        [self updateNumberLabelWithCurrentIndex:targetIndex + 1 allCount:self.allCount];
    }
}

#pragma mark - Private Method

- (void)updateNumberLabelWithCurrentIndex:(NSInteger)currentIndex allCount:(NSInteger)allCount { // 更新顶部页码Label
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",(long)currentIndex]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0, str.length)];
    NSAttributedString *allStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%ld",(long)allCount]];
    [str appendAttributedString:allStr];
    
    self.numberLabel.attributedText = str;
}

#pragma mark - Getter

- (UILabel *)numberLabel {
    
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21.f, SCREEN_WIDTH, 36.f)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont systemFontOfSize:16.0f];
        _numberLabel.textColor = [UIColor darkGrayColor];
        _numberLabel.text = @"0/0";
    }
    return _numberLabel;
}



#pragma mark - all button click

-(void)ClickToBuyBut {
    NSArray *buttons = nil;
    buttons = @[@"￥600",@"￥900",@"￥1200"];
    STAlertView *alert = [[STAlertView alloc] initWithTitle:@"选择定制价格区间"image:[UIImage imageNamed:@""] message:@"本产品为用户自己定制的产品，产品的价格不包括加工费！"buttonTitles:buttons];
    
    alert.hideWhenTapOutside = YES;
    [alert setDidShowHandler:^{
        NSLog(@"显示了");
    }];
    [alert setDidHideHandler:^{
        NSLog(@"消失了");
    }];
    [alert setActionHandler:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                ChooseClothesStyleViewController *chooseStyle = [[ChooseClothesStyleViewController alloc] init];
                [self.navigationController pushViewController:chooseStyle animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    [alert show:YES];
}

-(void)clothesDetailClick
{

    
//
//    AwTipView *tipView=[[AwTipView alloc]initWithTipStyle:AwTipViewStyleAnnularDeterminate inView:self.view title:nil message:@"正在加载..." posY:0];
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//            // Do something useful in the background and update the HUD periodically.
//        [self doSomeWorkWithProgressWith:self.view];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [tipView hideAnimated:YES];
//        });
//    });
//    tipView.dimBackground=YES;
//    [tipView showAnimated:YES];

    
}

- (void)doSomeWorkWithProgressWith:(UIView *)view {
    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
//            AwTipView *tipView=[AwTipView HUDForView:view];
//            //            NSLog(@"%@",@(progress));
//            tipView.progress = progress;
        });
        usleep(50000);
    }
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
