//
//  UINavigationController+Transition.m
//  GestureTest
//
//  Created by ByteDance on 2024/10/18.
//

#import "UINavigationController+Transition.h"
#import <objc/runtime.h>

@implementation UINavigationController (Transition)

+(void)hookDelegate
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(setDelegate:);
        SEL swizzledSelector = @selector(transition_setDelegate:);
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }); 
}

- (void)transition_setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    NSLog(@"fdas");
    [self transition_setDelegate:delegate];
}

@end
