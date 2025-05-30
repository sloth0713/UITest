//
//  DefaultPushTransiotion.m
//  UITest
//
//  Created by ByteDance on 2024/10/28.
//

#import "DefaultPushTransiotion.h"
#import <UIKit/UIKit.h>
#import "../../../UITest/UITest/UITest-Bridging-Header.h"

@implementation DefaultPushTransiotion

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
//    [self animateTransitionLeftPush:transitionContext];
//    [self animateTransitionRightPush:transitionContext];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([NSStringFromClass([toVC class]) isEqualToString:@"DetailTableViewController"]) {
        [self animateTransitionMagnify:transitionContext];
    } else {
        [self animateTransitionPropertyAnimator:transitionContext];
    }
//    [self animateTransitionOCPropertyAnimator:transitionContext];
}

- (void)animateTransitionOCPropertyAnimator:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];

    [containerView addSubview:toVC.view];
    

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect initialFrame = CGRectOffset(finalFrame, screenBounds.size.width, 0);
    toVC.view.frame = initialFrame;

    
    UISpringTimingParameters *timing = [[UISpringTimingParameters alloc] initWithMass:1 stiffness:9 damping:61.56 initialVelocity:CGVectorMake(0, 0)];
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 timingParameters:timing];
    
    
    [animator addAnimations:^{
        fromVC.view.frame = CGRectOffset(fromVC.view.frame, -screenBounds.size.width, 0);
        toVC.view.frame = finalFrame;
    }];
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [transitionContext completeTransition:YES]; // 转场动画完成，调用 completeTransition
        NSLog(@"completeTransition");
    }];
    
    CGFloat duration =5;
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.293 :0.453 :0.584 :1]];
    
    [animator startAnimation];
    [CATransaction commit];
}

- (void)animateTransitionPropertyAnimator:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    SwiftPushTransition *transition = [[SwiftPushTransition alloc] init];
    [transition animateTransitionPropertyAnimatorWithTransitionContext:transitionContext];
}


- (void)animateTransitionLeftPush:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]; // 获取push到的目标视图控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey]; // 获取从哪个视图控制器push过来的
    UIView *containerView = [transitionContext containerView]; // 获取转场的容器视图
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC]; // 获取目标视图控制器最终的frame

    /*
     将目标视图添加到容器视图（UIViewControllerWrapperView）中
     如果是navigation push，那么containerView是UIViewControllerWrapperView。如果是UIViewController PresentView那么containerView是一个UITransitionView
     present直接贴了一个UITransitionView在原来的UITransitionView的上面，原来的view都还在，和push不一样，push的话会把原来的view删除
     */
    [containerView addSubview:toVC.view];//会调用到didMoveFromWindow
    
//    UIView *emptyContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
//    [emptyContainerView addSubview:fromVC.view];
    
//    UIView *view= fromVC.view;

    // 设置目标视图的初始frame
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //右移tovc
    CGRect initialFrame = CGRectOffset(finalFrame, screenBounds.size.width, 0);
    toVC.view.frame = initialFrame;

    /*如果转场时长比动画时长长：动画结束后，转场没结束，导致中间时间段，用户无法点击
     如果转场时长比动画时长短：动画慢，没啥影响
     */
    CGFloat duration = [self transitionDuration:transitionContext];
//    duration = 0.2;
    // 执行动画
    //加个CATransition
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.293 :0.453 :0.584 :1]];
    
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.frame = CGRectOffset(fromVC.view.frame, -screenBounds.size.width, 0); // 将当前视图向左移动一半的距离，这样fromvc和toVC一起配合移动。注释掉这行，fromvc不动，相当于tovc覆盖过去
        toVC.view.frame = finalFrame; // 将目标视图移动到最终frame
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES]; // 转场动画完成，调用 completeTransition
        NSLog(@"completeTransition");
    }];
    
    [CATransaction commit];
    
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

- (void)animateTransitionMagnify:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 获取容器视图
    UIView *containerView = [transitionContext containerView];
    // 添加目标视图到容器
    [containerView addSubview:toVC.view];
    // 初始状态：目标视图缩小
    toVC.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    // 执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         // 恢复原始大小
                         toVC.view.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         // 完成后通知系统
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}


- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
