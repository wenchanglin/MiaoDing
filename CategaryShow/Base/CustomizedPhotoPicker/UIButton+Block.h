//
//  UIButton+Block.h
//  PluginsDemo
//
//  Created by Eric Che on 12/2/14.
//  Copyright (c) 2014 Eric Che. All rights reserved.
//
#define kUIButtonBlockTouchUpInside @"TouchInside"

#import <UIKit/UIKit.h>

@interface UIButton (Block)

@property (nonatomic, strong) NSMutableDictionary *actions;

- (void)addBlock:(void (^)(void))block forControlEvents:(UIControlEvents)event;

@end

