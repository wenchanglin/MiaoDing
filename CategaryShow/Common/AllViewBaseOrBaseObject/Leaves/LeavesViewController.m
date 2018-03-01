//
//  LeavesViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import "LeavesViewController.h"
#import "LeavesView.h"

@interface LeavesViewController ()  <LeavesViewDataSource, LeavesViewDelegate>

@end

@implementation LeavesViewController
{
    UILabel *pageNumber;
    NSInteger pageN;
    
}
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    if (self = [super initWithNibName:nibName bundle:nibBundle]) {
        pageN = 1;
        _leavesView = [[LeavesView alloc] initWithFrame:CGRectZero];
        _leavesView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _leavesView.dataSource = self;
        _leavesView.delegate = self;
    }
    return self;
}

- (void)dealloc {
	[_leavesView release];
    [super dealloc];
}

#pragma mark LeavesViewDataSource

- (NSUInteger)numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return 0;
}

- (void)renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	
}

-(void)leavesView:(LeavesView *)leavesView didTurnToPageAtIndex:(NSUInteger)pageIndex
{
    NSLog(@"%ld", pageIndex);

}


-(void)leavesViewDidTurnToLastPage
{
//    NSLog(@"dasdfasdfasdfas");
}

#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 76, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 74 - 20)];
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = getUIColor(Color_saveColor).CGColor;
    [self.view addSubview:bgView];
    _leavesView.frame = CGRectMake(10, 74, bgView.frame.size.width - 2, bgView.frame.size.height - 2);
    [_leavesView setBackgroundColor:getUIColor(Color_myOrderBack)];
	[self.view addSubview:_leavesView];
    [_leavesView.layer setBorderWidth:1];
    [_leavesView.layer setBorderColor:getUIColor(Color_saveColor).CGColor];
    UIView *viewUnToClick = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 200 )];
    viewUnToClick.center = _leavesView.center;
    [self.view addSubview:viewUnToClick];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickImage)];
    [viewUnToClick addGestureRecognizer:tap];
    
    
    
    _pageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leavesView.frame.size.width - 100, _leavesView.frame.size.height - 30, 90, 20)];
    [_pageNumberLabel setFont:[UIFont systemFontOfSize:14]];
    [_leavesView addSubview:_pageNumberLabel];
    [_pageNumberLabel setText:@"- 1 / 9-"];
    [_pageNumberLabel setTextAlignment:NSTextAlignmentRight];
	[_leavesView reloadData];
}

-(void)ClickImage{
    
}

@end
