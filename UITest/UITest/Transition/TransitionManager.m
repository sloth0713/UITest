//
//  TransitionManager.m
//  GestureTest
//
//  Created by ByteDance on 2024/8/16.
//

#import "TransitionManager.h"

@interface TransitionManager ()

@end


@implementation TransitionManager

#pragma UIViewControllerAnimatedTransitioning
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
//    [self animateTransition1:transitionContext];
    [self animateTransitionLeftPush:transitionContext];
//    [self animateTransitionScale:transitionContext];
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

- (void)animateTransition1:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // Get references to the source and destination views
    UIView *fromView = fromVC.view;
    UIView *toView   = toVC.view;

    // Determine the start and end frames for the toView
    CGRect initialFrame = CGRectMake(0, CGRectGetHeight(fromView.frame), CGRectGetWidth(toView.frame), CGRectGetHeight(toView.frame));
    CGRect finalFrame   = [transitionContext finalFrameForViewController:toVC];

    // Add the destination view to the container view
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];

    // Set up any transforms or animations you'll need for the transition
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(toView.frame));
    toView.transform = translation;

    // Perform the animation
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:duration
                     animations:^{
                         fromView.transform = translation;
                         toView.transform   = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         // Clean up by removing the source view from the container view
                         fromView.transform = CGAffineTransformIdentity;
                         [transitionContext completeTransition:YES];
                     }];
}


- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}


+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static TransitionManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[TransitionManager alloc] init];
        manager.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
    });
    return manager;
}

+ (scrollDirection)getDirection:(CGPoint)translation
{
    if (fabs(translation.x) > fabs(translation.y)) {
        // 左右滑动
        if (translation.x > 0) {
            return scrollDirectionRight;
        } else {
            return scrollDirectionLeft;
        }
    } else {
        // 上下滑动
        if (translation.y > 0) {
            return scrollDirectionUp;
        } else {
            return scrollDirectionDown;
        }
    }
    return scrollDirectionNone;
}


+ (scrollDirection)directionForPan:(UIPanGestureRecognizer *)pan view:(UIView *)view
{
    scrollDirection direction = scrollDirectionNone;
    CGPoint velocity = [pan velocityInView:view];
    if (velocity.x > 0) {
        if (velocity.y / velocity.x > 1) {
            direction = scrollDirectionDown;
        } else if (velocity.y / velocity.x < -1) {
            direction = scrollDirectionUp;
        } else {
            direction = scrollDirectionRight;
        }
    } else if (velocity.x < 0) {
        if (velocity.y / velocity.x > 1) {
            direction = scrollDirectionUp;
        } else if (velocity.y / velocity.x < -1) {
            direction = scrollDirectionDown;
        } else {
            direction = scrollDirectionLeft;
        }
    } else if (velocity.y > 0){
        direction = scrollDirectionDown;
    } else {
        direction = scrollDirectionUp;
    }
    return direction;
}

@end
