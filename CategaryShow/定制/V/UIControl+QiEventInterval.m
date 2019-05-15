//
//  UIButton+QiEventInterval.m
//  CategaryShow
//
//  Created by 文长林 on 2019/2/28.
//  Copyright © 2019年 Mr.huang. All rights reserved.
//

#import "UIControl+QiEventInterval.h"
#import <objc/runtime.h>
@interface UIControl ()
@property (nonatomic, assign) BOOL eventUnavailable;
@end
static char * const qi_eventIntervalKey = "qi_eventIntervalKey";
static char * const eventUnavailableKey = "eventUnavailableKey";
@implementation UIControl (QiEventInterval)
+ (void)load {
    
    Method method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method qi_method = class_getInstanceMethod(self, @selector(qi_sendAction:to:forEvent:));
    method_exchangeImplementations(method, qi_method);
}


#pragma mark - Action functions

- (void)qi_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.eventUnavailable == NO) {
        self.eventUnavailable = YES;
        [self qi_sendAction:action to:target forEvent:event];
        [self performSelector:@selector(setEventUnavailable:) withObject:@(NO) afterDelay:self.qi_eventInterval];
    }
}


#pragma mark - Setter & Getter functions

- (NSTimeInterval)qi_eventInterval {
    
    return [objc_getAssociatedObject(self, qi_eventIntervalKey) doubleValue];
}

- (void)setQi_eventInterval:(NSTimeInterval)qi_eventInterval {
    
    objc_setAssociatedObject(self, qi_eventIntervalKey, @(qi_eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)eventUnavailable {
    
    return [objc_getAssociatedObject(self, eventUnavailableKey) boolValue];
}

- (void)setEventUnavailable:(BOOL)eventUnavailable {
    objc_setAssociatedObject(self, eventUnavailableKey, @(eventUnavailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
