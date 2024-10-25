//
//  FeedSlidingViewController+Transition.m
//  UITest
//
//  Created by ByteDance on 2024/10/25.
//

#import "FeedSlidingViewController+Transition.h"
#import "Feed2ProfileTransition.h"

@implementation FeedSlidingViewController (Transition)
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  API_AVAILABLE(ios(7.0))
{
    return [[Feed2ProfileTransition alloc] init];
}
@end
