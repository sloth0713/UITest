//
//  AnimationView.m
//  UITest
//
//  Created by ByteDance on 2024/11/27.
//

#import "AnimationVC.h"

@interface AnimationVC ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView *displayLinkAnimatedView;
@property (nonatomic) CGFloat angle;

@property (nonatomic, strong) UIView *coreAnimatedView;

@property (nonatomic, strong) UIButton *coreAnimatedUIView;

@end

@implementation AnimationVC

- (void)dealloc
{
    NSLog(@"fdsa");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addDispalayLinkAnimationView];
    [self addCoreAnimationView];
    [self addCoreAnimationUIView];
    
}

- (void)addDispalayLinkAnimationView
{
    self.displayLinkAnimatedView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.displayLinkAnimatedView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.displayLinkAnimatedView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)addCoreAnimationView
{
    self.coreAnimatedView = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    self.coreAnimatedView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.coreAnimatedView];
}

- (void)addCoreAnimationUIView
{
    self.coreAnimatedUIView = [UIButton buttonWithType:UIButtonTypeCustom];
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
    [self startDispalayLinkAnimationView];
    [self startCoreAnimationView];
    [self startCoreAnimationUIView];
}

- (void)startCoreAnimationView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:self.coreAnimatedView.layer.position];
    
    CGPoint toPosition = self.coreAnimatedView.layer.position;
    toPosition.x += 200; // 移动到右侧
    animation.toValue = [NSValue valueWithCGPoint:toPosition];
    
    animation.duration = 2.0;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.coreAnimatedView.layer addAnimation:animation forKey:@"position"];
    
}

- (void)startCoreAnimationUIView
{
    self.coreAnimatedUIView.frame = CGRectMake(100, 400, 100, 100);
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                     animations:^{
                         CGRect frame = self.coreAnimatedUIView.frame;
                         frame.origin.x = 200;
                         self.coreAnimatedUIView.frame = frame;
                     }
                     completion:^(BOOL finished) {
//                         CGRect frame = self.coreAnimatedUIView.frame;
//                         frame.origin.x = 0;
//                         self.coreAnimatedUIView.frame = frame;
//                         [self addCoreAnimationUIView];
                     }];

    
}


- (void)startDispalayLinkAnimationView
{
    self.angle = 0.0;
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    self.angle += 0.05;
    self.displayLinkAnimatedView.transform = CGAffineTransformMakeRotation(self.angle);
//    NSLog(@"handle DisplayLink!");
}

@end
