//
//  InboxVC.m
//  UITest
//
//  Created by ByteDance on 2024/11/26.
//

#import "InboxVC.h"
#import <QuartzCore/QuartzCore.h>


@interface InboxVC ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView *displayLinkAnimatedView;
@property (nonatomic) CGFloat angle;

@property (nonatomic, strong) UIView *coreAnimatedView;

@property (nonatomic, strong) UIButton *coreAnimatedUIView;

@end

@implementation InboxVC

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-200)];
//    bgView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:bgView];
    self.coreAnimatedUIView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coreAnimatedUIView.frame = CGRectMake(100, 400, 100, 100);
    self.coreAnimatedUIView.backgroundColor = [UIColor greenColor];
    [self.coreAnimatedUIView addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.coreAnimatedUIView];
    
    
}
- (void)buttonClicked:sender
{
    //模拟kCFRunLoopBeforeSources的卡顿
    [NSThread sleepForTimeInterval:3];
}

- (void)viewDidAppear:(BOOL)animated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self addDispalayLinkAnimationView];
//        [self addCoreAnimationView];
//        [self addCoreAnimationUIView];
    });
}

- (void)addCoreAnimationView
{
    self.coreAnimatedView = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    self.coreAnimatedView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.coreAnimatedView];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:self.coreAnimatedView.layer.position];
    
    CGPoint toPosition = self.coreAnimatedView.layer.position;
    toPosition.x += 100; // 移动到右侧100像素
    animation.toValue = [NSValue valueWithCGPoint:toPosition];
    
    animation.duration = 2.0;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.coreAnimatedView.layer addAnimation:animation forKey:@"position"];
    
}

- (void)addCoreAnimationUIView
{
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                     animations:^{
                         CGRect frame = self.coreAnimatedUIView.frame;
                         frame.origin.x = 300;
                         self.coreAnimatedUIView.frame = frame;
                     }
                     completion:^(BOOL finished) {
//                         CGRect frame = self.coreAnimatedUIView.frame;
//                         frame.origin.x = 0;
//                         self.coreAnimatedUIView.frame = frame;
//                         [self addCoreAnimationUIView];
                     }];

    
}


- (void)addDispalayLinkAnimationView
{
    self.angle = 0.0;
    
    self.displayLinkAnimatedView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.displayLinkAnimatedView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.displayLinkAnimatedView];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    self.angle += 0.05;
    self.displayLinkAnimatedView.transform = CGAffineTransformMakeRotation(self.angle);
//    NSLog(@"handle DisplayLink!");
}

@end
