//
//  YHFlowerMenu.h
//  FAFancyMenuExample
//
//  Created by baiwei－mac on 16/7/14.
//  Copyright © 2016年 Fancy App. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YHFlowerDelegate <NSObject>

/*!按钮点击后的回调*/
- (void)flowerButtonSelected:(NSInteger)index clickPoint:(CGPoint)point;

@end



@interface YHFlowerMenu : UIView

/*!是否是展开状态*/
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic,assign) CGPoint clickPoint;
@property (nonatomic, weak, nullable) id <YHFlowerDelegate> delegate;

/*!通过该方法构造，传入父view*/
- (nullable instancetype)initWithSuperView:(nonnull UIView *)sView buttonArray:(nonnull NSArray *)buttonImages;
/*!出现*/
- (void)show;
/*!消失*/
- (void)hide;

@end
