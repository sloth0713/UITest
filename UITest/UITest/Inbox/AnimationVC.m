//
//  AnimationView.m
//  UITest
//
//  Created by ByteDance on 2024/11/27.
//

#import "AnimationVC.h"

@implementation CoreAnimatedUISubView

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
    CoreAnimatedUISubView *coreAnimatedUISubView = [[CoreAnimatedUISubView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    coreAnimatedUISubView.backgroundColor = [UIColor yellowColor];
    [self.coreAnimatedUIView addSubview:coreAnimatedUISubView];
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
    
    /*
     模拟Core Animation动画叠加
     动画A执行过程中执行动画B
     直接停止A，但是会以A的最终frame作为起始fram计算，按照B的逻辑计算最终的frame，然后按照B的时长和曲线执行动画
     即停止A，继续动画，将AB的效果叠加
     */
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:2.0
//                              delay:0.0
//                            options:UIViewAnimationOptionCurveLinear
//                         animations:^{
//                             CGRect frame = self.coreAnimatedUIView.frame;
//                             frame.origin.x += 100;
//                             self.coreAnimatedUIView.frame = frame;
//                         }
//                         completion:^(BOOL finished) {
//                         }];
//    });
    
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
