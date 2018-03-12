//
//  MYSegmentViewWhite.m
//  CategaryShow
//
//  Created by 文长林 on 2018/3/10.
//  Copyright © 2018年 Mr.huang. All rights reserved.
//

#import "MYSegmentViewWhite.h"

@implementation MYSegmentViewWhite
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray ParentController:(UIViewController *)parentC  lineWidth:(float)lineW lineHeight:(float)lineH
{
    if ( self=[super initWithFrame:frame  ])
    {
        float avgWidth = (frame.size.width/controllers.count);
        
        self.controllers=controllers;
        self.nameArray=titleArray;
        
        self.segmentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 43)];
        self.segmentView.tag=50;
        self.segmentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.segmentView];
        self.segmentScrollV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 43, frame.size.width, frame.size.height -43)];
        self.segmentScrollV.contentSize=CGSizeMake(frame.size.width*self.controllers.count, 0);
        self.segmentScrollV.delegate=self;
        self.segmentScrollV.showsHorizontalScrollIndicator=NO;
        self.segmentScrollV.pagingEnabled=YES;
        self.segmentScrollV.bounces=NO;
        [self addSubview:self.segmentScrollV];
        
        for (int i=0;i<self.controllers.count;i++)
        {
            UIViewController * contr=self.controllers[i];
            [self.segmentScrollV addSubview:contr.view];
            contr.view.frame=CGRectMake(i*frame.size.width, 0, frame.size.width,frame.size.height);
            [parentC addChildViewController:contr];
            [contr didMoveToParentViewController:parentC];
        }
        for (int i=0;i<self.controllers.count;i++)
        {
            UIButton * btn=[ UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(i*(frame.size.width/self.controllers.count), 0, frame.size.width/self.controllers.count, 40);
            btn.tag=i;
            [btn setTitle:self.nameArray[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:(UIControlStateNormal)];
            [btn setTitleColor:[UIColor colorWithHexString:@"#4F4F4F"] forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(Click:) forControlEvents:(UIControlEventTouchUpInside)];
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
            
            //            if (i==0)
            //            {btn.selected=YES ;self.seleBtn=btn;
            //                btn.titleLabel.font=[UIFont systemFontOfSize:19];
            //            } else { btn.selected=NO; }
            
            [self.segmentView addSubview:btn];
        }
        
        self.down=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, 1)];
        self.down.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];//getUIColor(Color_background);
        [self.segmentView addSubview:self.down];
        
        self.line=[[UILabel alloc]initWithFrame:CGRectMake((avgWidth-lineW)/2,35-lineH, lineW, lineH)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#4F4F4F"];
        self.line.tag=100;
        [self.segmentView addSubview:self.line];
    }
    
    
    return self;
}

- (void)Click:(UIButton*)sender
{
    self.seleBtn.titleLabel.font= [UIFont fontWithName:@"PingFangSC-Light" size:16];
    self.seleBtn.selected=NO;
    self.seleBtn=sender;
    self.seleBtn.selected=YES;
    self.seleBtn.titleLabel.font= [UIFont fontWithName:@"PingFangSC-Light" size:16];
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint  frame=self.line.center;
        frame.x=self.frame.size.width/(self.controllers.count*2) +(self.frame.size.width/self.controllers.count)* (sender.tag);
        self.line.center=frame;
    }];
    [self.segmentScrollV setContentOffset:CGPointMake((sender.tag)*self.frame.size.width, 0) animated:YES ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectVC" object:sender userInfo:nil];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint  frame=self.line.center;
        frame.x=self.frame.size.width/(self.controllers.count*2) +(self.frame.size.width/self.controllers.count)*(self.segmentScrollV.contentOffset.x/self.frame.size.width);
        self.line.center=frame;
    }];
    UIButton * btn=(UIButton*)[self.segmentView viewWithTag:(self.segmentScrollV.contentOffset.x/self.frame.size.width)];
    self.seleBtn.selected=NO;
    self.seleBtn=btn;
    self.seleBtn.selected=YES;
}

@end
