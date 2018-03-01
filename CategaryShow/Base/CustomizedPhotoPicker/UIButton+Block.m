//
//  UIButton+Block.m
//  PluginsDemo
//
//  Created by Eric Che on 12/2/14.
//  Copyright (c) 2014 Eric Che. All rights reserved.
//


#import "UIButton+block.h"
#import <objc/runtime.h>

static char BUTTON_BLOCK;

@implementation UIButton (block)

- (void)addBlock:(void (^)(void))block forControlEvents:(UIControlEvents)event {
    self.didTapped = block;
    [self addTarget:self action:@selector(callBlock:) forControlEvents:event];
}

-(void)callBlock:(id)sender{
    self.didTapped();
}

- (void (^)())didTapped {
    
    return objc_getAssociatedObject(self, &BUTTON_BLOCK);
}

- (void)setDidTapped:(void (^)())didTapped {
    
    objc_setAssociatedObject(self, &BUTTON_BLOCK, didTapped, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//-(void) dealloc{
//    Block_release(self.didTapped);
////    [super dealloc];
//}

@end
