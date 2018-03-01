//
//  YHFlowerMenu.m
//  FAFancyMenuExample
//
//  Created by baiwei－mac on 16/7/14.
//  Copyright © 2016年 Fancy App. All rights reserved.
//

#define DegreesToRadians(degrees) (degrees * M_PI / 180.f)

#import "YHFlowerMenu.h"

@interface YHFlowerMenuButton : UIButton



/*!角度*/
@property (nonatomic, assign) CGFloat degree;
/*!状态*/
@property (nonatomic, assign) BOOL isShow;

/*!出现*/
- (void)show;
/*!消失*/
- (void)hide;

@end

@implementation YHFlowerMenuButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.anchorPoint = CGPointMake(0.5, 1.f);
        self.layer.position = CGPointMake(frame.size.width/2+frame.origin.x,frame.size.height);
    }
    return self;
}


- (void)show{
    self.hidden = NO;
    [self.layer addAnimation:[self fadeInAnimation] forKey:@"FancyButtonFadeIn"];
}

- (void)hide{
    [self.layer addAnimation:[self rotateAnimationFromDegree:self.degree toDegree:0 delegate:self] forKey:@"FancyButtonRotationBack"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    CABasicAnimation *animation = (CABasicAnimation *)anim;
    if ([animation.keyPath isEqualToString:@"transform.scale"] && flag){
        if (self.isShow) {
            [self.layer addAnimation:[self rotateAnimationFromDegree:0 toDegree:self.degree delegate:nil] forKey:@"FancyButtonRotation"];
            self.transform = CGAffineTransformMakeRotation(DegreesToRadians(self.degree));
        }else {
            self.hidden = YES;
        }
    }else if ([animation.keyPath isEqualToString:@"transform.rotation.z"] && flag){
        [self.layer addAnimation:[self fadeOutAnimation] forKey:@"FancyButtonFadeOut"];
        self.transform = CGAffineTransformMakeRotation(DegreesToRadians(self.degree));
    }
}

- (CABasicAnimation *)fadeInAnimation{
    self.isShow = YES;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, .1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.duration = 0.2;
    scaleAnimation.delegate = self;
    return scaleAnimation;
}

- (CABasicAnimation *)fadeOutAnimation{
    self.isShow = NO;
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, .1)];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.duration = 0.2;
    scaleAnimation.delegate = self;
    return scaleAnimation;
}

- (CABasicAnimation *)rotateAnimationFromDegree:(CGFloat)from toDegree:(CGFloat)to delegate:(id)delegate{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: DegreesToRadians(from)];
    rotationAnimation.toValue = [NSNumber numberWithFloat: DegreesToRadians(to)];
    rotationAnimation.duration = 0.3f;
    rotationAnimation.delegate = delegate;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    return rotationAnimation;
}
@end




@implementation YHFlowerMenu

- (instancetype)initWithSuperView:(UIView *)sView buttonArray:(NSArray *)buttonImages{
    if (self = [super init]) {
        //父view添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [sView addGestureRecognizer:longPress];
        //父view添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [sView addGestureRecognizer:tap];
        [self addButtonWithImage:buttonImages];
    }
    return self;
}

- (void)addButtonWithImage:(NSArray *)images {
    self.frame = CGRectMake(100, 100, ((UIImage *)[images lastObject]).size.height * 2, ((UIImage *)[images lastObject]).size.height * 2);
    if (self.subviews.count > 0) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    NSInteger i = 0;
    CGFloat degree = 360.f/images.count;
    for (UIImage *image in images){
        YHFlowerMenuButton *button = [[YHFlowerMenuButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - image.size.width/2, 0, image.size.width, image.size.height)];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.degree = i*degree;
        button.hidden = YES;
        button.tag = i + 292;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        i++;
    }
}

#pragma mark -手势处理

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender{
    if (self.isShow) {
        //展开，不动作
        return;
    }
    UIView *superView = [sender view];
    CGPoint pressedPoint = [sender locationInView:superView];
    CGPoint newCenter = pressedPoint;
    _clickPoint = pressedPoint;
    if ((pressedPoint.x - self.frame.size.width/2) < 0){
        newCenter.x = self.frame.size.width/2;
    }
    if ((pressedPoint.x + self.frame.size.width/2) > superView.frame.size.width){
        newCenter.x = superView.frame.size.width - self.frame.size.width/2;
    }
    if ((pressedPoint.y - self.frame.size.height/2) <0){
        newCenter.y = self.frame.size.height/2;
    }
    if ((pressedPoint.y + self.frame.size.height/2) > superView.frame.size.height){
        newCenter.y = superView.frame.size.height - self.frame.size.height/2;
    }
    self.center = newCenter;
    [self show];
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    if (!self.isShow) {
        //已经收回，不动作
        return;
    }
    [self hide];
}

#pragma mark -menu动作
- (void)hide{
    for (YHFlowerMenuButton *button in self.subviews){
        [button hide];
    }
    self.isShow = NO;
}

- (void)show{
    self.isShow = YES;
    float delay = 0.f;
    for (YHFlowerMenuButton *button in self.subviews){
        [self performSelector:@selector(showButton:) withObject:button afterDelay:delay];
        delay += 0.05;
    }
}

- (void)showButton:(YHFlowerMenuButton *)button{
    [button show];
}

- (void)hideButton:(YHFlowerMenuButton *)button{
    [button hide];
}

#pragma mark -按钮点击
- (void)buttonPressed:(YHFlowerMenuButton *)button{
    if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(flowerButtonSelected:clickPoint:)]){
            [self.delegate flowerButtonSelected:button.tag - 292 clickPoint:_clickPoint];
        }
    }
}

@end
