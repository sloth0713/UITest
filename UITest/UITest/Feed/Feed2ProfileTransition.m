//
//  Feed2ProfileTransition.m
//  UITest
//
//  Created by ByteDance on 2024/10/25.
//

#import "Feed2ProfileTransition.h"

@implementation Feed2ProfileTransition

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext 
{
//    [self animateTransitionLeftPush:transitionContext];
    [self animateTransitionScale:transitionContext];
}


- (void)animateTransitionLeftPush:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]; // 获取push到的目标视图控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]; // 获取从哪个视图控制器push过来的
    UIView *containerView = [transitionContext containerView]; // 获取转场的容器视图
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC]; // 获取目标视图控制器最终的frame

    // 将目标视图添加到容器视图中
    [containerView addSubview:toVC.view];

    // 设置目标视图的初始frame
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect initialFrame = CGRectOffset(finalFrame, screenBounds.size.width, 0);
    toVC.view.frame = initialFrame;

    // 执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = CGRectOffset(fromVC.view.frame, -screenBounds.size.width / 2.0, 0); // 将当前视图向左移动一半的距离
        toVC.view.frame = finalFrame; // 将目标视图移动到最终frame
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES]; // 转场动画完成，调用 completeTransition
    }];
}

- (void)animateTransitionScale:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];

    NSTimeInterval duration = [self transitionDuration:transitionContext];
//    duration = 0.011;

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
    return 0.1;
}

@end
