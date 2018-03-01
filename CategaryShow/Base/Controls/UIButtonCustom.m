//
//  UIButtonCustom.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/24.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "UIButtonCustom.h"
#import "CommonFunction.h"

@implementation UIButtonCustom

@synthesize buttonType = _buttonType;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init {
    self = [super init];
    
    _buttonType = UIButtonCustomTypeOfHorizontal;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    _buttonType = UIButtonCustomTypeOfHorizontal;
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    _buttonType = UIButtonCustomTypeOfHorizontal;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.buttonType == UIButtonCustomTypeOfHorizontal) {
        // 处理布置
        [CommonFunction setLabelTextSize:self.titleLabel maxWidth:self.bounds.size.width - self.sizeImage.width isAuto:YES];
        
        
        CGFloat intMargin = (self.bounds.size.width - self.sizeImage.width - self.titleLabel.frame.size.width) / 5;
        
        CGRect rectFrame = self.imageView.frame;
        
        rectFrame.origin.x = intMargin;
        rectFrame.origin.y = (self.bounds.size.height - self.sizeImage.height) / 2;
        rectFrame.size.width = self.sizeImage.width;
        rectFrame.size.height = self.sizeImage.height;
        
        [self.imageView setFrame:rectFrame];
        
        rectFrame = self.titleLabel.frame;
        
        rectFrame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + intMargin * 2;
        rectFrame.origin.y = (self.bounds.size.height - self.titleLabel.frame.size.height) / 2;
        
        [self.titleLabel setFrame:rectFrame];
    }
    else if (self.buttonType == UIButtonCustomTypeOfVertical) {
        // 处理布置
        [CommonFunction setLabelTextSize:self.titleLabel maxWidth:self.bounds.size.width isAuto:YES];
        
        
        CGFloat intMargin = (self.bounds.size.height - self.sizeImage.height - self.titleLabel.frame.size.height) / 5;
        
        CGRect rectFrame = self.imageView.frame;
        
        rectFrame.origin.x = (self.bounds.size.width - self.sizeImage.width) / 2;
        rectFrame.origin.y = intMargin * 2;
        rectFrame.size.width = self.sizeImage.width;
        rectFrame.size.height = self.sizeImage.height;
        
        [self.imageView setFrame:rectFrame];
        
        rectFrame = self.titleLabel.frame;
        
        rectFrame.origin.x = (self.bounds.size.width - rectFrame.size.width) / 2;
        
        rectFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + intMargin;
                
        [self.titleLabel setFrame:rectFrame];
    }
}

@end
