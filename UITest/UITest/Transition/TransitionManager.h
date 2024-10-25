//
//  TransitionManager.h
//  GestureTest
//
//  Created by ByteDance on 2024/8/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, scrollDirection)
{
    scrollDirectionNone = 0,
    scrollDirectionUp = 1,
    scrollDirectionDown = 1 << 1,
    scrollDirectionLeft = 1 << 2,
    scrollDirectionRight = 1 << 3,
    
    scrollDirectionAny = scrollDirectionUp | scrollDirectionDown | scrollDirectionLeft | scrollDirectionRight,
    scrollDirectionPortrait = scrollDirectionUp | scrollDirectionDown,
    scrollDirectionHorizontal = scrollDirectionLeft | scrollDirectionRight,
};

@interface TransitionManager : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) UIPercentDrivenInteractiveTransition *interactionController;
+ (instancetype)shareManager;
+ (scrollDirection)directionForPan:(UIPanGestureRecognizer *)pan view:(UIView *)view;

@end


