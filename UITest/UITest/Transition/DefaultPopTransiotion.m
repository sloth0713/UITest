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
}

- (void)animateTransitionPop:(id<UIViewControllerContextTransitioning>)transitionContext 
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    [[transitionContext containerView] addSubview:toVC.view];

    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect startFrame = CGRectOffset(finalFrame, -finalFrame.size.width, 0);

    toVC.view.frame = startFrame;

    // 执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.frame = finalFrame;
        //原来frame加一个width，加width就是view向右走
        fromVC.view.frame = CGRectOffset(fromVC.view.frame, fromVC.view.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
