//
//  DefaultTransitionDelegate.h
//  UITest
//
//  Created by ByteDance on 2024/10/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    TransitionTypeNone,
    TransitionTypePush,
    TransitionTypePop,
} TransitionType;

@interface TransitionContext : NSObject
@property (nonatomic,assign) TransitionType type;
@end

@interface DefaultTransitionDelegate : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) TransitionContext *context;

- (instancetype)initWithContext:(TransitionContext *)context;

@end

