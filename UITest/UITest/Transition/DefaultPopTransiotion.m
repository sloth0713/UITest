//
//  DefaultPopTransiotion.m
//  UITest
//
//  Created by ByteDance on 2024/10/28.
//

#import "DefaultPopTransiotion.h"

@implementation DefaultPopTransiotion


- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    [self animateTransitionPop:transitionContext];
    
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    [self startDefaultAnimationWithFromVC:fromVC toVC:toVC fromContextProvider:nil toContextProvider:nil containerView:transitionContext.containerView context:nil completionHandler:nil duration:0.3 transitionContext:transitionContext];
}

- (void)startDefaultAnimationWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromContextProvider:(NSObject *)fromCP toContextProvider:(NSObject *)toCP containerView:(UIView *)containerView context:(id<UIViewControllerContextTransitioning>)context  completionHandler:(void (^)(BOOL))completionHander duration:(CGFloat)duration transitionContext:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *backDropView = [[UIView alloc] init];
    backDropView.frame = toVC.view.bounds;

    [containerView insertSubview:toVC.view belowSubview:fromVC.view];//to放在from下面
    [containerView insertSubview:backDropView belowSubview:fromVC.view];//backDropView放在from下面，to上面
    CGRect startFrame = toVC.view.frame;
    startFrame.origin.x = (-0.3) * containerView.bounds.size.width;//to移动屏幕的左边
    startFrame.origin.y = fromVC.view.frame.origin.y;
    toVC.view.frame = startFrame;

    UIViewController *toPresentedVC = toVC.presentedViewController;
    UIView *toTransitionView = nil;
    if (!toVC.definesPresentationContext || toVC != toPresentedVC.presentingViewController) {
        toPresentedVC = nil;
    }
    if (toPresentedVC) {
        toTransitionView = toPresentedVC.view;
        while (toTransitionView.superview != nil) {
            toTransitionView = toTransitionView.superview;
        }
        [containerView insertSubview:toTransitionView aboveSubview:toVC.view];//UIWindow加到了TransitionContainerView里了，所以crash
        CGRect startFrame = toTransitionView.frame;
        startFrame.origin.x = (-0.3) * containerView.bounds.size.width;
        toTransitionView.frame = startFrame;
        toTransitionView.hidden = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            toTransitionView.hidden = NO;
            [containerView insertSubview:toTransitionView aboveSubview:toVC.view];
        });
    }



    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                                                                                                                                                        CGRect toViewTargetFrame = [context finalFrameForViewController:toVC];
                                                                                                                                                                        if (CGRectEqualToRect(toViewTargetFrame, CGRectZero)) {
                                                                                                                                                                            toViewTargetFrame = containerView.bounds;
                                                                                                                                                                        }

                                                                                                                                                                        CGRect fromViewTargetFrame = [context finalFrameForViewController:fromVC];
                                                                                                                                                                        if (CGRectEqualToRect(fromViewTargetFrame, CGRectZero)) {
                                                                                                                                                                            fromViewTargetFrame = containerView.bounds;
                                                                                                                                                                        
                                                                                                                                                                                fromViewTargetFrame.origin.x -= fromViewTargetFrame.size.width;
                                                                                                                                                                            
                                                                                                                                                                        }

                                                                                                                                                                        fromVC.view.frame = fromViewTargetFrame;
                                                                                                                                                                        toVC.view.frame = toViewTargetFrame;
                                                                                                                                                                        toTransitionView.frame = toViewTargetFrame;
                                                                                                                                                                        backDropView.alpha = 0;
                                                                                                                                                                    } completion:^(BOOL finished) {
                                                                                                                                                                        [backDropView removeFromSuperview];
                                                                                                                                                                        if ([context transitionWasCancelled]) {
                                                                                                                                                                            fromVC.view.frame = containerView.bounds;
                                                                                                                                                                            [toVC.view removeFromSuperview];
                                                                                                                                                                            [toTransitionView removeFromSuperview];
                                                                                                                                                                        } else {
                                                                                                                                                                            [fromVC.view removeFromSuperview];
                                                                                                                                                                        }

                                                                                                                                                                        [transitionContext completeTransition:finished];

//                                                                                                                                                                        completionHander(![context transitionWasCancelled]);
//                                                                                                                                                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                                                                                                                                                                               completionHander(![context transitionWasCancelled]);
//                                                                                                                                                                                           });
                                                                                            
                                                                                                                                                                    }];
}

- (void)animateTransitionPop:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *toPresentedVC = toVC.presentedViewController;//如果是push动画，这里是nil。如果是presentvc，这里是当前的fromVC
    UIView *toTransitionView = nil;
    if (toPresentedVC) {
        toTransitionView = toPresentedVC.view;
        while (toTransitionView.superview != nil) {
            toTransitionView = toTransitionView.superview;
        }
        //此时toTransitionView是UIWindow
        [toTransitionView addSubview:toVC.view];
    }else{
        [[transitionContext containerView] addSubview:toVC.view];
    }
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect startFrame = CGRectOffset(finalFrame, -finalFrame.size.width, 0);

    toVC.view.frame = startFrame;
    
    // 执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.frame = finalFrame;
        //原来frame加一个width，加width就是view向右走
//        fromVC.view.frame = CGRectOffset(fromVC.view.frame, fromVC.view.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [fromVC.view removeFromSuperview];
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
