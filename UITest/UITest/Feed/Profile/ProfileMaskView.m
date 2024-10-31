//
//  ProfileMaskView.m
//  UITest
//
//  Created by ByteDance on 2024/10/31.
//

#import "ProfileMaskView.h"

@interface ProfileMaskView ()

@property (nonatomic, strong)UIPanGestureRecognizer *panGesture;

@end

@implementation ProfileMaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:self.panGesture];
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)pan:(UIPanGestureRecognizer *)panGesture
{
    NSLog(@"fda");
}

@end
