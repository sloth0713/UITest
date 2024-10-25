//
//  FullScreenPopTransition.m
//  UITest
//
//  Created by ByteDance on 2024/10/25.
//

#import "FullScreenPopTransition.h"

@implementation FullScreenPopTransition

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    [self animateTransitionScale:transitionContext];
}

- (void)animateTransitionScale:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];

    NSTimeInterval duration = [self transitionDuration:transitionContext];

    toVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:duration
                     animations:^{
//            toVC.view.transform = CGAffineTransformMakeScale(1, 1);
        toVC.view.transform = CGAffineTransformIdentity;
        }
                     completion:^(BOOL finished) {

                [transitionContext completeTransition:YES];
                        NSLog(@"animations completion");
    }];
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}


@end
