//
//  UIGestureRecognizer+Test.m
//  UITest
//
//  Created by ByteDance on 2024/10/31.
//

#import "UIGestureRecognizer+Test.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (Test)
+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hookMethod:@selector(touchesBegan:withEvent:) swizzledSelectorPop:@selector(transition_touchesBegan:withEvent:)];
        
//        [self hookMethod:@selector(pushViewController:animated:) swizzledSelectorPop:@selector(transition_pushViewController:animated:)];
//        
//        [self hookMethod:@selector(popViewControllerAnimated:) swizzledSelectorPop:@selector(transition_popViewControllerAnimated:)];
        
        
    });
}

+ (void)hookMethod:(SEL)originalSelector swizzledSelectorPop:(SEL)swizzledSelector
{
    Method originalMethodPop = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethodPop = class_getInstanceMethod([self class], swizzledSelector);
    method_exchangeImplementations(originalMethodPop, swizzledMethodPop);
}

- (void)transition_touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@_touchesBegan", self.name);
    [self transition_touchesBegan:touches withEvent:event];
}



@end

@implementation UIPanGestureRecognizer(Test)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hookMethod:@selector(touchesBegan:withEvent:) swizzledSelectorPop:@selector(transition_touchesBegan:withEvent:)];
    
        
        
    });
}

+ (void)hookMethod:(SEL)originalSelector swizzledSelectorPop:(SEL)swizzledSelector
{
    Method originalMethodPop = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethodPop = class_getInstanceMethod([self class], swizzledSelector);
    method_exchangeImplementations(originalMethodPop, swizzledMethodPop);
}

- (void)transition_touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@_touchesBegan", self.name);
    [self transition_touchesBegan:touches withEvent:event];
}

@end

