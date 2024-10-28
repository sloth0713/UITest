//
//  UINavigationController+Transition.m
//  GestureTest
//
//  Created by ByteDance on 2024/10/18.
//

#import "UINavigationController+Transition.h"
#import "DefaultTransitionDelegate.h"
#import <objc/runtime.h>

//void hookMethod:

@implementation UINavigationController (Transition)

+(void)hookDelegate
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hookMethod:@selector(setDelegate:) swizzledSelectorPop:@selector(transition_setDelegate:)];
        
        [self hookMethod:@selector(pushViewController:animated:) swizzledSelectorPop:@selector(transition_pushViewController:animated:)];
        
        [self hookMethod:@selector(popViewControllerAnimated:) swizzledSelectorPop:@selector(transition_popViewControllerAnimated:)];
        
        
    });
}

+ (void)hookMethod:(SEL)originalSelector swizzledSelectorPop:(SEL)swizzledSelector
{
    Method originalMethodPop = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethodPop = class_getInstanceMethod([self class], swizzledSelector);
    method_exchangeImplementations(originalMethodPop, swizzledMethodPop);
}

- (void)transition_setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    [self transition_setDelegate:delegate];
}

//[UINavigationController initWithRootViewController:]会自动调用到pushViewController
- (void)transition_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!self.delegate){
        
        TransitionContext *context  = [[TransitionContext alloc] init];
        self.transition_navigationProxyDelegate = [[DefaultTransitionDelegate alloc] initWithContext:context];
        self.delegate = self.transition_navigationProxyDelegate;
    }
    self.transition_navigationProxyDelegate.context.type = TransitionTypePush;
    [self transition_pushViewController:viewController animated:animated];
}

- (UIViewController *)transition_popViewControllerAnimated:(BOOL)animated
{
    if (!self.delegate){
        TransitionContext *context  = [[TransitionContext alloc] init];
        self.transition_navigationProxyDelegate = [[DefaultTransitionDelegate alloc] initWithContext:context];
        self.delegate = self.transition_navigationProxyDelegate;
    }
    self.transition_navigationProxyDelegate.context.type = TransitionTypePop;
    return [self transition_popViewControllerAnimated:animated];
}

//- (id<UINavigationControllerDelegate>)transition_delegate
//{
//    NSLog(@"fdas");
//    if (!self.delegate){
//        self.delegate = [[DefaultTransitionDelegate alloc] init];
//        [self transition_setDelegate:[[DefaultTransitionDelegate alloc] init]];
//    }
//    return [self transition_delegate];
////    [self transition_setDelegate:delegate];
//}

- (void)setTransition_navigationProxyDelegate:(DefaultTransitionDelegate *)transition_navigationProxyDelegate
{
    //分类不能新增属性，所以这样添加
    objc_setAssociatedObject(self, @selector(transition_navigationProxyDelegate), transition_navigationProxyDelegate, OBJC_ASSOCIATION_RETAIN);
}

- (DefaultTransitionDelegate *)transition_navigationProxyDelegate
{
    return objc_getAssociatedObject(self, _cmd);
}


@end
