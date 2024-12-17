//
//  DefaultPushTransiotion.m
//  UITest
//
//  Created by ByteDance on 2024/10/28.
//

#import "DefaultPushTransiotion.h"

@implementation DefaultPushTransiotion

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    [self animateTransitionLeftPush:transitionContext];
//    [self animateTransitionRightPush:transitionContext];
}

- (void)animateTransitionLeftPush:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]; // 获取push到的目标视图控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]; // 获取从哪个视图控制器push过来的
    UIView *containerView = [transitionContext containerView]; // 获取转场的容器视图
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC]; // 获取目标视图控制器最终的frame

    // 将目标视图添加到容器视图（UINavigationTransitionView）中
    [containerView addSubview:toVC.view];

    // 设置目标视图的初始frame
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //右移tovc
    CGRect initialFrame = CGRectOffset(finalFrame, screenBounds.size.width, 0);
    toVC.view.frame = initialFrame;

    // 执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        fromVC.view.frame = CGRectOffset(fromVC.view.frame, -screenBounds.size.width, 0); // 将当前视图向左移动一半的距离
        toVC.view.frame = finalFrame; // 将目标视图移动到最终frame
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES]; // 转场动画完成，调用 completeTransition
    }];
    
//    想要tovc向左滑动，动画开始前，将tovc右移，即CGRectOffset(finalFrame, screenBounds.size.width, 0);
    //再用动画，将其回到最终位置
}

- (void)animateTransitionRightPush:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toVC.view];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    //左移tovc，回到原位置，动画就是向右的
    toVC.view.frame = CGRectOffset(finalFrame, -finalFrame.size.width, 0);

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
