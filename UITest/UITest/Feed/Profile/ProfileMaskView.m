//
//  ProfileMaskView.m
//  UITest
//
//  Created by ByteDance on 2024/10/31.
//

#import "ProfileMaskView.h"
#import "../../../UITest/Responder.h"
#import "DetailTableViewController.h"

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
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
        button.backgroundColor = [UIColor blackColor];
        [button setTitle:@"to detail feed" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
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

- (void)buttonClicked:(UIButton *)sender {
    NSLog(@"Button clicked!");
//    [UIViewController dis]
    
    //UIViewController的setTransitioningDelegate被hook了，这样dismissViewControllerAnimated和presentViewController的时候都会走到设置好的delegate中的animationControllerForPresentedController的animationController中
    
//    为什么sparkview的dismissViewControllerAnimated是interacted的；因为在gestureRecognizerShouldBegin的时候把context设置成interacted了
    
//    dismissViewControllerAnimated -> TransitioningDelegate的animationControllerForDismissedController
    
    //todo，写一个presentViewController的自定义转场动画
    UIViewController *topVC = Responder.shareInstance.topVC;
    [topVC presentViewController:[[DetailTableViewController alloc] init] animated:YES completion:nil];
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
