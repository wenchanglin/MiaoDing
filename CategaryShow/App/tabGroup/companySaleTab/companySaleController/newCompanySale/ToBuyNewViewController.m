//
//  ToBuyNewViewController.m
//  CategaryShow
//
//  Created by 黄梦炜 on 2017/2/21.
//  Copyright © 2017年 Mr.huang. All rights reserved.
//

#import "ToBuyNewViewController.h"
#import "uiimageShowViewController.h"
#import "priceChooseView.h"
#import "DiyWordInClothesViewController.h"
#import "YuYueToBuyViewController.h"
@interface ToBuyNewViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,priceChooseViewDelegate>
@property(nonatomic ,strong) UIPageViewController *pageViewController;
@property(nonatomic ,strong) NSMutableArray       *dataArray;
@end

@implementation ToBuyNewViewController
{
    BaseDomain *getData;
    NSMutableDictionary *dataDictionary;
    NSMutableArray *pictureArray;
    NSMutableArray *detailArray;
    BOOL isShow;
    UIScrollView *scrollerClothesDetail;
    UIPageControl* pageCntroller;
    UIImageView *alphaView;
    priceChooseView *viewPiceChoose;
    NSDate *datBegin;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    datBegin = [NSDate dateWithTimeIntervalSinceNow:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isShow = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    getData = [BaseDomain getInstance:NO];
    [self createGetData];
    
    _dataArray = [NSMutableArray array];
        // Do any additional setup after loading the view.
}


-(void)createGetData
{
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:[_goodDic stringForKey:@"id"] forKey:@"goods_id"];
    [getData postData:URL_GetYouPingDetail PostParams:parmas finish:^(BaseDomain *domain, Boolean success) {
        
        if ([self checkHttpResponseResultStatus:getData]) {
            dataDictionary = [NSMutableDictionary dictionaryWithDictionary:[getData.dataRoot dictionaryForKey:@"data"]];
            _class_id = [dataDictionary stringForKey:@"classify_id"];
            pictureArray = [NSMutableArray arrayWithArray:[dataDictionary arrayForKey:@"img_list"]];
            [self createPage];
            [self createAlphaView];
            [self createTabView];
            [self createPageController];
            [self createPriceView];
        }
        
    }];
}




-(void)createPriceView
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NSArray *arrayPriceRemark = [[userd stringForKey:@"price_remark"] componentsSeparatedByString:@"/"];
    
    alphaView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [alphaView setImage:[UIImage imageNamed:@"BGALPHA"]];

    [alphaView setUserInteractionEnabled:YES];
    [self.view addSubview:alphaView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenChoose)];
//    [alphaView addGestureRecognizer:tap];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT)];
    [alphaView addSubview:button];
    [button addTarget:self action:@selector(hiddenChoose) forControlEvents:UIControlEventTouchUpInside];
    
    viewPiceChoose = [priceChooseView new];
    [alphaView addSubview:viewPiceChoose];
    viewPiceChoose.delegate = self;
    viewPiceChoose.sd_layout
    .leftSpaceToView(alphaView,SCREEN_WIDTH / 2)
    .topSpaceToView(alphaView, 150)
    .rightEqualToView(alphaView)
    .heightIs(45 * ([[dataDictionary arrayForKey:@"price"] count] + 1));
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [[dataDictionary arrayForKey:@"price"] count]; i ++) {
        NSString *string = [NSString stringWithFormat:@"￥%@  %@", [dataDictionary arrayForKey:@"price"][i], arrayPriceRemark[i]];
        [array addObject:string];
    }
    
    choosePriceModel *model = [choosePriceModel new];
    model.price = array;
    
    viewPiceChoose.model = model;
    
    UIButton *toBuyButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [alphaView addSubview:toBuyButton];
    [toBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alphaView.mas_left).with.offset(SCREEN_WIDTH / 2);
        make.top.equalTo(viewPiceChoose.mas_bottom).with.offset(15);
        make.height.equalTo(@45);
        make.width.equalTo(@(SCREEN_WIDTH / 2));
    }];
    [toBuyButton setTitle:@"立即定制" forState:UIControlStateNormal];
    [toBuyButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [toBuyButton addTarget:self action:@selector(ClickToBuyBut) forControlEvents:UIControlEventTouchUpInside];
    
    [toBuyButton setBackgroundColor:getUIColor(Color_buyColor)];
    
}

-(void)ClickToBuyBut
{
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    if ([[userd stringForKey:@"token"] length] > 0) {
        if ([dataDictionary integerForKey:@"is_yuyue"] == 1) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [viewPiceChoose setAlpha:1];
            [alphaView setAlpha:1];
            [UIView commitAnimations];
            
        } else {
            
            YuYueToBuyViewController *YuYue = [[YuYueToBuyViewController alloc] init];
            YuYue.goodName = [dataDictionary stringForKey:@"name"];
            [self.navigationController pushViewController:YuYue animated:YES];
        }
        
    } else {
        [self getDateBeginHaveReturn:datBegin fatherView:@"立即购买"];
    }
}

-(void)clickPriceChoose:(NSInteger)item
{
    
    
    NSArray *buttons = [dataDictionary arrayForKey:@"price"];
    DiyWordInClothesViewController *diyClothes = [[DiyWordInClothesViewController alloc] init];
    diyClothes.price_type = [NSString stringWithFormat:@"%ld", item + 1];
    diyClothes.price = [buttons objectAtIndex:item];
    diyClothes.class_id = _class_id;
    diyClothes.goodDic = _goodDic;
    [self.navigationController pushViewController:diyClothes animated:YES];
    [self hiddenChoose];
}


-(void)showPrice
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [alphaView setTransform:(CGAffineTransformMakeTranslation(-SCREEN_WIDTH,0))];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [alphaView setTransform:(CGAffineTransformMakeTranslation(-SCREEN_WIDTH + 20,0))];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [alphaView setTransform:(CGAffineTransformMakeTranslation(-SCREEN_WIDTH,0))];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    [alphaView setTransform:(CGAffineTransformMakeTranslation(-SCREEN_WIDTH + 10,0))];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        [alphaView setTransform:(CGAffineTransformMakeTranslation(-SCREEN_WIDTH ,0))];
                    } completion:^(BOOL finished) {
                        
                    }];
                }];
            }];
        }];
    }];
}

-(void)hiddenChoose
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [alphaView setTransform:(CGAffineTransformMakeTranslation(SCREEN_WIDTH / 2,0))];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)createTabView
{
    UIButton *buttonHome = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 50, 50, 50)];
    [buttonHome setImage:[UIImage imageNamed:@"home-hui"] forState:UIControlStateNormal];
    [self.view addSubview:buttonHome];
    [buttonHome addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *buttonXiangqing = [[UIButton alloc] initWithFrame:CGRectMake(70, SCREEN_HEIGHT - 50, 50, 50)];
    [buttonXiangqing setImage:[UIImage imageNamed:@"jiangxin-hui"] forState:UIControlStateNormal];
    [self.view addSubview:buttonXiangqing];
    [buttonXiangqing addTarget:self action:@selector(clothesDetailClick:) forControlEvents:UIControlEventTouchUpInside];
  
    UIButton *buttonDZ = [[UIButton alloc] initWithFrame:CGRectMake(130, SCREEN_HEIGHT - 50, 50, 50)];
    [buttonDZ setImage:[UIImage imageNamed:@"youpin-hui"] forState:UIControlStateNormal];
    [buttonDZ addTarget:self action:@selector(DZClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonDZ];
    
    
    
    
}

-(void)createPageController
{
   pageCntroller = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - ([pictureArray count] * 15), SCREEN_HEIGHT  - 30, [detailArray count] * 15, 20)];
    
    pageCntroller.numberOfPages = [pictureArray count];
    pageCntroller.currentPage = 0;
    [self.view addSubview:pageCntroller];
    pageCntroller.pageIndicatorTintColor = [UIColor grayColor];
    pageCntroller.currentPageIndicatorTintColor = [UIColor whiteColor];
    
}

-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)DZClick
{
    [self showPrice];
}

-(void)clothesDetailClick:(UIButton *)sender
{
    if (isShow) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [scrollerClothesDetail setAlpha:0];
        [UIView commitAnimations];
        isShow = NO;
        [sender setImage:[UIImage imageNamed:@"jiangxin-hui"] forState:UIControlStateNormal];
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [scrollerClothesDetail setAlpha:1];
        [UIView commitAnimations];
        isShow = YES;
        [sender setImage:[UIImage imageNamed:@"jiangxin"] forState:UIControlStateNormal];
    }
    
}


-(void)createAlphaView
{
    
    
    scrollerClothesDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )];
    UILabel *detailLabel = [UILabel new];
    if ([[dataDictionary stringForKey:@"content"] isEqualToString:@""]) {
        [detailLabel setText:@"暂无详情介绍"];
    } else {
        [detailLabel setText:[dataDictionary stringForKey:@"content"]];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detailLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailLabel.text length])];
    detailLabel.attributedText = attributedString;
    [detailLabel setNumberOfLines:0];
    
    [detailLabel setFont:[UIFont systemFontOfSize:14]];
    [detailLabel setTextColor:[UIColor whiteColor]];
    
    //    detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 40, 9999);//labelsize的最大值
    //关键语句
    CGSize expectSize = [detailLabel sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    detailLabel.frame = CGRectMake(20, 40, expectSize.width, expectSize.height);
    
    CGFloat scan = expectSize.width / expectSize.height;
    UIImageView *imageBg;
    if (SCREEN_WIDTH / scan < SCREEN_HEIGHT ) {
        imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } else {
        imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / scan)];
    }
    [imageBg setUserInteractionEnabled:YES];
    [imageBg setImage:[UIImage imageNamed:@"BGALPHA"]];
    //    scrollerClothesDetail.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
    [scrollerClothesDetail addSubview:imageBg];
    
    
    [scrollerClothesDetail addSubview:detailLabel];
    scrollerClothesDetail.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_WIDTH / scan);
    [self.view addSubview:scrollerClothesDetail];
     
    [scrollerClothesDetail setAlpha:0];
}

-(void)createPage
{
    for (int i = 0; i < 3; i++) {
        UIImage *image = [UIImage imageNamed:@"toBuyNew"];
        uiimageShowViewController *imageVC = [[uiimageShowViewController alloc]init];
        imageVC.image = image;
        
        [_dataArray addObject:imageVC];
        
//        uiimageShowViewController *imageVC = [[uiimageShowViewController alloc]init];
//        imageVC.imageUrl = pictureArray[i];
//        [_dataArray addObject:imageVC];
    }
    
    //设置第三个参数
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    
    //初始化UIPageViewController
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    //指定代理
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    //设置frame
    _pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //是否双面显示，默认为NO
    _pageViewController.doubleSided = NO;
    
    //设置首页显示数据
    uiimageShowViewController *imageViewController = [self createImage:0];
    NSArray *array = [NSArray arrayWithObjects:imageViewController, nil];
    [_pageViewController setViewControllers:array
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:YES
                                 completion:nil];
    
    //添加pageViewController到Controller
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];

}

//获取指定显示controller
-(uiimageShowViewController *)createImage:(NSInteger)integer
{
    return [_dataArray objectAtIndex:integer];
}

//获取显示controller元素下标
-(NSInteger)integerWithController:(uiimageShowViewController *)vc
{
    return [_dataArray indexOfObject:vc];
}


#pragma mark - UIPageViewControllerDataSource
//显示前一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger integer = [self integerWithController:(uiimageShowViewController *)viewController];
    [self hiddenChoose];
    if (integer == 0 || integer == NSNotFound) {
        
        return nil;
    }
    integer--;
    pageCntroller.currentPage = integer;
    return [self createImage:integer];
}

//显示下一页
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self integerWithController:(uiimageShowViewController *)viewController];
   
    if (index == NSNotFound)
    {
        [self showPrice];
        return nil;
    }
    index++;
    if (index == _dataArray.count)
    {
        [self showPrice];
        return nil;
    }
    
    [self hiddenChoose];
    pageCntroller.currentPage = index;
    
    return [self createImage:index];
    
}

//返回页控制器中页的数量
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 13;
}

//返回页控制器中当前页的索引
-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - UIPageViewControllerDelegate
//翻页视图控制器将要翻页时执行的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    NSLog(@"将要翻页也就是手势触发时调用方法");
}

//可以通过返回值重设书轴类型枚举
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return UIPageViewControllerSpineLocationMin;
}

//返回页控制器中控制器的页内容控制器数
-(UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController
{
    return _dataArray.count;
}


//防止上一个动画还没有结束,下一个动画就开始了
//当用户从一个页面转向下一个或者前一个页面,或者当用户开始从一个页面转向另一个页面的途中后悔 了,并撤销返回到了之前的页面时,将会调用这个方法。假如成功跳转到另一个页面时,transitionCompleted 会被置成 YES,假如在跳转途中取消了跳转这个动作将会被置成 NO。
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(finished && completed)
    {
        // 无论有无翻页，只要动画结束就恢复交互。
        pageViewController.view.userInteractionEnabled = YES;
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
