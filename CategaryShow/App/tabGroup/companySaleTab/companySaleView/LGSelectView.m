//
//  LGSelectView.m
//  LGSelectBtnDemo
//
//  Created by 雨逍 on 16/8/23.
//  Copyright © 2016年 刘干. All rights reserved.
//

#import "LGSelectView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define LOADIMAGE(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:@"png"]]

@implementation LGSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    
    return self;
}

-(void)setImageArray:(NSMutableArray *)imageArray
{
    _ImageArray = imageArray;
    [self creatView];
}

-(void)creatView
{
    UIScrollView * scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
    scrollV.contentSize = CGSizeMake(3 * SCREEN_WIDTH + SCREEN_WIDTH*2/3, 100);
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.delegate = self;
    scrollV.tag = 10086;
    [self addSubview:scrollV];
    
//    NSMutableArray * imageNameArr = [[NSMutableArray alloc]initWithObjects:[UIColor clearColor],[UIColor grayColor],[UIColor redColor],[UIColor greenColor],[UIColor orangeColor],[UIColor blackColor],[UIColor yellowColor],[UIColor cyanColor],[UIColor clearColor], nil];
    
    for (int i = 0; i < [_ImageArray count]; i ++)
    {
        UIButton * btn = [[UIButton alloc]init];
        btn.tag = 10010+i;
        
        float offsizeX = fabs(SCREEN_WIDTH/6 * (2 * i + 1)- SCREEN_WIDTH/2 - scrollV.contentOffset.x);
        double offsizeY = sqrt(fabs(SCREEN_WIDTH * SCREEN_WIDTH / 4 - offsizeX*offsizeX));
        
        btn.center = CGPointMake(SCREEN_WIDTH/6 * (2 * i + 1),SCREEN_WIDTH/2 - offsizeY + SCREEN_WIDTH/4);
        btn.bounds = CGRectMake(0, 0,  (SCREEN_WIDTH/2-offsizeX)/(SCREEN_WIDTH/2)*40+20, (SCREEN_WIDTH/2-offsizeX)/(SCREEN_WIDTH/2)*40+20);
        
        [btn setBackgroundImage:[UIImage imageNamed:_ImageArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollV addSubview:btn];
        
        if (i == 0 || i == [_ImageArray count] - 1)
        {
            btn.enabled = NO;
        }
    }

}

-(void)btnClick:(UIButton *)btn
{
    UIScrollView * scrollView = (UIScrollView *)[self viewWithTag:10086];
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH/3 * (btn.tag-10010-1), 0) animated:YES];
    if ([_delegate respondsToSelector:@selector(buttonClick:)]) {
        [_delegate buttonClick:btn.tag];
    }
}

//scrollerView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int location = 0;
    
    location = scrollView.contentOffset.x/(SCREEN_WIDTH/3);
    
    for (int i = 0; i < [_ImageArray count]; i ++)
    {
        UIButton * Btn = (UIButton *)[self viewWithTag:10010+i];
        
        float offsizeX = fabs(Btn.center.x- SCREEN_WIDTH/2 - scrollView.contentOffset.x);
        double offsizeY = sqrt(fabs(SCREEN_WIDTH * SCREEN_WIDTH / 4 - offsizeX*offsizeX));
        
        Btn.center = CGPointMake(Btn.center.x,SCREEN_WIDTH/2- offsizeY + SCREEN_WIDTH/4);
        Btn.bounds = CGRectMake(0, 0,  (SCREEN_WIDTH/2-offsizeX)/(SCREEN_WIDTH/2)*40+20, (SCREEN_WIDTH/2-offsizeX)/(SCREEN_WIDTH/2)*40+20);
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    int location = 0;
    
    CGFloat yy = scrollView.contentOffset.x/(SCREEN_WIDTH/3);
    
    int xx  = yy*([_ImageArray count] - 1);
    if (xx%([_ImageArray count] - 1) >= ([_ImageArray count] - 1) / 2)
    {
        location = xx/([_ImageArray count] - 1) +1;
    }else
    {
        location = xx/([_ImageArray count] - 1);
    }
    
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH/3 * location, 0) animated:YES];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int location = 0;
    
    CGFloat yy = scrollView.contentOffset.x/(SCREEN_WIDTH/3);
    
    int xx  = yy*([_ImageArray count] - 1);
    if (xx%([_ImageArray count] - 1) >= ([_ImageArray count] - 1) / 2)
    {
        location = xx/([_ImageArray count] - 1) +1;
    }else
    {
        location = xx/([_ImageArray count] - 1);
    }
    
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH/3 * location, 0) animated:YES];
}



@end
