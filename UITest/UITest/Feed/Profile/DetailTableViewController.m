//
//  DetailTableViewController.m
//  UITest
//
//  Created by ByteDance on 2024/12/12.
//

#import "DetailTableViewController.h"
#import "../../../UITest/Responder.h"
#import "../FeedTableViewController.h"

@interface DetailTableViewController ()

@property(nonatomic, strong)UITapGestureRecognizer *tapGesture;
@property(nonatomic, assign)NSTimeInterval initTime;

@end

@implementation DetailTableViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.initTime = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    FeedTableViewController *tableVC = [[FeedTableViewController alloc] init];
    tableVC.view.frame = self.view.frame;
    [self.view addSubview:tableVC.view];
    [self addChildViewController:tableVC];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.tapGesture.delegate = self;
    [self.view addGestureRecognizer:self.tapGesture];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    button.backgroundColor = [UIColor blackColor];
//    [button setTitle:@"back" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    
//    for (int i=0; i<500; i++) {
//        [self addLayout];
//    }
}

- (void)addLayout
{
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(50, 300, 300, 300)];
    parentView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:parentView];

    // 创建子视图1
    UIView *childView1 = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    childView1.backgroundColor = [UIColor blueColor];
    childView1.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addSubview:childView1];

    // 创建子视图2
    UIView *childView2 = [[UIView alloc] initWithFrame:CGRectMake(50, 60, 80, 120)];
    childView2.backgroundColor = [UIColor redColor];
    childView2.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addSubview:childView2];

    // 设置子视图之间的复杂约束
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:childView1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20];
    [parentView addConstraint:constraint1];

    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:childView1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20];
    [parentView addConstraint:constraint2];

    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:childView2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [parentView addConstraint:constraint3];

    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:childView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [parentView addConstraint:constraint4];
}



- (void)viewDidLayoutSubviews
{
    //在viewDidLayoutSubviews之前转场动画已经执行了，这里sleep很久之后实际动画才开始。也就是说core animation动画开始之前需要view的所有生命周期都执行完成
//    [NSThread sleepForTimeInterval:5];
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
    
    NSTimeInterval init_to_viewDidLoad = ([[NSDate now] timeIntervalSince1970] - self.initTime) *1000;
    NSLog(@"init_to_viewDidLoad DetailTableViewController  %lf",init_to_viewDidLoad);
//    os_signpost_interval_end(_logger,_logId,"Main","%{public}s","init_to_viewDidLoad");
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 在这里可以添加条件判断，如果满足条件则返回YES，否则返回NO
    return YES;
}

- (void)tap:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)buttonClicked:(UIButton *)sender {
    NSLog(@"Button clicked!");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
