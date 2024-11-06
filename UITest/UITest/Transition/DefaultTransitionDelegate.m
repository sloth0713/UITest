//
//  DefaultTransitionDelegate.m
//  UITest
//
//  Created by ByteDance on 2024/10/28.
//

#import "DefaultTransitionDelegate.h"
#import "DefaultPopTransiotion.h"
#import "DefaultPushTransiotion.h"
#import "../../UITest/Responder.h"

@implementation TransitionContext
@end

@implementation DefaultTransitionDelegate

- (instancetype)initWithContext:(TransitionContext *)context
{
    if (self = [super init]){
        self.context = context;
    }
    return self;
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  API_AVAILABLE(ios(7.0))
{
    //判断topvc
    Responder.shareInstance.topVC = toVC;
    switch (self.context.type) {
        case TransitionTypePush:
            return [[DefaultPushTransiotion alloc] init];
            break;
            
        case TransitionTypePop:
            return [[DefaultPopTransiotion alloc] init];
            break;
            
        default:
            return [[DefaultPushTransiotion alloc] init];
            break;
    }
}


@end
