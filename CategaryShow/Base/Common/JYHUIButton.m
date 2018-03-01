//
//  JYHUIButton.m
//  SameCityBuisness
//
//  Created by 黄 梦炜 on 14-2-17.
//  Copyright (c) 2014年 黄 梦炜. All rights reserved.
//

#import "JYHUIButton.h"

@interface JYHUIButton()



@property (nonatomic,retain) UIColor* backColorHighLighted;

@property (nonatomic,retain) UIColor* backColorNormal;

@end

@implementation JYHUIButton


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews{
    [self remaskIfNecessary];
    [super layoutSubviews];
}

- (void) setBackgroundColor:(UIColor *)color forState:(UIControlState)state{
    
    if (state == UIControlStateNormal){
        [super setBackgroundColor:color];
        
        self.backColorNormal = color;
    }
    else if (state == UIControlStateHighlighted){
        self.backColorHighLighted = color;
    }
    
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted || self.selected) {
        if (self.backColorHighLighted != nil)
            [self setBackgroundColor:self.backColorHighLighted];
    }
    else {
        if (self.backColorNormal != nil)
            [self setBackgroundColor:self.backColorNormal];
    }
}

- (void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected || self.highlighted) {
        if (self.backColorHighLighted != nil)
            [self setBackgroundColor:self.backColorHighLighted];
    }
    else {
        if (self.backColorNormal != nil)
            [self setBackgroundColor:self.backColorNormal];
    }
}

@end
