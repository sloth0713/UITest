//
//  FeedSlidingScrollView.m
//  GestureTest
//
//  Created by ByteDance on 2024/8/16.
//

#import "FeedSlidingScrollView.h"
//#import "../Transition/TransitionManager.h"

@interface FeedSlidingScrollView()

@end

@implementation FeedSlidingScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
//        self.panGestureRecognizer.delegate = self;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    //所有的UIScrollView都自带一个panGestureRecognizer，且self.panGestureRecognizer.delegate = self;需要修改，直接重写该方法即可
    if (self.isInLastVC){
        return NO;
    }
    
    return YES;
}

@end
