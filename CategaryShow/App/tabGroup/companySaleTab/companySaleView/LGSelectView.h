//
//  LGSelectView.h
//  LGSelectBtnDemo
//
//  Created by 雨逍 on 16/8/23.
//  Copyright © 2016年 刘干. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGSelectViewDelegate <NSObject>

-(void)buttonClick:(NSInteger )tag;

@end

@interface LGSelectView : UIView<UIScrollViewDelegate>


@property (nonatomic, retain) NSMutableArray *ImageArray;

@property (nonatomic, weak) id<LGSelectViewDelegate> delegate;
@end
