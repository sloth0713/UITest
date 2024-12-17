//
//  UIViewController+Transition.m
//  UITest
//
//  Created by ByteDance on 2024/12/12.
//

#import "UIViewController+Transition.h"
#import "DefaultTransitionDelegate.h"
#import <objc/runtime.h>

@implementation UIViewController (Transition)
+(void)hookDelegate
{
    BOOL customVCTransition = YES;
    if (!customVCTransition) return;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hookMethod:@selector(presentViewController:animated:completion:) swizzledSelector:@selector(transition_presentViewController:animated:completion:)];
        [self hookMethod:@selector(dismissViewControllerAnimated:completion:) swizzledSelector:@selector(transition_dismissViewControllerAnimated:completion:)];
    });
}

+ (void)hookMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Method originalMethodPop = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethodPop = class_getInstanceMethod([self class], swizzledSelector);
    method_exchangeImplementations(originalMethodPop, swizzledMethodPop);
}

- (void)transition_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{

    TransitionContext *context  = [[TransitionContext alloc] init];
    DefaultTransitionDelegate *transition_VCProxyDelegate = [[DefaultTransitionDelegate alloc] initWithContext:context];
    transition_VCProxyDelegate.context.type = TransitionTypePush;
    viewControllerToPresent.transitioningDelegate = transition_VCProxyDelegate;
    [self transition_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)transition_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    TransitionContext *context  = [[TransitionContext alloc] init];
    DefaultTransitionDelegate *transition_VCProxyDelegate = [[DefaultTransitionDelegate alloc] initWithContext:context];
    transition_VCProxyDelegate.context.type = TransitionTypePop;
    self.transitioningDelegate = transition_VCProxyDelegate;
    [self transition_dismissViewControllerAnimated:flag completion:completion];
}

- (void)setTransition_VCProxyDelegate:(DefaultTransitionDelegate *)transition_VCProxyDelegate
{
    //分类不能新增属性，所以这样添加
    objc_setAssociatedObject(self, @selector(transition_VCProxyDelegate), transition_VCProxyDelegate, OBJC_ASSOCIATION_RETAIN);
}

- (DefaultTransitionDelegate *)transition_VCProxyDelegate
{
    return objc_getAssociatedObject(self, _cmd);
}


@end
