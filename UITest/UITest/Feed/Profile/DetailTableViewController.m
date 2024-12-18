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

@end

@implementation DetailTableViewController

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
