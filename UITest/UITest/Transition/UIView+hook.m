//
//  UIView+hook.m
//  UITest
//
//  Created by ByteDance on 2024/12/31.
//

#import "UIView+hook.h"
#import <objc/runtime.h>
@implementation UIView (hook)


+(void)hookDelegate
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self hookMethod:@selector(_didMoveFromWindow:toWindow:) swizzledSelectorPop:@selector(hook_didMoveFromWindow:toWindow:)];
        [self hookMethod:@selector(_postMovedFromSuperview:) swizzledSelectorPop:@selector(hook_postMovedFromSuperview:)];
        [self hookMethod:@selector(didMoveToWindow) swizzledSelectorPop:@selector(hook_didMoveToWindow)];
        [self hookMethod:@selector(addSubview:) swizzledSelectorPop:@selector(hook_addSubview:)];
    
    
    });
}

+ (void)hookMethod:(SEL)originalSelector swizzledSelectorPop:(SEL)swizzledSelector
{
    Method originalMethodPop = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethodPop = class_getInstanceMethod([self class], swizzledSelector);
    method_exchangeImplementations(originalMethodPop, swizzledMethodPop);
}

- (void)hook_didMoveToWindow
{
    NSLog(@"hook_didMoveToWindow");
    [self hook_didMoveToWindow];
}

- (void)hook_postMovedFromSuperview:(id)view
{
    NSLog(@"hook_postMovedFromSuperview");
    [self hook_postMovedFromSuperview:view];
}

- (void)hook_didMoveFromWindow:(id)window toWindow:(id)toWindow
{
    NSLog(@"hook_didMoveFromWindow");
    [self hook_didMoveFromWindow:window toWindow:toWindow];
}

- (void)hook_addSubview:(id)subView
{
    NSLog(@"hook_addSubview");
    [self hook_addSubview:subView];
}

@end
