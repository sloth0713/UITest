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

#pragma mark - view life cycle

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSLog(@"drawRect");
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    NSLog(@"willMoveToSuperview");
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    NSLog(@"didMoveToSuperview");
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    NSLog(@"willMoveToWindow");
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    NSLog(@"didMoveToWindow");
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    [NSThread sleepForTimeInterval:10];
    NSLog(@"layoutSubviews");
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    NSLog(@"didAddSubview");
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    NSLog(@"willRemoveSubview");
}

@end
